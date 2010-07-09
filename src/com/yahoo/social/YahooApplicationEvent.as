package com.yahoo.social
{
	import flash.events.Event;

	public final class YahooApplicationEvent extends Event
	{
		public static const SECURITY_ERROR:String = "SECURITY_ERROR";
		
		protected var $data:Object;
		protected var $response:Object;
		
		public function YahooApplicationEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			//TODO: implement function
			super(type, bubbles, cancelable);
		}
		
		public function get data():Object
		{
			return this.$data;
		}
		
		public function set data(value:Object):void
		{
			this.$data = value;
		}
		
		public function get response():Object
		{
			return this.$response;
		}
		
		public function set response(value:Object):void
		{
			this.$response = value;
		}
	}
}