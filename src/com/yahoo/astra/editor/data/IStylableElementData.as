package com.yahoo.astra.editor.data
{
	/**
	 * An editor element that provides hooks for editing style values in the
	 * target object. This element type is useful for keeping a list of modified
	 * style. Developers may want this information if they intend to save
	 * or or export the edited content in some format.
	 * 
	 * @see com.yahoo.astra.editor.IGraphicalEditor
	 * @author Josh Tynjala
	 */
	public interface IStylableElementData extends IElementData
	{
		/**
		 * Returns a list of style names that have been modified by calling
		 * the <code>setStyle()</code> function. Put another way, this is a
		 * list of styles that no longer hold the default value.
		 */
		function getModifiedStyles():Array;
		
		/**
		 * Retrieves the value of a style on the target. Should be used
		 * rather than accessing the style from the target directly because
		 * style getters and setters may be overridden.
		 */
		function getStyle(name:String):*;
		
		/**
		 * Changes the value of a style on the target. Developers should use
		 * this method instead of setting properties on the target directly
		 * because the <code>IStylableElementData</code> instance saves a list
		 * of changed styles that may be used to save the document in the
		 * editor or export to another format (such as code, for a wysiwyg
		 * interface builder. Additionally, it's possible to override the
		 * default style getters and setters with override functions.
		 */
		function setStyle(name:String, value:Object):void;
		
		//function setStyleOverride(name:String, getMethod:Function, setMethod:Function):void;
		//function clearStyleOverride(name:String):void;
	}
}