/*
Copyright (c) 2007 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package com.yahoo.astra.badgekit.managers
{
	import com.yahoo.astra.customizer.Customizer;
	
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	/**
    * The service manager class that loads the services specified in the services section of content.xml.
    *
    * @langversion ActionScript 3.0
	* @playerversion Flash 9
    * @author Allen Rabinovich
    */
	public class ServiceManager extends EventDispatcher
	{
		/**
		* @private
		* Reference to the main badge
		*/
		private var mainBadge:Badge;
		
		/**
		* A dictionary of all services
		*/
		public var servicesDict:Dictionary = new Dictionary();
		
		/**
		* @private
		* The instance of this Singleton
		*/
		private static var instance:ServiceManager;
		
		/**
		* @private
		* Whether the singleton is initialized
		*/
        private static var initialized:Boolean;
        
        
        /**
		* The customizer instance
		*/
		public var customizer:Customizer;
		
		/**
		* Singleton
		*/
		public static function getInstance():ServiceManager 
		{
	         if (instance == null) 
	         {
	            instance = new ServiceManager();
	            
	            initialized = true;
	         
	          }
	      		
	      	return instance;
       }

		
		/**
		* Constructor
		*/
		function ServiceManager () {
			if (initialized) 
			{
           		 throw new Error("Instantiation failed: Use ServiceManager.getInstance()");
          	}
			
		}
		
		
		/**
		 * Gets an id as an attribute or child node
		 */
		private function getId (xml:XML) : String 
		{
			if (xml.@id != null && xml.@id.toString() != "") 
			{
				return xml.@id;
			}
		
			else if(xml.properties.child("id") != null && xml.properties.child("id").toString() != "")
			{
				return xml.properties.child("id").toString();
			}
			
			else return null;
		}
		
		
		/**
		 * Parses the services section of content.xml
		 * 
		 * @param services	XML from services section of content.xml
		 */
		public function parseXML (services:XML) : void {
			for each (var currentXML:XML in services.children()) {
				var elementClass:Class;
				var newelement:EventDispatcher;
				elementClass = ConfigurationManager.getInstance().getClass(currentXML.name().localName);
								
				if (elementClass != null) {
					newelement = new elementClass();
					if (getId(currentXML) != null) {
						if (ElementManager.getInstance().elementsByName[String(getId(currentXML))] != null) {
							throw new Error ("Duplicate service name: " + String(getId(currentXML)));
						}
						else {
						ElementManager.getInstance().elementsByName[String(getId(currentXML))] = newelement;
						}
					}
					else {
						throw new Error(currentXML.name().localName + " is missing an 'id' required for all services.");
					}					
					
					var autotrigger:Boolean = false;
					var properties:Array = new Array();
					var actions:Dictionary = new Dictionary();
					
// loop through children
					for each (var nestedProperty:XML in currentXML.properties.children()) {
				    var prop:String = nestedProperty.name().toString();
					if (newelement.hasOwnProperty(prop)) 
					{
						var propObject:Object = {name:prop, val:nestedProperty.toString()}
						
						//customize
						if(  nestedProperty.hasOwnProperty("@customize") 
								&& 
								nestedProperty.@customize == "true"
						  )
						{
							propObject.customize = true;
							
							var label:String = getId(currentXML) + " " + prop;
							var type:String;
							type = nestedProperty.@type;
							//might be able to use a switch statment here to 
							//give a default type 
							//switch(newelement[prop]
							var defaultObject:Object = {};
							defaultObject.value = nestedProperty.toString();
							
							//add defaults specified in the node's attributes
							for each(var attrib:XML in nestedProperty.@*)
							{
								defaultObject[attrib.name().localName] = attrib.toXMLString();
							}
							
							instance.customizer.addProperty(label, newelement, prop, type, defaultObject);	
						}
						
						properties.push(propObject);
						
					}
						
					
				}
				
				
					for each (var attribute:XML in currentXML.attributes()) {
		    			var attr:String = attribute.name().toString();
						if (newelement.hasOwnProperty(attr) && attr != "send") {
							trace("Found property: " + attr);
							var processedVal:String = ConfigurationManager.getInstance().getQualifiedPath(attribute.toString());
							properties.push({name: attr, val: processedVal});
						}
						
						else if (attr == "send") {
							autotrigger = (attribute.toString() == "true");
						}
						
						else {
							actions[attr] = attribute.toString();
						}
					}	
					//loop through events if not specified as an attribute
					for each (var eventXML:XML in currentXML.events.children()) 
					{						
		    			var evt:String = eventXML.name().toString();
						
						 if (evt == "send") {
							autotrigger = (eventXML.toString() == "true");
						}
						
						else {
							actions[evt] = eventXML.toString();
						}
					}	
					
			
			// alaric
					for (var action:String in actions) {
						BindingManager.getInstance().createBinding(newelement as EventDispatcher, actions[action], action);
						newelement.addEventListener(action, BindingManager.getInstance().processAction);
						}

					
					for each (var propertypair:Object in properties) {
						var property:String = propertypair.name;
						var pval:String = propertypair.val;
							if (pval.toLowerCase() == "true") {
								newelement[property] = true;
							}
							else if (pval.toLowerCase() == "false") {
								newelement[property] = false;
							}
							else if (pval.indexOf("flashvars.") == 0) {
								newelement[property] = BindingManager.getInstance().getElement(pval)[BindingManager.getInstance().evalVar(pval)];
							}
							else {
								newelement[property] = pval;
							}
					}
					
					if (autotrigger) {
					                   newelement["send"].call(); 
					                 }
					
					servicesDict[newelement] = "true";
				}
				else {
					throw new Error ("Service " + currentXML.name().localName + " not found.");
				}
			}
		}
	}
}