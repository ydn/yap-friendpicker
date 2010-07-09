package com.yahoo.astra.badgekit.controls.listClasses {
import fl.controls.listClasses.ImageCell;
import fl.controls.listClasses.ICellRenderer;
    //--------------------------------------
    //  Class description
    //--------------------------------------
	/**
	 * The ImageCellRenderer is a cell renderer for the BadgeKit,
	 * providing a quick and easy grid for photos.
	 *
     * @author Alaric Cole
	 */
	public class ImageCellRenderer extends ImageCell implements ICellRenderer 
	{
		
		/**
         * @private
         *
		 */
		private static var defaultStyles:Object = 
												{
													imagePadding:5,
													textPadding:5,
													textOverlayAlpha:0
												};
												
        /**
         * @private
         * @copy fl.core.UIComponent#getStyleDefinition()
         *
         * @see fl.core.UIComponent#getStyle()
         * @see fl.core.UIComponent#setStyle()
         * @see fl.managers.StyleManager
         *
         */
		public static function getStyleDefinition():Object 
		{
			return mergeStyles(defaultStyles, ImageCell.getStyleDefinition());
		}
		/**
         * Constructor
         *
		 */
		public function ImageCellRenderer() 
		{
			super();
			
		}
		/**
         * @private
         *
		 */
		override protected function drawLayout():void 
		{
			var imagePadding:Number = getStyleValue("imagePadding") as Number;
			var textPadding:Number = getStyleValue("textPadding") as Number;
			loader.move(imagePadding, imagePadding);
			
			var w:Number = width-(imagePadding*2);
			var h:Number = height-imagePadding*2 - textPadding - 10;
			
			if (loader.width != w && loader.height != h) 
			{
				loader.setSize(w,h);
			}
			loader.drawNow(); 
			
			if (_label == "" || _label == null) 
			{
				if (contains(textField))  removeChild(textField); 
				if (contains(textOverlay)) removeChild(textOverlay); 
			} 
			else 
			{
				
				textField.height = textField.textHeight + 5;
				textField.width = Math.min(width-textPadding*2, textField.textWidth+5);
			
				textField.x = Math.max(textPadding, width/2-textField.width/2);
				textField.y = height - textField.height - textPadding + 5; 
				
				addChild(textField);
			}
			
			background.width = width;
			background.height = height;
		}
		
	}
}