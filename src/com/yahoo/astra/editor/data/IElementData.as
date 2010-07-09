package com.yahoo.astra.editor.data
{
	import com.yahoo.astra.editor.traits.ITrait;
	
	import flash.events.IEventDispatcher;
	
	/**
	 * An element that may be displayed in an graphical editor.
	 * 
	 * @see com.yahoo.astra.editor.IGraphicalEditor
	 * @author Josh Tynjala
	 */
	public interface IElementData extends IEventDispatcher
	{
		/**
		 * The object being edited. Often, this is a DisplayObject, and its
		 * current appearance is used to display the item in IGraphicalEditor
		 * instances.
		 */
		function get target():Object;
		
		/**
		 * @private
		 */
		function set target(value:Object):void;
		
		/**
		 * The name of the target, as displayed to the user. Generally, there is
		 * no requirement that this value be unique. If your <code>IGraphicalEditor</code>
		 * implementation requires a unique identifier, a seperate property
		 * should be made available in your implementation of <code>IElementData</code>.
		 */
		function get displayName():String;
		
		/**
		 * @private
		 */
		function set displayName(value:String):void;
		
		/**
		 * Adds a trait that may be used by element editors. Typically this
		 * is extra information used by the editor that shouldn't be stored on
		 * the target itself. For example, the editor might enforce a minimum
		 * width or height, but the target doesn't necessarily need or have
		 * properties for those values.
		 */
		function addTrait(trait:ITrait):void;
		
		/**
		 * Removes a trait from the element. Generally, if a developer requests
		 * that a trait be removed, but it doesn't exist on this element,
		 * implementers should throw an <code>ArgumentError</code>.
		 */
		function removeTrait(trait:ITrait):void;
		
		/**
		 * Finds the traits added to theelement that are instances of the
		 * specified datatype.
		 */
		function getTraitsByType(type:Class):Array;
		
		/**
		 * Returns <code>true</code> if the element has a trait that is an instance of the
		 * specified datatype.
		 */
		function hasTraitOfType(type:Class):Boolean;
		
		/**
		 * Expected to be called when a property is edited on the target.
		 * Implementations generally fire an event to notify listeners that they
		 * must refresh their state.
		 * 
		 * <p>For example, a set of drag handles highlighting a display object
		 * target might need to reposition themselves if the target is moved or
		 * resized by another control.</p>
		 */
		function invalidateTarget():void;
		
		/**
		 * Expected to be called when the target changes in such a way that the
		 * graphical editor containing the element will need to rebuild its
		 * renderers. Typically, this is used when children are added or removed
		 * from containers.
		 */
		function invalidateData():void;
	}
}