package com.yahoo.astra.richtext.events
{
	import flash.events.Event;

	public class TextFormatEvent extends Event
	{
		public static const TEXT_FORMAT_CHANGE:String = "textFormatChange";
		
		public function TextFormatEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new TextFormatEvent(this.type, this.bubbles, this.cancelable);
		}
		
	}
}