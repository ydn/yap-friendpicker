/*
Copyright (c) 2007 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package com.yahoo.astra.fl.skins{
	import flash.display.MovieClip;
	import flash.display.Graphics;
	//import fl.controls.listClasses.CellRenderer;
	import com.yahoo.astra.fl.controls.menuClasses.MenuCellRenderer;
	//import Tree;
	import flash.events.Event;
	public class MenuIcon extends MovieClip {
		
		public function MenuIcon() {
			super();
			
			this.addEventListener(flash.events.Event.ADDED_TO_STAGE, initIcon);
		}
		public function initIcon(ev:Event):void {
			var g:Graphics = graphics;
			
			//draw arrow
			g.clear();
			//g.lineStyle(0);
			g.beginFill(0x666666);
			g.moveTo(0,0);
			g.lineTo(7, 5);
			g.lineTo(0,10);
			g.lineTo(0,0);
			g.endFill();
			
		}
	}
}