/*
Copyright (c) 2007 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package com.yahoo.astra.badgekit.managers
{
	import fl.core.UIComponent;
	import fl.data.DataProvider;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import com.yahoo.astra.badgekit.managers.*;

	/**
    * The binding manager class handles data assignments and event responses.
    *
    * @langversion ActionScript 3.0
	* @playerversion Flash 9
    * @author Allen Rabinovich
    */
	public class BindingManager extends EventDispatcher
	{
		
		/**
		* @private
		* A dictionary of all bindings
		*/
		private var bindings:Dictionary;
		
		/**
		* @private
		* The instance of this Singleton
		*/
		private static var instance:BindingManager;
		
		/**
		* @private
		* Whether the singleton is initialized
		*/
        private static var initialized:Boolean;
        
		/**
		* Singleton
		*/
		public static function getInstance():BindingManager 
		{
	         if (instance == null) 
	         {
	            instance = new BindingManager();
	            instance.bindings = new Dictionary();
	            initialized = true;
	            
	          }
	      		
	      	return instance;
       }
      
		/**
		* Constructor
		*/
		public function BindingManager() 
		{
			if (initialized) 
			{
           		 throw new Error("Instantiation failed: Use BindingManager.getInstance()");
          	}
		}
		
		
		/**
		* Checks whether a specific component is a service
		*
		* @element The component to check
		*/
		public function isService(element:Object) : Boolean {
//			trace("Service: " + (element is IService));
//			trace("Is it there? " + ServiceManager.getInstance().servicesDict[element]);
				return (ServiceManager.getInstance().servicesDict[element] != null);
		}
		
		/**
		* Performs requires data transfers in response to a particular event
		*
		* @param event The event to respond to
		*/
		public function processAction (event:Event) : void {
			// trace("Event has been dispatched: " + event.type + ", from " + event.currentTarget);
			for each (var pair:Array in bindings[event.currentTarget][event.type]) {
				// trace("Processing: " + pair[0] + ": " + pair[1]);
				if (isBoolean(pair[1])) {
					if (evalVar(pair[0]) == "visible") {
						TweenManager.getInstance().processTween(getElement(pair[0]) as UIComponent,  stringToBoolean(pair[1]));
					}
					else if (isService(getElement(pair[0])) && evalVar(pair[0]) == "send") {
						trace("Service to be sent...");
						getElement(pair[0]).send();
					}
					else {	
					   	getElement(pair[0])[evalVar(pair[0])] = stringToBoolean(pair[1]);
					}
				}
				else if (isString(pair[1])) {
				  getElement(pair[0])[evalVar(pair[0])] = stringToString(pair[1]);
				}
				else if (isNumber(pair[1])) {
				   getElement(pair[0])[evalVar(pair[0])] = Number(pair[1]);	
				}
				else if (isArrayElement(pair[1])) {
					if (getElement(pair[0])[evalVar(pair[0])] is DataProvider) {
						getElement(pair[0])[evalVar(pair[0])] = new DataProvider (getElement(pair[1])[evalArrayVar(pair[1])][evalArrayIndex(pair[1])]);
					}
					else {
						getElement(pair[0])[evalVar(pair[0])] = getElement(pair[1])[evalArrayVar(pair[1])][evalArrayIndex(pair[1])];
					}
				}
				else {
					if (getElement(pair[0])[evalVar(pair[0])] is DataProvider) {
						trace("Got a data provider!");
					   getElement(pair[0])[evalVar(pair[0])] = new DataProvider(getElement(pair[1])[evalVar(pair[1])]);
					}
					else {
					   getElement(pair[0])[evalVar(pair[0])] = getElement(pair[1])[evalVar(pair[1])];
					}	
				}
			}
		}
		
		/**
		* Retrieve a particular element based on name
		* @param elementName The name of the element to retrieve
		*/
		public function getElement(elementName:String) : Object {
			var elementNames:Array = elementName.split(".");
			var topElement:Object = ElementManager.getInstance().elementsByName[elementNames[0]];
			
			if (topElement != null) {
				for (var i:int = 1; i < elementNames.length-1; i++) {
					topElement = topElement[elementNames[i]];
				}
				return topElement;
			}
			else {
				throw new Error("Element " + elementNames[0] + " not found.");
				return null;
			}
		}

		/**
		* Evaluate a variable reference
		*
		* @param objName The name of the variable to evaluate
		*/
		public function evalVar(objName:String) : String {
			var nameArray:Array = objName.split(".");
			return (nameArray[nameArray.length-1]);	
		}

		/**
		* Evaluate an array variable reference
		*
		* @param objName The name of the array variable to evaluate
		*/		
		public function evalArrayVar(objName:String) : String {
			var nameArray:Array = objName.split(".");
			var varNameArray:Array = nameArray[nameArray.length - 1].split("[");
			return varNameArray[0];
		}

		/**
		* Helper function that evaluates an array index for an array variable reference
		*
		* @param objName The name of the variable to evaluate
		*/
		public function evalArrayIndex(objName:String) : Number {
			var openBracket:int = objName.indexOf("[");
			var closeBracket:int = objName.indexOf("]");
			trace("Seeing... " + objName.substring(openBracket + 1, closeBracket));
			return Number(objName.substring(openBracket + 1, closeBracket));
		}		
		
		/**
		* Helper function that checks whether a particular statement is a Boolean string
		*
		* @param somestr The string to evaluate
		*/
		private function isBoolean(somestr:String) : Boolean {
			if (somestr.toLowerCase() == "true" || somestr.toLowerCase() == "false")
				return true;
			else
				return false;
		}
	
		/**
		* Convert a Boolean string to an actual Boolean
		*
		* @param somestr The string to evaluate
		*/	
		public function stringToBoolean(somestr:String) : Boolean {
			if (somestr.toLowerCase() == "true") {
				return true;
			}
			else if (somestr.toLowerCase() == "false") {
				return false;
			}
			return false;	
		}

		/**
		* Convert a string representing a string to an actual string (strip quotes)
		*
		* @param somestr The string to evaluate
		*/		
		private function stringToString (somestr:String) : String {
			return somestr.substring(1,somestr.length-1);
		}

		/**
		* Check whether something is a string
		*
		* @param somestr The string to evaluate
		*/		
		private function isString(somestr:String) : Boolean {
			if ((somestr.substr(0,1) == '"' && somestr.substr(somestr.length-1,1) == '"') ||
			    (somestr.substr(0,1) == "'" && somestr.substr(somestr.length-1,1) == "'")) {
			    	return true;
			    } 
			else {
				return false;		
			}
		}

		/**
		* Check whether a string is a number
		*
		* @param somestr The string to evaluate
		*/		
		private function isNumber(somestr:String) : Boolean {
			if (isNaN(Number(somestr))) {
				return false;
			}
			else {
				return true;
			}
		}

		/**
		* Check whether a variable name represents an array element
		*
		* @param somestr The string to evaluate
		*/		
		private function isArrayElement(somestr:String) : Boolean {
			if (somestr.substr(somestr.length-1,1) == "]") {
				return true;
			}
			else {
				return false;
			}
		}


		/**
		* Create a response to a particular event for a specific component
		*
		* @param currentClip The component that will dispatch the event
		* @param action The set of variable assignments to perform
		* @param event The event to listen for
		*/
		public function createBinding(currentClip:EventDispatcher, action:String, event:String) : void {
			
			var clipbindings:Array = new Array();
			var setValues:Array = action.toString().split(";");
			// trace("Setting " + event + " to " + action);
			if (setValues[setValues.length - 1] == "") {
				setValues.pop();
			}
			trace("Event: " + event);
			for each (var item:String in setValues) {
				var eqIndex:int = item.indexOf("=");
				var pair:Array = new Array(item.substring(0, eqIndex), item.substring(eqIndex+1, item.length));
				trace("On the left: " + pair[0]);
				trace("On the right: " + pair[1]);
				if (pair[0] != "" && pair[1] != "") {
				var left:String = pair[0];
				var right:String = pair[1];
				pair[0] = left.replace(/^\s*(.*[^\s\n])\s*$/,'$1');
				pair[1] = right.replace(/^\s*(.*[^\s\n])\s*$/,'$1');
				clipbindings.push(pair);
				}
			}

			if (bindings[currentClip] == null) {
				bindings[currentClip] = new Object();
			} 
			
			bindings[currentClip][event] = clipbindings;
		}
	}
}