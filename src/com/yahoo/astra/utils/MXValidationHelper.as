package com.yahoo.astra.utils {
	import mx.validators.CreditCardValidator;
	import mx.validators.CurrencyValidator;
	import mx.validators.DateValidator;
	import mx.validators.EmailValidator;
	import mx.validators.NumberValidator;
	import mx.validators.PhoneNumberValidator;
	import mx.validators.StringValidator;
	import mx.validators.Validator;
	import mx.validators.ZipCodeValidator;
	import mx.validators.ZipCodeValidatorDomainType;	

		/**
	 * A helper class to be used associated with <code>MX.validators</code> classes.
	 * <code>MX.validators</code> provides a variety of validation types and detailed error messages.
	 * You can edit the default error types and messages as needed.
	 * However, the use of the MXvalidator will increase your overall file size by approximately 20K.
	 * 
	 * Currently credit card, regExp and social security validations are not providing, can be added under your responsiblity.
	 * 
	 * @see http://livedocs.adobe.com/flex/3/langref/mx/validators/Validator.html
	 * 
	 * @author kayoh
	 */
	public class MXValidationHelper extends Object{
		/**
		 * Validate email value. Returning an array of error messages or empty array if there is no error.
		 * 
		 * @param str String to validate. */
		public function validateEmail(str : String) : Array {
			var emailValidator : EmailValidator = new EmailValidator();
			emailValidator.invalidCharError = "Invalid characters in your email address." ;
			emailValidator.invalidDomainError = "The domain in your email address is incorrectly formatted." ;
			emailValidator.invalidIPDomainError = "The IP domain in your email address is incorrectly formatted." ;
			emailValidator.invalidPeriodsInDomainError = "The domain in your email address has consecutive periods." ;
			emailValidator.missingAtSignError = "Missing an at character in your email address." ;
			emailValidator.missingPeriodInDomainError = "The domain in your email address is missing a period." ;
			emailValidator.missingUsernameError = "The username in your email address is missing." ;
			emailValidator.tooManyAtSignsError = "Too many at characters in your email address.";
			return EmailValidator.validateEmail(emailValidator, str, "");
		}
		/**
		 * Validate string value. Returning an array of error messages or empty array if there is no error.
		 * 
		 * @param str String to validate.
		 */
		public function validateString(str : String) : Array {
			var stringValidator : StringValidator = new StringValidator();
			stringValidator.minLength = 1;
			stringValidator.tooShortError = "This must be at least " + stringValidator.minLength + " characters long." ;
			
			return StringValidator.validateString(stringValidator, str, "");
		}
		/**
		 * Validate zipcode value. Returning an array of error messages or empty array if there is no error.
		 * 
		 * @param str String to validate.
		 */
		public function validateZipCode(str : String) : Array {
			var zipCodeValidator : ZipCodeValidator = new ZipCodeValidator();
			zipCodeValidator.domain = ZipCodeValidatorDomainType.US_OR_CANADA;
			zipCodeValidator.allowedFormatChars = "/\-. " ;
			zipCodeValidator.wrongLengthError = "Type the date in the format inputFormat.";
			zipCodeValidator.invalidCharError = "The ZIP code contains invalid characters." ;
			zipCodeValidator.invalidDomainError = "The domain parameter is invalid. It must be either 'US Only' or 'US or Canada'." ;
			zipCodeValidator.wrongCAFormatError = "The Canadian ZIP code must be formatted 'A1B 2C3'." ;
			zipCodeValidator.wrongLengthError = "The ZIP code must be 5 digits or 5+4 digits." ;
			zipCodeValidator.wrongUSFormatError = "The ZIP+4 extension must be formatted '12345-6789'." ;
			return ZipCodeValidator.validateZipCode(zipCodeValidator, str, "");
		}
		/**
		 * Validate number value. Returning an array of error messages or empty array if there is no error.
		 * 
		 * @param str String to validate.
		 */
		public function validateNumber(str : String) : Array {
			var numberValidator : NumberValidator = new NumberValidator();
			numberValidator.allowNegative = "true";
			numberValidator.decimalPointCountError = "The decimal separator can only occur once.";
			numberValidator.decimalSeparator = ".";
			numberValidator.domain = "real"; 
			numberValidator.exceedsMaxError = "The number entered is too large.";
			numberValidator.integerError = "The number must be an integer.";
			numberValidator.invalidCharError = "The input contains invalid characters.";
			numberValidator.invalidFormatCharsError = "One of the formatting parameters is invalid.";
			numberValidator.lowerThanMinError = "The amount entered is too small.";
			numberValidator.maxValue = "NaN";
			numberValidator.minValue = "NaN";
			numberValidator.negativeError = "The amount may not be negative.";
			numberValidator.precision = "-1";
			numberValidator.precisionError = "The amount entered has too many digits beyond the decimal point.";
			numberValidator.separationError = "The thousands separator must be followed by three digits.";
			numberValidator.thousandsSeparator = ",";
			
			return NumberValidator.validateNumber(numberValidator, str, "");
		}
		/**
		 * Validate currency value. Returning an array of error messages or empty array if there is no error.
		 * 
		 * @param str String to validate.
		 */
		public function validateCurrency(str : String) : Array {
			var currencyValidator : CurrencyValidator = new CurrencyValidator();
			currencyValidator.alignSymbol = "left";
			currencyValidator.allowNegative = "true";
			currencyValidator.currencySymbol = "$";
			currencyValidator.currencySymbolError = "The currency symbol occurs in an invalid location.";
			currencyValidator.decimalPointCountError = "The decimal separator can occur only once.";
			currencyValidator.decimalSeparator = ".";
			currencyValidator.exceedsMaxError = "The amount entered is too large.";
			currencyValidator.invalidCharError = "The input contains invalid characters.";
			currencyValidator.invalidFormatCharsError = "One of the formatting parameters is invalid.";
			currencyValidator.lowerThanMinError = "The amount entered is too small.";
			currencyValidator.maxValue = "NaN";
			currencyValidator.minValue = "NaN";
			currencyValidator.negativeError = "The amount may not be negative.";
			currencyValidator.precision = "2";
			currencyValidator.precisionError = "The amount entered has too many digits beyond the decimal point.";
			currencyValidator.separationError = "The thousands separator must be followed by three digits.";
			currencyValidator.thousandsSeparator = ",";
			
			return CurrencyValidator.validateCurrency(currencyValidator, str, "");
		}
		/**
		 * Validate date value. Returning an array of error messages or empty array if there is no error.
		 * 
		 * @param str String to validate.
		 */
		public function validateDate(str : String) : Array {
			var dateValidator : DateValidator = new DateValidator();
			dateValidator.allowedFormatChars = "/\-. ";
			dateValidator.formatError = "Configuration error: Incorrect formatting string.";
			dateValidator.inputFormat = "MM/DD/YYYY";
			dateValidator.invalidCharError = "The date contains invalid characters.";
			dateValidator.validateAsString = "true";
			dateValidator.wrongDayError = "Enter a valid day for the month.";
			dateValidator.wrongLengthError = "Type the date in the format inputFormat.";
			dateValidator.wrongMonthError = "Enter a month between 1 and 12.";
			dateValidator.wrongYearError = "Enter a year between 0 and 9999.";
			
			return DateValidator.validateDate(dateValidator, str, "");
		}
		/**
		 * Validate phone number value. Returning an array of error messages or empty array if there is no error.
		 * 
		 * @param str String to validate.
		 */
		public function validatePhoneNumber(str : String) : Array {
			var phoneNumberValidator : PhoneNumberValidator = new PhoneNumberValidator();
			phoneNumberValidator.allowedFormatChars = "()- .+";
			phoneNumberValidator.invalidCharError = "Your telephone number contains invalid characters.";
			phoneNumberValidator.wrongLengthError = "Your telephone number must contain at least 10 digits.";
			
			return PhoneNumberValidator.validatePhoneNumber(phoneNumberValidator, str, "");
		}
	}
}
