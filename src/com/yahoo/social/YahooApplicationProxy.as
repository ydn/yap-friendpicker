package com.yahoo.social
{
	import flash.events.AsyncErrorEvent;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;
	
	public class YahooApplicationProxy extends EventDispatcher
	{
		private static const LOCAL_CONNECTION_NAME:String = "_yapFlashProxy";
		
		private var $app:YahooApplication;
		private var $local:LocalConnection;
		
		public function YahooApplicationProxy(application:YahooApplication)
		{
			super();
			this.$app = application;
			this.setLocalConnection();
		}
		
		/**
		 * Directs the container to open the yml:share dialog. 
		 * 
		 * Only valid in applications within YAP.
		 * 
		 * @param to_guids			An array of GUIDs in which this message should be addressed to.
		 * @param subject			The message subject.
		 * @param body				The message body.
		 * @param image				A URL to an image to show in the dialog.
		 * 
		 */		
		public function openShareDialog(to_guids:Array=null, subject:String=null, body:String=null, image:String=null):void
		{	
			this.share("yml_openShareDialog", to_guids, subject, body, image);
		}
		
		/**
		 * Directs the container to open the yml:message dialog. 
		 * 
		 * Only valid in applications within YAP.
		 *  
		 * @param to_guids			An array of GUIDs in which this message should be addressed to.
		 * @param subject			The message subject.
		 * @param body				The message body.
		 * @param image				A URL to an image to show in the dialog.
		 * 
		 */		
		public function openMessageDialog(to_guids:Array=null, subject:String=null, body:String=null, image:String=null):void
		{
			this.share("yml_openMessageDialog", to_guids, subject, body, image);
		}
		
		protected function setLocalConnection():void
		{
			if(!this.$app.appid) 
				throw new Error("Required application ID string is null or empty.");
			
			// this will ensure you create the LocalConnection 
			// once and only when you need it.
			if(!$local)  {
				var domainPolicy:String = "*";
				
				$local = new LocalConnection();
				$local.allowDomain(domainPolicy);
				$local.client = this;
				$local.addEventListener(StatusEvent.STATUS, handleLocalStatus);
				$local.addEventListener(AsyncErrorEvent.ASYNC_ERROR, handleAsyncError);
			}
		}
		
		protected function handleLocalStatus(event:StatusEvent):void
		{
			this.dispatchEvent(event.clone());
		}
		
		protected function handleAsyncError(event:AsyncErrorEvent):void
		{
			this.dispatchEvent(event.clone());
		}
		
		protected function share(method:String,to_guids:Array=null, subject:String=null, body:String=null, image:String=null):void
		{
			subject = (subject) ? subject : "";
			body = (body) ? body : "";
			
			var name:String = LOCAL_CONNECTION_NAME+"-"+this.$app.appid;
			this.$local.send(name, method, to_guids, subject, body, image);
		}
	}
}