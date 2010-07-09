package com.yahoo.astra.richtext.controls
{
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import fl.core.UIComponent;
	import fl.events.ComponentEvent;

	public class Caret extends UIComponent
	{
		public function Caret()
		{
			super();
			this.addEventListener(ComponentEvent.MOVE, moveHandler);
			this.redrawTimer.addEventListener(TimerEvent.TIMER, redrawTimerHandler);
			this.redrawTimer.start();
		}
		
		private var showCaret:Boolean = false;
		
		private var redrawTimer:Timer = new Timer(500);
				
		override protected function draw():void
		{
			this.graphics.clear();
			
			if(this.showCaret)
			{
				this.graphics.lineStyle(1, 0x000000);
				this.graphics.moveTo(0, 0);
				this.graphics.lineTo(0, this.height);
			}
			
			super.draw();
		}
		
		private function redrawTimerHandler(event:TimerEvent):void
		{
			this.showCaret = !this.showCaret;
			this.drawNow();
		}
		
		private function moveHandler(event:ComponentEvent):void
		{
			this.redrawTimer.stop();
			this.showCaret = true;
			this.drawNow();
			this.redrawTimer.start();
		}
		
	}
}