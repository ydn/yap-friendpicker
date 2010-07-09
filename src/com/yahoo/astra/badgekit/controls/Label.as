package com.yahoo.astra.badgekit.controls
{
	import fl.controls.Label;
	import flash.text.TextFormat;
	
	include "../styles/metadata/TextStyles.as"
	
	
	//--------------------------------------
    //  Class description
    //--------------------------------------
	/**
	 * Extends the base component and adds styling options
	 *
     * @author Alaric Cole
	 */
	 
	public class Label extends fl.controls.Label
	{
		public function Label()
		{
			
		}
		
		/**
         * @private
		 * 
		 */
		private static var defaultStyles:Object = {
				textFormat:null, fontFamily: "_sans", fontSize:11, fontStyle:"normal", 
				fontWeight:"normal", fontColor:0x999999, embedFonts:false
				};
        /**
         * @private
         * @copy fl.core.UIComponent#getStyleDefinition()
         *
         * @see fl.core.UIComponent#getStyle()
         * @see fl.core.UIComponent#setStyle()
         * @see fl.managers.StyleManager
         */
		public static function getStyleDefinition():Object { return defaultStyles; }
		/**
         * @private (protected)
         * Adds styles to the textformat
		 */
		override protected function drawTextFormat():void 
		{
			var fontFamily:String = getStyleValue("fontFamily") as String;
			var fontSize:Number = getStyleValue("fontSize") as Number;
			var fontStyle:String = getStyleValue("fontStyle") as String;
			var fontWeight:String = getStyleValue("fontWeight") as String;
			var textDecoration:String = getStyleValue("textDecoration") as String;
			var fontColor:uint = getStyleValue("color") as uint;
			
			var tf:TextFormat = new TextFormat(fontFamily, fontSize, fontColor, fontWeight == "bold" ? true:false, fontStyle == "italic" ? true:false, textDecoration == "underline" ? true:false);
			
			
			textField.defaultTextFormat = tf; 
			textField.setTextFormat(tf);
			
			//should preserve html
			if (_html && _savedHTML != null) 
			{ 
				htmlText = _savedHTML
			}
		}
	}
}