package com.yahoo.astra.richtext.controls
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.geom.Point;
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	import com.yahoo.astra.richtext.*;
	import com.yahoo.astra.richtext.controls.flowClasses.TextNodeDisplayData;
	import com.yahoo.utils.DisplayObjectUtil;
	import com.yahoo.astra.richtext.events.NodeEvent;
	
	public class NodeFlow extends Flow
	{
		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
	
		public function NodeFlow()
		{
			super();
		}
	
	//--------------------------------------
	//  Properties
	//--------------------------------------
		
		public var document:DocumentFlow;
		
		private var _data:ContainerNode = new ContainerNode();
		
		public function get data():ContainerNode
		{
			return this._data;
		}
		
		public function set data(value:ContainerNode):void
		{
			if(this._data != value)
			{
				if(this._data)
				{
					this._data.removeEventListener(NodeEvent.CONTENT_CHANGE, contentChangeHandler);	
				}
				
				this._data = value as ContainerNode;
				
				if(this._data)
				{
					this._data.addEventListener(NodeEvent.CONTENT_CHANGE, contentChangeHandler, false, 10, true);
				}
				
				this._invalidIndex = 0;
				this._invalidChildIndex = 0;
				this.invalidate();
			}
		}
		
		private var _invalidIndex:int = 0;
		private var _invalidChildIndex:int = 0;
		private var _cachedTextFields:Array = [];
		private var _cachedDisplayObjects:Array = [];
		private var _nodeStartPositions:Array = [];
		
	//--------------------------------------
	//  Protected Methods
	//--------------------------------------
	
		override protected function draw():void
		{
			if(this._invalidIndex < 0) return; //no need to redraw!
			
			//its likely that we will be using most of the same objects when we
			//redraw the flow. cache everything for reuse so that we don't need
			//to excessively manipulate the display list.
			this.createCache();
			
			if(this._data)
			{
				this.drawNodes();
			}
			
			this.clearCache();
			
			this._invalidChildIndex = -1;
			this._invalidIndex = -1;
			super.draw();
		}
		
		protected function drawNodes():void
		{
			var xPosition:Number = 0;
			var yPosition:Number = 0;
			var lineHeight:Number = 0;
			var lineIndex:int = 0;
			if(this._invalidChildIndex > 0)
			{
				//get the original start position of the invalid node
				var position:Point = this._nodeStartPositions[this._invalidIndex];
				xPosition = position.x;
				yPosition = position.y;
				this._nodeStartPositions.splice(this._invalidIndex);
			}
			else
			{
				this._nodeStartPositions = [];
			}
			
			var nodeCount:int = this._data.numChildren;
			for(var i:int = this._invalidIndex; i < nodeCount; i++)
			{
				var node:Node = this._data.getChildAt(i);
				if(node is ContainerNode)
				{
					var nodeFlow:NodeFlow = this.getNodeFlow(node as ContainerNode);
					nodeFlow.drawNow();
					
					this.document.nodeToDisplayDataHash[node] = nodeFlow;
					this.document.displayObjectToNodeHash[nodeFlow] = node;
					lineIndex++;
					
					xPosition = 0;
					this._nodeStartPositions[i] = new Point(xPosition, yPosition);
					yPosition += nodeFlow.height;
				}
				else if(node is MediaNode)
				{
					var mediaNode:MediaNode = node as MediaNode;
					var content:DisplayObject = this.getMediaContent(mediaNode);
					this.document.nodeToDisplayDataHash[mediaNode] = content;
					this.document.displayObjectToNodeHash[content] = mediaNode;
					
					if(xPosition != 0 && (xPosition + content.width > this.width))
					{
						xPosition = 0;
						yPosition += lineHeight;
						lineHeight = 0;
						lineIndex++;
					}
					this._nodeStartPositions[i] = new Point(xPosition, yPosition);
					
					xPosition += content.width;
					lineHeight = Math.max(lineHeight, content.height);
				}
				else if(node is TextNode)
				{
					var textNode:TextNode = node as TextNode;
					var textNodeData:TextNodeDisplayData = new TextNodeDisplayData(textNode);
					this.document.nodeToDisplayDataHash[textNode] = textNodeData;
					
					this._nodeStartPositions[i] = new Point(xPosition, yPosition);
					
					var remainingText:String = textNode.text;
					while(remainingText.length > 0)
					{	
						var textStartIndex:int = textNode.text.length - remainingText.length;
						if(xPosition == 0 && remainingText.charAt(0) == " ")
						{
							//skip whitespace at the beginning of the line.
							remainingText = remainingText.substr(1);
						}
						var textField:TextField = this.getTextField();
						if(textNode.textFormat)
						{
							textField.defaultTextFormat = textNode.textFormat;
						}
						textField.text = remainingText;
						
						var lengthToEndOfLine:Number = this.width - xPosition;
						
						xPosition += textField.textWidth;
						
						//if we've caused this line to overflow...
						if(lengthToEndOfLine < textField.textWidth)
						{
							var lastCharacter:Point = DisplayObjectUtil.localToLocal(new Point(lengthToEndOfLine, textField.height / 2), this, textField);
							var index:int = textField.getCharIndexAtPoint(lastCharacter.x, lastCharacter.y);
							if(index > 0)
							{
								//find the last whitespace character
								index = remainingText.lastIndexOf(" ", index - 1) + 1;
							}
							
							index = Math.min(index, remainingText.length);
							//we might have a really long line!
							if(index < 0 || (index == 0 && xPosition == textField.textWidth))
							{
								index = remainingText.indexOf(" ");
								if(index < 0)
								{
									index = remainingText.length;
								}
							}
							
							textField.text = remainingText.substr(0, index);
							
							//skip whitespace at the end of the line.
							if(textField.text.charAt(textField.length - 1) == " ")
							{
								textField.text = textField.text.substr(0, textField.length - 1);
							}
							
							//if we've cleared all the text in this textfield, remove it
							if(!textField.text)
							{
								this.removeChild(textField);
								textField = null;
							}
							else
							{
								lineHeight = Math.max(lineHeight, textField.textHeight);
								/*if(i == nodeCount - 1)
								{
									textField.autoSize = TextFieldAutoSize.NONE;
									textField.width = lengthToEndOfLine - 4;
								}*/
							}
							
							remainingText = remainingText.substr(index);
							xPosition = 0;
							yPosition += lineHeight;
							lineHeight = 0;
							lineIndex++;
						}
						else //all of our text fits on this one line.
						{
							remainingText = "";
							lineHeight = Math.max(lineHeight, textField.textHeight);
							/*if(i == nodeCount - 1)
							{
								textField.autoSize = TextFieldAutoSize.NONE;
								textField.width = lengthToEndOfLine;
							}*/
						}
						
						if(textField)
						{
							this.document.displayObjectToNodeHash[textField] = node;
							textNodeData.addTextField(textField, textStartIndex);
						}
						
					}
				}
			}
		}
		
	//--------------------------------------
	//  Private Methods
	//--------------------------------------
	
		private function getNodeFlow(node:ContainerNode):NodeFlow
		{
			var flow:NodeFlow;
			
			this._nodeToFind = node;
			var filteredValues:Array = this._cachedDisplayObjects.filter(isNodeFlowForData);
			
			if(filteredValues.length > 0)
			{
				flow = filteredValues[0] as NodeFlow;
				var index:int = this._cachedDisplayObjects.indexOf(flow);
				this._cachedDisplayObjects.splice(index, 1);
				this.setChildIndex(flow, this.numChildren - 1);
			}
			else
			{
				flow = new NodeFlow();
				this.addChild(flow);
			}
			
			flow.document = this.document;
			flow.data = node;
			flow.width = this.width;
			flow.drawNow();
			
			return flow;
		}
		
		private function getTextField():TextField
		{
			var textField:TextField;
			if(this._cachedTextFields.length == 0)
			{
				textField = new TextField();
				textField.selectable = false;
				/*//debug
				textField.border = true;
				textField.borderColor = 0xff0000;*/
				this.addChild(textField);
			}
			else
			{
				textField = this._cachedTextFields.pop() as TextField;
				textField.x = textField.y = 0;
				textField.text = "";
				textField.visible = true;
				this.setChildIndex(textField, this.numChildren - 1);
			}
			textField.autoSize = TextFieldAutoSize.LEFT;
			return textField;
		}
		
		private function getMediaContent(node:MediaNode):DisplayObject
		{
			var index:int = this._cachedDisplayObjects.indexOf(node.content);
			if(index < 0)
			{
				this.addChild(node.content);
			}
			else
			{
				//simply remove from cache, it's already on the display list
				this._cachedDisplayObjects.splice(index, 1);
				this.setChildIndex(node.content, this.numChildren - 1);
			}
			
			return node.content;
		}
		
		private function createCache():void
		{
			var childCount:int = this.numChildren;
			for(var i:int = this._invalidChildIndex; i < childCount; i++)
			{
				var child:DisplayObject = this.getChildAt(i);
				var node:Node = this.document.displayObjectToNode(child);
				
				//clear relations between the display object and its node
				this.document.displayObjectToNodeHash[child] = null;
				this.document.nodeToDisplayDataHash[node] = null;
				if(child is TextField)
				{
					//text fields are a special case
					child.visible = false;
					this._cachedTextFields.push(child);
				}
				else
				{
					this._cachedDisplayObjects.push(child);
				}
			}
		}
		
		private function clearCache():void
		{
			//clear any unused textfields
			var cacheLength:int = this._cachedTextFields.length;
			for(var i:int = 0; i < cacheLength; i++)
			{
				var textField:TextField = this._cachedTextFields.pop() as TextField;
				this.removeChild(textField);
			}
			
			//clear the cached display objects
			cacheLength = this._cachedDisplayObjects.length;
			for(i = 0; i < cacheLength; i++)
			{
				var content:DisplayObject = this._cachedDisplayObjects.pop();
				if(content is NodeFlow)
				{
					(content as NodeFlow).data = null;
				}
				this.removeChild(content);
			}
		}
		
		private var _nodeToFind:Node;
		
		private function isNodeFlowForData(item:Object, index:int, array:Array):Boolean
		{
			if(item is NodeFlow)
			{
				var nodeFlow:NodeFlow = item as NodeFlow;
				if(nodeFlow.data == this._nodeToFind)
				{
					return true;
				}
			}
			return false;
		}
		
		private function contentChangeHandler(event:NodeEvent):void
		{
			var node:Node = event.relatedObject as Node;
			if(this._data.hasChild(node))
			{
				this._invalidIndex = this.data.getChildIndex(node);
				
				this._invalidChildIndex = -1;
				var displayData:Object = this.document.nodeToDisplayData(node);
				if(displayData is TextNodeDisplayData)
				{
					var textData:TextNodeDisplayData = displayData as TextNodeDisplayData;
					this._invalidChildIndex = this.getChildIndex(textData.indexToTextField(0));
				}
				else
				{
					this._invalidChildIndex = this.getChildIndex(displayData as DisplayObject);
				}
					
				this.invalidate();
			}
		}
		
	}
}