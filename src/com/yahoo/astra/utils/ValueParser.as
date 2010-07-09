package com.yahoo.astra.utils {
	import com.yahoo.astra.utils.IValueParser;

	import flash.text.TextField;	

	/**
	 * Valuedator is helper class that provides easy data stripping. It stores the source and property of data to be collected and return the value.
	 * By setting data source(input) on <code>setValue</code>, it returns the actual value of the source.
	 * Main usage of the class is storing function as a object before actual input happening, and providing handy collection of data from the source(input field). 
	 * 
	 * @example The following code shows a use of <code>FormContainer</code>:
	 *  <listing version="3.0">
	 *	import com.yahoo.astra.utils.ValueParser;
	 *	import com.yahoo.astra.fl.utils.FlValueParser;
	 *
	 *
	 *	var myComboBox:ComboBox = statesComboBox();
	 *	this.addChild(myComboBox);
	 *
	 *	var zipInput:TextInput = new TextInput();
	 *	zipInput.x = 105;
	 *	zipInput.restrict = "0-9";
	 *	zipInput.maxChars = 5;
	 *	this.addChild(zipInput);
	 *
	 *	var submitButton:Button = new Button();
	 *	submitButton.x = 210;
	 *	submitButton.width = 50;
	 *	submitButton.label ="Submit";
	 *	submitButton.addEventListener(MouseEvent.CLICK, clickHandler);
	 *	this.addChild(submitButton);
	 *
	 *	var myValueObect:Object = {myProperty: "State :"};
	 *	var myObjectValue:Function = new ValueParser().setValue(myValueObect, "myProperty");
	 *	var myComboBoxValue:Function = new FlValueParser().setValue(myComboBox, "abbreviation");
	 *	var myTextInputValue:Function = new FlValueParser().setValue(zipInput);
	 *
	 *	function clickHandler(e:Event):void{
	 *		trace(myObjectValue()+" "+myComboBoxValue()+" "+myTextInputValue());
	 *		// State : CA 94089
	 *	}
	 *
	 *	function statesComboBox():ComboBox {
	 *		var items : XML = <items>
	 *		<item label="California" abbreviation="CA" />
	 *		<item label="Tennessee" abbreviation="TN" />
	 *		<item label="New York" abbreviation="NY" />
	 *		</items>;
	 *		var comboBox : ComboBox = new ComboBox();
	 *		comboBox.dataProvider =  new DataProvider(items);
	 *		return comboBox;
	 *	}
	 *
	 * </listing>
	 * 
	 * @see com.yahoo.astra.fl.utils.FlValueParser
	 * @author kayoh
	 */
	public class ValueParser implements IValueParser {

		protected var _source : Object = null;
		protected var _value : Object = null;

		/**
		 * @copy com.yahoo.astra.utils.Ivaluedator#setValue
		 */
		public function setValue(source : Object = null, property : Object = null) : Function {
			_source = source;
			_value = property;
			
			return getValue;
		}

		/**
		 * @copy com.yahoo.astra.utils.Ivaluedator#getValue 
		 */
		public function getValue() : Object {
			if(!_source) {
				if(this._value) return this._value;
			} else {
				return objectValue(this._source, this._value);
			}
			/*
			 * preventing returning null.	
			 */
			return "";
		}

		/**
		 * @private
		 */
		private function objectValue(source : Object = null, property : Object = null) : Object {
			var returnedvalue : Object = {};
			
			if(source is TextField) {
				var textInput : TextField = source as TextField;
				if(!property)  property = "text";
				returnedvalue = textInput[property];
			} else {
				if(source && property) returnedvalue = source[property];
			}
			/*
			 * preventing returning null.	
			 */
			if(!returnedvalue) returnedvalue = "";
			return returnedvalue;
		}
	}
}
