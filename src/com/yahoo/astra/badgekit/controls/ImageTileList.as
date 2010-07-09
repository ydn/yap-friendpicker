package com.yahoo.astra.badgekit.controls
{
	import fl.controls.TileList;
	import com.yahoo.astra.badgekit.controls.listClasses.MultilineImageCellRenderer;
	import fl.core.InvalidationType;
	
	//--------------------------------------
    //  Class description
    //--------------------------------------
	/**
	 * The ImageTileList makes a quick and easy grid for photos, 
	 * allowing customization of labels and source for the image to display.
	 *
     * @author Alaric Cole
	 */
	public class ImageTileList extends TileList
	{
		/**
         * Constructor
         *
		 */
		public function ImageTileList()
		{
			super();
		}
		
		/**
         * @private
         *
		 */
		private static var defaultStyles:Object ={cellRenderer:MultilineImageCellRenderer};
												
        /**
         * @private
         * @copy fl.core.UIComponent#getStyleDefinition()
         *
         * @see fl.core.UIComponent#getStyle()
         * @see fl.core.UIComponent#setStyle()
         * @see fl.managers.StyleManager
         */
		public static function getStyleDefinition():Object 
		{
			return mergeStyles(defaultStyles, TileList.getStyleDefinition());
		}
	}
}