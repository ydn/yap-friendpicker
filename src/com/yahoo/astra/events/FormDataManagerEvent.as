package com.yahoo.astra.events {
	import flash.events.Event;	

	/**
	 * The FormDataManagerEvent class defines events for the FormDataManager and FormItem.
	 * 
	 * @author kayoh
	 */
	public class FormDataManagerEvent extends Event {
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Defines the value of the <code>type</code> property of an <code>passed</code> 
		 * event object. 
		 * 
		 *  @eventType validatonPassed
		 */
		public static const VALIDATION_PASSED : String = "validatonPassed";
		/**
		 * Defines the value of the <code>type</code> property of an <code>passed</code> 
		 * event object. 
		 * 
		 *  @eventType validationFailed
		 */
		public static const VALIDATION_FAILED : String = "validationFailed";
		/**
		 * Defines the value of the <code>type</code> property of an <code>passed</code> 
		 * event object. 
		 * 
		 *  @eventType dataCollectionSuccess
		 */
		public static const DATACOLLECTION_SUCCESS : String = "dataCollectionSuccess";
		/**
		 * Defines the value of the <code>type</code> property of an <code>passed</code> 
		 * event object. 
		 * 
		 *  @eventType dataFollectionFail
		 */
		public static const DATACOLLECTION_FAIL : String = "dataFollectionFail";

		
		//--------------------------------------
		//  Constructor
		//--------------------------------------
		/**
		 *  Constructor.
		 *
		 *  @param type The event type; indicates the action that caused the event.
		 *
		 *  @param bubbles Specifies whether the event can bubble
		 *  up the display list hierarchy.
		 *
		 *  @param cancelable Specifies whether the behavior
		 *  associated with the event can be prevented.
		 * 
		 *  @param errorMsg reference to the data of error messages from validation
		 *  
		 *  @param collectedData  collected data from validation.
		 *  
		 *  @see com.yahoo.astra.managers.FormDataManager
		 */
		public function FormDataManagerEvent(type : String, bubbles : Boolean = false,
                                  cancelable : Boolean = false,
                                  errorMsg : Object = null,collectedData : Object = null) {
			super(type, bubbles, cancelable);
			this.errorMsg = errorMsg;
			this.collectedData = collectedData;
		}

		//--------------------------------------
		//  Properties
		//--------------------------------------
		
		/**
		 * The data object mainly collected from <code>FormDataManager</code>.
		 * 
		 * @see com.yahoo.astra.managers.FormDataManager
		 */
		public var collectedData : Object = null;
		/**
		 * The error massages object mainly collected from <code>FormDataManager</code>.
		 * 
		 * @see com.yahoo.astra.managers.FormDataManager
		 */
		public var errorMsg : Object = null;

		//--------------------------------------
		//  Public Methods
		//--------------------------------------
	
		/**
		 * @private
		 */
		override public function clone() : Event {
			return new FormDataManagerEvent(type, bubbles, cancelable, this.errorMsg, this.collectedData);
		}
	}
}
