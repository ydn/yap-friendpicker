package com.yahoo.astra.utils
{
	import flash.events.FocusEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;

	/**
	 * A specialized UITextField designed to allow input of numeric values
	 * restricted to a particular range. 
	 * 
	 * @author Josh Tynjala
	 */
	public class NumericRangeInputRestriction
	{
		public function NumericRangeInputRestriction(target:TextField)
		{
			super();
			
			this.target = target;
			
			this.target.type = TextFieldType.INPUT;
			this.target.selectable = true;
			
			//make weak so that we can garbage collect
			this.target.addEventListener(TextEvent.TEXT_INPUT, textInputHandler);
			this.target.addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);
		}
		
		protected var target:TextField;
		
		private var _minimum:Number = NaN;
		
		public function get minimum():Number
		{
			return this._minimum;
		}
		
		public function set minimum(value:Number):void
		{
			this._minimum = value;
			this.refreshRestriction();
		}
		
		private var _maximum:Number = NaN;
		
		public function get maximum():Number
		{
			return this._maximum;
		}
		
		public function set maximum(value:Number):void
		{
			this._maximum = value;
			this.refreshRestriction();
		}
		
		private var _allowFloat:Boolean = false;
		
		public function get allowFloat():Boolean
		{
			return this._allowFloat;
		}
		
		public function set allowFloat(value:Boolean):void
		{
			this._allowFloat = value;
			this.refreshRestriction();
		}
		
		private var _maxPrecision:int = -1;
		
		public function get maxPrecision():int
		{
			return this._maxPrecision;
		}
		
		public function set maxPrecision(value:int):void
		{
			this._maxPrecision = value;
		}
		
		protected function refreshRestriction():void
		{
			var restrictValue:String = "0-9\\-";
			if(this.allowFloat)
			{
				restrictValue += "\\.";
			}
			this.target.restrict = restrictValue;
		}
		
		protected function textInputHandler(event:TextEvent):void
		{
			var currentText:String = this.target.text;
			currentText = currentText.substr(0, this.target.selectionBeginIndex) + event.text + currentText.substr(this.target.selectionEndIndex);
			
			//can't have multiple decimal places
			if(event.text == "." && this.target.text.indexOf(".") >= 0)
			{
				event.preventDefault();
				return;
			}
			
			//allow - at the front only if minimum includes negative numbers
			if(event.text == "-" && (this.target.selectionBeginIndex > 0 || this.minimum >= 0))
			{
				event.preventDefault();
				return;
			}
			
			//no more than one - may exist
			if(event.text == "-" && currentText.length > 1 && currentText.charAt(1) == "-")
			{
				event.preventDefault();
				return;
			}
			
			//this is the only non-numeric value that is okay
			//will convert to zero if focus is lost, though
			if(currentText == "-")
			{
				return;
			}
			
			//keep the number of decimal places within the specified precision
			var decimalIndex:int = currentText.indexOf(".");
			if(this.maxPrecision >= 0 && currentText.substr(decimalIndex + 1).length > this.maxPrecision)
			{
				event.preventDefault();
				return;
			}
			
			var newValue:Number = parseFloat(currentText);
			
			//if the new value isn't in the range, we don't want it!
			if((!isNaN(this.maximum) && newValue > this.maximum) || (!isNaN(this.minimum) && newValue < this.minimum))
			{
				event.preventDefault();
				return;
			}
		}
		
		/**
		 * @private 
		 */
		protected function focusOutHandler(event:FocusEvent):void
		{
			var parsedValue:Number = parseFloat(this.target.text);
			this.target.text = parsedValue.toString();
		}
	}
}