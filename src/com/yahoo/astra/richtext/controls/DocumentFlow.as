package com.yahoo.astra.richtext.controls
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	import com.yahoo.astra.richtext.Node;
	
	public class DocumentFlow extends NodeFlow
	{
	
	//--------------------------------------
	//  Constructor
	//--------------------------------------
	
		public function DocumentFlow()
		{
			super();
			this.document = this;
		}
		
	//--------------------------------------
	//  Properties
	//--------------------------------------
	
		internal var nodeToDisplayDataHash:Dictionary = new Dictionary(true);
		internal var displayObjectToNodeHash:Dictionary = new Dictionary(true);
		
	//--------------------------------------
	//  Public Methods
	//--------------------------------------
	
		public function displayObjectToNode(displayObject:DisplayObject):Node
		{
			return this.displayObjectToNodeHash[displayObject];
		}
		
		public function nodeToDisplayData(node:Node):Object
		{
			return this.nodeToDisplayDataHash[node];
		}
		
	}
}