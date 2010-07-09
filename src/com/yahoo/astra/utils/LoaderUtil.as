package com.yahoo.astra.utils
{
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;

	/**
	 * Utility functions for Loader objects.
	 * 
	 * @see flash.display.Loader
	 * 
	 * @author Josh Tynjala
	 */
	public class LoaderUtil
	{
		/**
		 * Creates a function that will return a newly-created Loader that
		 * automatically loads a resource from a specific URL. This function may
		 * be used with the <code>new</code> keyword as a sort of
		 * pseudo-constructor. 
		 * 
		 * @param url		the location of the item to pass to the Loader
		 * @param context	the LoaderContext to pass to the Loader
		 * @return			a function that will return a loader with the specified parameters
		 */
		public static function createAutoLoader(url:String, context:LoaderContext = null):Function
		{
			//this is going to be treated like a class constructor
			var autoLoader:Function = function():Loader
			{
				//we need a Loader that automatically loads our image
				var loader:Loader = new Loader();
				loader.load(new URLRequest(this.url), context);

				//our "constructor" returns the Loader instead
				return loader;
			};
			//the image to load in our dynamically created "class"
			autoLoader.prototype.url = url;

			//A function may be treated as a class
			return autoLoader;
		}
	}
}