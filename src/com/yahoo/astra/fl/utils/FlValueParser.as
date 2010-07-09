package com.yahoo.astra.fl.utils {
	import fl.controls.ColorPicker;
	import fl.controls.ComboBox;
	import fl.controls.LabelButton;
	import fl.controls.NumericStepper;
	import fl.controls.RadioButtonGroup;
	import fl.controls.TextArea;
	import fl.controls.TextInput;
	import fl.core.UIComponent;
	import com.yahoo.astra.fl.utils.FlValueParser;
	import com.yahoo.astra.utils.IValueParser;
	import com.yahoo.astra.utils.ValueParser;
	import flash.text.TextField;	

	/**
	 * Valuedator is helper class that provides easy data stripping from UI components.
	 * 
	 * <p><strong>Source and default property:</strong></p>
	 * <dl>
	 * 	<dt><strong><code>TextInput</code></strong> : "text"</dt>
	 * 	<dt><strong><code>ComboBox</code></strong> : selectedItem["data"]</dt>
	 * 	<dt><strong><code>NumericStepper</code></strong> : "value"</dt>
	 * 	<dt><strong><code>LabelButton</code></strong> : "selected"</dt>
	 * 	<dd>LabelButton includes Button,CheckBox, RadioButton</dd>
	 * 	<dt><strong><code>ColorPicker</code></strong> : "hexValue"</dt>
	 * </dl>
	 * 
	 * @see com.yahoo.astra.utils.ValueParser
	 */
	public class FlValueParser extends ValueParser implements IValueParser {
		/**
		 * Constructor
		 */
		public function FlValueParser() {
			super();
		}

		/**
		 * 
		 * Store a source(input field) and property of the source to collect data from. 
		 * If the source is UIcomponent or TextField, you don't have to specify the property.
		 * (e.g. If you want to strip a data from TextInput, you don't have to specify property as "text".)
		 * However, you can detail the data you want collect by setting property parameter
		 * (e.g. source:ComboBox, property:"abbreviation");
		 * 
		 * <code>setValue</code> passed as arguments to <code>getValue</code> is passed by reference and not by value. 
		 * So you can call this returned method as function with parentheses operator when the user input into the source is ready to be collected.
		 * see the actual use in the FormDataManager.
		 * 
		 * @copy com.yahoo.astra.utils.Ivaluedator#getValue 
		 */
		override public function getValue() : Object {
			var returned_value : Object = null ;
			if(!_source) {
				if(this._value) return this._value;
			} else {
				if(this._source is UIComponent) {
					return UIcomponentsValue(this._source as UIComponent, this._value);
				} else {
					return objectValue(this._source, this._value);
				}
			}
			
			return returned_value;
		}

		/**
		 * @private
		 */
		private function objectValue(source : Object = null, property : Object = null) : Object {
			
			var returnedvalue : Object = {};
			switch(source) {
				case source as TextField:
					var textInput : TextField = source as TextField;
					if(!property)  property = "text";
					returnedvalue = textInput[property];
					break;
					
				case source as RadioButtonGroup:
					var rBtnBrp : RadioButtonGroup = source as RadioButtonGroup;
					if(!property)  property = "selectedData";
					if(rBtnBrp[property]) returnedvalue = rBtnBrp[property];
					break;	
					
				default :
					if(source && property) returnedvalue = source[property];
					break;
			}
			/*
			 * prevent returning null.	
			 */
			if(!returnedvalue) returnedvalue = "";
			return returnedvalue;
		}

		/**
		 * @private
		 */
		private function  UIcomponentsValue(UiComponent : UIComponent = null, property : Object = null) : Object {
			var returnedvalue : Object = {};
			switch(UiComponent) {
				case UiComponent as TextInput:
					var textInput : TextInput = UiComponent as TextInput;
					if(!property)  property = "text";
					returnedvalue = textInput[property];
					break;
												
				case UiComponent as ComboBox:
					var comboBox : ComboBox = UiComponent as ComboBox;
					if(!property)  property = "data";
					returnedvalue = comboBox.selectedItem[property];
					if(!returnedvalue) returnedvalue = " ";
					break;
											
				case UiComponent as TextArea:
					var textArea : TextArea = UiComponent as TextArea;
					if(!property)  property = "text";
					returnedvalue = textArea[property];
					break;
				case UiComponent as NumericStepper:
					var numericStepper : NumericStepper = UiComponent as NumericStepper;
					if(!property)  property = "value";
					returnedvalue = numericStepper[property];
					break;
				/*
				 * LabelButton includes Button,CheckBox, RadioButton
				 */					
				case UiComponent as LabelButton:
					var checkBox : LabelButton = UiComponent as LabelButton;
					if(!property || property == "selected") {  
						returnedvalue = checkBox["selected"];
					} else {
						if(Boolean(checkBox["selected"])) {
							returnedvalue = property;
						} else {
							returnedvalue = checkBox["selected"];
						}
					}
					break;
				case UiComponent as ColorPicker:
					var colorPicker : ColorPicker = UiComponent as ColorPicker;
					if(!property)  property = "hexValue";
					returnedvalue = colorPicker[property];
					break;
						
				default :
					returnedvalue = "";
					break;
			}
			/*
			 * prevent returning null.	
			 */
			if(!returnedvalue) returnedvalue = "";
			return returnedvalue;
		}
	}
}
