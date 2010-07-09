package com.yahoo.astra.customizer.events
{
	import flash.events.Event;

	/**
	 * The CustomizerEvent class defines events for the Customizer class. 
	 * 
	 * These events include the following:
	 * <ul>
	 * <li><code>CustomizerEvent.REGISTERED_BINDINGS</code>: dispatched by the <code>registeredBindings</code> method on the Customizer class.</li>
	 * </ul>
	 */	
	
	
	public class CustomizerEvent extends Event
	{
		
	//--------------------------------------
	//  Constants
	//--------------------------------------		
		/**
		 * CustomizerEvent.REGISTERED_BINDINGS indicates that all flashVars have been registered in the customizer. 
		 * 
		 * <p>This event has the following properties:</p>
		 *  <table class="innertable" width="100%">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *     <tr><td><code>cancelable</code></td><td><code>true</code></td></tr>
		 *     <tr><td><code>currentTarget</code></td><td>The object that is actively processing 
		 *          the event object with an event listener.</td></tr>
		 * 	  <tr><td><code>binding</code></td><td>An object containing all information for a flashVar</td></tr>
		 * 	  <tr><td><code>bindings</code></td><td>An object containing all binding binding objects.</td></tr>
		 * 	  <tr><td><code>target</code></td><td>The object that dispatched the event. The target is 
		 *           not always the object listening for the event. Use the <code>currentTarget</code>
		 * 			property to access the object that is listening for the event.</td></tr>
		 * 	  		</td></tr>
		 *  </table>
		 *
		 * @eventType registeredBindings
		 */
		public static const REGISTERED_BINDINGS:String = "registeredBindings";
		
		/**
		 * <code>CustomizerEvent.UPDATE_FLASH_VAR</code> indicates that a single flashVar has been updated by the parent swf. 
		 * 
		 * <p>This event has the following properties:</p>
		 *  <table class="innertable" width="100%">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *     <tr><td><code>cancelable</code></td><td><code>true</code></td></tr>
		 *     <tr><td><code>currentTarget</code></td><td>The object that is actively processing 
		 *          the event object with an event listener.</td></tr>
		 * 	  <tr><td><code>binding</code></td><td>An object containing all information for a flashVar</td></tr>
		 * 	  <tr><td><code>bindings</code></td><td>An object containing all binding binding objects.</td></tr>
		 * 	  <tr><td><code>target</code></td><td>The object that dispatched the event. The target is 
		 *           not always the object listening for the event. Use the <code>currentTarget</code>
		 * 			property to access the object that is listening for the event.</td></tr>
		 * 	  		</td></tr>
		 *  </table>
		 *
		 * @eventType updateBinding
		 */
		public static const UPDATE_FLASH_VAR:String = "updateFlashVar";		
		
		/**
		 * <code>CustomizerEvent.UPDATE_ALL_BINDINGS</code> indicates that all flashVars has been updated by the parent swf. 
		 * 
		 * <p>This event has the following properties:</p>
		 *  <table class="innertable" width="100%">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *     <tr><td><code>cancelable</code></td><td><code>true</code></td></tr>
		 *     <tr><td><code>currentTarget</code></td><td>The object that is actively processing 
		 *          the event object with an event listener.</td></tr>
		 * 	  <tr><td><code>binding</code></td><td>An object containing all information for a flashVar</td></tr>
		 * 	  <tr><td><code>bindings</code></td><td>An object containing all binding binding objects.</td></tr>
		 * 	  <tr><td><code>target</code></td><td>The object that dispatched the event. The target is 
		 *           not always the object listening for the event. Use the <code>currentTarget</code>
		 * 			property to access the object that is listening for the event.</td></tr>
		 * 	  		</td></tr>
		 *  </table>
		 *
		 * @eventType updateAllBindings
		 */
		public static const UPDATE_ALL_BINDINGS:String = "updateAllBindings";		
		
		/**
		 * <code>CustomizerEvent.RESIZE_APP</code> indicates that the main application has been resized.
		 */
		public static const RESIZE_APP:String = "resizeApp";
		
		/**
		 * <code>CustomizerEvent.UPDATE_APP_SIZES</code> indicates that the customizable application has been resized.
		 */
		public static const UPDATE_APP_SIZES:String = "updateAppSizes";
		
		public static const UPDATE_FLASH_PARAM:String = "updateFlashParam";
		
		public static const NEW_GROUP:String = "newGroup";
		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
	
		/**
		 * Constructor. Creates a new CustomizerEvent object with the specified parameters. 
		 * 
         * @param type The event type; this value identifies the action that caused the event.
         *
         * @param bubbles Indicates whether the event can bubble up the display list hierarchy.
         *
         * @param cancelable Indicates whether the behavior associated with the event can be
		 *        prevented.
		 *
		 * @param bindings The bindings object in the Customizer class.
		 */
		public function CustomizerEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, bindings:Object = null, binding:Object = null)
		{
			super(type, bubbles, cancelable);
			this.bindings = bindings;
			this.binding = binding;
		}
		
	//--------------------------------------
	//  Properties
	//--------------------------------------		
		
		/**
		 * The bindings object.
		 */
		public var bindings:Object; 
		
		/**
		 * A single binding object
		 */
		public var binding:Object; 
		
		/**
		 * Available width for the application
		 */
		public var availableWidth:Number;
		
		/**
		 * Available height for the application
		 */		
		public var availableHeight:Number;
		
		/**
		 * Actual width of the application
		 */
		public var actualWidth:Number;
		
		/**
		 * Actual height of the application
		 */
		public var actualHeight:Number;
		
		/**
		 * Resized width to fit available width.
		 */
		public var currentWidth:Number;
		
		/**
		 * Resized height to fit available height.
		 */
		public var currentHeight:Number; 
		
		/**
		 *
		 */
		public var flashParam:Object;
		
		/**
		 *
		 */
		public var flashParams:Object; 
		
		/**
		 *
		 */
		public var group:Object; 
		 
		
		 
		/**
		 * Creates a copy of the CustomizerEvent object and sets the value of each parameter to match
		 * the original.
		 *
		 * @return A new CustomizerEvent object with parameter values that match those of the original.
		 */
		override public function clone():Event
		{
			return new CustomizerEvent(this.type, this.bubbles, this.cancelable, this.bindings, this.binding);
		}
	}
}