package com.yahoo.astra.customizer
{
	import flash.display.Stage;
	import flash.display.*;
	import flash.events.EventDispatcher;
	import flash.external.*;
	import flash.events.*;
	import com.yahoo.astra.customizer.events.*;
	import com.yahoo.astra.customizer.net.LocalConnectionDispatcher;
	import flash.net.LocalConnection;
	import flash.events.StatusEvent;	
	import flash.external.ExternalInterface;
	
    //--------------------------------------
    //  Events
    //--------------------------------------
    /**
     * Dispatched when a binding object is added.  
     *
     * @eventType com.yahoo.astra.customizer.events.CustomizerEvent.REGISTERED_BINDINGS
     */
	[Event(name="registeredBindings", type="com.yahoo.astra.customizer.events.CustomizerEvent")]
	
    //--------------------------------------
    //  Class description
    //--------------------------------------			
	/**
	 * The Customizer class is used to manage flash vars passed into an application. The
	 * Customizer class allows a developer to create an application with customizable styles
	 * and properties. Flash files created with the Customizer class can be added to Badge Central
	 * and customized by an end user.  
	 *
	 */
	public class Customizer extends EventDispatcher
	{
		/**
		 * @private
		 * object that will contain all bindings
		 */
		private static var _bindings:Object = {};
		
		/**
		 * @private
		 *
		 * object that will contain flash embed params
		 */
		private static var _flashParams:Object = {}; 
		
		/**
		 * @private
		 * parent display object that loads the customizer
		 */
		private static var _parent:DisplayObject;
		
		/**
		 * @private (protected)
		 *
		 * LocalConnectionDispatcher used to communicate through LocalConnection.
		 */
		protected static var _localConnectionDispatcher:LocalConnectionDispatcher;
		
		/**
		 * @private (protected)
		 *
		 * comma delimited string of allowed domains
		 */
		//Temporarily wildcarded.  We will not release with a wildcard.  It will contain the domain of the location of BadgeCentral.swf
		protected static var _allowedDomains:String = "*";
		
		/**
		 * @private (protected)
		 * 
		 * contains a list of objects and functions used to apply changes to properties and styles.
		 */
		protected static var _objectDictionary:Object = {}; 
		
		/**
		 * @private (protected)
		 *
		 * contains a list of groups for that the portal will use for organizing controls
		 * each group contains a title and a description
		 */
		protected static var _groups:Object = {}; 
		
		/**
		 * @private (protected)
		 *
		 * indicates whether or not there should be a local connection
		 */
		protected static var _useLocalConnection:Boolean = false;
		
		/**
		 * @private 
		 *
		 * Instance of the Customizer class as this is now a singleton
		 */
		private static var _customizer:Customizer;
		
		/**
		 * @private (protected)
		 */
		protected static var _allowInstantiation:Boolean = false;
		/**
		 * @private (singleton) 
		 * 
		 * Establishes a parent object.  Creates a <code>LocalConnectionDispatcher</code> instance and sets its sending and receiving 
		 * connection.  Creates a <code>StageResizer</code> instance.
		 */
		public function Customizer(parent:DisplayObject)
		{
			if(_allowInstantiation)
			{
				_parent = parent;
				if(_parent.loaderInfo.parameters.rndNumString != null)
				{
					_useLocalConnection = true;
					var rndNumString:String = _parent.loaderInfo.parameters.rndNumString;			
					_localConnectionDispatcher = new LocalConnectionDispatcher();
					_localConnectionDispatcher.setReceivingDomains([_allowedDomains]);
					_localConnectionDispatcher.addEventListener(CustomizerEvent.REGISTERED_BINDINGS, updateBinding);
					_localConnectionDispatcher.setSendingConnection("_toConfigEditor" + rndNumString); 
					_localConnectionDispatcher.setReceivingConnection("_toCustomizer" + rndNumString);				
					var resizer:StageResizer = new StageResizer(parent.stage, _localConnectionDispatcher);
				}
			}
			else
			{
				throw new Error("This is a singleton class that can only be accessed through the Customizer.getInstance() method");
			}
		}
		
		/**
		 * Returns the singleton instance of the Customizer class. 
		 * Use this method to instantiate the Customizer in an application.  
		 * <listing version="3.0">
		 * //instantiate the Customizer 
		 * var myCustomizer:Customizer = Customizer.getInstance(this);
		 * </listing>
		 */
		public static function getInstance(parent:DisplayObject):Customizer
		{
			if(_customizer == null)
			{
				_allowInstantiation = true;
				_customizer = new Customizer(parent);
				_allowInstantiation = false;
			}
			return _customizer;
		}

		/**
		 * @private (protected)
		 * 
		 * Updates a binding
		 *
		 * @param event CustomizerEvent object
		 */ 
		public function updateBinding(event:CustomizerEvent):void
		{
			try
			{
				if(event != null)
				{
					var updatedBinding:Object = event.binding;
					if(updatedBinding.value != null && _bindings[updatedBinding.flashVarName] != null)
					{
						if(updatedBinding.bindingType == "property")
						{
							_objectDictionary[updatedBinding.flashVarName][updatedBinding.propName] = updatedBinding.value;
						}
						else if(updatedBinding.bindingType == "function")
						{
							_objectDictionary[updatedBinding.flashVarName](updatedBinding.propName, updatedBinding.value);	
						}	
					}
				}
			}
			catch(e:Error)
			{
				throw new Error(e);
			}
		}

		/**
		 * @private (protected)
		 *
		 * @param binding  Contains information relating to a particular property or function to be set by the customizer.
		 * @param flashVarName Identifier for the flash var
		 *
		 * Assigns a binding value to the property of a property binding or passes the value as a parameter to the function of a function binding.
		 * If there is an exisisting flashvar in the <code>loaderInfo.parameters</code> object, that value will be used instead.
		 */
		protected function registerBinding(binding:Object, flashVarName:String):void
		{
			var flashVars:Object = _parent.loaderInfo.parameters;

			if(binding.bindingType == "property")
			{
				if(flashVars[flashVarName] != null)
				{
					_objectDictionary[binding.flashVarName][binding.propName] = flashVars[flashVarName];
				}
				else if(binding.value != null)
				{
					_objectDictionary[binding.flashVarName][binding.propName] = binding.value;
				}
			}
			else if(binding.bindingType == "function")
			{
				if(flashVars[flashVarName] != null)
				{
					_objectDictionary[binding.flashVarName](binding.propName, flashVars[flashVarName]);
				}
				else if(binding.value != null)
				{
					_objectDictionary[binding.flashVarName](binding.propName, binding.value);
				}
			}		
		}
		

		/**
		 * Creates a property binding and adds it to the <code>_bindings</code> object.  
		 * <p>Passes the new binding to the registerBinding method to assign the value to appropriate property.</p>
		 * <p>Dispatches a <code>CustomizerEvent.REGISTER_BINDINGS</code> event through the LocalConnectionDispatcher class.</p>
		 *
		 * @param label Text for the label on the form of the parent customizing swf.
		 * @param obj Contains the property to which the flash value will be assigned.
		 * @param propName The name of the variable to which the flash var will be assigned.
		 * @param controlType The <code>ControlType.type</code> of variable.
		 * @param defaultParams Optional parameters that can contain the following any of the following properties:
		 * <br />
		 *  <table class="innertable" width="100%">
		 *  	<tr><th>Property</th><th>Purpose</th></tr>
		 * 		<tr><td><code>flashVarName</code></td><td>Specified value to be used for the flashVar name.  If 
		 *  one is not specified, a value will be generated.</td></tr>
		 *     	<tr><td><code>value</code></td><td>The default value for property.  This value will populate the configuration control in the BadgeCentral portal.</td></tr>
		 *      <tr><td><code>customizable</code></td><td>Indicates whether the property is configurable by the end user.</td></tr>		 
		 * 		<tr><td><code>dataProvider</code></td><td>Optional filter to specify the colors to display in the ColorPicker.  It can be used when the property is of <code>ControlType.COLOR</code>.</td></tr>
		 * 		<tr><td><code>restrict</code></td><td>Optional filter to limit the allowed characters when the property is of type <code>String</code>.</td></tr>
		 *      <tr><td><code>maxChars</code></td><td>Optional filter to limit the number of characters allowed when the property is of type <code>String</code>.</td></tr>		 
		 * 		<tr><td><code>maximum</code></td><td>Optional filter to specify the maximum allowed value for a <code>Number</code>, <code>int</code> or <code>uint</code>.</td></tr>
		 * 		<tr><td><code>minimum</code></td><td>Optional filter to specify the minimum allowed value for a <code>Number</code>, <code>int</code> or <code>uint</code>.</td></tr>
		 *  </table>
		 */
		public function addProperty(label:String,
									obj:Object,
									propName:String,
									controlType:String = ControlType.TEXT_INPUT,
									defaultParams:* = null):void
		{
		
			var flashVarName:String = (defaultParams != null && defaultParams.flashVar != null)?defaultParams.flashVar:label.replace(/ /g, '')+propName;
			_objectDictionary[flashVarName] = obj;
			_bindings[flashVarName] = {
				flashVarName:flashVarName,
				label:label,
				propName:propName,
				controlType:controlType, 
				bindingType:"property",
				customizable:true
			}
			
			if(defaultParams != null)
			{
				for(var i:String in defaultParams)
				{
					_bindings[flashVarName][i] = defaultParams[i]
				}
			}
			registerBinding(_bindings[flashVarName], flashVarName);
			if(_useLocalConnection)
			{
				var obj:Object = {bindings:_bindings, binding:_bindings[flashVarName], type:"registeredBindings"};
				_localConnectionDispatcher.sendData(obj);
			}
		}
								
		/**
		 * Creates a function binding and adds it to the <code>_bindings</code> object.  
		 * <p>Passes the new binding to the registerBinding method which will pass the values to the appropriate function.</p>
		 * <p>Dispatches a <code>CustomizerEvent.REGISTER_BINDINGS</code> event through the LocalConnectionDispatcher class.</p>		
		 * 
		 * @param label Text for the label on the form of the parent customizing swf.
		 * @param func Function called to set the value (e.g. setStyle).  
		 * @param propName The name of the variable to which the flash var will be assigned.
		 * @param controlType The <code>ControlType.type</code> of variable.
		 * @param defaultParams Optional parameters that can contain the following any of the following properties:
		 * <br />
		 *  <table class="innertable" width="100%">
		 *  	<tr><th>Property</th><th>Purpose</th></tr>
		 * 		<tr><td><code>flashVarName</code></td><td>Specified value to be used for the flashVar name.  If 
		 *  one is not specified, a value will be generated.</td></tr>
		 *     	<tr><td><code>value</code></td><td>The default value for property.  This value will populate the configuration control in the BadgeCentral portal.</td></tr>
		 *      <tr><td><code>customizable</code></td><td>Indicates whether the property is configurable by the end user.</td></tr>		 
		 * 		<tr><td><code>dataProvider</code></td><td>Optional filter to specify the colors to display in the ColorPicker.  It can be used when the property is of <code>ControlType.COLOR</code>.</td></tr>
		 * 		<tr><td><code>restrict</code></td><td>Optional filter to limit the allowed characters when the property is of type <code>String</code>.</td></tr>
		 *      <tr><td><code>maxChars</code></td><td>Optional filter to limit the number of characters allowed when the property is of type <code>String</code>.</td></tr>		 
		 * 		<tr><td><code>maximum</code></td><td>Optional filter to specify the maximum allowed value for a <code>Number</code>, <code>int</code> or <code>uint</code>.</td></tr>
		 * 		<tr><td><code>minimum</code></td><td>Optional filter to specify the minimum allowed value for a <code>Number</code>, <code>int</code> or <code>uint</code>.</td></tr>	
		 *  </table>
		 */
		public function addFunction(label:String,
									func:Function,
									propName:String,
									controlType:String = ControlType.TEXT_INPUT,
									defaultParams:* = null):void
		{
			var flashVarName:String = (defaultParams != null && defaultParams.flashVar != null)?defaultParams.flashVar:label.replace(/ /g, '') + propName;
			_objectDictionary[flashVarName] = func;
			_bindings[flashVarName] = {
				flashVarName:flashVarName,
				label:label,
				controlType:controlType,
				propName:propName,
				bindingType:"function",
				customizable:true
			}
			if(defaultParams != null)
			{
				for(var i:String in defaultParams)
				{
					_bindings[flashVarName][i] = defaultParams[i];
				}				
			}
			registerBinding(_bindings[flashVarName], flashVarName);
			if(_useLocalConnection)
			{
				var obj:Object = {bindings:_bindings, binding:_bindings[flashVarName], type:"registeredBindings"};
				_localConnectionDispatcher.sendData(obj);
			}
		}
		
		/**
		 * Creates a flashParam object and adds it to the global flashParams object.
		 * <p>Allows the developer to specify embed params for the html wrapper generated in BadgeCentral.  The
		 * developer has the option to make the params customizable to the end user.</p>
		 * <p>Dispatches a <code>CustomizerEvent.UPDATE_FLASH_PARAM</code> event through the LocalConnectionDispatcher class</p>
		 *
		 * @param propName HTML param to be set on the embed object. 
		 * @param propValue Value to set on the HTML param of the embed object.
		 * @param controlType indicates the <code>ControlType.type</code> of variable.
		 * @param customizable indicates whether or not the property is to be configurable by the end user.
		 *
		 * @example The following code sets the <code>wmode</code> of the html wrapper to <code>transparent</code> and allows for
		 * customization in BadgeCentral. The <code>allowScriptAccess</code> is set to <code>sameDomain</code> and is not exposed 
		 * for customization in BadgeCentral.
		 * <listing version="3.0">
		 * import com.yahoo.astra.customizer.*;
		 * import com.yahoo.astra.customizer.events.*;
		 * var myCustomizer:Customizer = Customizer.getInstance(this);
		 * myCustomizer.addFlashParam("wmode", "transparent", ControlType.TEXT_INPUT, true);
		 * myCustomizer.addFlashParam("allowScriiptAccess", "sameDomain");
		 * </listing>
		 */
		public function addFlashParam(propName:String, propValue:String, controlType:String = ControlType.TEXT_INPUT, customizable:Boolean = false):void
		{
			_flashParams[propName] = {
				label:propName,
				flashVarName:propName,
				controlType:controlType,
				value:propValue,
				customizable:customizable
			}
			
			if(_useLocalConnection)
			{
				var obj:Object = {flashParams:_flashParams, flashParam:_flashParams[propName], type:"updateFlashParam"};
				_localConnectionDispatcher.sendData(obj);
			}
		}
		
		
		/**
		 * Creates a group and adds it to the <code>_group</code> object.  
		 * <p>Groups are created by the developer and used by BadgeCentral to aggregate user controls. Once a group is created, 
		 * the developer can assign bindings to that group object through the <code>defaultParams</code> of the <code>addProperty</code>
		 * and <code>addFunction </code> methods.</p>
		 *
		 * @param groupName The key for the group
		 * @param groupTitle The title text associated with the group
		 * @param groupDescription The description text associated with the group
		 *
		 * @example The following code creates a group called Headline with the <code>addGroup</code> method and uses the <code>addProperty</code> 
		 * method to create a binding for a label and assign it to the headline group.
		 * <listing version="3.0">
		 * import fl.controls.Label; 
		 * import com.yahoo.astra.customizer.*;
		 * import com.yahoo.astra.customizer.events.*;		 
		 * var myCustomizer:Customizer = Customizer.getInstance(this);
		 * myCustomizer.addGroup("headline", "Headline", "Below are the configurable properties of the headline.");
		 * var myHeadline:Label = new Label();
		 * myCustomizer.addProperty("Headline text", this, "myHeadline", ControlType.TEXT_INPUT, {value:"This is a headline!", group:"headline"});
		 * </listing>
		 */
		public function addGroup(groupName:String, groupTitle:String, groupDescription:String):void
		{
			if(_useLocalConnection)
			{
				var obj:Object = {};
				obj.title = groupTitle;
				obj.description = groupDescription;
				obj.groupName = groupName;
				obj.type = "newGroup";
				_groups[groupName] = obj;
				_localConnectionDispatcher.sendData(obj);
			}
		}
	}
}





							