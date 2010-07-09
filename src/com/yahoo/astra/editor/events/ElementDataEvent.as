package com.yahoo.astra.editor.events
{
	import flash.events.Event;

	public class ElementDataEvent extends Event
	{
		public static const TARGET_CHANGE:String = "targetChange";
		public static const DATA_CHANGE:String = "dataChange";
		
		public function ElementDataEvent(type:String)
		{
			super(type, false, false);
		}
		
		override public function clone():Event
		{
			return new ElementDataEvent(this.type);
		}
		
	}
}