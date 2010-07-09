package com.yahoo.social
{
	import com.yahoo.oauth.OAuthToken;
	
	public class YahooRequestToken extends OAuthToken
	{
		public var expires:Date;
		public var request_auth_url:String;
		public var oauth_problem:String;
		
		public function YahooRequestToken()
		{
			super();
		}
	}
}