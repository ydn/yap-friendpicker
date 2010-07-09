package com.yahoo.astra.badgekit.webapis
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.*;
	import flash.external.ExternalInterface;
	import com.yahoo.webapis.IService;
	/**
	 * Allows the use of URL Requests in a Badge
	 * 
	 * @author Alaric Cole
	 */
	
	public class URLService extends EventDispatcher implements IService
	{
		/**
		 * @private the URL to pass
		 */ 
		private var _url:String;
		
		/**
		 * DOM to open the window
		 */ 
		protected static const OPEN_WINDOW : String = "window.open";
		/**
		 * An object with which to place all requests as properties
		 */
       	public var request:Object = {};
       	
       	/**
		 * Where to open the window. Possible values include "_self", "_blank", and "_parent", as well as
		 * specifics for frames. 
		 */
		public var window:String = "_self";
		
		/**
		 * Returns the url for this service
		 */
		public function get url():String
		{
			return _url;
		}
			
		public function set url(theURL:String):void
		{
			_url = theURL;
			send(url);
		}
		
		/**
		 * The last result of the service invocation. As this is not necessary for this service, 
		 * we'll just set it to the URL.
		 */
		public function get lastResult():Object
		{
			return _url;
		}
		
		
		/**
		 * Constructor
		 */
		public function URLService()
		{
			
		}
		
		/**
		 * This function allows the use of External Interface instead of <code>navigateToURL</code>. 
		 * It is included in case this works better for you under Firefox.
		 */
		public static function openWindow(url : String, window : String = "_self") : void 
        {
            ExternalInterface.call(OPEN_WINDOW, url, window);
        }
		
		/**
		 * This method is used to allow the Badge Kit to call the service
		 */
		public function send(parameters:Object = null):void
		{
			var paramsString:String = "";
			
			for (var i:String in request)
			{
				paramsString += (paramsString.length < 1 ? "?" : "&") + i + "=" + request[i];
			}
			
			var theURL:URLRequest = new URLRequest(url + paramsString);
			
			navigateToURL(theURL, window);
			
			//including ExternalInterface workaround if this is necessary for Firefox
			//openWindow(url + paramsString, window);
			
			//clear values for reuse
			window="_self";
			request = {};
		}
		
		
	}
}
