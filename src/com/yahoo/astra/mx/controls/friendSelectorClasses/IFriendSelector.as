package com.yahoo.astra.mx.controls.friendSelectorClasses
{
	import com.yahoo.astra.mx.managers.AutoCompleteManager;
	import com.yahoo.social.YahooApplication;
	
	/**
	 * Interface object for all implementation of a friend selector.
	 * @author zachg
	 * 
	 */	
	public interface IFriendSelector
	{
		function get guid():String;
		function set guid(value:String):void
		
		function get sortFields():String;
		function set sortFields(value:String):void;
		
		function get labelFields():String;
		function set labelFields(value:String):void
		
		function get application():YahooApplication;
		function set application(value:YahooApplication):void;
		
		function get connections():Array;
		
		function get selectedItem():Object;
		function set selectedItem(value:Object):void;
		
		function get selectedIndex():int;
		function set selectedIndex(value:int):void;
	}
}