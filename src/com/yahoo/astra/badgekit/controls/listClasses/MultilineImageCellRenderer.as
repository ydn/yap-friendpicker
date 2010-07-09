package com.yahoo.astra.badgekit.controls.listClasses 
{
import fl.controls.listClasses.ImageCell;
import flash.display.MovieClip;
import flash.text.TextField;
import fl.controls.listClasses.ListData;
import fl.controls.listClasses.TileListData;
import fl.controls.listClasses.ICellRenderer;
import flash.events.MouseEvent;
import flash.events.Event;
import fl.core.UIComponent;
import fl.core.InvalidationType;
import fl.containers.UILoader;
    //--------------------------------------
    //  Class description
    //--------------------------------------
	/**
	 * The MultilineImageCellRenderer is a graphical cell renderer for the BadgeKit,
	 * providing a quick and easy grid for photos with a mask, enabling masking for round corners and html multiline labels.
	 *
     * @author Alaric Cole
	 */
	public class MultilineImageCellRenderer extends UIComponent implements ICellRenderer  
	{
		/**
         * @private
         *
		 */
		protected var _listData:ListData;
		/**
         * @private
         *
		 */
		protected var _data:Object;
		
		/**
         * @private
         *
		 */
		protected var _selected:Boolean;
		
		/**
         * @private
         *
		 */
		protected var _toggle:Boolean = false;
		
		/**
         * Constructor
         *
		 */
		public function MultilineImageCellRenderer() 
		{
			super();
			toggle = true;
			
		}
		/**
		 * Gets the data object
		 */
		public function get data():Object 
		{
			return _data;
		}		
		/**
         * @private (setter)
         *
		 */
		public function set data(value:Object):void 
		{
			_data = value;
		}
		
		/**
         * Gets or sets the label of the item
         *
         */
		public function get label():String 
		{ 
			return this["textField"].text;
		}
		/**
		 * @private (setter)
		 *
		 */
		public function set label(value:String):void 
		{
			this["textField"].htmlText = value;
		}
		/**
         * Gets or sets a URL of the image to load
         *
         */
		public function get source():Object 
		{ 
			return this["image"].source;
		}
		/**
		 * @private (setter)
		 *
		 */
		public function set source(value:Object):void 
		{
			this["image"].source = value;
		}
		
		/**
		 * @private 
		 * Gets the list data
		 */
		public function get listData():ListData 
		{
			return _listData;
		}	
		
		/**
         * @private (setter)
         *
		 */
		public function set listData(value:ListData):void 
		{
			_listData = value;
			label = _listData.label;
			var newSource:Object = (_listData as TileListData).source;
			if (source != newSource) 
			{ 
				source = newSource;
			}
		}
		
		
		/**
         *  Gets or sets whether the button can be toggled. 
         *  @default false
         *
		 */		
		public function get toggle():Boolean {
			return _toggle;
		}		
		
		/**
         * @private (setter)
         *
		 */
		public function set toggle(value:Boolean):void 
		{
			
			if (!value) selected = false;
			_toggle = value;
			
			if (_toggle) { addEventListener("click",toggleSelected,false,0,true); }
			else { removeEventListener("click",toggleSelected); }
			invalidate(InvalidationType.STATE);
		}
		
		/**
         * @private
         *
		 */
		protected function toggleSelected(event:MouseEvent):void 
		{
			selected = !selected;
			trace("toggled");
			dispatchEvent(new Event(Event.CHANGE, true));
		}	
		
		/**
		 *  Whether the button is selected, toggled on or off.
         *  @default false
         *
		 */		
		public function get selected():Boolean {
			return (_toggle) ? _selected : false;
		}		
		
		
		public function set selected(value:Boolean):void {
			_selected = value;
			if (_toggle) {
				invalidate(InvalidationType.STATE);
			}
		}
		
		 /**
         * Set the mouse state; needed to implement ICellRenderer
         * @private
		 */
		public function setMouseState(state:String):void 
		{
			
		}
	}
}