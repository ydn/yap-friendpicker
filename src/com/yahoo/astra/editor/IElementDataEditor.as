package com.yahoo.astra.editor
{
	import com.yahoo.astra.editor.data.IElementData;
	
	/**
	 * A graphical editor that modifies a specific "element". For example, a
	 * developer can implement a set of handles the user can click and drag to
	 * modify the element's size and position.
	 * 
	 * @see IGraphicalEditor
	 * @see com.yahoo.astra.editor.data.IElementData
	 * @author Josh Tynjala
	 */
	public interface IElementDataEditor
	{
		/**
		 * The element to be edited.
		 */
		function get dataProvider():IElementData;
		
		/**
		 * @private
		 */
		function set dataProvider(value:IElementData):void;
	}
}