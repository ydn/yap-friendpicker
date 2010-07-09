package com.yahoo.astra.mx.skins.halo
{
	import mx.skins.ProgrammaticSkin;

	/**
	 * A skin for a selection indicator.
	 * 
	 * @author Josh Tynjala
	 */
	public class SelectionIndicatorSkin extends ProgrammaticSkin
	{
		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
	
		/**
		 * Constructor
		 */
		public function SelectionIndicatorSkin()
		{
			super();
		}
		
	//--------------------------------------
	//  Protected Methods
	//--------------------------------------
	
		/**
		 * @private
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			this.graphics.clear();
			
			this.graphics.beginFill(0xff00ff, 1);
			this.graphics.moveTo(0, -unscaledHeight / 2);
			this.graphics.lineTo(5, 0);
			this.graphics.lineTo(0, unscaledHeight / 2);
			this.graphics.lineTo(0, -unscaledHeight / 2);
			this.graphics.endFill();
			
			this.graphics.beginFill(0xff00ff, 1);
			this.graphics.moveTo(unscaledWidth, -unscaledHeight / 2);
			this.graphics.lineTo(unscaledWidth - 5, 0);
			this.graphics.lineTo(unscaledWidth, unscaledHeight / 2);
			this.graphics.lineTo(unscaledWidth, -unscaledHeight / 2);
			this.graphics.endFill();
		}
	}
}