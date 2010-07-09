package com.yahoo.astra.utils
{
	/**
	 * An interface for colors that may be represented by differing colorspaces.
	 * 
	 * @author Josh Tynjala
	 */
	public interface IColor
	{
		/**
		 * Converts the IColor object to a standard RGB uint color value.
		 */
		function touint():uint;
		
		/**
		 * Copies the values of the IColor object into a new instance.
		 */
		function clone():IColor;
	}
}