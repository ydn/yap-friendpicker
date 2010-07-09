package com.yahoo.astra.editor.events
{
	import com.yahoo.astra.editor.data.IElementData;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * Events that IGraphicalEditor instances will commonly make available to
	 * developers. Similar to how a List or another control will expose mouse
	 * events for its item renderers.
	 * 
	 * @author Josh Tynjala
	 */
	public class GraphicalEditorEvent extends Event
	{
		public static const ELEMENT_MOUSE_DOWN:String = "elementMouseDown";
		public static const ELEMENT_ROLL_OVER:String = "elementRollOver";
		public static const ELEMENT_ROLL_OUT:String = "elementRollOut";
		public static const ELEMENT_CLICK:String = "elementClick";
		public static const ELEMENT_DOUBLE_CLICK:String = "elementDoubleClick";
		
		/**
		 * Constructor.
		 */
		public function GraphicalEditorEvent(type:String, elementData:IElementData, mouseEvent:MouseEvent)
		{
			super(type);
			this.elementData = elementData;
			this.mouseEvent = mouseEvent;
		}
		
		/**
		 * The element with which the user interacted.
		 */
		public var elementData:IElementData;
		
		/**
		 * The original mouse event that caused this event.
		 */
		public var mouseEvent:MouseEvent;
		
	}
}