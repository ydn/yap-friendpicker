package com.yahoo.astra.richtext
{
	public class Document extends ContainerNode
	{
		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
	
		public function Document()
		{
			super();
			this.rootDocument = this;
		}
		
	//--------------------------------------
	//  Properties
	//--------------------------------------
		
		private var _title:String;
		
		public function get title():String
		{
			return this._title;
		}
		
		public function set title(value:String):void
		{
			this._title = value;
		}
	}
}