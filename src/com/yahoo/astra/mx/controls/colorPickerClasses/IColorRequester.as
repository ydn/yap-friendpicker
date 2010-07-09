package com.yahoo.astra.mx.controls.colorPickerClasses
{
	
	//--------------------------------------
	//  Events
	//--------------------------------------
	
	/**
	 * Dispatched when some sort of user interaction causes
	 * the IColorRequester to need a new color.
	 * 
	 * @eventType om.yahoo.astra.mx.events.ColorRequestEvent.REQUEST_COLOR
	 */
	[Event(name="requestColor", type="com.yahoo.astra.mx.events.ColorRequestEvent")]
	
	/**
	 * An IColorViewer that may request a new color.
	 * 
	 * @author Josh Tynjala
	 */
	public interface IColorRequester extends IColorViewer
	{
		//nothing right now. see required event above!
	}
}