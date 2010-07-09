package com.yahoo.astra.mx.controls.colorPickerClasses
{
	/**
	 * Some DropDownColorPicker related classes are plugins that aren't
	 * referenced in the main component by default. They're referenced here to
	 * make building the SWC easier.
	 * 
	 * Yes, it looks weird, but Adobe does it too.
	 *
	 * @author Josh Tynjala
	 */
	internal class ColorPickerDependencies
	{
		//TODO: Keep this up to date if new DropDownColorPicker plugins are created.
		AdvancedColorPickerDropDown;
		AdvancedHSBColorWheelPicker;
		ColorSliderDropDown;
		ColorWheelPicker;
		DisplayObjectColorPickerDropDown;
		HexColorViewer;
	}
}