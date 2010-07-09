package com.yahoo.astra.richtext.controls.flowClasses
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import com.yahoo.astra.richtext.TextNode;
	import com.yahoo.utils.DisplayObjectUtil;
	
	/**
	 * Creates a mapping between a TextNode object and the TextFields that
	 * visually represent it.
	 */
	public class TextNodeDisplayData
	{
		/**
		 * Constructor.
		 */
		public function TextNodeDisplayData(node:TextNode = null)
		{
			this.node = node;	
		}
		
		public var node:TextNode;
		
		protected var indices:Dictionary = new Dictionary(true);
		protected var textFields:Array = [];
		
		public function addTextField(textField:TextField, startIndex:int):void
		{
			this.indices[textField] = startIndex;
			this.textFields.push(textField);
		}
		
		public function containsTextField(textField:TextField):Boolean
		{
			return this.textFields.indexOf(textField) >= 0;
		}
		
		public function textFieldToStartIndex(textField:TextField):int
		{
			var index:int = this.indices[textField];
			if(isNaN(index)) return -1;
			return index;
		}
		
		public function indexToTextField(index:int):TextField
		{
			var textFieldIndex:int = 0;
			var closestStartIndex:int = 0;
			var textFieldCount:int = this.textFields.length;
			for(var i:int = 0; i < textFieldCount; i++)
			{
				var textField:TextField = this.textFields[i] as TextField;
				var currentIndex:int = this.indices[textField];
				if(currentIndex <= index && currentIndex >= closestStartIndex)
				{
					textFieldIndex = i;
					closestStartIndex = currentIndex;
					if(closestStartIndex == index) break;
				}
			}
			
			return this.textFields[textFieldIndex];
		}
		
		public function indexToPosition(index:int):Point
		{
			var textField:TextField = this.indexToTextField(index);
			var startIndex:int = this.textFieldToStartIndex(textField);
			var difference:int = index - startIndex;
			
			if(difference > 0 && this.node.text.charAt(startIndex) == " " && textField.text.charAt(0) != " ")
			{
				difference--;
			}
			
			var bounds:Rectangle = textField.getCharBoundaries(difference);
			if(!bounds)
			{
				//if the index is the length of the text field, we'll get bad data
				return new Point(textField.textWidth + 2, 2);
			}
			return new Point(bounds.x, bounds.y);
		}
		
		public function positionToTextField(position:Point):TextField
		{
			var textFieldCount:int = this.textFields.length;
			for(var i:int = 0; i < textFieldCount; i++)
			{
				var textField:TextField = this.textFields[i] as TextField;
				var globalPosition:Point = textField.parent.localToGlobal(position); 
				if(textField.hitTestPoint(globalPosition.x, globalPosition.y))
				{
					return textField;
				}
			}
			
			return null;
		}
		
		public function positionToIndex(position:Point):int
		{
			var textField:TextField = this.positionToTextField(position);
			if(!textField)
			{
				return -1;
			}
			
			position = DisplayObjectUtil.localToLocal(position, textField.parent, textField);
			position.y = textField.height / 2;
			
			var textFieldIndex:int = textField.getCharIndexAtPoint(position.x, position.y);
			if(textFieldIndex < 0)
			{
				//we're inside the textfield, but there's no text under the mouse
				textFieldIndex = textField.text.length;
			}
			else
			{
				var bounds:Rectangle = textField.getCharBoundaries(textFieldIndex);
				if(bounds && position.x > bounds.x + bounds.width / 2)
				{
					textFieldIndex++;
				}
			}
			
			var startIndex:int = this.textFieldToStartIndex(textField);
			var endIndex:int = startIndex + textField.length - 1;
			if((this.node.text.charAt(startIndex) == " " && textField.text.charAt(0) != " ") ||
				(this.node.text.charAt(endIndex) == " " && textField.text.charAt(textField.length - 1) != " "))
			{
				textFieldIndex--;
			}
			return startIndex + textFieldIndex;
		}
	}
}