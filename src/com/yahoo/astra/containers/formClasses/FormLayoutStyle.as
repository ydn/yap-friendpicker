package com.yahoo.astra.containers.formClasses {
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;	

	/**
	 * Event types and style definitions for form classes.
	 * @author kayoh
	 */
	public class FormLayoutStyle extends Object {
		//--------------------------------------------------------------------------
		//  Const Properties
		//--------------------------------------------------------------------------
		/**
		 * Defines the value of the <code>type</code> property of a 
		 * <code>vertical</code> event object. 
		 * 	 
		 *  @eventType horizontal
		 *  @see com.yahoo.astra.containers.FormItem#itemAlign
		 */
		public static const HORIZONTAL : String = "horizontal";
		/**
		 * Defines the value of the <code>type</code> property of a 
		 * <code>vertical</code> event object. 
		 * 	 
		 *  @eventType vertical
		 *  @see com.yahoo.astra.containers.FormItem#itemAlign
		 */
		public static const VERTICAL : String = "vertical";

		/**
		 * Defines the value of the <code>type</code> property of a 
		 * <code>left</code> event object. 
		 * 	 
		 *  @eventType left
		 *  @see com.yahoo.astra.fl.containers.FormContainer#indicatorLocation
		 */
		public static const INDICATOR_LEFT : String = "left";
		/**
		 * Defines the value of the <code>type</code> property of a 
		 * <code>right</code> event object. 
		 * 	 
		 *  @eventType right
		 *  @see com.yahoo.astra.fl.containers.FormContainer#indicatorLocation
		 */
		public static const INDICATOR_RIGHT : String = "right";
		/**
		 * Defines the value of the <code>type</code> property of a 
		 * <code>label_right</code> event object. 
		 * 	 
		 *  @eventType label_right
		 *  @see com.yahoo.astra.fl.containers.FormContainer#indicatorLocation
		 */
		public static const INDICATOR_LABEL_RIGHT : String = "label_right";
		/**
		 * Defines the value of the <code>type</code> property of a 
		 * <code>none</code> event object. 
		 * 	 
		 *  @eventType none
		 *  @see com.yahoo.astra.fl.containers.FormContainer#indicatorLocation
		 */
		public static const INDICATOR_NONE : String = "none";
		/**
		 * Defines the value of the <code>type</code> property of a 
		 * <code>left</code> event object. 
		 * 	 
		 *  @eventType left
		 */
		public static const LEFT : String = "left";
		/**
		 * Defines the value of the <code>type</code> property of a 
		 * <code>right</code> event object. 
		 * 	 
		 *  @eventType right
		 */
		public static const RIGHT : String = "right";
		/**
		 * Defines the value of the <code>type</code> property of a 
		 * <code>top</code> event object. 
		 * 	 
		 *  @eventType top
		 */
		public static const TOP : String = "top";
		/**
		 * Default value of label alignment.
		 * 
		 * @see com.yahoo.astra.fl.containers.FormContainer#labelAlign
		 * @see com.yahoo.astra.containers.formClasses.FormItem#labelAlign
		 */
		public static const DEFAULT_LABELALIGN : String = FormLayoutStyle.RIGHT;
		/**
		 * Default alignment of items in <code>FormItem</code>.
		 * 
		 * @see com.yahoo.astra.containers.formClasses.FormItem#itemAlign
		 */
		public static const DEFAULT_ITEM_ALIGN : String = FormLayoutStyle.HORIZONTAL;
		/**
		 * Default location of required indicators.
		 * 
		 * @see com.yahoo.astra.fl.containers.FormContainer#indicatorLocation
		 * @see com.yahoo.astra.containers.formClasses.FormItem#indicatorLocation
		 */
		public static const DEFAULT_INDICATOR_LOCATION : String = FormLayoutStyle.INDICATOR_LABEL_RIGHT;

		/**
		 * Default number of pixels in gaps between labels and items.
		 * 
		 *  @see com.yahoo.astra.containers.formClasses.FormItem#horizontalGap 
		 */
		public static const DEFAULT_HORIZONTAL_GAP : Number = 6;
		/**
		 * Default number of pixels in gaps between each <code>FormItem</code>s in<code>FormContainer</code> verticaly.
		 * 
		 *  @copy com.yahoo.astra.fl.containers.FormContainer#verticalGap 
		 */
		public static const DEFAULT_VERTICAL_GAP : Number = 6;
		/**
		 * Default number of pixels in gaps between each items in a <code>FormItem</code>s verticaly.
		 * 
		 *  @see com.yahoo.astra.fl.containers.formClasses.FormItem#itemVerticalGap 
		 *  @see com.yahoo.astra.fl.containers.FormContainer#itemVerticalGap 
		 */
		public static const DEFAULT_FORMITEM_HORIZONTAL_GAP : Number = 6;
		/**
		 * Default number of pixels in gaps between each items in a <code>FormItem</code>s horizontaly.
		 * 
		 *  @see com.yahoo.astra.fl.containers.formClasses.FormItem#itemHorizontalGap 
		 *  @see com.yahoo.astra.fl.containers.FormContainer#itemHorizontalGap 
		 */
		public static const DEFAULT_FORMITEM_VERTICAL_GAP : Number = 6;
		/**
		 * Default message to be shown as an error message in <code>FormItem</code>.
		 * 
		 *  @see com.yahoo.astra.fl.containers.formClasses.FormItem#showErrorMessageText 
		 */
		public static const DEFAULT_ERROR_STRING : String = "Invalid input";

		/**
		 *  Default transparency of error box Sprite(<code>errorGrayBox</code>) in <code>FormItem</code>.
		 *  
		 *  @see com.yahoo.astra.fl.containers.formClasses.FormItem#showErrorMessageBox
		 */
		public static const ERR_BOX_ALPHA : Number = .1;
		/**
		 *  Default color of error box Sprite(<code>errorGrayBox</code>) in <code>FormItem</code>.
		 *  
		 *   @see com.yahoo.astra.fl.containers.formClasses.FormItem#showErrorMessageBox
		 */
		public static const ERR_BOX_COLOR : uint = 0x333333;

		//--------------------------------------------------------------------------
		//  Properties
		//--------------------------------------------------------------------------		
		
		/**
		 *  Default width of the required indicator.
		 *  
		 */
		public static var INDICATORFIELD_WIDTH : Number = 13;
		/**
		 * Default height of the required indicator.
		 */
		public static var INDICATORFIELD_HEIGHT : Number = 18;

		/**
		 * Default styles for text fields and indicatorSkin.
		 */
		public static const defaultStyles : Object = {
					indicatorSkin: "indicatorSkin", textFormat: new TextFormat("_sans", 11, 0x000000, false, false, false, "", "", TextFormatAlign.LEFT, 0, 0, 0, 0), headTextFormat: new TextFormat("_sans", 11, 0x000000, true, false, false, "", "", TextFormatAlign.LEFT, 0, 0, 0, 0), instructionTextFormat: new TextFormat("_sans", 10, 0x000000, false, false, false, "", "", TextFormatAlign.LEFT, 0, 0, 0, 0), defaultDisabledTextFormat: new TextFormat("_sans", 11, 0x999999, false, false, false, "", "", TextFormatAlign.LEFT, 0, 0, 0, 0)	
				};

		/**
		 * TextField to be used for instruction text in FormItem.
		 */

		public static function get instructionTextField() : TextField {
			var Tformat : TextFormat = FormLayoutStyle.defaultStyles["instructionTextFormat"];
			var instTextField : TextField = FormLayoutStyle.defaultTextField;
			instTextField.defaultTextFormat = Tformat;
			instTextField.autoSize = TextFieldAutoSize.LEFT;
			return instTextField;
		}

		/**
		 * TextField to be used for FormHead.
		 */
		public static function get headTextField() : TextField {
			var Tformat : TextFormat = FormLayoutStyle.defaultStyles["headTextFormat"];
			var textField : TextField = FormLayoutStyle.defaultTextField;
			textField.defaultTextFormat = Tformat;
			textField.autoSize = TextFormatAlign.LEFT;
			return textField;
		}

		/**
		 * @private
		 */
		internal static function get labelTextField() : TextField {
			var Tformat : TextFormat = FormLayoutStyle.defaultStyles["textFormat"];
			var textField : TextField = FormLayoutStyle.defaultTextField;
			textField.defaultTextFormat = Tformat;
			textField.autoSize = TextFormatAlign.LEFT;
			return textField;
		}

		/**
		 * @private
		 */

		internal static function get asteriskTextField() : TextField {
			
			var textField : TextField = FormLayoutStyle.labelTextField;
			var Tformat : TextFormat = new TextFormat("_sans", 20, 0xff0000);
			textField.defaultTextFormat = Tformat;
			textField.autoSize = TextFormatAlign.LEFT;
			textField.text = "*";
			return textField;
		}

		/**
		 * @private
		 */
		internal static function get defaultTextField() : TextField {
			var textField : TextField = new TextField();
			textField.selectable = false;
			textField.wordWrap = false;
			return textField;
		}
	}
}
