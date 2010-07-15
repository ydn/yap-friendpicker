YAP Friend Picker
========================

The YAP Friend Picker is a Flex component that makes it easy to drop-in sharing and messaging capabilities into your YAP application. 

Yahoo! Application Platform
=======

Find documentation and support on Yahoo! Developer Network: http://developer.yahoo.com

 * Yahoo! Application Platform - http://developer.yahoo.com/yap/
 * Yahoo! Social APIs - http://developer.yahoo.com/social/
 * Yahoo! Query Language - http://developer.yahoo.com/yql/

Hosted on GitHub: http://github.com/yahoo/yos-social-php5/tree/master

License
=======

@copyright: Copyrights for code authored by Yahoo! Inc. is licensed under the following terms:
@license:   BSD Open Source License

Yahoo! Social SDK
Software License Agreement (BSD License)
Copyright (c) 2010, Yahoo! Inc.
All rights reserved.

Redistribution and use of this software in source and binary forms, with
or without modification, are permitted provided that the following
conditions are met:

* Redistributions of source code must retain the above
  copyright notice, this list of conditions and the
  following disclaimer.

* Redistributions in binary form must reproduce the above
  copyright notice, this list of conditions and the
  following disclaimer in the documentation and/or other
  materials provided with the distribution.

* Neither the name of Yahoo! Inc. nor the names of its
  contributors may be used to endorse or promote products
  derived from this software without specific prior
  written permission of Yahoo! Inc.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


The Yahoo! Social SDK code is subject to the BSD license, see the LICENSE file.


Requirements
============

The following dependencies are bundled with the Yahoo! PHP SDK, but are under
terms of a separate license. See the bundled LICENSE files for more information:

 * Flex 3.5   - http://opensource.adobe.com/wiki/display/flexsdk/Download+Flex+3
 * FlexLib    - http://code.google.com/p/flexlib/
 * as3corelib - http://code.google.com/p/as3corelib/


Installation
============

After downloading and unpacking the release, import the directory into a new
Flash Builder project.


Examples
========

The sdk comes with an example application, but you must first set the 
OAuth consumer key and secret in the main application MXML file.


    private static const CONSUMER_KEY:String = "YOUR_CONSUMER_KEY";
    private static const CONSUMER_SECRET:String = "YOUR_CONSUMER_SECRET";


Create OAuth applications in the Yahoo! Developer Dashboard:

http://developer.yahoo.com/dashboard/


## Using the component:

Using the component is as simple as adding the component MXML to your application.

    <friendpicker:FriendPicker id="friendPicker" width="350" height="500"/>

On initialization of the application, you must supply the component with OAuth 
credentials in order to request social information from YQL. The sample application 
uses Flashvars to provide this data, as shown below.

    var flashvars:Object = Application.application.parameters;
    
    var consumer:OAuthConsumer = new OAuthConsumer();
    consumer.key = CONSUMER_KEY;
    consumer.secret = CONSUMER_SECRET;
    
    var token:YahooAccessToken = new YahooAccessToken();
    token.key = flashvars.yap_viewer_access_token;
    token.secret = flashvars.yap_viewer_access_token_secret;
    token.yahoo_guid = flashvars.yap_viewer_guid;

    friendPicker.setup({
        application: new YahooApplication(consumer.key, consumer.secret, flashvars.yap_appid, token),
        type: flashvars.type,
        subject: flashvars.subject,
        body: flashvars.body,
        cancelURL: flashvars.cancelURL
    });
    
## Displaying on YAP

The following markup used to display Flash content in YAP applications. 
An absolute URL to the Flash SWF is required, along with a query-string defining the flashvars.

    <yml:swf 
       src="http://your-application.com/swf/YAPFriendPicker.swf" 
       width="350" 
       height="500"
       flashvars="type=message&subject=message+subject&body=message+body&yap_viewer_access_token=...&yap_viewer_access_token_secret=...&yap_viewer_guid=..." 
    />

PHP Example
    
    $config = array(
       'type' => 'message',
       'subject' => '%MessageSubject%',
       'body' => '%MessageBody%',
       'yap_viewer_access_token' => $_POST['yap_viewer_access_token'],
       'yap_viewer_access_token_secret' => $_POST['yap_viewer_access_token_secret'],
       'yap_viewer_guid' => $_POST['yap_viewer_guid'],
       'yap_appid' => $_POST['yap_appid']
    );

    $flashvars = http_build_query($config);

    echo "<yml:swf flashvars='$flashvars' src='http://your-application.com/swf/YAPFriendPicker.swf' width='350' height='500'/>";
    
