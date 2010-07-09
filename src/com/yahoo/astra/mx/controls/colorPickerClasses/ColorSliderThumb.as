package com.yahoo.astra.mx.controls.colorPickerClasses
{
	import mx.controls.Button;
	import mx.core.IUIComponent;
	import mx.core.mx_internal;

	use namespace mx_internal;

	/**
	 * A button representing the thumb on the ColorSlider control.
	 * 
	 * @see com.yahoo.astra.mx.controls.ColorSlider
	 * 
	 * @author Josh Tynjala
	 */
	public class ColorSliderThumb extends Button
	{
		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
	
		/**
		 * Constructor.
		 */
		public function ColorSliderThumb()
		{
			super();
			this.stickyHighlighting = true;
		}
		
	//--------------------------------------
	//  Protected Methods
	//--------------------------------------
	
		/**
		 * @private
		 */
		override protected function measure():void
		{
			super.measure();
			
			this.measuredWidth = this.currentSkin.measuredWidth;
			this.measuredHeight = this.currentSkin.measuredHeight;
		}
	}
}