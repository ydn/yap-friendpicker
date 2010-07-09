package com.yahoo.astra.editor.data
{
	import mx.collections.ArrayCollection;
	
	/**
	 * The data displayed by an IGraphicalEditor. The expected base
	 * implementation is just a collection of <code>IElementData</code> objects,
	 * but implementers may add more properties, like the dimensions of the
	 * editing space or a background color.
	 * 
	 * @see com.yahoo.astra.editor.IGraphicalEditor
	 * @see IEditorData
	 * @author Josh Tynjala
	 */
	public interface IGraphicalEditorData
	{
		/**
		 * The number of elements in the collection.
		 */
		function get elementCount():int;
		
		/**
		 * Adds an element to the collection.
		 */
		function addElement(element:IElementData):void;
		
		/**
		 * Removes an element from the collection.
		 */
		function removeElement(element:IElementData):void;
		
		/**
		 * Returns the element at the specified index.
		 */
		function getElementAt(index:int):IElementData;
		
		/**
		 * Gets the index of an element, or returns -1 if the element is not in
		 * the collection.
		 *  
		 * <p>Alternatively, an element instance is not required. Instead, the
		 * first argument may be a function with the following signature.</p>
		 * 
		 * <pre>function( item:Object, index:int ):Boolean</pre>
		 * 
		 * <p>The function will be called for each item in the collection until
		 * a matching value has been found.</p>
		 * 
		 * <p>If a function is not specified as the compare object, the second
		 * argument is ingnored.</p>
		 */
		function getElementIndex(compare:Object, thisObject:* = null):int;
		
		/**
		 * Returns the underlying data structure that holds the elements.
		 */
		function getElementsCollection():Object;
	}
}