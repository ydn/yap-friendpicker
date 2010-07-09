package com.yahoo.astra.containers.formClasses {
	import com.yahoo.astra.containers.formClasses.IForm;

	/**
	 * Event obsever class for form classes. 
	 */
	public class FormEventObserver implements IFormEventObserver{

		//--------------------------------------
		//  Constructor
		//--------------------------------------
	
		/**
		 * Constructor.
		 * 
		 */
		public function FormEventObserver() : void {
			observers = [];
		}

		//--------------------------------------
		//  Properties
		//--------------------------------------
		/**
		 * @private
		 */
		private var observers : Array;

		//--------------------------------------
		//  internal Methods
		//--------------------------------------
		/**
		 * Add formItems to be subscribed.
		 * Returns <code>IFormEventObserver</code> to force IForm instance to subscribe this observer class.
		 * 
		 * @param obserItem Iform object to be subscribe events.
		 * @return IFormEventObserver
		 * 
		 * @see com.yahoo.astra.containers.formClasses.IForm#subscribeObserver
		 */
		public function subscribeObserver(obserItem : IForm) : IFormEventObserver {
			var duplicate : Boolean = false;
			for (var i : uint = 0;i < observers.length; i++) {
				if (observers[i] == obserItem) {
					duplicate = true;
				}
			}
			if (!duplicate) {
				observers.push(obserItem);
			}
			return this;
		}

		/**
		 * Remove formItems from subscription.
		 * 
		 *  @param obserItem Iform instance to be unsubscribed.
		 */
		public function unsubscribeObserver(obserItem : IForm) : void {
			for (var i : uint = 0;i < observers.length; i++) {
				if (observers[i] == obserItem) {
					observers.splice(i, 1);
				}
			}
		}

		/**
		 * Update events every formItems(<code>IForm</code>) in subscription.
		 * 
		 * @param target String <code>FormLayoutEvent</code> type and its value.
		 * @param value Object contains value associated <code>FormLayoutEvent</code>
		 * 
		 * @see com.yahoo.astra.containers.formClasses.IForm#update
		 */
		public function setUpdate(target : String, value:Object) : void {
			for (var i in this.observers) {
				observers[i].update(target, value);
			}
		}

	}
}