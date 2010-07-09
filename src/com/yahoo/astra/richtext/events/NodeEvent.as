package com.yahoo.astra.richtext.events
{
	import flash.events.Event;
	import com.yahoo.astra.richtext.Node;

	public class NodeEvent extends Event
	{
		public static const CONTENT_CHANGE:String = "contentChange";
		
		public function NodeEvent(type:String, relatedObject:Node = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.relatedObject = relatedObject;
		}
		
		public var relatedObject:Node;
		
		override public function clone():Event
		{
			return new NodeEvent(this.type, this.relatedObject, this.bubbles, this.cancelable);
		}
		
	}
}