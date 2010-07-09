package com.yahoo.astra.richtext.managers
{
	import flash.display.Stage;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import fl.core.UIComponent;
	import com.yahoo.astra.richtext.*;
	import com.yahoo.astra.richtext.controls.DocumentFlow;
	import com.yahoo.astra.richtext.controls.flowClasses.TextNodeDisplayData;
	import com.yahoo.astra.richtext.controls.Caret;
	import com.yahoo.astra.richtext.controls.NodeFlow;
	import com.yahoo.astra.richtext.utils.TextFormatUtil;
	import flash.events.EventDispatcher;
	import com.yahoo.astra.richtext.events.TextFormatEvent;
	import flash.events.FocusEvent;
	import com.yahoo.utils.DisplayObjectUtil;
	import flash.events.TextEvent;
	import flash.text.TextFieldType;
	
	[Event(name="textFormatChange",type="com.yahoo.astra.richtext.events.TextFormatEvent")]
	
	public class InputManager extends EventDispatcher
	{
		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
	
		public function InputManager(target:DocumentFlow)
		{
			this.target = target;
			this.stage = this.target.stage;
			this.target.addEventListener(Event.ADDED_TO_STAGE, targetAddedToStageHandler, false, 0, true);
			this.target.addEventListener(MouseEvent.CLICK, targetClickHandler, false, 0, true);
			this.target.addEventListener(FocusEvent.FOCUS_IN, targetFocusInHandler, false, 0, true);
			this.target.addEventListener(FocusEvent.FOCUS_OUT, targetFocusOutHandler, false, 0, true);
			this.target.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		}
		
	//--------------------------------------
	//  Properties
	//--------------------------------------
	
		/**
		 * The FlowContainer object that we're targeting.
		 */
		protected var target:DocumentFlow;
		
		protected var caret:Caret;
		
		private var _stage:Stage;
		
		protected function get stage():Stage
		{
			return this._stage;
		}
		
		protected function set stage(value:Stage):void
		{
			if(this._stage)
			{
				if(this.caret)
				{
					this.stage.removeChild(this.caret);
					this.caret = null;
				}
			}
			
			this._stage = value;
			
			if(this._stage)
			{
				this.caret = new Caret();
				this.caret.visible = false;
				this.stage.addChild(this.caret);
			}
		}
		
		/**
		 * The <code>Document</code> object that we're editing. Comes from the target.
		 */
		public var document:Document;
		
		/**
		 * @private
		 * Storage for the textFormat value of the last TextNode
		 * that the input cursor had focused. We need this for
		 * creating new text nodes.
		 */
		private var _inputTextFormat:TextFormat = null;
		
		public function get inputTextFormat():TextFormat
		{
			return this._inputTextFormat;
		}
		
		public function set inputTextFormat(value:TextFormat):void
		{
			if(!TextFormatUtil.equal(this._inputTextFormat, value))
			{
				this._inputTextFormat = value;
				this.dispatchEvent(new TextFormatEvent(TextFormatEvent.TEXT_FORMAT_CHANGE));
			}
		}
		
		/**
		 * @private
		 * Storage for the inputNode property.
		 */
		private var _inputNode:Node;
		
		/**
		 * The currently focused node.
		 */
		public function get inputNode():Node
		{
			return this._inputNode;
		}
		
		/**
		 * @private
		 */
		public function set inputNode(value:Node):void
		{
			this._inputNode = value;
			var textNode:TextNode = this._inputNode as TextNode;
			if(textNode)
			{
				this.inputTextFormat = textNode.textFormat;
			}
		}
		
		private var inputIndex:int = -1;
		
	//--------------------------------------
	//  Public Methods
	//--------------------------------------
	
		public function insertMedia(media:DisplayObject):void
		{
			
		}
		
	//--------------------------------------
	//  Protected Methods
	//--------------------------------------
	
		protected function keyDownHandler(event:KeyboardEvent):void
		{
			if(!this.inputNode) return;
			
			if(event.keyCode == Keyboard.LEFT)
			{
				this.moveBack();
			}
			else if(event.keyCode == Keyboard.RIGHT)
			{
				this.moveForward();
			}
			else if(event.keyCode == Keyboard.UP)
			{
				
			}
			else if(event.keyCode == Keyboard.DOWN)
			{
				
			}
			else if(event.keyCode == Keyboard.BACKSPACE)
			{
				this.deleteBack();
			}
			else if(event.keyCode == Keyboard.DELETE)
			{
				this.deleteForward();
			}
			else if(event.keyCode == Keyboard.ENTER)
			{
				
			}
			else if(event.charCode >= 32 && event.charCode <= 126)
			{
				var text:String = String.fromCharCode(event.charCode);
				this.insertText(text);
			}
			
			this.refreshCaret();
		}
		
		protected function moveBack():void
		{
			var textNode:TextNode = this.inputNode as TextNode;
			this.inputIndex--;
			
			//if the input index is less than zero, we need to move to the
			//previous node. in the case of non-text nodes, it will always be
			//negative
			if(this.inputIndex < 0)
			{
				var previousNode:Node = this.findPreviousNode(this.inputNode);
				if(previousNode)
				{
					textNode = previousNode as TextNode;
					if(textNode)
					{
						var oldInputNode:Node = this.inputNode;
						this.inputNode = textNode;
						this.inputIndex = textNode.text.length;
						if(oldInputNode.parent == this.inputNode.parent)
						{
							 this.inputIndex--;
						}
					}
					else
					{
						this.inputNode = previousNode;
						//for non-text nodes, the index is always -1
						this.inputIndex = -1;
					}
				}
				else
				{
					if(textNode)
					{
						//we must be at the beginning of the document
						//so reset the index to zero.
						this.inputIndex = 0;
					}
					else this.inputIndex = -1;
				}
			}
		}
		
		protected function deleteBack():void
		{
			var textNode:TextNode = this.inputNode as TextNode;
			var previousNode:Node = this.findPreviousNode(this.inputNode);
			
			if(textNode && this.inputIndex > 0)
			{
				this.inputIndex--;
				this.removeText();
			}
			else if(previousNode) //we need to manipulate the node that appears before the input node
			{
				textNode = previousNode as TextNode;
				if(textNode)
				{
					this.inputNode = textNode;
					this.inputIndex = textNode.text.length - 1;
					
					this.removeText();
				}
				else
				{
					this.removeNode(previousNode);
				}
			}
		}
		
		protected function moveForward():void
		{
			var textNode:TextNode = this.inputNode as TextNode;
			if(textNode)
			{
				this.inputIndex++;
			}
			
			if(!textNode || this.inputIndex > textNode.text.length)
			{
				var nextNode:Node = this.findNextNode(this.inputNode);
				if(nextNode)
				{
					var skip:Boolean = false;
					if(textNode) skip = this.inputIndex == textNode.text.length + 1;	
					
					textNode = nextNode as TextNode;
					if(textNode)
					{
						var oldInputNode:Node = this.inputNode;
						this.inputNode = textNode;
						this.inputIndex = 0;
						if(skip && oldInputNode.parent == this.inputNode.parent)
						{
							//if the input index was at the very end of the previous node
							//we need to start at index 1
							this.inputIndex++;
						}
						
					}
					else
					{
						if(skip)
						{
							//special case for if the index is the same as the
							//length of the previous node. we're actually going
							//to skip the next node.
							var nextNextNode:Node = this.findNextNode(nextNode);
							if(nextNextNode)
							{
								this.inputNode = nextNextNode;
								if(this.inputNode is TextNode)
								{
									this.inputIndex = 0;
								}
								else this.inputIndex = -1;
							}
							else
							{
								this.inputNode = nextNode;
								if(this.inputNode is TextNode)
								{
									this.inputIndex = 1;
								}
								else this.inputIndex = -1;
							}
						}
						else
						{
							this.inputNode = nextNode;
							//for non-text nodes, the index is always -1
							this.inputIndex = -1;
						}
					}
				}
				else if(textNode)
				{
					//we must be at the end of the document so reset the index.
					this.inputIndex = textNode.text.length;
				}
			}
		}
		
		protected function deleteForward():void
		{
			var textNode:TextNode = this.inputNode as TextNode;
			var nextNode:Node = this.findNextNode(this.inputNode);
			if(textNode && this.inputIndex < textNode.text.length)
			{
				this.removeText();
			}
			else if(nextNode)
			{
				textNode = nextNode as TextNode;
				if(textNode)
				{
					this.inputNode = textNode;
					this.inputIndex = 0;
					this.removeText();
				}
				else
				{
					this.removeNode(nextNode, false);
				}
			}
		}
		
		private function findPreviousNode(node:Node, crawlTree:Boolean = true):Node
		{	
			var previousNode:Node;
			var parentNode:ContainerNode = node.parent;
			var index:int = parentNode.getChildIndex(node);
			if(index > 0)
			{
				previousNode = parentNode.getChildAt(index - 1);
			}
			
			if(!previousNode && crawlTree)
			{
				//crawl the tree to get nodes from other containers
				previousNode = this.findPreviousNode(parentNode, false);
				while(previousNode is ContainerNode)
				{
					var previousContainer:ContainerNode = previousNode as ContainerNode;
					previousNode = previousContainer.getChildAt(previousContainer.numChildren - 1);
				}
			}
			
			return previousNode;
		}
		
		private function findNextNode(node:Node, crawlTree:Boolean = true):Node
		{	
			var nextNode:Node;
			var parentNode:ContainerNode = node.parent;
			var index:int = parentNode.getChildIndex(node);
			if(index < parentNode.numChildren - 1)
			{
				nextNode = parentNode.getChildAt(index + 1);
			}
			
			if(!nextNode && crawlTree)
			{
				//crawl the tree to get nodes from other containers
				nextNode = this.findNextNode(parentNode, false);
				while(nextNode is ContainerNode)
				{
					var nextContainer:ContainerNode = nextNode as ContainerNode;
					nextNode = nextContainer.getChildAt(0);
				}
			}
			
			return nextNode;
		}
		
		private function insertText(text:String):void
		{
			var textNode:TextNode = this.inputNode as TextNode;
			if(!textNode)
			{
				//see if we can find an adjacent TextNode
				textNode = this.findPreviousNode(this.inputNode, false) as TextNode;
				
				//otherwise, add a new TextNode
				if(!textNode)
				{
					var parentNode:ContainerNode = this.inputNode.parent;
					var index:int = parentNode.getChildIndex(this.inputNode);
					textNode = new TextNode("", this._inputTextFormat);
					parentNode.addChildAt(textNode, index);
				}
				
				//we should have a TextNode now, so
				//switch the input node to point to it
				this.inputNode = textNode;
				this.inputIndex = textNode.text.length;
			}
			
			if(!TextFormatUtil.equal(textNode.textFormat, this.inputTextFormat))
			{
				//save the new inputTextFormat because it will change when we split the current input node.
				var newInputFormat:TextFormat = this.inputTextFormat;
				
				this.splitInputNode();
				parentNode = this.inputNode.parent;
				var insertionIndex:int = parentNode.getChildIndex(this.inputNode);
				
				textNode = new TextNode("", newInputFormat);
				parentNode.addChildAt(textNode, insertionIndex + 1);
				
				this.inputNode = textNode;
				this.inputIndex = 0;
			}
			
			//add the new text
			textNode.text = textNode.text.substr(0, this.inputIndex) + text + textNode.text.substr(this.inputIndex);
			this.moveForward();
		}
		
		private function removeText():void
		{
			var textNode:TextNode = this.inputNode as TextNode;
			textNode.text = textNode.text.substr(0, this.inputIndex) + textNode.text.substr(this.inputIndex + 1);
			if(!textNode.text)
			{			
				//remove the text node if the text is empty
				this.removeNode(textNode);
			}
		}
		
		private function removeNode(node:Node, updateInputNode:Boolean = true):void
		{
			var previousNode:Node = this.findPreviousNode(node);
			var nextNode:Node = this.findNextNode(node);
			
			var parentNode:ContainerNode = node.parent;
			parentNode.removeChild(node);
			
			if(previousNode is TextNode && nextNode is TextNode && previousNode.parent == nextNode.parent)
			{
				var previousTextNode:TextNode = previousNode as TextNode;
				var nextTextNode:TextNode = nextNode as TextNode;
				
				if(TextFormatUtil.equal(previousTextNode.textFormat, nextTextNode.textFormat))
				{
					//combine the previous and next nodes if their parent and textformat values are equal.
					var previousNodeLength:int = previousTextNode.text.length;
					previousTextNode.text += nextTextNode.text;
					parentNode.removeChild(nextTextNode);
					if(updateInputNode)
					{
						this.inputNode = previousNode;
						this.inputIndex = previousNodeLength;
					}
				}
			}
			else if(updateInputNode)
			{
				if(previousNode)
				{
					this.inputNode = previousNode;
					if(this.inputNode is TextNode)
					{
						this.inputIndex = (this.inputNode as TextNode).text.length;
					}
					else this.inputIndex = -1;
				}
				else if(nextNode)
				{
					this.inputNode = nextNode;
					if(this.inputNode is TextNode)
					{
						this.inputIndex = 0;
					}
					else this.inputIndex = -1;
				}
			}
		}
		
		private function splitInputNode():void
		{
			//TODO: Handle the case when the input index is at the beginning or end!
			
			var node:TextNode = this.inputNode as TextNode;
			
			var parentNode:ContainerNode = node.parent;
			var index:int = parentNode.getChildIndex(node);
			var nodes:Array = node.split(this.inputIndex);
			parentNode.removeChildAt(index);
			
			var firstHalf:TextNode = nodes[0] as TextNode;
			var secondHalf:TextNode = nodes[1] as TextNode;
			
			parentNode.addChildAt(firstHalf, index);
			parentNode.addChildAt(secondHalf, index + 1);
			
			this.inputNode = firstHalf;
		}
		
		private function targetAddedToStageHandler(event:Event):void
		{
			this.stage = event.target.stage;
		}
		
		private function targetClickHandler(event:MouseEvent):void
		{
			if(event.currentTarget != this.target) return;
			
			if(event.target is TextField)
			{
				var textField:TextField = event.target as TextField;
				var textNode:TextNode = this.target.displayObjectToNode(textField) as TextNode;
				var displayData:TextNodeDisplayData = this.target.nodeToDisplayData(textNode) as TextNodeDisplayData;
				this.inputNode = displayData.node;
				
				//account for the TextField's gutters
				var clickX:Number = Math.max(2, event.localX);
				clickX = Math.min(clickX, 2 + textField.textWidth);
				var clickY:Number = Math.max(2, event.localY);
				clickY = Math.min(clickY, 2 + textField.textHeight);
				
				var clickPosition:Point = new Point(clickX, clickY);
				clickPosition = DisplayObjectUtil.localToLocal(clickPosition, textField, textField.parent);
				
				this.inputIndex = displayData.positionToIndex(clickPosition);
				this.target.setFocus();
			}
			else
			{
				var node:Node = this.target.displayObjectToNode(event.target as DisplayObject);
				if(node)
				{
					this.inputNode = node;
					this.inputIndex = -1;
					this.target.setFocus();
				}
			}
		}
		
		private function refreshCaret():void
		{
			var nodeData:Object = this.target.nodeToDisplayData(this.inputNode);
			if(nodeData is TextNodeDisplayData)
			{
				var displayData:TextNodeDisplayData = nodeData as TextNodeDisplayData;
				var textField:TextField = displayData.indexToTextField(this.inputIndex);
				var caretPosition:Point = displayData.indexToPosition(this.inputIndex);
				caretPosition = textField.localToGlobal(caretPosition);
				
				this.caret.x = caretPosition.x;
				this.caret.y = caretPosition.y;
				this.caret.height = textField.getLineMetrics(0).ascent;
				this.caret.visible = true;
			}
			else if(nodeData is DisplayObject)
			{
				var mediaContent:DisplayObject = nodeData as DisplayObject;
				
				caretPosition = mediaContent.localToGlobal(new Point(0, 0));
				this.caret.x = caretPosition.x;
				this.caret.y = caretPosition.y;
				this.caret.height = mediaContent.height;
				this.caret.visible = true;
			}
			else this.caret.visible = false;
			this.caret.drawNow();
		}
		
		private function targetFocusInHandler(event:FocusEvent):void
		{
			this.refreshCaret();
		}
		
		private function targetFocusOutHandler(event:FocusEvent):void
		{
			this.caret.visible = false;
		}
	}
}