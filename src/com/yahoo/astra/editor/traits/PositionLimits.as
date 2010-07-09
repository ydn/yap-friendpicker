package com.yahoo.astra.editor.traits
{
	import com.yahoo.astra.editor.data.IElementData;
	
	import flash.geom.Rectangle;

	/**
	 * Editors that handle this trait must keep the element within a specific
	 * region.
	 * 
	 * @author Josh Tynjala
	 */
	public class PositionLimits implements ITrait
	{
		/**
		 * Constructor.
		 */
		public function PositionLimits(bounds:Rectangle = null)
		{
			if(!bounds)
			{
				bounds = new Rectangle(Number.NEGATIVE_INFINITY, Number.NEGATIVE_INFINITY, Number.POSITIVE_INFINITY, Number.POSITIVE_INFINITY);
			}
			this.bounds = bounds;
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
		 * The area in which the element is constrained.
		 */
		public var bounds:Rectangle;
	}
}