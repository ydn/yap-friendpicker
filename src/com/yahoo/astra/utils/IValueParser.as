package com.yahoo.astra.utils {

	/**
	 * Methods expected to be defined by a valudator for <code>FormDataManager</code> class.
	 * 
	 * @author kayoh
	 */
	public interface IValueParser {
		/**
		 * @param property points to the actual user input form objects
		 * @param source specifies the name of the property of the source
		 */

		function setValue(source : Object = null, property : Object = null) : Function ;

		/**
		 * Returning actual value of <code>setValue</code>. 
		 */
		function getValue() : Object ;
	}
}
