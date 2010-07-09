package com.yahoo.astra.utils
{
	/**
	 * Used to estimate text field properties for strings
	 * 
	 * @author Tripp Bridges
	 */
	
	import flash.display.Sprite;
	import flash.text.*;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	
	public class TextUtil
	{
		
		public static function getTextWidth(textValue:String, tf:TextFormat, rotation:Number = 0):Number
		{
			rotation = Math.max(-90, Math.min(rotation, 90));			
			var textField:TextField = new TextField();
			textField.selectable = false;
			textField.autoSize = rotation < 0 ? TextFieldAutoSize.RIGHT : TextFieldAutoSize.LEFT;			
			textField.text = textValue;
			if(tf != null) textField.setTextFormat(tf);
			if(rotation != 0)
			{
				return getBitmapTextSize(textField, rotation).width * (1 - Math.abs(rotation/180));	
			}
			
			return Math.max(textField.textWidth, textField.width);
			
		}
		public static function getTextHeight(textValue:String, tf:TextFormat, rotation:Number = 0):Number
		{
			rotation = Math.max(-90, Math.min(rotation, 90));
			var textField:TextField = new TextField();
			textField.selectable = false;
			textField.autoSize = rotation < 0 ? TextFieldAutoSize.RIGHT : TextFieldAutoSize.LEFT;			
			textField.text = textValue;
			if(tf != null) textField.setTextFormat(tf);
			if(rotation != 0)
			{
				return getBitmapTextSize(textField, rotation).height;
			}
			
			return textField.height;
			
		}
		
		
		public static function getBitmapTextSize(textField:TextField, rotation:Number):Object
		{
			var spr:Sprite = new Sprite();
			var bitmapDataText:BitmapData = new BitmapData(textField.width, textField.height, true, 0);
			bitmapDataText.draw(textField);
			var bm:Bitmap = new Bitmap(bitmapDataText, PixelSnapping.AUTO, true);
			spr.addChild(bm);
			spr.rotation = rotation;
			return {width:spr.width, height:spr.height};						
		}
		
	}
}