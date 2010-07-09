package com.yahoo.astra.containers.formClasses {

	/**
	 * Methods and properties expected to be defined by Form Classes. 
	 * 
	 * @see com.yahoo.astra.containers.formClasses.FormEventObserver
	 *  
	 * @author kayoh 
	 */
	public interface IForm {

		//--------------------------------------
		//  Methods
		//--------------------------------------
		/**
		 * @param formEventObserver <code>FormEventObserver</code> to register.
		 * @return IFormEventObserver Return type of <code>formEventObserver.subscribeObserver(IForm)</code>.
		 */
		function subscribeObserver(formEventObserver : FormEventObserver) : IFormEventObserver;

		/** 
		 * @param target String <code>FormLayoutEvent</code> type.
		 * @param value Object contains value associated <code>FormLayoutEvent</code>
		 */
		function update(target : String, value : Object = null) : void;
	}
}
