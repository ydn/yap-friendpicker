package com.yahoo.astra.richtext
{
	import flash.events.EventDispatcher;
	
	[Event(name="contentChange", type="com.yahoo.astra.richtext.events.NodeEvent")]
	
	public class Node extends EventDispatcher
	{
		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
	
		public function Node()
		{
		}
		
	//--------------------------------------
	//  Properties
	//--------------------------------------
		
		internal var parentNode:ContainerNode;
		
		public function get parent():ContainerNode
		{
			return this.parentNode;
		}
		
		internal var rootDocument:Document;
		
		public function get document():Document
		{
			return this.rootDocument;
		}
		
		private var _layoutMode:String = LayoutMode.INLINE;
		
		public function get layoutMode():String
		{
			return this._layoutMode;
		}
		
		public function set layoutMode(value:String):void
		{
			this._layoutMode = value;
		}
	}
}