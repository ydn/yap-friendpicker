package com.yahoo.astra.editor.data
{
	/**
	 * An editor element that provides hooks for editing property values in the
	 * target object. This element type is useful for keeping a list of modified
	 * properties. Developers may want this information if they intend to save
	 * or or export the edited content in some format.
	 * 
	 * @see com.yahoo.astra.editor.IGraphicalEditor
	 * @author Josh Tynjala
	 */
	public interface IEditableElementData extends IElementData
	{
		/**
		 * Returns a list of property names that have been modified by calling
		 * the <code>setProperty()</code> function. Put another way, this is a
		 * list of properties that no longer hold the default value.
		 */
		function getModifiedProperties():Array;
		
		/**
		 * Retrieves the value of a property on the target. Should be used
		 * rather than accessing the property from the target directly because
		 * property getters and setters may be overridden.
		 * 
		 * @see #setPropertyOverride() 
		 */
		function getProperty(name:String):*;
		
		/**
		 * Changes the value of a property on the target. Developers should use
		 * this method instead of setting properties on the target directly
		 * because the <code>IEditableElementData</code> instance saves a list
		 * of changed properties that may be used to save the document in the
		 * editor or export to another format (such as code, for a wysiwyg
		 * interface builder. Additionally, it's possible to override the
		 * default property getters and setters with override functions.
		 * 
		 * @see #setPropertyOverride()
		 */
		function setProperty(name:String, value:Object):void;
		
		/**
		 * Rather than accessing a property directly, a getter and setter pair
		 * may be used to override the default behavior. Useful for editor
		 * controls that need to "wrap" the element.
		 * 
		 * <p>For example, an element renderer overrides the element's x and y
		 * properties because the element is added as a child of the renderer.
		 * The element itself should always appear at 0,0 and the renderer will
		 * be placed at the defined x and y positions.</p>
		 * 
		 * @see #getProperty()
		 * @see #setProperty()
		 */
		function setPropertyOverride(name:String, getMethod:Function, setMethod:Function):void;
		
		/**
		 * Removes the override for a particular property.
		 */
		function clearPropertyOverride(name:String):void;
	}
}