/*
Copyright (c) 2007 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package com.yahoo.astra.badgekit.managers
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	
	import com.yahoo.astra.badgekit.managers.*;
	
	/**
    * The configuration manager class that loads config.xml and prepares the Badge for rendering.
    *
    * @langversion ActionScript 3.0
	* @playerversion Flash 9
    * @author Allen Rabinovich
    */
	public class ConfigurationManager extends EventDispatcher
	{
		/**
		* @private
		* The XML container
		*/
		private var contentXML:XML;
		
		/**
		* Path shorthands dictionary
		*/
		public var paths:Dictionary;
		
		/**
		* A list of known classpaths
		*/
		public var classpaths:Array;
		
		/**
		* @private
		* Hardcoded content.xml path
		*/
		public var contentPath:String = "content.xml";
		
		/**
		* @private
		* The instance of this Singleton
		*/
		private static var instance:ConfigurationManager;
		
		/**
		* @private
		* Whether the singleton is initialized
		*/
        private static var initialized:Boolean;
        
		/**
		* Singleton
		*/
		public static function getInstance():ConfigurationManager 
		{
	         if (instance == null) 
	         {
	            instance = new ConfigurationManager();
	            
	            initialized = true;
	            instance.paths = new Dictionary();
				instance.classpaths = new Array();
				
	          }
	      		
	      	return instance;
       }

		
		/**
		* Constructor
		*/
		public function ConfigurationManager () {
			if (initialized) 
			{
           		 throw new Error("Instantiation failed: Use ConfigurationManager.getInstance()");
          	}
			
		}
		
	
		/**
		 * Expands a path with shorthands to fully qualified path
		 * 
		 * @param path	Path with shorthands
		 * @return      Path with shorthands expanded
		 */
		public function getQualifiedPath (path:String) : String {
			var newPath:String = path.replace(/%(.*)%/, getPath);
			return newPath; 
		}
		/**
		 * @private
		 * Retrieves the shorthand match
		 * 
		 */		
		private function getPath() : String {
			if (paths[arguments[1]] != null) {
				return paths[arguments[1]];
			}
			else return arguments[0];
		}

		/**
		 * @private
		 * Loads the config XML file
		 * 
		 */		
		public function loadXML (evtObject:Event = null) : void {
			if (evtObject == null) {
				var XMLLoader:URLLoader = new URLLoader();
				XMLLoader.addEventListener(Event.COMPLETE, loadXML);
				XMLLoader.load(new URLRequest(contentPath));	
			}
	
			else {
				contentXML = new XML(evtObject.target.data);
				parseXML();
			}
		}

		/**
		 * @private
		 * Checks whether a particular class exists in the ApplicationDomain
		 * 
		 */		
		private function classExists (classname:String) : Boolean {
			return (ApplicationDomain.currentDomain.hasDefinition(classname));
		}
		
		/**
		 * Returns an instance of a Class in the current ApplicationDomain by name, if it exists
		 * 
		 * @param classname The name of the class
		 * @return An instance of class with the given name
		 */
		public function getClass (classname:String) : Class {
			if (classExists(classname)) {			
				return (ApplicationDomain.currentDomain.getDefinition(classname) as Class);
			}
			else {
				for each (var classpath:String in classpaths) {
					if (classExists(classpath + "." + classname)) {
						return (ApplicationDomain.currentDomain.getDefinition(classpath + "." + classname) as Class);
					}
				}
				return null;
			}
		}

		/**
		 * @private
		 * Parses the config xml data and populates appropriate data structures.
		 * 
		 */
		private function parseXML () : void {
			
			
			
			
			for each (var path:XML in contentXML.config.paths.path) {
				paths[path.@shorthand.toString()] = path.@path.toString();
			}
			
			for each (var classpath:XML in contentXML.config.classpaths.classpath) {
				classpaths.push(classpath.@path.toString());
			}
			
				ResourceManager.getInstance().contentXML = contentXML;
				
			for each (var animation:XML in contentXML.config.animations.animation) {
				TweenManager.getInstance().tweens[animation.@id.toString()] = {property: animation.@property.toString(), startval: Number(animation.@startvalue.toString()), endval: Number(animation.@endvalue.toString()), duration: Number(animation.@duration.toString()), autoStart:(animation.@autoStart.toString()=="false")?false:true, clearAllRunning:(animation.@clearAllRunning.toString()=="true")?true:false};
			}

			dispatchEvent(new Event(Event.INIT));
		}
	}
}