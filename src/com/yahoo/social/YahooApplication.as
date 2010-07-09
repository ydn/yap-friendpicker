package com.yahoo.social
{
	import com.adobe.serialization.json.JSON;
	import com.adobe.serialization.json.JSONParseError;
	import com.yahoo.net.Connection;
	import com.yahoo.oauth.OAuthConnection;
	import com.yahoo.oauth.OAuthConsumer;
	import com.yahoo.oauth.OAuthRequest;
	import com.yahoo.oauth.OAuthToken;
	
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	
	public class YahooApplication extends EventDispatcher
	{
		private static const YQL_OAUTH_ENDPOINT:String = "query.yahooapis.com/v1/yql";
		private static const YQL_PUBLIC_ENDPOINT:String = "query.yahooapis.com/v1/public/yql";
		private static const REQUEST_TOKEN_API_URL:String = 'https://api.login.yahoo.com/oauth/v2/get_request_token';
		private static const AUTHORIZATION_API_URL:String = 'https://api.login.yahoo.com/oauth/v2/request_auth';
		private static const ACCESS_TOKEN_API_URL:String  = 'https://api.login.yahoo.com/oauth/v2/get_token';
		
		public var consumer:OAuthConsumer;
		public var token:YahooAccessToken;
		public var appid:String;
		
		public function YahooApplication(consumer_key:String, consumer_secret:String, application_id:String, token:YahooAccessToken = null)
		{
			super();
			
			this.consumer = new OAuthConsumer(consumer_key, consumer_secret);
			this.appid = application_id; 
			this.token = token;
		}
		
		public function proxy():YahooApplicationProxy
		{
			return new YahooApplicationProxy(this);
		}
		
		public function getRequestToken(callback_url:String='oob', lang:String="en_US"):URLRequest
		{
			var args:Object = {};
			args.oauth_callback = callback_url;
			args.xoauth_lang_pref = lang;
			
			var callback:Object = {};
			
			return Connection.asyncRequest(URLRequestMethod.POST, YahooApplication.REQUEST_TOKEN_API_URL, callback, args);
		}
		
		public function getAuthorizationUrl(request_token:YahooRequestToken):String
		{
			if(request_token.request_auth_url) {
				return request_token.request_auth_url;
			} else {
				return YahooApplication.AUTHORIZATION_API_URL+"?oauth_token="+request_token.key;
			}
		}
		
		public function sendToAuthorization(token:YahooRequestToken, window:String="_blank"):Boolean
		{
			try {
				flash.net.navigateToURL(new URLRequest(this.getAuthorizationUrl(token)), window);
				return true;
			} catch(error:Error) {}
			
			return false;
		}
		
		public function getAccessToken(request_token:OAuthToken, verifier:String):URLRequest
		{
			var args:Object = {};
			args.oauth_verifier = verifier;
			
			if(request_token.session_handle && request_token.session_handle != '') {
				args.oauth_session_handle = request_token.oauth_session_handle;
			}
			
			var callback:Object = {};
			var headers:Array = [new URLRequestHeader("Content-Type","application/x-www-form-urlencoded")];
			
			return Connection.asyncRequest(URLRequestMethod.POST, YahooApplication.ACCESS_TOKEN_API_URL, callback, args, headers);
		}
		
		public function refreshAccessToken(access_token:YahooAccessToken):URLRequest
		{
			var callback:Object = {};
			return null;
		}
		
		public function getIdentity(yid:String):URLRequest
		{
			return this.yql('SELECT * from yahoo.identity where yid="'+yid+'"', {
				success: handleGetIdentitySuccess, 
				failure: handleGetIdentityFailure,
				security: handleSecurityError
			});
		}
		
		protected function handleGetIdentitySuccess(response:Object):void
		{
			this.dispatchApplicationEvent(YahooApplicationEvent.SECURITY_ERROR, response);
		}
		
		protected function handleGetIdentityFailure(response:Object):void
		{
			this.dispatchApplicationEvent(YahooApplicationEvent.SECURITY_ERROR, response);
		}
		
		public function getProfile(guid:String = null):URLRequest
		{
			return this.yql('SELECT * from social.profile where guid="'+guid+'"', {
				success: handleGetProfileSuccess, 
				failure: handleGetProfileFailure,
				security: handleSecurityError
			});
		}
		
		protected function handleGetProfileSuccess(response:Object):void
		{
			this.dispatchApplicationEvent(YahooApplicationEvent.SECURITY_ERROR, response);
		}
		
		protected function handleGetProfileFailure(response:Object):void
		{
			this.dispatchApplicationEvent(YahooApplicationEvent.SECURITY_ERROR, response);
		}
		
		public function getProfileImages(guid:String = null):URLRequest
		{
			return this.yql('SELECT * from social.profile.image where guid="'+guid+'"', {
				success: handleGetProfileImagesSuccess, 
				failure: handleGetProfileImagesFailure,
				security: handleSecurityError
			});
		}
		
		protected function handleGetProfileImagesSuccess(response:Object):void
		{
			this.dispatchApplicationEvent(YahooApplicationEvent.SECURITY_ERROR, response);
		}
		
		protected function handleGetProfileImagesFailure(response:Object):void
		{
			this.dispatchApplicationEvent(YahooApplicationEvent.SECURITY_ERROR, response);
		}
		
		public function getStatus(guid:String = null):URLRequest
		{
			guid = (guid) ? guid : this.guid();
			
			return this.yql('SELECT * FROM social.profile.status WHERE guid="'+guid+'"', {
				success: handleGetStatusSuccess, 
				failure: handleGetStatusFailure,
				security: handleSecurityError
			});
		}
		
		protected function handleGetStatusSuccess(response:Object):void
		{
			this.dispatchApplicationEvent(YahooApplicationEvent.SECURITY_ERROR, response);
		}
		
		protected function handleGetStatusFailure(response:Object):void
		{
			this.dispatchApplicationEvent(YahooApplicationEvent.SECURITY_ERROR, response);
		}
		
		/*
		public function setStatus(status:String):URLRequest
		{
			return this.yql('UPDATE social.profile.status SET status="'+status+'" WHERE guid="'+this.guid()+'"', {
				success: handleSetStatusSuccess, 
				failure: handleSetStatusFailure,
				security: handleSecurityError
			}, URLRequestMethod.POST);
		}
		
		protected function handleSetStatusSuccess(response:Object):void
		{
			this.dispatchApplicationEvent(YahooApplicationEvent.SECURITY_ERROR, response);
		}
		
		protected function handleSetStatusFailure(response:Object):void
		{
			this.dispatchApplicationEvent(YahooApplicationEvent.SECURITY_ERROR, response);
		}
		*/
		
		public function getConnections(guid:String = null, offset:int = 0, limit:int = 100):URLRequest
		{
			guid = (guid) ? guid : this.guid();
			
			return this.yql('SELECT * FROM social.connections('+offset+','+limit+') WHERE owner_guid="'+guid+'"', {
				success: handleGetConnectionsSuccess, 
				failure: handleGetConnectionsFailure,
				security: handleSecurityError
			});
		}
		
		protected function handleGetConnectionsSuccess(response:Object):void
		{
			this.dispatchApplicationEvent(YahooApplicationEvent.SECURITY_ERROR, response);
		}
		
		protected function handleGetConnectionsFailure(response:Object):void
		{
			this.dispatchApplicationEvent(YahooApplicationEvent.SECURITY_ERROR, response);
		}
		
		public function getContacts(offset:int = 0, limit:int = 100):URLRequest
		{
			return this.yql('SELECT * FROM social.contacts('+offset+','+limit+') WHERE guid="'+this.guid()+'"', {
				success: handleGetContactsSuccess, 
				failure: handleGetContactsFailure,
				security: handleSecurityError
			});
		}
		
		protected function handleGetContactsSuccess(response:Object):void
		{
			this.dispatchApplicationEvent(YahooApplicationEvent.SECURITY_ERROR, response);
		}
		
		protected function handleGetContactsFailure(response:Object):void
		{
			this.dispatchApplicationEvent(YahooApplicationEvent.SECURITY_ERROR, response);
		}
		
		public function getContact(cid:String):URLRequest
		{
			return this.yql('SELECT * from social.contacts WHERE guid="'+this.guid()+'" AND contact_id="'+cid+'"', {
				success: handleGetContactSuccess, 
				failure: handleGetContactFailure,
				security: handleSecurityError
			});
		}
		
		protected function handleGetContactSuccess(response:Object):void
		{
			this.dispatchApplicationEvent(YahooApplicationEvent.SECURITY_ERROR, response);
		}
		
		protected function handleGetContactFailure(response:Object):void
		{
			this.dispatchApplicationEvent(YahooApplicationEvent.SECURITY_ERROR, response);
		}
		
		public function getContactSync(rev:int = 0):URLRequest
		{
			return this.yql('SELECT * from social.contacts.sync WHERE guid="'+this.guid()+'" AND rev="'+rev+'"', {
				success: handleGetContactSyncSuccess, 
				failure: handleGetContactSyncFailure,
				security: handleSecurityError
			});
		}
		
		protected function handleGetContactSyncSuccess(response:Object):void
		{
			this.dispatchApplicationEvent(YahooApplicationEvent.SECURITY_ERROR, response);
		}
		
		protected function handleGetContactSyncFailure(response:Object):void
		{
			this.dispatchApplicationEvent(YahooApplicationEvent.SECURITY_ERROR, response);
		}
		
		/*
		public function addSimpleContact(givenName:String, familyName:String, email:String, nickname:String):URLRequest
		{
			return this.yql('INSERT INTO social.contacts (owner_guid, givenName, familyName, email, nickname) VALUES ("'+this.guid()+'", "'+givenName+'", "'+familyName+'", "'+email+'", "'+nickname+'")', {
				success: handleAddSimpleContactSuccess, 
				failure: handleAddSimpleContactFailure,
				security: handleSecurityError
			}, URLRequestMethod.POST);
		}
		
		protected function handleAddSimpleContactSuccess(response:Object):void
		{
			this.dispatchApplicationEvent(YahooApplicationEvent.SECURITY_ERROR, response);
		}
		
		protected function handleAddSimpleContactFailure(response:Object):void
		{
			this.dispatchApplicationEvent(YahooApplicationEvent.SECURITY_ERROR, response);
		}
		*/
		
		public function addContact(contact:Object):URLRequest
		{
			var callback:Object = {
				success: handleAddContactSuccess, 
				failure: handleAddContactFailure,
				security: handleSecurityError
			};
			return null;
		}
		
		protected function handleAddContactSuccess(response:Object):void
		{
			this.dispatchApplicationEvent(YahooApplicationEvent.SECURITY_ERROR, response);
		}
		
		protected function handleAddContactFailure(response:Object):void
		{
			this.dispatchApplicationEvent(YahooApplicationEvent.SECURITY_ERROR, response);
		}
		
		public function getUpdates(guid:String = null, offset:int = 0, limit:int = 100):URLRequest
		{
			guid = (guid) ? guid : this.guid();
			
			return this.yql('SELECT * FROM social.updates('+offset+', '+limit+') WHERE guid="'+guid+'"', {
				success: handleGetUpdatesSuccess, 
				failure: handleGetUpdatesFailure,
				security: handleSecurityError
			});
		}
		
		protected function handleGetUpdatesSuccess(response:Object):void
		{
			this.dispatchApplicationEvent(YahooApplicationEvent.SECURITY_ERROR, response);
		}
		
		protected function handleGetUpdatesFailure(response:Object):void
		{
			this.dispatchApplicationEvent(YahooApplicationEvent.SECURITY_ERROR, response);
		}
		
		public function getConnectionUpdates(guid:String = null, offset:int = 0, limit:int = 100):URLRequest
		{
			guid = (guid) ? guid : this.guid();
			
			return this.yql('SELECT * FROM social.connections.updates('+offset+', '+limit+') WHERE guid="'+guid+'"', {
				success: handleGetConnectionUpdatesSuccess, 
				failure: handleGetConnectionUpdatesFailure,
				security: handleSecurityError
			});
		}
		
		protected function handleGetConnectionUpdatesSuccess(response:Object):void
		{
			this.dispatchApplicationEvent(YahooApplicationEvent.SECURITY_ERROR, response);
		}
		
		protected function handleGetConnectionUpdatesFailure(response:Object):void
		{
			this.dispatchApplicationEvent(YahooApplicationEvent.SECURITY_ERROR, response);
		}
		
		/*
		public function insertUpdate(title:String, description:String, link:String = '', pubDate:Date = null, suid:String = null, guid:String = null):URLRequest
		{
			guid = (guid) ? guid : this.guid();
			
			var pubDateTime:Number = (pubDate) ? pubDate.getTime() / 1000 : (new Date().getTime() / 1000);
			var source:String = "APP."+this.appid;
			
			return this.yql('INSERT INTO social.updates (guid, title, description, link, pubDate, source, suid) VALUES ("'+guid+'", "'+title+'", "'+description+'", "'+link+'", "'+pubDateTime+'", "'+source+'", "'+suid+'")', {
				success: handleInsertUpdateSuccess, 
				failure: handleInsertUpdateFailure,
				security: handleSecurityError
			}, URLRequestMethod.POST);
		}
		
		protected function handleInsertUpdateSuccess(response:Object):void
		{
			this.dispatchApplicationEvent(YahooApplicationEvent.SECURITY_ERROR, response);
		}
		
		protected function handleInsertUpdateFailure(response:Object):void
		{
			this.dispatchApplicationEvent(YahooApplicationEvent.SECURITY_ERROR, response);
		}
		*/
		
		public function getSocialGraph(guid:String = null, offset:int = 0, limit:int = 100):URLRequest
		{
			guid = (guid) ? guid : this.guid();
			
			return this.yql('SELECT * FROM social.profile where guid in (SELECT guid from social.connections ('+offset+', '+limit+') WHERE owner_guid="'+guid+'")', {
				success: handleGetGraphSuccess, 
				failure: handleGetGraphFailure,
				security: handleSecurityError
			}); 
		}
		
		protected function handleGetGraphSuccess(response:Object):void
		{
			this.dispatchApplicationEvent(YahooApplicationEvent.SECURITY_ERROR, response);
		}
		
		protected function handleGetGraphFailure(response:Object):void
		{
			this.dispatchApplicationEvent(YahooApplicationEvent.SECURITY_ERROR, response);
		}
		
		public function getProfileLocation(guid:String = null):URLRequest
		{
			guid = (guid) ? guid : this.guid();
			
			return this.yql('SELECT * FROM geo.places WHERE text IN (SELECT location FROM social.profile WHERE guid="'+guid+'")', {
				success: handleGetProfileLocSuccess, 
				failure: handleGetProfileLocFailure,
				security: handleSecurityError
			});
		}
		
		protected function handleGetProfileLocSuccess(response:Object):void
		{
			this.dispatchApplicationEvent(YahooApplicationEvent.SECURITY_ERROR, response);
		}
		
		protected function handleGetProfileLocFailure(response:Object):void
		{
			this.dispatchApplicationEvent(YahooApplicationEvent.SECURITY_ERROR, response);
		}
		
		public function getGeoPlaces(location:String):URLRequest
		{
			return this.yql('SELECT * FROM geo.places where text="'+location+'"', {
				success: handleGetPlacesSuccess, 
				failure: handleGetPlacesFailure,
				security: handleSecurityError
			}, URLRequestMethod.GET, null, false);
		}
		
		protected function handleGetPlacesSuccess(response:Object):void
		{
			this.dispatchApplicationEvent(YahooApplicationEvent.SECURITY_ERROR, response);
		}
		
		protected function handleGetPlacesFailure(response:Object):void
		{
			this.dispatchApplicationEvent(YahooApplicationEvent.SECURITY_ERROR, response);
		}
		
		/*
		public function setSmallView(content:String, guid:String = null):URLRequest
		{
			return this.yql('UPDATE yap.setsmallview SET content="'+content+'" where guid="'+guid+'" and ck="'+this.consumer.key+'" and cks="'+this.consumer.secret+'"', {
				success: handleSetSmallViewSuccess, 
				failure: handleSetSmallViewFailure,
				security: handleSecurityError
			}, URLRequestMethod.POST);
		} 
		
		protected function handleSetSmallViewSuccess(response:Object):void
		{
			this.dispatchApplicationEvent(YahooApplicationEvent.SECURITY_ERROR, response);
		}
		
		protected function handleSetSmallViewFailure(response:Object):void
		{
			this.dispatchApplicationEvent(YahooApplicationEvent.SECURITY_ERROR, response);
		}
		*/
		
		public function guid():String
		{
			return (this.token) ? this.token.yahoo_guid : null;
		}
		
		public function yql(query:String, callback:Object, method:String='GET', params:Object=null, signRequest:Boolean=true):URLRequest
		{
			query = escape(query).replace(/\x2a/g,'%2A');
			params = params || {};
			
			var protocol:String = (params.secure) ? 'https://' : 'http://';
			var url:String = protocol + YQL_OAUTH_ENDPOINT;
			
			var args:Object = {
				q: query,
				format: params.format || 'json',
				diagnostics: params.diagnostics || false,
				debug: params.debug || false
			};
			
			if(this.consumer && signRequest) {
				var connection:OAuthConnection = OAuthConnection.fromConsumerAndToken(this.consumer, this.token);
				connection.realm = url;
				connection.requestType = (method == URLRequestMethod.GET) ? OAuthRequest.OAUTH_REQUEST_TYPE_OBJECT : OAuthRequest.OAUTH_REQUEST_TYPE_HEADER;
				connection.useExplicitEncoding = false;
				
				return connection.asyncRequestSigned(method, url, callback, args);
			} else {
				return Connection.asyncRequest(method, url, callback, args);
			}
		}
		
		protected function handleSecurityError(response:Object):void
		{
			this.dispatchApplicationEvent(YahooApplicationEvent.SECURITY_ERROR, response);
		}
		
		protected function dispatchApplicationEvent(type:String, response:Object, bubbles:Boolean=false, cancelable:Boolean=false):YahooApplicationEvent
		{
			var event:YahooApplicationEvent = new YahooApplicationEvent(type, bubbles, cancelable); 
			event.response = response;
			
			if(response.hasOwnProperty('responseText') && !!response.responseText) {
				if(response.xmlParseSuccess) {
					event.data = response.responseXML;
				} else {
					try {
						event.data = JSON.decode(response.responseText, true);
					} catch(error:JSONParseError) {
						event.data = response.responseText;
					}
				}
			} else {
				event.data = response.text;
			}
			
			this.dispatchEvent(event);
			return event;
		}  
	}
}