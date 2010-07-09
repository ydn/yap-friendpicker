package com.yahoo.astra.richtext.utils
{
	import flash.text.TextFormat;
	import flash.utils.describeType;
	
	public class TextFormatUtil
	{
		public static function equal(textFormat1:TextFormat, textFormat2:TextFormat):Boolean
		{
			if(!textFormat1 || !textFormat2)
			{
				return !textFormat1 && !textFormat2;
			}
			
			var props:XMLList = describeType(textFormat1).accessor.@name;
			var propCount:int = props.length();
			for(var i:int = 0; i < propCount; i++)
			{
				var prop:String = props[i].toString();
				if(textFormat1[prop] != textFormat2[prop])
				{
					return false;
				}
			}
			
			return true;
		}
		
		public static function clone(textFormat:TextFormat):TextFormat
		{
			if(!textFormat) return null;
			
			var clonedFormat:TextFormat = new TextFormat();
			var props:XMLList = describeType(textFormat).accessor.@name;
			var propCount:int = props.length();
			for(var i:int = 0; i < propCount; i++)
			{
				var prop:String = props[i].toString();
				clonedFormat[prop] = textFormat[prop];
			}
			return clonedFormat;
		}
	}
}