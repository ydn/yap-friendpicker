package com.yahoo.astra.fl.containers
{	
	/**
	 * A scrolling container that arranges its children in a vertical column.
	 * 
	 * @example The following code configures a VBoxPane container:
	 * <listing version="3.0">
	 * var pane:VBoxPane = new VBoxPane();
	 * pane.verticalGap = 4;
	 * pane.verticalAlign = VerticalAlignment.MIDDLE;
	 * this.addChild( pane );
	 * </listing>
	 * 
	 * @author Josh Tynjala
	 */
	public class VBoxPane extends BoxPane
	{
		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
	
		/**
		 * Constructor.
		 * 
		 * @param configuration		An Array of optional configurations for the layout container's children.
		 */
		public function VBoxPane(configuration:Array = null)
		{
			super(configuration);
			this.direction = "vertical";
		}
	}
}