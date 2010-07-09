package com.yahoo.social
{
	import com.yahoo.oauth.OAuthToken;
	
	public class YahooAccessToken extends OAuthToken
	{
		public var yahoo_guid:String;
		public var session_handle:String;
		public var expires:Date;
		public var auth_expires:Date;
		public var oauth_problem:String;
		
		public function YahooAccessToken()
		{
			super();
		}
	}
}