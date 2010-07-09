package com.yahoo.astra.editor.traits
{
	import com.yahoo.astra.editor.data.IElementData;

	/**
	 * Element editors that handle this trait must keep the element's size
	 * within the specified range.
	 * 
	 * @author Josh Tynjala
	 */
	public class SizeLimits implements ITrait
	{
		/**
		 * Constructor.
		 */
		public function SizeLimits(minWidth:Number = 0, minHeight:Number = 0, maxWidth:Number = Number.POSITIVE_INFINITY, maxHeight:Number = Number.POSITIVE_INFINITY)
		{
			this.minWidth = minWidth;
			this.minHeight = minHeight;
			this.maxWidth = maxWidth;
			this.maxHeight = maxHeight;
		}
		
		/**
		 * @private
		 * Storage for the owner property.
		 */
		private var _owner:IElementData;
		
		/**
		 * @inheritDoc
		 */
		public function get owner():IElementData
		{
			return this._owner;
		}
		
		/**
		 * @private
		 */
		public function set owner(value:IElementData):void
		{
			this._owner = value;
		}
		
		/**
		 * The minimum possible width value for the element.
		 */
		public var minWidth:Number;
		
		/**
		 * The maximum possible width value for the element.
		 */
		public var maxWidth:Number;
		
		/**
		 * The minimum possible height value for the element.
		 */
		public var minHeight:Number;
		
		/**
		 * The maximum possible height value for the element.
		 */
		public var maxHeight:Number;
	}
}