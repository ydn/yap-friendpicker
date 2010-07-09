package com.yahoo.astra.richtext
{
	import flash.text.TextFormat;
	import com.yahoo.astra.richtext.events.NodeEvent;
	import com.yahoo.astra.richtext.utils.TextFormatUtil;
	
	public class TextNode extends Node implements IIndexableNode, IFormattableNode
	{
		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
	
		public function TextNode(text:String = "", format:TextFormat = null)
		{
			super();
			this.text = text;
			this.textFormat = format;
		}
		
	//--------------------------------------
	//  Properties
	//--------------------------------------
		
		private var _text:String = "";
		
		public function get text():String
		{
			return this._text;
		}
		
		public function set text(value:String):void
		{
			if(value == null) value = "";
			
			this._text = value;
			
			var change:NodeEvent = new NodeEvent(NodeEvent.CONTENT_CHANGE);
			this.dispatchEvent(change);
		}
		
		public function get length():int
		{
			return this._text.length;
		}
		
		private var _textFormat:TextFormat;
		
		public function get textFormat():TextFormat
		{
			return this._textFormat;
		}
		
		public function set textFormat(value:TextFormat):void
		{
			this._textFormat = value;
		}
		
	//--------------------------------------
	//  Public Methods
	//--------------------------------------
		
		public function split(index:int):Array
		{
			var node1:TextNode = new TextNode();
			node1.text = this.text.substr(0, index);
			node1.textFormat = TextFormatUtil.clone(this.textFormat);
			
			var node2:TextNode = new TextNode();
			node2.text = this.text.substr(index);
			node2.textFormat = TextFormatUtil.clone(this.textFormat);
			
			return [node1, node2];
		}
		
		override public function toString():String
		{
			return this._text;
		}
		
	}
}