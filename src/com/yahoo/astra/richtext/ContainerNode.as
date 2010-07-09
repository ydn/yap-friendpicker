package com.yahoo.astra.richtext
{
	import com.yahoo.astra.richtext.events.NodeEvent;
		
	public class ContainerNode extends Node
	{
		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
	
		public function ContainerNode()
		{
			super();
			this.layoutMode = LayoutMode.BLOCK;
		}
		
	//--------------------------------------
	//  Properties
	//--------------------------------------
		
		private var _children:Array = [];
		
		public function get numChildren():int
		{
			return this._children.length;
		}
		
	//--------------------------------------
	//  Public Methods
	//--------------------------------------
	
		public function getChildAt(index:int):Node
		{
			return this._children[index];
		}
		
		public function getChildIndex(node:Node):int
		{
			return this._children.indexOf(node);
		}
		
		public function addChild(node:Node):void
		{
			this.addChildAt(node, this.numChildren);
		}
		
		public function addChildAt(node:Node, index:int):void
		{
			this._children.splice(index, 0, node);
			node.parentNode = this;
			node.rootDocument = this.document;
			node.addEventListener(NodeEvent.CONTENT_CHANGE, childContentChangeHandler, false, 0, true);
			//var change:NodeEvent = new NodeEvent(NodeEvent.CONTENT_CHANGE, node);
			//this.dispatchEvent(change);
		}
		
		public function removeChild(node:Node):Node
		{
			var index:int = this._children.indexOf(node);
			if(index >= 0)
			{
				return this.removeChildAt(index);
			}
			
			throw new Error("Node must be a child of ContainerNode.");
		}
		
		public function removeChildAt(index:int):Node
		{
			if(index < 0 || index >= this._children.length)
			{
				throw new Error("Node not found at index " + index + ".");
			}
			
			var removedChild:Node = this._children.splice(index, 1)[0];
			removedChild.parentNode = null;
			removedChild.rootDocument = null;
			removedChild.removeEventListener(NodeEvent.CONTENT_CHANGE, childContentChangeHandler);
			
			//var change:NodeEvent = new NodeEvent(NodeEvent.CONTENT_CHANGE);
			//this.dispatchEvent(change);
			
			return removedChild;
		}
		
		public function removeAllChildren():Array
		{
			var removedChildren:Array = [];
			var childCount:int = this.numChildren;
			for(var i:int = 0; i < childCount; i++)
			{
				var removedChild:Node = this.removeChildAt(0);
				removedChildren.push(removedChild);
			}
			return removedChildren;
		}
		
		public function join(node:ContainerNode, removeEmptyNode:Boolean = true):void
		{
			if(node is Document)
			{
				throw new Error("Cannot join a document with another node.");
			}
			
			var childCount:int = node.numChildren;
			for(var i:int = 0; i < childCount; i++)
			{
				var child:Node = node.removeChildAt(0);
				this.addChild(child);
			}
			
			if(removeEmptyNode)
			{
				var parentNode:ContainerNode = node.parent;
				parentNode.removeChild(node);
			}
		}
		
		public function hasChild(node:Node):Boolean
		{
			return this._children.indexOf(node) >= 0;
		}
		
	//--------------------------------------
	//  Protected Methods
	//--------------------------------------
	
		protected function childContentChangeHandler(event:NodeEvent):void
		{
			var change:NodeEvent = new NodeEvent(NodeEvent.CONTENT_CHANGE, event.target as Node);
			this.dispatchEvent(change);
		}
		
	}
}