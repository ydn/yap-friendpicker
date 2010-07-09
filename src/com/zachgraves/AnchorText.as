package com.zachgraves
{
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import mx.controls.Text;
	
	public class AnchorText extends Text
	{
		private var $href:String;
		private var $target:String = "_blank";
		
		public function AnchorText()
		{
			this.addEventListener(MouseEvent.ROLL_OVER, handleRollOver);
			this.addEventListener(MouseEvent.ROLL_OUT, handleRollOut);
			
			this.buttonMode=true;
			this.mouseEnabled = true;
			this.useHandCursor=true;
			this.mouseChildren=false;
			
			this.setStyle("textDecoration","underline");
		}
		
		private function handleRollOver(event:MouseEvent):void
		{
//			this.setStyle("textDecoration","underline");
		}
		
		private function handleRollOut(event:MouseEvent):void
		{
//			this.setStyle("textDecoration","none");
		}
		
		[Bindable] public function set target(value:String):void
		{
			$target = value;
		}
		
		public function get target():String
		{
			return $target;
		}
		
		[Bindable] public function set href(value:String):void
		{
			$href = value;
			trace('value',value);
			if($href) {
				this.addEventListener(MouseEvent.CLICK, handleTextMouseUp);
			}
		}
		
		public function get href():String
		{
			return $href;
		}
		
		private function handleTextMouseUp(event:MouseEvent):void
		{
			flash.net.navigateToURL(new URLRequest($href), $target);
		}
		
		
	}
}