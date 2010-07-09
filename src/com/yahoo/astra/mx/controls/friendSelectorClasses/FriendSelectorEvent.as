package com.yahoo.astra.mx.controls.friendSelectorClasses
{
	import flash.events.Event;

	/**
	 * The FriendSelectorEvent class represents the event object passed to the event listener for events dispatched by a FriendSelector.
	 * @see FriendSelector 
	 * @author zachg
	 * 
	 */	
	public class FriendSelectorEvent extends Event
	{
		public static const CONNECTIONS_ERROR:String = "connectionsError";
		
		/**
		 * The name of the event dispatched when the selectedItem of the selector changes. 
		 */		
		public static const SELECTION_CHANGE:String = "selectionChange";
		
		/**
		 * Storage variable for the event data object.
		 * @private
		 */		
		private var $data:Object;
		
		/**
		 * 
		 * @param type
		 * @param data
		 * @param bubbles
		 * @param cancelable
		 * 
		 */		
		public function FriendSelectorEvent(type:String, data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			$data = data;
		}
		
		/**
		 * The event data object. 
		 * @return 
		 * 
		 */		
		public function get data():Object
		{
			return $data;
		}
		
		/**
		 * The event data object.
		 * @param value
		 * 
		 */		
		public function set data(value:Object):void
		{
			this.$data = value;
		}
		
		/**
		 * Duplicates an instance of an YahooResultEvent class.
		 * @return
		 */
		override public function clone():Event
		{
			return new FriendSelectorEvent(type,data,bubbles,cancelable);
		}
		
		/**
		 * Returns a string containing all the properties of the Event object.
		 * @return
		 */ 
		override public function toString():String 
		{
			return formatToString("FriendSelectorEvent", "type", "data", "bubbles", "cancelable", "eventPhase");
		}
		
	}
}