package com.yahoo.astra.richtext.controls
{
	import fl.core.UIComponent
	import flash.display.DisplayObject;
	import flash.text.TextField;

	/**
	 * A very simple component that positions its children with a flow algorithm.
	 */
	public class Flow extends UIComponent
	{
		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
	
		public function Flow()
		{
			super();
		}
			
	//--------------------------------------
	//  Protected Methods
	//--------------------------------------
	
		override protected function draw():void
		{
			var xPosition:Number = 0;
			var yPosition:Number = 0;
			var lineAscent:Number = 0;
			var lineDescent:Number = 0;
			var currentLine:Array = [];
			for(var i:int = 0; i < this.numChildren; i++)
			{
				var child:DisplayObject = this.getChildAt(i);
				
				var childWidth:Number = this.getItemWidth(child);
				var childAscent:Number = this.getItemAscent(child);
				var childDescent:Number = this.getItemDescent(child);
				var childHeight:Number = childAscent + childDescent;
				
				var endOfLine:Boolean = xPosition + childWidth > this.width || i == this.numChildren - 1;
				if(endOfLine)
				{
					var lineCount:int = currentLine.length;
					for(var j:int = 0; j < lineCount; j++)
					{
						var item:DisplayObject = currentLine[j] as DisplayObject;
						
						//since the line height (and descent) probably changed
						//since the item was first positioned, we're positioning
						//it again.
						item.y = yPosition + lineAscent - this.getItemAscent(item);
						
						if(item is TextField) item.y -= 2; //textfield gutter
					}
					
					currentLine = [];
										
					xPosition = 0;
					yPosition += lineAscent + lineDescent;
					lineAscent = 0;
					lineDescent = 0;
				}
				
				currentLine.push(child);
				
				lineAscent = Math.max(lineAscent, childAscent);
				lineDescent = Math.max(lineDescent, childDescent);
				
				child.x = xPosition;
				
				//this y position will only be correct when there is a single
				//item on the line. We calculate it now because it is needed
				//when there is only one item on the last line.
				child.y = yPosition + lineAscent - childAscent;
				xPosition += childWidth;
				
				//if it's a textfield, correct for the gutters
				if(child is TextField)
				{
					child.x -= 2;
					child.y -= 2;
				}
			}
			
			this.height = yPosition + lineAscent + lineDescent;
			this.invalidateFlag = false;
			super.draw();
		}
		
	//--------------------------------------
	//  Private Methods
	//--------------------------------------
	
		private function getItemWidth(item:DisplayObject):Number
		{
			var w:Number = item.width;
			if(item is TextField)
			{
				var textField:TextField = item as TextField;
				w = textField.textWidth;
			}
			
			return w;
		}
		
		private function getItemHeight(item:DisplayObject):Number
		{
			var h:Number = item.height;
			if(item is TextField)
			{
				var textField:TextField = item as TextField;
				h = textField.getLineMetrics(0).height;//textHeight;
			}
			return h;
		}
		
		private function getItemAscent(item:DisplayObject):Number
		{
			if(item is TextField)
			{
				return (item as TextField).getLineMetrics(0).ascent;
			}
			//for any other display object, the ascent is its height
			return item.height;
		}
		
		private function getItemDescent(item:DisplayObject):Number
		{
			if(item is TextField)
			{
				return (item as TextField).getLineMetrics(0).descent;
			}
			//for any other display object, the descent is zero
			return 0;
		}
		
	}
}