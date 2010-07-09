package com.yahoo.astra.richtext
{
	import flash.display.DisplayObject;
	import com.yahoo.astra.richtext.events.NodeEvent;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.display.LoaderInfo;
	import flash.events.IOErrorEvent;
	
	public class MediaNode extends Node
	{
		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
	
		public function MediaNode(content:DisplayObject = null)
		{
			super();
			this.content = content;
		}
		
	//--------------------------------------
	//  Properties
	//--------------------------------------
		
		private var _content:DisplayObject
		
		public function get content():DisplayObject
		{
			return this._content;
		}
		
		public function set content(value:DisplayObject):void
		{
			this._content = value;
			
			if(this._content is Loader)
			{
				var loader:Loader = this._content as Loader;
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleteHandler, false, 0, true);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loaderIOErrorHandler, false, 0, true);
			}
			
			var change:NodeEvent = new NodeEvent(NodeEvent.CONTENT_CHANGE);
			this.dispatchEvent(change);
		}
		
	//--------------------------------------
	//  Public Methods
	//--------------------------------------
		
		override public function toString():String
		{
			return "[" + this.content.toString() + " MediaNode]";
		}
		
	//--------------------------------------
	//  Public Methods
	//--------------------------------------
	
		protected function loaderCompleteHandler(event:Event):void
		{
			var loaderInfo:LoaderInfo = event.target as LoaderInfo;
			loaderInfo.removeEventListener(Event.COMPLETE, loaderCompleteHandler);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loaderIOErrorHandler);
			
			var change:NodeEvent = new NodeEvent(NodeEvent.CONTENT_CHANGE);
			this.dispatchEvent(change);
		}
		
		protected function loaderIOErrorHandler(event:IOErrorEvent):void
		{
			var loaderInfo:LoaderInfo = event.target as LoaderInfo;
			loaderInfo.removeEventListener(Event.COMPLETE, loaderCompleteHandler);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loaderIOErrorHandler);
		}
	}
}