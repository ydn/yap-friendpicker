package com.yahoo.astra.editor.traits
{
	import com.yahoo.astra.editor.data.IElementData;
	
	/**
	 * Extra properties added to element data that may be used by editors. These
	 * typically provide extra information about the target object, or
	 * restrictions that affect how an editor behaves.
	 * 
	 * @author Josh Tynjala
	 * @see com.yahoo.astra.editor.data.IElementData
	 * @see com.yahoo.astra.editor.IGraphicalEditor
	 */
	public interface ITrait
	{
		function get owner():IElementData;
		function set owner(value:IElementData):void;
	}
}