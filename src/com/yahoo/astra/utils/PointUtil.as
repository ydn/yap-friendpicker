package com.yahoo.astra.utils
{
	import flash.geom.Point;
	
	/**
	 * Utility functions for the manipulation of Points.
	 * 
	 * @see flash.geom.Point
	 * 
	 * @author Josh Tynjala
	 */
	public class PointUtil
	{
		/**
		 * Determines the angle between two arbitrary points.
		 * 
		 * @param p1	the first point
		 * @param p2	the second point
		 * @return		the angle in radians 
		 */
		public static function angle(p1:Point, p2:Point):Number
		{
			var dx:Number = p1.x - p2.x;
			var dy:Number = p1.y - p2.y;
			return Math.atan2(dy, dx);
		}

	}
}