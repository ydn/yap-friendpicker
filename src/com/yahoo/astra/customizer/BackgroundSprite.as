/*
Copyright (c) 2008 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package com.yahoo.astra.customizer
{
	import flash.display.Sprite;
	import flash.filters.BevelFilter;
	import flash.filters.BitmapFilterQuality;
    import flash.filters.BitmapFilterType;
	
	public class BackgroundSprite extends Sprite
	{
		private var _color:uint = 0xffffff;	
		private var _width:Number;
		private var _height:Number;
		private var _margin:Number = 0;
		private var _elipse:Number = 8;
		
		public function BackgroundSprite():void
		{
			super();
		}
		
		private function drawBackgroundFiller():void
		{	
			if(!isNaN(width) && !isNaN(height) && !isNaN(_margin))
			{
				graphics.clear();
				graphics.beginFill(_color);
				graphics.drawRoundRect(_margin, _margin, width - (_margin * 2), height - (_margin * 2), _elipse, _elipse);
				graphics.endFill();
				var bf:BevelFilter = new BevelFilter(4,
													45,
													0xffffff,
													.25,
													0x000000,
													.4,
													4,
													4,
													4,
													BitmapFilterQuality.HIGH,
													BitmapFilterType.INNER,
													false);
													
				var graphicFilters:Array = [bf];
				filters = graphicFilters;
			}
		}
		
		public function set color(value:uint):void
		{
			_color = value;
			drawBackgroundFiller();
		}
		
		public function get color():uint
		{
			return _color;
		}
	
		override public function set width(value:Number):void
		{
			_width = value;
			drawBackgroundFiller();
		}
		
		override public function set height(value:Number):void
		{
			_height = value;
			drawBackgroundFiller();
		}
		
		override public function get width():Number
		{
			return _width;
		}
		
		override public function get height():Number
		{
			return _height;
		}
		
		public function get margin():Number
		{
			return _margin;
		}
		
		public function set margin(value:Number):void
		{
			_margin = value;
			drawBackgroundFiller();
		}
		
		public function set elipse(value:Number):void
		{
			_elipse = value;
			drawBackgroundFiller();
		}
	
	}
}