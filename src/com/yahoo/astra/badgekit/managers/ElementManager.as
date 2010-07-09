package com.yahoo.astra.badgekit.managers
{
	import com.yahoo.astra.customizer.Customizer;
	
	import fl.core.UIComponent;
	
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	/**
    * The element manager class that parses the elements section of content.xml and instantiates elements on stage.
    *
    * @langversion ActionScript 3.0
	* @playerversion Flash 9
    * @author Allen Rabinovich
    */
	public class ElementManager extends EventDispatcher
	{
		
		/**
		* @private
		* The instance of this Singleton
		*/
		private static var instance:ElementManager;
		
		/**
		* @private
		* Whether the singleton is initialized
		*/
        private static var initialized:Boolean;
        
		/**
		* Singleton
		*/
		public static function getInstance():ElementManager 
		{
	         if (instance == null) 
	         {
	            instance = new ElementManager();
	            
	            initialized = true;
	            instance.elements = new Dictionary();
				instance.instanceCounter = 0;
	          }
	      		
	      	return instance;
       }


		
		
		/**
		* Data structure for all existing elements
		*/
		public var elements:Dictionary;
		
		/**
		* Dictionary of all elements by name
		*/
		public var elementsByName:Dictionary = new Dictionary();
		
		/**
		* Instance counter for automatic element naming
		*/
		public var instanceCounter:int;
		
		/**
		* Keywords that identify containers rather than element names
		*/
		public var elementKeywords:Array = ["elements", "container"];
		
		
		/**
		* The customizer instance
		*/
		public var customizer:Customizer;
		
		/**
		* Constructor
		*/
		public function ElementManager () {
			if (initialized) 
			{
           		 throw new Error("Instantiation failed: Use ElementManager.getInstance()");
          	}
			
		
		}
		
		
		/**
		 * Produces an automatic instance name
		 * 
		 * @return A new unique instance name
		 */
		public function getInstanceName() : String {
			instanceCounter++;
			return ("instance" + String(instanceCounter));
		}
		
		/**
		 * Parses the content.xml elements section recursively
		 * 
		 * @param currentXML	The XML to be parsed
		 * @param parentClip    Reference to the parent element (for recursion)
		 */
		public function parseXML (currentXML:XML, parentClip:UIComponent) : void {
			
		var elementClass:Class;
		var newelement:UIComponent;
		//alaric
		var elementIsContainer:Boolean;
		
		elementClass = ConfigurationManager.getInstance().getClass(currentXML.name().localName);
				
		if (elementClass != null || elementKeywords.indexOf(currentXML.name().localName) != -1) {
		
		if (elementClass != null) {
			newelement = new elementClass();
		}
		else {
			newelement = new UIComponent();
			//alaric
			elementIsContainer = true;
		}
		
		if (currentXML.@id != null && currentXML.@id.toString() != "") {
			newelement.name = currentXML.@id;
		}
		
		else if(currentXML.properties.child("id") != null && currentXML.properties.child("id").toString() != "")
		{
			newelement.name =currentXML.properties.child("id").toString();
		}
		else {
			newelement.name = getInstanceName();
		}
		
		parentClip.addChild(newelement);
		elements[newelement] = new Array();
		if (elementsByName[newelement.name] == null) {
		elementsByName[newelement.name] = newelement;
		}
		else {
			throw new Error("Duplicate element name: " + newelement.name);
		}
		
		var properties:Array = new Array();
		var styles:Dictionary = new Dictionary();
		
		for each (var attribute:XML in currentXML.attributes()) {
		    var attr:String = attribute.name().toString();
			if (newelement.hasOwnProperty(attr)) {
				properties.push({name:attr, val:attribute.toString()});
			}
			else {
				//throw new Error("Styles should be placed in a <styles> tag, not as an attribute");
				//styles[attr] = attribute.toString();
			}
			
			
		}
		
		// Addition by Alaric Cole
		// Loop through nested nodes on elements that could also be properties
		//also add customization
		if(!elementIsContainer)
		{
			for each (var nestedProperty:XML in currentXML.properties.children()) {
			    var prop:String = nestedProperty.name().toString();
				if (newelement.hasOwnProperty(prop)) 
				{
					var propObject:Object = {name:prop, val:nestedProperty.toString()}
					
					//customize
					if( 
						nestedProperty.hasOwnProperty("@customize") 
							&& 
						nestedProperty.@customize == "true"
						
					  )
					{
						propObject.customize = true;
						
						var label:String = newelement.name + " " + prop;
						var type:String;
						type = nestedProperty.@controlType;
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
					
				//}
				else {
					//now in style tag. throw error?
					//styles[prop] = nestedProperty.toString();
				}
			}
		}
		// 


		// Loop through and collect styles
		for each (var nestedStyle:XML in currentXML.styles.children()) 
		{
		    var stleProp:String = nestedStyle.name().toString();
			styles[stleProp] = nestedStyle.toString();
			
			//add customizer
			var stylepropObject:Object = {name:prop, val:nestedStyle.toString()}
			if( 
				nestedStyle.hasOwnProperty("@customize") 
					&& 
				nestedStyle.@customize == "true"
				
			  )
			{
				stylepropObject.customize = true;
				
				var label:String = newelement.name + " " + stleProp;
				var type:String;
				type = nestedStyle.@controlType;
				
				var defObject:Object = {};
				defObject.value = int(nestedStyle.toString());
				
				var ctl:UIComponent = elementsByName[newelement.name];
				//add customizer defaults specified in the node's attributes
				for each(var att:XML in nestedStyle.@*)
				{
					defObject[att.name().localName] = att.toXMLString();
				}
				
				instance.customizer.addFunction(label, ctl.setStyle, stleProp, type, defObject);	
			}
		}
		
		//apply styles
		for (var style:String in styles) {
			//BindingManager.getInstance().createBinding(newelement as EventDispatcher, styles[style], style);
			//newelement.addEventListener(style, BindingManager.getInstance().processAction);
			parseStyle(newelement, style, styles[style]);

		}
		
		// Loop through events and add listeners
		for each (var nestedEvent:XML in currentXML.events.children()) 
		{
		    BindingManager.getInstance().createBinding(newelement as EventDispatcher, nestedEvent.toString(), nestedEvent.name().toString());
			
		    newelement.addEventListener(nestedEvent.name().toString(), BindingManager.getInstance().processAction);
		}
		
		
		var tweenFlag:Boolean = true;
		
		for each (var propertyObject:Object in properties) {
			var pname:String = propertyObject.name;
			var pval:String = propertyObject.val;
			
			if (pname == "visible" && pval == "false") {
				newelement[pname] = false;
				tweenFlag = false;
			}
			
			else {
				if (pval.toLowerCase() == "true") {
						newelement[pname] = true;
				}
				else if (pval.toLowerCase() == "false") {
						newelement[pname] = false;
				}
				else {
					var processedVal:String;
					if( propertyObject.hasOwnProperty("customize") )
					{
						if(propertyObject.customize)
						{
							//this has been customized through a Flashvars via Customizer
							//don't do anything
							trace("nothing");
						}
					}
					else
					{
						processedVal = ConfigurationManager.getInstance().getQualifiedPath(pval);
						newelement[pname] = processedVal;
					}
					 
					
					
					if (processedVal.indexOf("flashvars.") == 0) {
						newelement[pname] = BindingManager.getInstance().getElement(processedVal)[BindingManager.getInstance().evalVar(processedVal)];
					}
					
				}
			}
		}
		
		if (tweenFlag) {
			TweenManager.getInstance().processTween(newelement, true);
		}

		
		}
		else {
			throw new Error("Unknown element name: " + currentXML.name().localName);
		}		
				
		if (currentXML.children().length() > 0 && elementIsContainer) {
			for each (var childNode:XML in currentXML.children()) { 
				// parse childnodes that are not styles, events, properties
				var localName:String = childNode.name().localName;
				if ( localName != "styles" && localName != "events" && localName != "properties" ) 
					parseXML(childNode, newelement);
			}		
		}
	}
	
	/**
	 * @private
	 * Assign a particular style for an element
	 * 
	 */
	private function parseStyle(component:UIComponent, styleName:String, styleValue:String) : void {
		if (styleValue == "true") {
			component.setStyle(styleName, true);
		}
		else if (styleValue == "false") {
			component.setStyle(styleName, false);
		}
		else if (!isNaN(Number(styleValue))) {
			component.setStyle(styleName, Number(styleValue));
		}
		else { // if (ApplicationDomain.currentDomain.hasDefinition(styleValue)) {
			component.setStyle(styleName, styleValue);
		}
	}
	}	
			
	}