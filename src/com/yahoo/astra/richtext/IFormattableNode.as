package com.yahoo.astra.richtext
{
	import flash.text.TextFormat;
	
	public interface IFormattableNode
	{
		function get textFormat():TextFormat;
		function set textFormat(value:TextFormat):void;
	}
}