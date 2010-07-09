/*
Copyright (c) 2007 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package com.yahoo.astra.badgekit.managers
{
	import flash.display.Loader;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	/**
    * The resource manager class that loads the resources specified in the resources section of content.xml.
    *
    * @langversion ActionScript 3.0
	* @playerversion Flash 9
    * @author Allen Rabinovich
    */
	public class ResourceManager extends EventDispatcher
	{		
		
		/**
		* @private
		* The top level display object
		*/
		public static var mainBadge:Badge;
		
		/**
		* @private
		* Counter for number of loaded resources
		*/
		private var loadCounter:int;
		
		/**
		* Container for flashvars
		*/
		public var flashvars:Object;
		
		/**
		* Path to content.xml
		*/
		public var contentXMLPath:String = "content.xml";
		
		/**
		 * @private
		* The resource XML section
		*/
		private var _contentXML:XML ;
		
		/**
		* List of all loaders
		*/
		public var loaders:Array = new Array();
				
		/**
		* @private
		* The instance of this Singleton
		*/
		private static var instance:ResourceManager;
		
		/**
		* @private
		* Whether the singleton is initialized
		*/
        private static var initialized:Boolean;
        
		/**
		* Singleton
		*/
		public static function getInstance():ResourceManager 
		{
	         if (instance == null) 
	         {
	            instance = new ResourceManager();
	            
	            initialized = true;
	         
	           
	          }
	      		
	      	return instance;
       }


		
		/**
		* Constructor
		*/
		public function ResourceManager () {
			if (initialized) 
			{
           		 throw new Error("Instantiation failed: Use ResourceManager.getInstance()");
          	}
			
		}
		
		public function get contentXML():XML
		{
			return _contentXML;
		}
		public function set contentXML(xml:XML):void
		{
			_contentXML = xml;
			parseXML();
		}
		
		/**
		 * Parses the resources section of content.xml and initializes the loading of resources.
		 * 
		 */
		public function parseXML () : void {
			
		if (contentXML.name().toString() != "badge") {
			throw new Error("Top-level badge element not found");
		}		
		else if (contentXML.config.child("resources").length() > 0) {
			loadResources();
		}
		else {
			loadFlashvars();
			loadServices();
			loadElements();
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		}
		
		/**
		 * @private
		 * Loads the flashvars and stores them 
		 *
		 */
		private function loadFlashvars () : void {
///needs to be passed to via the main badge
			ElementManager.getInstance().elementsByName["flashvars"] = mainBadge.loaderInfo.parameters;
		}
		
		/**
		 * @private
		 * Call the elementManager.parseXML to load the elements
		 *
		 */
		private function loadElements () : void {	
			if (contentXML.child("elements").length() > 0) {
				ElementManager.getInstance().parseXML(contentXML.child("elements")[0], mainBadge);
			}
			else {
				throw new Error("No badge elements found");
			}
		}
		
		/**
		 * @private
		 * Call the ServiceManager.parseXML to load the services
		 *
		 */
		private function loadServices () : void {
			if (contentXML.child("services").length() > 0) {
				ServiceManager.getInstance().parseXML(contentXML.child("services")[0]);
			}
		}
		
		/**
		 * @private
		 * Load and initialize the resources 
		 *
		 */
		private function loadResources () : void { 
			var swflist:XMLList = contentXML.config.resources.swf;
			loadCounter = swflist.length();
			// trace("Length of SWF files: " + loadCounter);
			for each (var item:XML in swflist) {
					var loader:Loader = new Loader();				
					var urlReq:URLRequest = new URLRequest(ConfigurationManager.getInstance().getQualifiedPath(item.@filename.toString()));
					var context:LoaderContext = new LoaderContext();
					context.applicationDomain = ApplicationDomain.currentDomain;

					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, swfLoaded);
					loader.load(urlReq, context);
					loaders.push(loader);
			}
		}
		
		/**
		 * @private
		 * Called when all resources are loaded.
		 *
		 */
		public function swfLoaded (evt:Event) : void {
			loadCounter -= 1;
			if (loadCounter == 0) {
				
				loadFlashvars();
				loadServices();
				loadElements();
				
				
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
	}
}