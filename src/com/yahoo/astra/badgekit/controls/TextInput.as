package com.yahoo.astra.badgekit.controls
{
	import fl.controls.TextInput;
	import fl.core.UIComponent;
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
	 
	public class TextInput extends fl.controls.TextInput
	{
		public function TextInput()
		{
			
		}
		
		/**
         * @private
		 * 
		 */
		private static var defaultStyles:Object = {
				textFormat:null, fontFamily: "_sans", fontSize:11, 
				fontStyle:"normal", fontWeight:"normal", fontColor:0x999999, embedFonts:false};
        /**
         * @private
         * @copy fl.core.UIComponent#getStyleDefinition()
         *
         * @see fl.core.UIComponent#getStyle()
         * @see fl.core.UIComponent#setStyle()
         * @see fl.managers.StyleManager
         */
		public static function getStyleDefinition():Object { return UIComponent.mergeStyles(fl.controls.TextInput.getStyleDefinition(), defaultStyles); }
		/**
         * @private (protected)
         * Adds styles to textFormat
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
			
			setEmbedFont();
			// Should preserver the html
			if (_html) 
			{ 
				textField.htmlText = _savedHTML
			}
		}
	}
}