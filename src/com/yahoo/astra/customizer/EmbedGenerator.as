package com.yahoo.astra.customizer
{
	import flash.net.URLVariables;
	import com.yahoo.astra.utils.ColorUtil;
	
	public class EmbedGenerator
	{	
		public static function generateHTMLEmbed(swfSource:String, width:Number, height:Number, flashVars:Array = null, flashParams:Object = null):String
		{
			var encodedFlashVars:String = generateURLEncodedFlashVars(flashVars); 
			
			var version:String = "9,0,28,0";
			var backgroundColor:String = "#ffffff";
			var allowScriptAccess:String = "sameDomain";
			var allowFullScreen:Boolean = false;
			var wmode:String;
			var id:String = "flashContent";
			var base:String = ".";
			
			if(flashParams != null)
			{
				if(flashParams.version != null && flashParams.version.value != null) version = flashParams.version.value;
				if(flashParams.backgroundColor != null && flashParams.backgroundColor.value != null) backgroundColor = "#" + ColorUtil.toHexString(uint(flashParams.backgroundColor.value));
				if(flashParams.allowScriptAccess != null && flashParams.allowScriptAccess.value != null) allowScriptAccess = flashParams.allowScriptAccess.value;
				if(flashParams.allowFullScreen != null && flashParams.allowFullScreen.value != null) allowFullScreen = flashParams.allowFullScreen.value;
				if(flashParams.wmode != null && flashParams.wmode.value != null) wmode = flashParams.wmode.value;
				if(flashParams.id != null && flashParams.id.value != null) id = flashParams.id.value;
				if(flashParams.base != null && flashParams.base.value != null) base = flashParams.base.value;
			}
			
			var embedHTML:XML =
			<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase=""
				width="" height="" id="" align="middle">
				<param name="movie" value=""/>
				<param name="quality" value="high" />
				<param name="bgcolor" value="" />
				<param name="allowScriptAccess" value="" />
				<param name="allowFullScreen" value="" />
				<param name="base" value="." />
				<embed src="" quality="high" bgcolor="" width="" height="" name="" align="middle" base="."
					type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />
			</object>;
			
			embedHTML.@width = width;
			embedHTML.@height = height;
			embedHTML.@codebase = "http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=" + version;
			embedHTML.@id = id;
			embedHTML.param.(@name == "movie").@value = swfSource;
			embedHTML.param.(@name == "bgcolor").@value = backgroundColor;
			embedHTML.param.(@name == "allowScriptAccess").@value = allowScriptAccess;
			embedHTML.param.(@name == "allowFullScreen").@value = allowFullScreen;
			embedHTML.param.(@name == "base").@value = base;
			
			if(wmode !== null)
			{
				embedHTML.appendChild(<param name="wmode" value=""/>);
				embedHTML.param.(@name == "wmode").@value = wmode;
			}
			
			if(encodedFlashVars)
			{
				embedHTML.insertChildBefore(embedHTML.embed, <param name="FlashVars" value=""/>);
				embedHTML.param.(@name == "FlashVars").@value = encodedFlashVars;
			}
			
			embedHTML.embed.@src = swfSource;
			embedHTML.embed.@bgcolor = backgroundColor;
			embedHTML.embed.@width = width;
			embedHTML.embed.@height = height;
			embedHTML.embed.@name = id;
			embedHTML.embed.@base = base;
			
			embedHTML.embed.@allowScriptAccess = allowScriptAccess;
			embedHTML.embed.@allowFullScreen = allowFullScreen;
			
			if(wmode !== null)
			{
				embedHTML.embed.@wmode = wmode;
			}
			
			if(encodedFlashVars)
			{
				embedHTML.embed.@FlashVars = encodedFlashVars;
			}
			
			return embedHTML.toXMLString();
		}
		
		public static function generateSWFObjectEmbed(swfURL:String, width:Number, height:Number, flashVars:Array = null, flashParams:Object = null):String
		{
			var version:String = "9,0,28,0";
			var backgroundColor:String = "#ffffff";
			var allowScriptAccess:String = "sameDomain";
			var allowFullScreen:Boolean = false;
			var wmode:String;
			var id:String = "flashContent";
			var expressInstallSWF:String = null;
			var containerID:String = "flashContentDiv";
			var base:String = ".";
			
			if(flashParams != null)
			{
				if(flashParams.version != null && flashParams.version.value != null) version = flashParams.version.value;
				if(flashParams.backgroundColor != null && flashParams.backgroundColor.value != null) backgroundColor = "#" + ColorUtil.toHexString(uint(flashParams.backgroundColor.value));
				if(flashParams.allowScriptAccess != null  && flashParams.allowScriptAccess.value != null) allowScriptAccess = flashParams.allowScriptAccess.value;
				if(flashParams.allowFullScreen != null && flashParams.allowFullScreen.value != null) allowFullScreen = flashParams.allowFullScreen.value;
				if(flashParams.wmode != null && flashParams.wmode.value != null) wmode = flashParams.wmode.value;
				if(flashParams.expressInstallSWF != null && flashParams.expressInstallSWF.value != null) expressInstallSWF = flashParams.expressInstallSWF.value;
				if(flashParams.id != null && flashParams.id.value != null) id = flashParams.id.value;
				if(flashParams.containerID != null && flashParams.containerID.value != null) containerID = flashParams.containerID.value;
				if(flashParams.base != null && flashParams.base.value != null) base = flashParams.base.value;
			}			
			
			var swfObjectName:String = "swfObj";
			var alternateContent:String = "<!-- place your alternate content here -->";
			var embedCode:String = "<script type='text/javascript' src='http://us.js2.yimg.com/us.js.yimg.com/lib/flash/swfobject/1.0/swfobject.js' language='javascript'></script>\n<div id=\"" + containerID + "\">" + alternateContent + "</div>\n<script>\n";
			
			embedCode += "var " + swfObjectName + " = new deconcept.SWFObject(\"" + swfURL + "\", \"" + id + "\", \"" + width + "\", \"" + height + "\", \"" + version + "\", \"" + backgroundColor + "\");\n";
			
			if(expressInstallSWF)
			{
				embedCode += swfObjectName + ".useExpressInstall(\"" + expressInstallSWF + "\");\n";
			}
			
			if(flashVars)
			{
				embedCode += generateSWFObjectVariables(swfObjectName, flashVars);
			}
			
			embedCode += swfObjectName + ".addParam(\"allowScriptAccess\", \"" + allowScriptAccess + "\");\n"
			embedCode += swfObjectName + ".addParam(\"allowFullScreen\", \"" + allowFullScreen + "\");\n"
			embedCode += swfObjectName + ".addParam(\"base\", \"" + base + "\");\n"
			
			if(wmode !== null)
			{
				embedCode += swfObjectName + ".addParam(\"wmode\", \"" + wmode + "\");\n"
			}
			
			embedCode += swfObjectName + ".write(\"" + containerID + "\");\n";
			embedCode += "</script>";
			
			return embedCode;
		}
		
		private static function generateSWFObjectVariables(swfObjectName:String, input:Array):String
		{
			var encoded:String = "";
			
			var varCount:int = input.length;
			for(var i:int = 0; i < varCount; i++)
			{
				var item:Object = input[i];
				if(item.value != null)
					encoded += swfObjectName + ".addVariable(\"" + item.flashVarName + "\", \"" + item.value.toString() + "\");\n";
			}
			return encoded;
		}
		
		private static function generateURLEncodedFlashVars(input:Array):String
		{
			if(!input) return "";
			var encoded:URLVariables = new URLVariables();
		
			var varCount:int = input.length;
			for(var i:int = 0; i < varCount; i++)
			{
				var item:Object = input[i];
				if(item.value != null)
					encoded[item.flashVarName] = item.value.toString();
			}
			return encoded.toString();
		}

	}
}