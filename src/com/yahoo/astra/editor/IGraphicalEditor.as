package com.yahoo.astra.editor
{
	import com.yahoo.astra.editor.data.IElementData;
	import com.yahoo.astra.editor.data.IGraphicalEditorData;
	
	import flash.display.DisplayObject;
	
	/**
	 * A graphical environment for editing "elements". This is intentially vague
	 * because the interface is general enough to apply to many types of UI that
	 * can visually edit other objects.
	 * 
	 * <p>In general, this interface and its supporting datatypes are expected
	 * to be used to create drag-and-drop WYSIWYG editors. It is framework
	 * agnostic and the only dependency is Flash Player itself. One could use
	 * Flex, the Flash CS3 components, or another framework built on
	 * ActionScript 3.0.</p>
	 * 
	 * @see com.yahoo.astra.editor.data.IElementData
	 * @see IElementDataEditor
	 * @author Josh Tynjala
	 */
	public interface IGraphicalEditor
	{
		/**
		 * A collection of elements that are displayed in the editor. The
		 * implementation of the <code>IGraphicalEditorData</code> interface may
		 * include addition information to be used by the IGraphicalEditor as
		 * well. For example, implementors might want to add a background color
		 * or dimensions for the editing space.
		 * 
		 * @see com.yahoo.astra.editor.data.IElementData
		 */
		function get dataProvider():IGraphicalEditorData;
		
		/**
		 * @private
		 */
		function set dataProvider(value:IGraphicalEditorData):void;
		
		/**
		 * Editors generally allow an item to be selected.
		 * 
		 * <p>TODO: Allow multiple selection.</p>
		 */
		function get selectedItem():IElementData;
		
		/**
		 * @private
		 */
		function set selectedItem(value:IElementData):void;
	}
}