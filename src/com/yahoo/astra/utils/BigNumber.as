package com.yahoo.astra.utils
{
	import flash.utils.ByteArray;
	
	use namespace big_number;
	
	/**
	 * A numeric value not subject to the inaccurracies of floating-point math.
	 * 
	 * @author Josh Tynjala
	 */
	public class BigNumber
	{
		
	//--------------------------------------
	//  Public Static Properties
	//--------------------------------------
		
		private static const ZERO:BigNumber = BigNumber.fromNumber(0);
		
	//--------------------------------------
	//  Public Static Methods
	//--------------------------------------
	
		/**
		 * Converts a Number value to a BigNumber.
		 */
		public static function fromNumber(value:Number):BigNumber
		{
			var result:BigNumber = new BigNumber();
			
			if(isNaN(value))
			{
				result.isNaN = true;
				return result;
			}
			
			var valueAsString:String = value.toString();
			var negativeIndex:int = valueAsString.indexOf("-");
			if(negativeIndex == 0)
			{
				valueAsString = valueAsString.substr(1);
				result.negative = true;
			}
			result.decimalIndex = valueAsString.indexOf(".");
			
			//remove the decimal so we can read the raw digits
			valueAsString = valueAsString.split(".").join("");
			
			if(result.decimalIndex < 0)
			{
				result.decimalIndex = valueAsString.length;
			}
			
			var digitCount:int = valueAsString.length;
			for(var i:int = 0; i < digitCount; i++)
			{
				result.digits[i] = int(valueAsString.charAt(i));
			}
			
			return result;
		}
		
		/**
		 * Determines if a value is not a number.
		 */
		public static function isBigNumberNaN(value:BigNumber):Boolean
		{
			return value.isNaN;
		}
		
		/**
		 * Adds the value of rightSide to the value of leftSide. Non-destructive.
		 */
		public static function add(leftSide:BigNumber, rightSide:BigNumber, ...rest:Array):BigNumber
		{
			if(!leftSide.negative && rightSide.negative)
			{
				var rightClone:BigNumber = rightSide.clone();
				rightClone.negative = false;
				return subtract(leftSide, rightClone);
			}
			else if(leftSide.negative && !rightSide.negative)
			{
				var leftClone:BigNumber = leftSide.clone();
				leftClone.negative = false;
				return subtract(rightSide, leftClone);
			}
			
			var result:BigNumber = new BigNumber();
			if(isBigNumberNaN(leftSide) || isBigNumberNaN(rightSide))
			{
				result.isNaN = true;
				return result;
			}
			
			leftClone = leftSide.clone();
			rightClone = rightSide.clone();
			makeSameLength(leftClone, rightClone);
			
			result.decimalIndex = leftClone.decimalIndex;
			
			var digitCount:int = leftClone.digits.length;
			var carry:int = 0;
			for(var i:int = digitCount; i >= 0; i--)
			{
				var value1:int = leftClone.digits[i] as int;
				var value2:int = rightClone.digits[i] as int;
				var sum:int = value1 + value2 + carry;
				if(sum > 9)
				{
					sum -= 10;
					carry = 1;
				}
				else carry = 0;
				result.digits[i] = sum;
			}
			if(carry == 1)
			{
				result.digits.unshift(1);
				result.decimalIndex++;
			}
			
			if(leftSide.negative) //right side will be too!
			{
				result.negative = true;
			}
			result = normalize(result);
			
			var restCount:int = rest.length;
			for(i = 0; i < restCount; i++)
			{
				result = add(result, rest.shift());
			}
			
			return result;
		}
		
		/**
		 * Subtracts the value of rightSide from the value of leftSide. Non-destructive.
		 */
		public static function subtract(leftSide:BigNumber, rightSide:BigNumber, ...rest:Array):BigNumber
		{
			if(leftSide.negative && rightSide.negative)
			{
				var leftClone:BigNumber = leftSide.clone();
				leftClone.negative = false;
				var rightClone:BigNumber = rightSide.clone();
				rightClone.negative = false;
				return subtract(rightClone, leftClone);
			}
			else if(!leftSide.negative && rightSide.negative)
			{
				rightClone = rightSide.clone();
				rightClone.negative = false;
				return add(leftSide, rightClone);
			}
			else if(leftSide.negative && !rightSide.negative)
			{
				rightClone = rightSide.clone();
				rightClone.negative = true;
				return add(leftSide, rightClone);
			}
			
			var result:BigNumber = new BigNumber();
			if(isBigNumberNaN(leftSide) || isBigNumberNaN(rightSide))
			{
				result.isNaN = true;
				return result;
			}
			
			//swap if rightSide > leftSide 
			var negative:Boolean = greaterThan(rightSide, leftSide);
			if(negative)
			{
				var temp:BigNumber = leftSide;
				leftSide = rightSide;
				rightSide = temp;
			}
			
			leftClone = leftSide.clone();
			rightClone = rightSide.clone();
			makeSameLength(leftClone, rightClone);
			
			result.decimalIndex = leftClone.decimalIndex;
			
			var digitCount:int = leftClone.digits.length;
			for(var i:int = digitCount - 1; i >= 0; i--)
			{
				var value1:int = leftClone.digits[i] as int;
				var value2:int = rightClone.digits[i] as int;
				
				if(value2 > value1)
				{
					var currentDigit:int = i;
					value1 += 10;
					do
					{
						currentDigit--;
						var nextValue:int = leftClone.digits[currentDigit] as int;
						if(nextValue == 0)
						{
							leftClone.digits[currentDigit] = 9;
						}
						else
						{
							leftClone.digits[currentDigit] = nextValue - 1;
							break;
						}
					}
					while(currentDigit != 0)
				}
				
				var difference:int = value1 - value2;
				result.digits[i] = difference;
			}
			
			result.negative = negative;
			
			result = normalize(result);
			
			var restCount:int = rest.length;
			for(i = 0; i < restCount; i++)
			{
				result = subtract(result, rest.shift());
			}
			
			return result;
		}
		
		/**
		 * Multiplies the value of leftSide by the value of rightSide. Non-destructive.
		 */
		public static function multiply(leftSide:BigNumber, rightSide:BigNumber, ...rest:Array):BigNumber
		{
			var negative:Boolean = (leftSide.negative && !rightSide.negative) || (!leftSide.negative && rightSide.negative); 
			
			var leftClone:BigNumber = leftSide.clone();
			var rightClone:BigNumber = rightSide.clone();
			
			var results:Array = [];
			
			var rightDigitCount:int = rightClone.digits.length;
			var carry:int = 0;
			for(var i:int = rightDigitCount; i >= 0; i--)
			{
				var result:BigNumber = new BigNumber();
				var value2:int = rightClone.digits[i] as int;
				var leftDigitCount:int = leftClone.digits.length;
				for(var j:int = leftDigitCount; j >= 0; j--)
				{
					var value1:int = leftClone.digits[j] as int;
					var product:int = value1 * value2 + carry;
					if(product > 9)
					{
						carry = product - (product % 10); 
						product -= carry;
					}
					else carry = 0;
					result.digits[j] = product;
				}
				if(carry > 0)
				{
					result.digits.unshift(carry);
				}
				
				var extraZeros:int = result.digits.length - i;
				for(j = 0; j < extraZeros; j++)
				{
					result.digits.push(0);
				}
				result.decimalIndex = result.digits.length;
				results.push(result);
			}
			
			result = BigNumber.add.apply(BigNumber, results);
			result.decimalIndex = (leftSide.digits.length - leftSide.decimalIndex) + (rightSide.digits.length - rightSide.decimalIndex);
			result.negative = negative;
			result = normalize(result);
			
			var restCount:int = rest.length;
			for(i = 0; i < restCount; i++)
			{
				result = multiply(result, rest.shift());
			}
			
			return result;
		}
		
		/**
		 * Divides the value of leftSide by the value of rightSide. Non-destructive.
		 */
		public static function divide(leftSide:BigNumber, rightSide:BigNumber, maxDecimalPlaces:int = 10):BigNumber
		{
			if(equals(rightSide, BigNumber.ZERO))
			{
				throw new ArgumentError("Cannot divide by zero");
			}
			
			var negative:Boolean = (leftSide.negative && !rightSide.negative) || (!leftSide.negative && rightSide.negative); 
			
			var leftClone:BigNumber = leftSide.clone();
			var rightClone:BigNumber = rightSide.clone();
			var decimalIndexInResult:int = leftClone.decimalIndex + (rightClone.digits.length - rightClone.decimalIndex + 1);
			//move the decimal to the end for long division
			rightClone.decimalIndex = rightClone.digits.length;
			
			var totalDecimalPlaces:int = 0;
			var result:BigNumber = BigNumber.ZERO.clone();
			var remainder:BigNumber = BigNumber.ZERO.clone();
			for(var i:int = 0; i < leftClone.digits.length; i++)
			{
				var digit:int = leftClone.digits[i] as int;
				remainder.digits.push(digit);
				remainder.decimalIndex = remainder.digits.length;
				remainder = normalize(remainder);
				
				var times:int = 0;
				while(BigNumber.greaterThanOrEqual(remainder, rightClone))
				{
					remainder = BigNumber.subtract(remainder, rightClone);
					times++;
				}
				
				result.digits.push(times);
				result.decimalIndex = result.digits.length;
				
				if(i >= decimalIndexInResult)
				{
					totalDecimalPlaces++;
				}
				
				if(totalDecimalPlaces >= maxDecimalPlaces)
				{
					break;
				}
				
				//add extra zeros if needed
				if(i == leftClone.digits.length - 1 && BigNumber.greaterThan(remainder, BigNumber.ZERO))
				{
					leftClone.digits.push(0);
				}
			}
			
			result.decimalIndex = decimalIndexInResult;
			result = normalize(result);
			result.negative = negative;
			return result;
		}
		
		/**
		 * Divides the value of leftSide by the value of rightSide and returns the remainder. Non-destructive.
		 */
		public static function mod(leftSide:BigNumber, rightSide:BigNumber):BigNumber
		{
			if(equals(rightSide, BigNumber.ZERO))
			{
				throw new ArgumentError("Cannot divide by zero");
			}
			var negative:Boolean = (leftSide.negative && !rightSide.negative) || (!leftSide.negative && rightSide.negative); 
			
			var remainder:BigNumber = leftSide.clone();
			while(BigNumber.greaterThanOrEqual(remainder, rightSide))
			{
				remainder = BigNumber.subtract(remainder, rightSide);
			}
			remainder.negative = negative;
			return remainder;
		}
		
		/**
		 * Evaluates leftSide and rightSide returns true if the value of
		 * leftSide is equal to the value of rightSide.
		 */
		public static function equals(leftSide:BigNumber, rightSide:BigNumber):Boolean
		{
			if(leftSide.decimalIndex != rightSide.decimalIndex) return false;
			if(leftSide.digits.length != rightSide.digits.length) return false;
			
			var digitCount:int = leftSide.digits.length;
			for(var i:int = 0; i < digitCount; i++)
			{
				var value1:int = leftSide.digits[i] as int;
				var value2:int = rightSide.digits[i] as int;
				if(value1 !== value2)
				{
					return false;
				}
			}
			return true;
		}
		
		/**
		 * Evaluates leftSide and rightSide returns true if the value of
		 * leftSide is greater than the value of rightSide.
		 */
		public static function greaterThan(leftSide:BigNumber, rightSide:BigNumber):Boolean
		{
			if(leftSide.decimalIndex < rightSide.decimalIndex) return false;
			if(leftSide.decimalIndex > rightSide.decimalIndex) return true;
			//after this point, decimal index must be equal
			
			var leftClone:BigNumber = leftSide.clone();
			var rightClone:BigNumber = rightSide.clone();
			makeSameLength(leftClone, rightClone);
			
			var digitCount:int = leftSide.digits.length;
			for(var i:int = 0; i < digitCount; i++)
			{
				var value1:int = leftClone.digits[i] as int;
				var value2:int = rightClone.digits[i] as int;
				if(value2 > value1) return false;
				if(value1 > value2) return true;
			}
			return false;
		}
		
		/**
		 * Evaluates leftSide and rightSide returns true if the value of
		 * leftSide is greater than or equal to the value of rightSide.
		 */
		public static function greaterThanOrEqual(leftSide:BigNumber, rightSide:BigNumber):Boolean
		{
			return equals(leftSide, rightSide) || greaterThan(leftSide, rightSide);
		}
		
		/**
		 * Evaluates leftSide and rightSide returns true if the value of
		 * leftSide is less than the value of rightSide.
		 */
		public static function lessThan(leftSide:BigNumber, rightSide:BigNumber):Boolean
		{
			if(leftSide.decimalIndex < rightSide.decimalIndex) return true;
			if(leftSide.decimalIndex > rightSide.decimalIndex) return false;
			//after this point, decimal index must be equal
			
			var leftClone:BigNumber = leftSide.clone();
			var rightClone:BigNumber = rightSide.clone();
			makeSameLength(leftClone, rightClone);
			
			var digitCount:int = leftSide.digits.length;
			for(var i:int = 0; i < digitCount; i++)
			{
				var value1:int = leftClone.digits[i] as int;
				var value2:int = rightClone.digits[i] as int;
				if(value2 < value1) return false;
				if(value1 < value2) return true;
			}
			return false;
		}
		
		/**
		 * Evaluates leftSide and rightSide returns true if the value of
		 * leftSide is less than or equal to the value of rightSide.
		 */
		public static function lessThanOrEqual(leftSide:BigNumber, rightSide:BigNumber):Boolean
		{
			return equals(leftSide, rightSide) || lessThan(leftSide, rightSide);
		}
		
		/**
		 * Evaluates value1 and value2 (or more values) and returns the largest value.
		 */
		public static function max(value1:BigNumber, value2:BigNumber, ...rest:Array):BigNumber
		{
			var max:BigNumber = value1;
			if(greaterThan(value2, value1))
			{
				max = value2;
			}
			
			var count:int = rest.length;
			for(var i:int = 0; i < count; i++)
			{
				var valueN:BigNumber = BigNumber(rest[i]);
				if(greaterThan(valueN, max))
				{
					max = valueN;
				}
			}
			return max;
		}
		
		/**
		 * Evaluates value1 and value2 (or more values) and returns the smallest value.
		 */
		public static function min(value1:BigNumber, value2:BigNumber, ...rest:Array):BigNumber
		{
			var min:BigNumber = value1;
			if(lessThan(value2, value1))
			{
				min = value2;
			}
			
			var count:int = rest.length;
			for(var i:int = 0; i < count; i++)
			{
				var valueN:BigNumber = BigNumber(rest[i]);
				if(lessThan(valueN, min))
				{
					min = valueN;
				}
			}
			return min;
		}
		
		/**
		 * Returns the floor of the number or expression specified in the
		 * parameter value. The floor is the closest integer that is less than or
		 * equal to the specified number or expression. Non-destructive.
		 */
		public static function floor(value:BigNumber):BigNumber
		{
			var clone:BigNumber = value.clone();
			
			var digits:Array = clone.digits;
			digits.splice(clone.decimalIndex, digits.length - clone.decimalIndex);
			clone.decimalIndex = digits.length;
			return clone;
		}
		
		/**
		 * Returns the floor of the number or expression specified in the
		 * parameter value. The floor is the closest integer that is greater
		 * than or equal to the specified number or expression. Non-destructive.
		 */
		public static function ceil(value:BigNumber):BigNumber
		{
			var clone:BigNumber = floor(value);
			
			if(!equals(value, clone))
			{
				clone = add(clone, fromNumber(1))
			}
			
			return clone;
		}
		
		/**
		 * Rounds the value of the parameter value up or down to the nearest
		 * integer and returns the value. If value is equidistant from its two
		 * nearest integers (that is, if the number ends in .5), the value is
		 * rounded up to the next higher integer. Non-destructive.
		 */
		public static function round(value:BigNumber):BigNumber
		{
			var clone:BigNumber = ceil(value);
			
			if(greaterThan(subtract(clone, value), fromNumber(0.5)))
			{
				clone = subtract(clone, fromNumber(1));
			}
			
			return clone;
		}
		
		/**
		 * Rounds the value to the nearest multiple of an input. For example, by rounding
		 * 16 to the nearest 10, you will receive 20. Similar to function <code>round()</code>.
		 * 
		 * @param	value				the value to round
		 * @param	nearest				the value whose multiple must be found
		 * @return	the rounded value
		 * 
		 * @see #round()
		 */
		public static function roundToNearest(value:BigNumber, nearest:BigNumber):BigNumber
		{
			return BigNumber.multiply(BigNumber.round(BigNumber.public::divide(value, nearest)), nearest);
		}
		
	//--------------------------------------
	//  Private Static Methods
	//--------------------------------------
		
		/**
		 * @private
		 * 
		 * Pads two BigNumbers with zeros to produce the same number of digits
		 * before and after the decimals.
		 */
		private static function makeSameLength(value1:BigNumber, value2:BigNumber):void
		{
			var maxBeforeDecimal:int = Math.max(value1.decimalIndex, value2.decimalIndex);
			var maxAfterDecimal:int = Math.max(value1.digits.length - value1.decimalIndex, value2.digits.length - value2.decimalIndex);
			
			pad(value1, maxBeforeDecimal, maxAfterDecimal);
			pad(value2, maxBeforeDecimal, maxAfterDecimal);
		}
		
		/**
		 * @private
		 * 
		 * Pads a BigNumber to include zeroes to match the number of specified
		 * digits before and after the decimal.
		 */
		private static function pad(value:BigNumber, before:int, after:int):void
		{
			var digits:Array = value.digits;
			
			before -= value.decimalIndex;
			for(var i:int = 0; i < before; i++)
			{
				digits.unshift(0);
				value.decimalIndex++;
			}
			
			after -= (value.digits.length - value.decimalIndex);
			for(i = 0; i < after; i++)
			{
				digits.push(0);
			}
		}
		
		/**
		 * @private
		 * Removes extra zero padding created in <code>pad()</code>.
		 */
		private static function normalize(value:BigNumber):BigNumber
		{
			//we subtract one, because a single zero before the decimal is a-okay!
			var digitsBeforeDecimal:int = value.decimalIndex - 1;
			for(var i:int = 0; i < digitsBeforeDecimal; i++)
			{
				var digit:int = value.digits[0] as int;
				if(digit === 0)
				{
					value.digits.shift();
					value.decimalIndex--;
				}
				else break;
			}
			
			var digitCount:int = value.digits.length;
			if(value.decimalIndex < digitCount)
			{
				for(i = digitCount - 1; i >= value.decimalIndex; i--)
				{
					digit = value.digits[i] as int;
					if(digit === 0)
					{
						value.digits.pop();
					}
					else break;
				}
			}

			return value;
		}
		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
		
		/**
		 * Constructor.
		 */
		public function BigNumber()
		{
		}
		
	//--------------------------------------
	//  Properties
	//--------------------------------------
	
		big_number var negative:Boolean = false;
		big_number var isNaN:Boolean = false;
		big_number var decimalIndex:int = -1;
		big_number var digits:Array = new Array();
		
	//--------------------------------------
	//  Public Methods
	//--------------------------------------
		
		/**
		 * Creates a copy of a BigNumber.
		 */
		public function clone():BigNumber
		{
			var cloned:BigNumber = new BigNumber();
			cloned.decimalIndex = this.decimalIndex;
			cloned.negative = this.negative;
			cloned.isNaN = this.isNaN;
			cloned.digits = this.digits.concat();
			return cloned;
		}
		
		/**
		 * Converts a BigNumber to a String
		 */
		public function toString():String
		{
			if(isBigNumberNaN(this)) return NaN.toString();
			if(this.digits.length == 0) return "0";
			
			var result:String = this.digits.join("");
			if(negative) result = "-" + result;
			
			if(this.decimalIndex == this.digits.length) return result;
			return result.substr(0, this.decimalIndex) + "." + result.substr(this.decimalIndex);
		}
		
		/**
		 * Converts a BigNumber to a regular Number (may not be accurate for
		 * sufficiently large or precise BigNumber values).
		 */
		public function toNumber():Number
		{
			return Number(this.toString());
		}
	}
}
	import com.yahoo.astra.utils.BigNumber;
	
//used to keep some stuff accessible to static methods
//but inaccessible outside this class
namespace big_number;

class DivisionResult
{
	public function DivisionResult(quotient:BigNumber, remainder:BigNumber)
	{
		this.quotient = quotient;
		this.remainder = remainder;
	}
	public var quotient:BigNumber;
	public var remainder:BigNumber;
}