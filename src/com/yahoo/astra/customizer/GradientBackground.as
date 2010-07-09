﻿package com.yahoo.astra.customizer
{
	import flash.display.Sprite;
	import flash.filters.BevelFilter;
	import flash.filters.BitmapFilterQuality;
    import flash.filters.BitmapFilterType;
    import flash.filters.DropShadowFilter;
    import flash.display.GradientType;
    import flash.geom.Matrix;
    
	/**
	 * GradientBackground draws a gradient rectangle sprite with the following configurable properties: 
	 * 	<br/>
	 *  <table class="innertable" width="100%">
	 *  	<tr><th>Property</th><th>Purpose</th></tr>	 
	 * 		<tr><td><code>margin</code></td><td>distance between the size of the sprite and the graphics object</td></tr>
	 * 		<tr><td><code>elipse</code></td><td>curve of the corners of the rectangle</td></tr>
	 * 		<tr><td><code>colors</code></td><td>array of colors in the gradient</td></tr>
	 * 		<tr><td><code>alphas</code></td><td>array of alpha values in the gradient</td></tr>
	 * 		<tr><td><code>ratios</code></td><td>array of ratio values (0-255) in the gradient</td></tr>
	 * 		<tr><td><code>gradientRotation</code></td><td>rotation of the gradient in degrees</td></tr>
	 * 		<tr><td><code>hasBevel</code></td><td>Indicates whether the background has a bevel</td></tr>
	 * 		<tr><td><code>hasDropShadow</code></td><td>Indicates whether the background has a drop shadow</td></tr>
	 *  </table>
	 */
	public class GradientBackground extends Sprite
	{		
		/**
		 * Constructor
		 */
		public function GradientBackground():void
		{
			super();
		}

		/**
		 * @private
		 */
		private var _width:Number;
		
		/**
		 * Gets or sets the width
		 */
		override public function get width():Number
		{
			return _width;
		}
	
		/**
		 * @private (setter)
		 */	
		override public function set width(value:Number):void
		{
			_width = value;
			drawBackgroundFiller();
		}		

		/**
		 * @private
		 */
		private var _height:Number;

		/**
		 * Gets or sets the height
		 */		
		override public function get height():Number
		{
			return _height;
		}

		/**
		 * @private (setter)
		 */		
		override public function set height(value:Number):void
		{
			_height = value;
			drawBackgroundFiller();
		}

		/**
		 * @private
		 */
		private var _margin:Number = 0;
		
		/**
		 * Gets or sets the margin between the graphics and border
		 */
		public function get margin():Number
		{
			return _margin;
		}
		
		/**
		 * @private (setter)
		 */
		public function set margin(value:Number):void
		{
			_margin = value;
			drawBackgroundFiller();
		}
		
		/**
		 * @private
		 */
		private var _elipse:Number = 8;	
		
		/**
		 * Gets or sets the elipse value
		 */
		public function get elipse():Number
		{
			return _elipse;	
		}
		
		/**
		 * @private (setter)
		 */		
		public function set elipse(value:Number):void
		{
			_elipse = value;
			drawBackgroundFiller();
		}		
		
		/**
		 * @private
		 */
		private var _colors:Array = [0xff0000, 0x333333];
		
		/**
		 * Gets or sets the color array
		 */
		public function get colors():Array
		{
			return _colors;
		}
		
		/**
		 * @private (setter) 
		 */
		public function set colors(value:Array):void
		{
			_colors = value;
			drawBackgroundFiller();
		}
		
		/**
		 * @private
		 */
		private var _ratios:Array = [0, 255];
		
		/**
		 * Gets or sets the ratios array
		 */
		public function get ratios():Array
		{
			return _ratios;
		}

		/**
		 * @private (setter) 
		 */		
		public function set ratios(value:Array):void
		{
			_ratios = value;
			drawBackgroundFiller();
		}		
		
		/**
		 * @private
		 */
		private var _alphas:Array = [100, 100]; 
		
		/**
		 * Gets or sets alpha array
		 */
		public function get alphas():Array
		{
			return _alphas;
		}
		
		/**
		 * @private (setter) 
		 */		
		public function set alphas(value:Array):void
		{
			_alphas = value;
			drawBackgroundFiller();
		}
		
		/**
		 * @private
		 */
		private var _gradientRotation:Number = 0; 
		
		/**
		 * Gets or sets the gradient rotation for the background
		 */
		public function get gradientRotation():Number
		{
			return _gradientRotation;
		}
		
		/**
		 * @private (setter) 
		 */
		public function set gradientRotation(value:Number):void
		{
			_gradientRotation = value;
			drawBackgroundFiller();
		}
		
		/**
		 * @private
		 */
		private var _hasBevel:Boolean = false;

		/**
		 * Indicates whether the background has a bevel
		 */		
		public function get hasBevel():Boolean
		{
			return _hasBevel;
		}
		
		/**
		 * @private (setter)
		 */
		public function set hasBevel(value:Boolean):void
		{
			_hasBevel = value;
			drawBackgroundFiller();
		}

		/**
		 * @private
		 */		
		private var _hasDropShadow:Boolean = false;
		
		/**
		 * Indicates whether background has a drop shadow
		 */
		public function get hasDropShadow():Boolean
		{
			return _hasDropShadow;
		}
		
		/**
		 * @private (setter)
		 */
		public function set hasDropShadow(value:Boolean):void
		{
			_hasDropShadow = value;
			drawBackgroundFiller();
		}
		
		/**
		 * @private
		 *
		 * Draws a round rectangle background with a bevel filter.
		 */
		private function drawBackgroundFiller():void
		{	
			if(!isNaN(width) && !isNaN(height) && !isNaN(_margin))
			{
				var box:Matrix = new Matrix();
				box.createGradientBox(width-_margin, height-_margin, _gradientRotation * (Math.PI/180));
				graphics.clear();
				graphics.beginGradientFill(GradientType.LINEAR, _colors, _alphas, _ratios, box);
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
													
				var ds:DropShadowFilter = new DropShadowFilter(4.0, 
																45, 
																0, 
																.5, 
																4.0, 
																4.0, 
																1.0,
																1)
				
				var graphicFilters:Array = [];
				if(hasBevel) graphicFilters.push(bf);
				if(hasDropShadow) graphicFilters.push(ds);
				filters = graphicFilters;
			}
		}	
	}
}