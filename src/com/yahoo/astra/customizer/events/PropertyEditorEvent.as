package com.yahoo.astra.customizer.events
{
	import flash.events.Event;
	
	public class PropertyEditorEvent extends Event
	{
		public var item:Object;
		
		//--------------------------------------
		//  Constants
		//--------------------------------------		
		/**
		 * Dispatched when a property changes
		 * @eventType propertyChanged
		 */
		public static const CHANGE:String = "change";
		
		
		public function PropertyEditorEvent(type:String)
		{
			super(type);
		}

	}
}