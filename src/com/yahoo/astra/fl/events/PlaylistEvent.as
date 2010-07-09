package com.yahoo.astra.fl.events
{
	import flash.events.Event;
	import com.yahoo.astra.fl.controls.mediaPlayerClasses.AudioClip;
	
	public class PlaylistEvent extends Event
	{
		
		public static const UPDATE_ITEM_INFO:String = "updateItemInfo";
		
		public static const NEW_PLAYLIST:String = "newPlaylist";
		
		public static const NEXT_CLIP:String = "nextClip";
		
		public static const PREVIOUS_CLIP:String = "previousClip";
		
		public static const PLAYLIST_ERROR:String = "playlistError";
		
		public static const CLIP_ERROR:String = "clipError";
		
		public function PlaylistEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, index:int = 0, item:Object = null, playlist:Array = null):void
		{
			super(type, bubbles, cancelable);
			this.model = model;
			this.index = index;
			this.item = item;
			this.playlist = playlist;
			
		}
		
		public var model:AudioClip;
		
		public var index:int = 0;
		
		public var item:Object = null;
		
		public var playlist:Array = null;
		
		override public function clone():Event
		{
			return new PlaylistEvent(this.type, this.bubbles, cancelable, this.index, this.item, this.playlist);
		}
	}
}