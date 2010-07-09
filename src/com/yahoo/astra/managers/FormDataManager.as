﻿
package com.yahoo.astra.managers {
	import com.yahoo.astra.containers.formClasses.FormItem;
	import com.yahoo.astra.containers.formClasses.FormLayoutStyle;
	import com.yahoo.astra.events.FormDataManagerEvent;
	import com.yahoo.astra.utils.IValueParser;
	import com.yahoo.astra.utils.ValueParser;

	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;	
	/**
	 * FormDataManager to collect user input data and validate it before you submit the data to the server. 
	 * Astra does not provide a separate validation class, but there are compatible validation classes available from Adobe. 
	 * Another option for the validation is the mx.validators distributed in the Flex SDK. For convenient use of Flex validators, you can use the Astra <code>MXValidatorHelper</code> class. 
	 * Flex MXvalidator provides a variety of validation types and detailed error messages. However, the use of the MXvalidator will increase your overall file size by approximately 20K.
	 * 
	 * 
	 * 
	 * @see com.yahoo.astra.fl.utils.MXValidatorHelper
	 * @see http://code.google.com/p/flash-validators
	 * @author kayoh  
	 */
	public class FormDataManager extends EventDispatcher {
		//--------------------------------------
		// Constructor
		//--------------------------------------
		/**
		 * Constructor.
		 * 
		 * @example The following code shows a use of <code>FormDataManager</code>:
		 *  <listing version="3.0">
		 *  import import com.yahoo.astra.fl.utils.FlValueParser;	
		 *  
		 *  // Init validator to be used.
		 *	var manager = new FormDataManager(FlValueParser);
		 *	manager.functionValidationSuccess = handler_passed;
		 *	manager.functionValidationFail = handler_failed;
		 *	manager.errorString = "required field or invalid input";
		 * </listing>
		 * 
		 * @param customValuedator A Class having Ivaluedator as its interface. If there is no defined class, <code>com.yahoo.astra.utils.Valuedator</code> will be used to strip input data.
		 * 
		 * @see com.yahoo.astra.utils.Valuedator
		 * @see com.yahoo.astra.fl.utils.FlValuedator
		 */
		public function FormDataManager(customValuedator : Class = null) {
			valueParser = (customValuedator) ? customValuedator : ValueParser;
			managerArray = [];
		}
		//--------------------------------------
		// Properties
		//--------------------------------------
		/**
		 * @private
		 */
		private var valueParser : Class = null;
		/**
		 * @private
		 */
		private var managerArray : Array = [];
		/**
		 * @private
		 */
		private var validFunction : Function = null;
		/**
		 * @private
		 */
		private var inValidFunction : Function = null;
		/**
		 * @private
		 */
		private var _functionValidationSuccess : Function = null;
		/**
		 * Sets the bound method to be called as a handler function, when validation is success(FormDataManagerEvent.VALIDATION_PASSED).
		 */
		public  function get functionValidationSuccess() : Function {
			return _functionValidationSuccess;
		}
		/**
		 * @private
		 */
		public  function set functionValidationSuccess(value : Function) : void {
			_functionValidationSuccess = value;
		}
		/**
		 * @private
		 */
		private var _functionValidationFail : Function = null;
		/**
		 * Sets the bound method to be called as a handler function, when validation is failed(FormDataManagerEvent.VALIDATION_FAILED).
		 */
		public  function get functionValidationFail() : Function {
			return _functionValidationFail;
		}
		/**
		 * @private
		 */
		public  function set functionValidationFail(value : Function) : void {
			_functionValidationFail = value;
		}
		/**
		 * @private
		 */
		private var _errorString : String = FormLayoutStyle.DEFAULT_ERROR_STRING;
		/**
		 * Sets the text representing error.
		 * 
		 * @default "Invalid input"
		 */
		public  function get errorString() : String {
			return _errorString;
		}
		/**
		 * @private
		 */
		public  function set errorString(value : String) : void {
			_errorString = value;
		}
		/**
		 * @private
		 */
		private static var _collectedData : Object;
		/**
		 * Collection of form input data variables object array. 
		 * The <code>"id"</code> will be the key and the user input from the <code>"source"</code> will be value of the array.(e.g. collectedData["zip"] = "94089")
		 * You can loop over each value within the <code>collectedData</code> object instance by using a for..in loop.
		 * 
		 * @example The following code configures shows usage of collectedData:
		 * <listing version="3.0">
		 *  for (var i:String in FormDataManager.collectedData) {  
		 *		trace( i + " : " + FormDataManager.collectedData[i] + "\n");  
		 *	}
		 *	// state : CA
		 *	// zip :  94089
		 * </listing>
		 * 
		 */
		public static function get collectedData() : Object {
			return _collectedData;
		}
		/**
		 * @private
		 */
		public static function set collectedData(value : Object) : void {
			_collectedData = value;
		}
		/**
		 * @private
		 */
		private static var _failedData : Object = null;
		/**
		 * Collection of erroe messages object array. 
		 * Any error string from validation or default <code>errorString</code> will be collected as a object array with <code>"id"</code> as a key and the message as value.
		 * 
		 *  * @example The following code configures shows usage of collectedData:
		 * <listing version="3.0">
		 *  for (var i:String in FormDataManager.failedData) {  
		 *		trace( i + " : " + FormDataManager.failedData[i] + "\n");  
		 *	}
		 *	// zip : Unkown Zip type.
		 *	// email : The email address contains invalid characters.
		 * </listing>
		 */
		public static function get failedData() : Object {
			return _failedData;
		}
		/**
		 * @private
		 */
		public static function set failedData(value : Object) : void {
			_failedData = value;
		}
		/**
		 * @private
		 */
		private var _dataObject : Object = null;
		/**
		 * Gets or sets the data to be shown and validated in <code>FormContainer</code>. 
		 * <code>id</code>and <code>source</code> are mandatory. 
		 * 
		 * @example The following code shows a use of <code>dataProvider</code>:
		 *  <listing version="3.0">
		 *	manager.dataProvider = [
		 *	{id:"firstname", source:this["firstNameInput"], validator:validator.isNotEmpty,required:true,eventTargetObj:this["fistName_result"]},
		 *	{id:"lastname", source:this["lastNameInput"], validator:validator.isNotEmpty, required:true,eventTargetObj:this["lastNameInput"], eventFunction_success:handler_lastNameInput_passed,eventFunction_fail: handler_lastNameInput_failed},
		 *	{id:"message", source:this["messageInput"], validator:validator.isNotEmpty, required:true,eventTargetObj:this["message_result"]},
		 *	{id:"email", source:this["emailInput"], validator:validator.isEmail, required:true,eventTargetObj:this["email_result"]},
		 *	{id:"state", source:this["stateComboBox"]},
		 *	{id:"emailformat", source:radioGroup},
		 *	{id:"zipcode", source:this["zipcodeInput"], validator:validator.isNotEmpty, required:true,eventTargetObj:this["zip_result"]},
		 *	];
		 * </listing>
		 * 
		 * 
		 * @see addItem for parameter can be applied.
		 * 
		 */
		public function get dataProvider() : Object {
			return this._dataObject;
		}
		/**
		 * @private
		 */
		public function set dataProvider(value : Object) : void {
			this._dataObject = value;
			buildFromDataProvider();
		}
		
		
		//--------------------------------------
		//  Public Methods
		//--------------------------------------
		/**
		 * Register itmes into the FormDataManager with it's properties.
		 * Since FormDataManager collects and saves data as form of associative arrays, "id" will be used as a property of the array. (e.g. collectedData["zip"] = "94089")
		 * <code>id</code>and <code>source</code> are mandatory. 
		 * 
		 * @param id String to be a property of the data array(collectedData or failedData)
		 * @param source Object contains form input.
		 * @param property Object property of the <code>source</code>.
		 * @param validation Function object to be used for validation of the <code>source</code>. 
		 * @param required Boolean determinds to be validated or not.
		 * @param eventTargetObj DisplayObject to be listen <code>FormDataManagerEvent</code> (<code>FormDataManagerEvent.VALIDATION_PASSED</code> and <code>FormDataManagerEvent.VALIDATION_FAILED</code>)
		 * @param eventFunction_success Function Object to be triggered when <code>eventTargetObj</code> gets <code>FormDataManagerEvent.VALIDATION_PASSED</code> event.
		 * @param eventFunction_success Function Object to be triggered when <code>eventTargetObj</code> gets <code>FormDataManagerEvent.VALIDATION_FAILED</code> event.
		 */
		public  function addItem(id : String,source : Object, property : Object = null , validation : Function = null,required : Boolean = false , eventTargetObj : DisplayObject = null,eventFunction_success : Function = null,eventFunction_fail : Function = null) : void {
			
			var valueParserObject : * = new valueParser();
			var valueParser : IValueParser = ( valueParserObject is IValueParser) ? valueParserObject : new ValueParser();
			managerArray.push({id:id, value : valueParser.setValue(source, property), validation:validation, required:required, eventTargetObj:eventTargetObj});
			if(eventTargetObj ) {
				var handler_success_function : Function = (eventFunction_success is Function) ? eventFunction_success : functionValidationSuccess;
				var handler_fail_function : Function = (eventFunction_fail is Function) ? eventFunction_fail : functionValidationFail;
				if(handler_success_function is Function) eventTargetObj.addEventListener(FormDataManagerEvent.VALIDATION_PASSED, handler_success_function);
				if(handler_fail_function is Function) eventTargetObj.addEventListener(FormDataManagerEvent.VALIDATION_FAILED, handler_fail_function);
			}
		}	
		/**
		 * Start collecting and validating data.
		 * If there is registerd trigger(<code>addTrigger</code>), this function will be called by <code>MouseEvent.CLICK</code> event of the button.
		 * 
		 * @param e MouseEvent
		 */
		public function collectData(e : MouseEvent = null) : void {
			var arrLeng : Number = managerArray.length;
			FormDataManager.collectedData = FormDataManager.failedData = null;
			FormDataManager.collectedData = {};	
			FormDataManager.failedData = {};	
			var passedBool : Boolean = true;
			
			for (var j : Number = 0;j < arrLeng; j++) {
				if(managerArray[j].eventTargetObj is FormItem) {
					var curFormItme : FormItem = managerArray[j].eventTargetObj as FormItem;
					curFormItme.gotResultBool = true;
				}
			}
			for (var i : Number = 0;i < arrLeng; i++) {
				var result : Boolean = validateAndStore(managerArray[i].id, managerArray[i].value, managerArray[i].validation, managerArray[i].required, managerArray[i].eventTargetObj);
				passedBool &&= result;
			}	
			
			(passedBool) ? this.dispatchEvent(new FormDataManagerEvent(FormDataManagerEvent.DATACOLLECTION_SUCCESS, false, false, null, FormDataManager.collectedData)) : this.dispatchEvent(new FormDataManagerEvent(FormDataManagerEvent.DATACOLLECTION_FAIL, false, false, FormDataManager.failedData, collectedData));
		}
		/**
		 * Register a button(DisplayObject) to trigger <code>collectData</code> by MouseEvent.CLICK event.
		 * Also sets <code>validFunction</code> and <code>inValidFunction</code> to be triggered when <code>FormDataManagerEvent.DATACOLLECTION_SUCCESS</code> or <code>FormDataManagerEvent.DATACOLLECTION_FAIL</code> happens.
		 * 
		 * @param button DisplayObject button to be clicked.
		 * @param eventFunction_fail Function to be triggered when all the forms in the FormDataManagerEvent passed validation(<code>FormDataManagerEvent.DATACOLLECTION_SUCCESS</code>)
		 * @param eventFunction_fail Function to be triggered when any the forms in the FormDataManagerEvent failed validation(<code>FormDataManagerEvent.DATACOLLECTION_FAIL</code>)
		 */
		public function addTrigger(button : DisplayObject, eventFunction_success : Function = null, eventFunction_fail : Function = null) : void {
			
			if(eventFunction_success is Function) { 
				validFunction = eventFunction_success;
				this.addEventListener(FormDataManagerEvent.DATACOLLECTION_SUCCESS, eventFunction_success);
			}
			if(eventFunction_fail is Function) { 
				inValidFunction = eventFunction_fail;
				this.addEventListener(FormDataManagerEvent.DATACOLLECTION_FAIL, eventFunction_fail);
			}
			if(button is DisplayObject) {
				button.addEventListener(MouseEvent.CLICK, collectData, false, 0, true);
			}
		}
		/**
		 * unregister a button(DisplayObject) to trigger <code>collectData</code>.
		 * Also removes listener of <code>FormDataManagerEvent.DATACOLLECTION_SUCCESS</code> and <code>FormDataManagerEvent.DATACOLLECTION_FAIL</code>.
		 * @param button DisplayObject
		 */
		public function removeTrigger(button : DisplayObject) : void {
			button.removeEventListener(MouseEvent.CLICK, collectData);
			if(validFunction is Function) this.removeEventListener(FormDataManagerEvent.DATACOLLECTION_SUCCESS, validFunction);
			if(inValidFunction is Function) this.removeEventListener(FormDataManagerEvent.DATACOLLECTION_FAIL, inValidFunction);
		}

		//--------------------------------------
		//  Private Methods
		//--------------------------------------
		
		
		/**
		 * @private
		 */
		private function buildFromDataProvider() : void {
			
			var dataLength : int = dataProvider.length;
			
			for (var i : int = 0;i < dataLength; i++) {
				var curData : Object = dataProvider[i];
				/*
				 * no Id, no collection
				 */
				var curId : String = curData["id"] as String;
				var curSource : Object = curData["source"] as Object;
				if(!curId || !curSource) {
					throw new Error("id and source are needed."); 
					continue;
				} else {
					addItem( curId, curSource, curData["property"], curData["validator"], curData["required"], curData["eventTargetObj"], curData["eventFunction_success"], curData["eventFunction_fail"]);	
				}
			}
		}

		
		/**
		 * @private
		 */
		private function validateAndStore(id : String , value : Object , validation : Function = null,required : Boolean = false,eventTargetObj : DisplayObject = null) : Boolean {
			var curErrStr : String = errorString;
			if(value is Function) {
				var func : Function = value as Function;
				value = func();
			}
			var tempResult : Boolean = true;
			if(validation != null) { 
				var validationResult : Object = validation(value);
				if(required) {
					tempResult = false;
					//ADOBE Validator result
					if(validationResult is Boolean ) {
						if(validationResult) tempResult = true;
					} else {
						//MX Validator result
						if(validationResult is Array) {
							if(validationResult.length > 0) {
								if(validationResult[0].errorMessage) curErrStr = validationResult[0].errorMessage;
							} else {
								tempResult = true;
							} 
						}
						//ADOBE Validator result
						if(validationResult.errorStr) curErrStr = validationResult.errorStr;
						if(validationResult.result) tempResult = true; 
					}
				}
			}
			
			if(eventTargetObj is FormItem) {
				var formItem : FormItem = eventTargetObj as FormItem;
				if(formItem.errorString != FormLayoutStyle.DEFAULT_ERROR_STRING) curErrStr = formItem.errorString;
			}
			if(tempResult) {
				FormDataManager.collectedData[id] = value;
				if(eventTargetObj)eventTargetObj.dispatchEvent(new FormDataManagerEvent(FormDataManagerEvent.VALIDATION_PASSED));
				return true;
			} else {
				FormDataManager.failedData[id] = curErrStr; 
				if(eventTargetObj) eventTargetObj.dispatchEvent(new FormDataManagerEvent(FormDataManagerEvent.VALIDATION_FAILED, false, false, curErrStr));
				return false;
			}
		}
	}
}
