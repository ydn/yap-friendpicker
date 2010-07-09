package com.yahoo.astra.mx.controls.colorPickerClasses
{
	import flash.events.IEventDispatcher;
	
	import mx.core.IFlexDisplayObject;
	import mx.core.IInvalidating;
	import mx.core.IUIComponent;
	import mx.managers.IFocusManagerComponent;
	import mx.styles.IStyleClient;

	/**
	 * An interface representing color viewers.
	 * 
	 * @author Josh Tynjala
	 */
	public interface IColorViewer extends IEventDispatcher, IUIComponent, IFocusManagerComponent
	{
		
	//--------------------------------------
	//  Properties
	//--------------------------------------
	
		/**
		 * The currently displayed color.
		 */
		function get color():uint;
		
		/**
		 * @private
		 */
		function set color(value:uint):void;
	}
}