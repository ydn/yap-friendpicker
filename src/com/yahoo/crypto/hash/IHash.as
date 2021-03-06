/**
 * IHash
 * 
 * Copyright (c) 2007 Henri Torgemane
 * 
 * See LICENSE.txt for full license information.
 */
package com.yahoo.crypto.hash
{
	import flash.utils.ByteArray;

	/**
	 * @private
	 * An interface for each hash function to implement
	 */
	internal interface IHash
	{
		function getInputSize():uint;
		function getHashSize():uint;
		function hash(src:ByteArray):ByteArray;
		function toString():String;
	}
}