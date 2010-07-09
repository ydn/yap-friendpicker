
package com.yahoo.astra.containers.formClasses {
	import com.yahoo.astra.containers.formClasses.FormItemContainer;
	import com.yahoo.astra.containers.formClasses.FormItemLabel;
	import com.yahoo.astra.containers.formClasses.FormLayoutStyle;
	import com.yahoo.astra.containers.formClasses.IForm;
	import com.yahoo.astra.events.FormDataManagerEvent;
	import com.yahoo.astra.events.FormLayoutEvent;
	import com.yahoo.astra.layout.LayoutContainer;
	import com.yahoo.astra.layout.LayoutManager;
	import com.yahoo.astra.layout.events.LayoutEvent;
	import com.yahoo.astra.layout.modes.BoxLayout;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;	

	/**
	 * The FormItem container defines a label and one or more children arranged horizontally or vertically. 
	 * Similar to Flex FormItem, the label is vertically aligned with the first child in the FormItem container and is right-aligned in the region to the left of the container.
	 * It is designed to be nested in a FormContainer, but it can be used as a standalone class as desired.
	 * 
	 * @author kayoh
	 */
	public class FormItem extends Sprite implements IForm {

		//--------------------------------------
		//  Constructor
		//--------------------------------------
	
		//--------------------------------------
		/**
		 * Constructor.
		 * The parameter can be either Strings or DisplayObjects. 
		 * The first sting will be set as a label, and any string afterward will be a label aligned with other DisplayObjects.
		 * 
		 * @param args		 String or DisplayObjectsto be contained in the FormItem.
		 */
		public function FormItem( ...args ) {
			formItemLayout = new BoxLayout();

			formItemLayout.horizontalGap = horizontalGap; 
			fomItemContainer = new LayoutContainer(formItemLayout);
//			fomItemContainer.autoMask = false;
			this.addChild(fomItemContainer);
			
			//attach Label
			var i : int = 0;
			if(args[0] is String) {
				labelItem = addLabel(args[0].toString());
				i = 1;
			} else {
				labelItem = addLabel(null);
			}
			
			//attach ItemContainer
			itemContainer = new FormItemContainer();
			if(itemAlign) itemContainer.itemAlign = this.itemAlign;
			if(itemHorizontalGap) itemContainer.itemHorizontalGap = this.itemHorizontalGap;
			if(itemVerticalGap) itemContainer.itemVerticalGap = this.itemVerticalGap;

			itemContainer.addEventListener(LayoutEvent.LAYOUT_CHANGE, handler_fomItemContainer_listener, false, 0, true);
			
			for (i;i < args.length; i++) {
				var curObject : * = args[i];
				if(curObject is String) {
					curObject = addTextField(curObject);
					textfieldArr.push(curObject);
				}
				if(curObject is Array) {
					var curObjectArr : Array = curObject as Array;
					var curObjectlength : int = curObjectArr.length;
					for (var j : int = 0;j < curObjectlength; j++) {
						var curObj : * = curObject[j];
						if(curObj is String) {
							curObj = addTextField(curObj);
							textfieldArr.push(curObj);
						}
						itemContainer.addItem(curObj);
					}
				} else {
					itemContainer.addItem(curObject);	
				}
			}

			fomItemContainer.addChild(labelItem);
			fomItemContainer.addChild(itemContainer);
		}

		//--------------------------------------
		//  Properties
		//--------------------------------------
		/**
		 * @private
		 */
		private var formItemLayout : BoxLayout = null;
		/**
		 * @private
		 */
		private var fomItemContainer : LayoutContainer = null;
		/**
		 * @private
		 */
		private var errorGrayBox : Sprite = null;
		/**
		 * @private
		 */
		private var textfieldArr : Array = [];
		/**
		 * @private
		 */
		private var formEventObserver : FormEventObserver = null;

		/**
		 * @private
		 */
		private var _gotResultBool : Boolean = true;

		/**
		 * @private
		 * 
		 * No explicit use.
		 * 
		 * When <code>multipleResult</code> is <code>true</code>, used as a reference to determine to pass/fail in validation  in <code>FormDataManager</code>.
		 * In case <code>multipleResult</code> is <code>true</code>, 
		 * In case <code>FormItem</code> has multiple form inputs to validate and part of them are not passed the validation, <code>gotResultBool</code> will be set as <code>false</code> to show ErrorMessageBox or ErrorMessageMessage.
		 * 
		 * @default true;
		 */
		public function get gotResultBool() : Boolean {
			return _gotResultBool;
		}

		/**
		 * @private
		 */
		public function set gotResultBool(value : Boolean) : void {
			_gotResultBool = value;
		}

		/**
		 * @private
		 * Storage for the showErrorMessageBox property.
		 */
		private var _showErrorMessageBox : Boolean = false;

		/**
		 * Decides to present error result message box : a translucent gray box(color:0x333333, alpha:.1) under the items that failed to validate.
		 * 
		 * @see 	com.yahoo.astra.fl.containers.formClasses.FormLayoutStyle#ERR_BOX_ALPHA	and  com.yahoo.astra.fl.containers.formClasses.FormLayoutStyle#ERR_BOX_COLOR for appearance setting of the box.
		 * 
		 * @default false;
		 */
		public function get showErrorMessageBox() : Boolean {
			return _showErrorMessageBox;
		}

		/**
		 * @private
		 */
		public function set showErrorMessageBox(value : Boolean) : void {
			_showErrorMessageBox = value;
			(value) ? this.addLiestners() : this.removeLiestners();
		}

		/**
		 * @private
		 * Storage for the showErrorMessageText property.
		 */
		private var _showErrorMessageText : Boolean = false;
		/**
		 * Decides to present error result message string : a text returned from <code>FormDataManager</code> that failed to validate.
		 * 
		 * @see 	com.yahoo.astra.fl.containers.formClasses.FormDataManager#errorString for default error string.
		 *  
		 * @default false;
		 */
		public function get showErrorMessageText() : Boolean {
			return _showErrorMessageText;
		}

		/**
		 * @private
		 */
		public function set showErrorMessageText(value : Boolean) : void {
			_showErrorMessageText = value;
			(value) ? addLiestners() : removeLiestners();
		}

		/**
		 * @private
		 * Storage for the itemContainer property.
		 */
		private var _itemContainer : FormItemContainer = null;

		/**
		 * FormItemContainer to contain form items in a FormItem.
		 * 
		 * @see com.yahoo.astra.containers.formClasses.FormItemContainer
		 */
		public function get itemContainer() : FormItemContainer {
			return _itemContainer;
		}

		/**
		 * @private
		 */
		public function set itemContainer(value : FormItemContainer) : void {
			_itemContainer = value;
		}
		/**
		 * @private
		 * Storage for the labelItem property.
		 */
		private var _labelItem : FormItemLabel = null;

		/**
		 * FormItemLabel to contain a label in a FormItem.
		 * 
		 *  @param value LayoutContainer to be used as label container.
		 */
		public function get labelItem() : FormItemLabel {
			return _labelItem;
		}

		/**
		 * @private
		 */
		public function set labelItem(value : FormItemLabel) : void {
			_labelItem = value;
		}

		
		/**
		 * @private
		 * Storage for the errorString property.
		 */
		private var _errorString : String = FormLayoutStyle.DEFAULT_ERROR_STRING;

		/**
		 * Setting of a text to be used for validation error. 
		 * 
		 * @param value String to be set as error message.
		 * @default "Invalid input"
		 */
		public function get errorString() : String {
			return _errorString;
		}

		/**
		 * @private
		 */
		public function set errorString(value : String) : void {
			_errorString = value;
		}

		/**
		 * Setting an additional text label bottom of the item field
		 */
		public function set instructionText(value : String) : void {
			this.itemContainer.instructionText = value;
		}

		/**
		 * @private
		 * Storage for the labelAlign property.
		 */
		private var _labelAlign : String = FormLayoutStyle.DEFAULT_LABELALIGN;

		/**
		 * Alignment of labels in FormItems. Default alignment is right-aligned(<code>FormStyle.RIGHT</code>). 
		 * Changes labels' alignment by setting the labelAlign property to left(<code>FormStyle.LEFT</code>) and to top(<code>FormStyle.TOP</code>) which stacks the labels and times vertically.
		 *
		 * @default FormStyle.RIGHT
		 * @param value String of alignment.
		 */
		public function get labelAlign() : String {
			return _labelAlign;
		}

		/**
		 * @private
		 */
		public function set labelAlign(value : String) : void {
			if(_labelAlign == value) return; 
			_labelAlign = value;
			
			this.updatelabelAlign(value);
		}

		
		/**
		 * @private
		 * Storage for the labelWidth property.
		 */
		private var _labelWidth : Number = NaN;

		/**
		 * Setting width of label field.
		 * FormContainer automatically matches the width of labels on the longest label among FormItems in the container. 
		 * However, you can override the width of the label using the labelWidth property. 
		 * If the forced width is smaller than the actual label width, it will cut the label size according the label alignment. 
		 * (e.g., for the label aligned left(FormStyle.LEFT), right side of label will be delimited.)
		 * 
		 * @param value Number of pixels.
		 */
		public function get labelWidth() : Number {
			return _labelWidth;
		}

		/**
		 * @private
		 */
		public function set labelWidth(value : Number) : void {
			if(_labelWidth == value) return;
			_labelWidth = value;
		
			if(this.labelItem) {	
				this.labelItem.preferredLabelWidth = value;
			}
		}

		/**
		 * @private
		 * Storage for the required property.
		 */
		private var _required : Boolean = false;

		/**
		 * Setting the requirement of the item(s).
		 * When it is set to <code>true</code> FormContainer inserts a red asterisk (*) character on the spot that a indicatorLocation has specified. 
		 * For multiple items under one label, you need to specify the same number of required attributes in a FormItem.(e.g.  items:[addressInput_1, addressInput_2], required:[true, false])
		 * If required property is specified, all of the children of the FormItem container are marked as required.
		 * 
		 * @default false
		 */
		public function get required() : Boolean {
			return _required;	
		}

		/**
		 * @private
		 */
		public function set required(value : Boolean) : void {
			_required = value;
			if(required) labelItem.required = true;
			if(required) itemContainer.required = true;
			
			if(this.itemContainer) itemContainer.update_indicatiorLocation(indicatorLocation);
			if(this.labelItem) labelItem.update_indicatiorLocation(indicatorLocation);
		}

		/**
		 * @private
		 *  Storage for the indicatiorLocation property.
		 */
		private var _indicatorLocation : String = FormLayoutStyle.DEFAULT_INDICATOR_LOCATION;

		/**
		 * Setting location of reauirement indicator(~~) when the FormItem is set as required.
		 * Acceptable values for the indicatorLocation: 
		 * <code>FormLayoutStyle.INDICATOR_LABEL_RIGHT</code>(default), <code>FormLayoutStyle.INDICATOR_LEFT</code>,<code>FormLayoutStyle.INDICATOR_RIGHT</code>
		 * 
		 * @default FormLayoutStyle.RIGHT
		 */
		public function get indicatorLocation() : String {
			return _indicatorLocation;	
		}

		/**
		 * @private
		 */
		public function set indicatorLocation(value : String) : void {
			if(_indicatorLocation == value) return;
			_indicatorLocation = value;
			if(itemContainer) itemContainer.update_indicatiorLocation(value);
			if(labelItem) labelItem.update_indicatiorLocation(value);
		}

		
		/**
		 * @private
		 * Storage for the itemAlign property.
		 */
		private var _itemAlign : String = FormLayoutStyle.DEFAULT_ITEM_ALIGN;
		/**
		 * Setting Alignment of multiple items contained in a FormItem.
		 * Acceptable values: <code>FormLayoutStyle.VERTIAL</code>(default), <code>FormLayoutStyle.HORIZONTAL</code>
		 * 
		 * @default FormLayoutStyle.HORIZONTAL
		 */
		public function get itemAlign() : String {
			return _itemAlign;
		}
		/**
		 * @private
		 */
		public function set itemAlign(value : String) : void {
			_itemAlign = value;
			if(this.itemContainer) itemContainer.itemAlign = value;
		}
		/**
		 * @private
		 * Storage for the itemVerticalGap property.
		 */
		private var _itemVerticalGap : Number = FormLayoutStyle.DEFAULT_FORMITEM_VERTICAL_GAP;

		
		/**
		 * The number of pixels in gaps between each items in a formItems verticaly.
		 * 
		 * @default FormLayoutStyle.DEFAULT_FORMITEM_VERTICAL_GAP(6px)
		 */
		public function get itemVerticalGap() : Number {
			return _itemVerticalGap;
		}
		/**
		 * @private
		 */
		public function set itemVerticalGap(value : Number) : void {
			_itemVerticalGap = value;
		}
		/**
		 * @private
		 * Storage for the itemHorizontalGap property.
		 */
		private var _itemHorizontalGap : Number = FormLayoutStyle.DEFAULT_FORMITEM_HORIZONTAL_GAP;

		
		/**
		 * The number of pixels in gaps between each items in a formItems horizontaly.
		 * 
		 * @default FormLayoutStyle.DEFAULT_FORMITEM_HORIZONTAL_GAP(6px)
		 * @see com.yahoo.astra.fl.containers.formClasses.FormLayoutStyle
		 */
		public function get itemHorizontalGap() : Number {
			return _itemHorizontalGap;
		}
		/**
		 * @private
		 */
		public function set itemHorizontalGap(value : Number) : void {
			_itemHorizontalGap = value;
		}
		/**
		 * @private
		 * Storage for the horizontalGap property.
		 */
		private var _horizontalGap : Number = FormLayoutStyle.DEFAULT_HORIZONTAL_GAP;

		/**
		 * The number of pixels in gaps between labels and items.
		 * Default gap is 6(FormLayoutStyle.DEFAULT_HORIZONTAL_GAP).
		 * 
		 * @default FormLayoutStyle.DEFAULT_HORIZONTAL_GAP(6 px)
		 * 
		 * @see com.yahoo.astra.fl.containers.formClasses.FormLayoutStyle
		 */
		public function get horizontalGap() : Number {
			return _horizontalGap;
		}
		/**
		 * @private
		 */
		public function set horizontalGap(value : Number) : void {
			_horizontalGap = value;
		}
		
		/**
		 * @private
		 * Storage for the multipleResult property.
		 */
		private var _hasMultipleItems : Boolean = false;

		
		/**
		 * @private
		 * 
		 * A Boolean value whether <code>FormItem</code> has multiple form inputs to collect data. 
		 * <code>FormContainer</code> sets this value to <code>true</code> when the current <code>FormItem</code> has multiple <code>id</code>s.
		 * <p>No explicit use.</p>
		 * 
		 * 
		 * @deafult false
		 */
		public function get hasMultipleItems() : Boolean {
			return _hasMultipleItems;	
		}

		/**
		 * @private
		 */
		public function set hasMultipleItems(value : Boolean) : void {
			_hasMultipleItems = value;
		}

		/**
		 * @private
		 * Storage for the isHeadLabel property.
		 */
		private var _isFormHeadingLabel : Boolean = false;

		/**
		 * @private
		 * 
		 * A Boolean value whether current <code>FormItem</code> is used as a container for FromHeading.
		 * <code>FormContainer</code> sets this value to <code>true</code> when the current <code>FormItem</code> is FormHeading container.
		 * 
		 */
		public function set isFormHeadingLabel(value : Boolean) : void {
			_isFormHeadingLabel = value;
			if(itemContainer) itemContainer.isFormHeadingLabel = value;
		}

		/**
		 * @private
		 * Storage for the labelTextFormat property.
		 */
		private var _labelTextFormat : TextFormat = FormLayoutStyle.defaultStyles["textFormat"];

		/**
		 * Applies <code>TextFormat</code> to the label than default <code>TextFormat</code>.
		 * 
		 * @default TextFormat("_sans", 11, 0x000000, false, false, false, "", "", TextFormatAlign.LEFT, 0, 0, 0, 0)
		 */
		public function get labelTextFormat() : TextFormat {
			var TxtFormat : TextFormat = _labelTextFormat;
			return TxtFormat;
		}

		/**
		 * @private
		 */
		public function set labelTextFormat(value : TextFormat) : void {
			_labelTextFormat = value;
			if(value is TextFormat && labelItem) {
				labelItem.update(FormLayoutEvent.UPDATE_LABEL_FONT_CHANGE, value);	
			}
		}

		/**
		 * @private
		 * Storage for the instructionTextFormat property.
		 */
		private var _instructionTextFormat : TextFormat;

		/**
		 * Applies <code>TextFormat</code> to the label than default <code>TextFormat</code>.
		 * 
		 * @default TextFormat("_sans", 10, 0x000000, false, false, false, "", "", TextFormatAlign.LEFT, 0, 0, 0, 0)
		 */
		public function get instructionTextFormat() : TextFormat {
			var TxtFormat : TextFormat = (_instructionTextFormat) ? _instructionTextFormat : FormLayoutStyle.defaultStyles["instructionTextFormat"];
			return TxtFormat;
		}

		/**
		 * @private
		 */
		public function set instructionTextFormat(value : TextFormat) : void {
			_instructionTextFormat = value;
			if(itemContainer && formEventObserver) formEventObserver.setUpdate(FormLayoutEvent.UPDATE_INSTRUCTION_FONT_CHANGE, value);
		}

		/**
		 * Chnage the skin of the required indicator. Default is "*" in red(0xff0000). Set any DisplayObject to apply the skin of the indicator.
		 */
		public function set setIndicatorSkin(value : DisplayObject) : void {
			FormLayoutStyle.defaultStyles["indicatorSkin"] = value;
		}

		
		//--------------------------------------
		//  Public Methods
		//--------------------------------------
		
		/**
		 * @private
		 */
		override public function set width(value : Number) : void {
			if(fomItemContainer) fomItemContainer.width = value;
		}

		/**
		 * Set FormEventObserver as an event observer class and register IForm class into it.
		 * Returns <code>IFormEventObserver</code>(the return type of <code>FormEventObserver.subscribeObserver</code>) to force to add IForm instance into formEventObserver's subscription for notifing and updating FormEvents.
		 * 
		 * @example The following code shows a use of <code>subscribeObserver</code>:
		 *  <listing version="3.0">
		 *  public function subscribeObserver(formEventObserver : FormEventObserver) : IFormEventObserver {
		 *		return formEventObserver.subscribeObserver(this);
		 *	}
		 *  </listing>
		 *  
		 * @param formEventObserver <code>FormEventObserver</code> to register.
		 * @return IFormEventObserver Return type of <code>formEventObserver.subscribeObserver(IForm)</code>.
		 * @see com.yahoo.astra.containers.formClasses.FormEventObserver#subscribeObserver
		 */
		public function subscribeObserver(formEventObserver : FormEventObserver ) : IFormEventObserver {
			this.formEventObserver = formEventObserver;
			
			itemContainer.subscribeObserver(formEventObserver);
			labelItem.subscribeObserver(formEventObserver);
			
			return formEventObserver.subscribeObserver(this);
		}

		/**
		 * Update FormLayoutEvents and properties.
		 * <p>
		 * Works like an event lister: passing name of event and its value.
		 * Mainly, it will be tiggered by <code>setUpdate</code> from <code>FormEventObserver</code> class to notify <code>FormLayoutEvent</code>s.
		 * 
		 * @param target String <code>FormLayoutEvent</code> type.
		 * @param value Object contains value associated <code>FormLayoutEvent</code>
		 */
		public function update(target:String , value: Object = null) : void {
				switch(target) {
					case FormLayoutEvent.UPDATE_LABEL_FONT_CHANGE:
						updateTextFields(value as TextFormat);
						break;
					case FormLayoutEvent.UPDATE_HORIZONTAL_GAP:
						formItemLayout.horizontalGap = Number(value);
						break;
					case FormLayoutEvent.UPDATE_LABEL_ALIGN:
						this.labelAlign = String(value);
						break;
					case FormLayoutEvent.UPDATE_ERROR_MSG_TEXT:
						this.showErrorMessageText = true;
						break;
					case FormLayoutEvent.UPDATE_ERROR_MSG_BOX:
						this.showErrorMessageBox = true;
						break;
				}
		}

		
		//--------------------------------------
		//  Private Methods
		//--------------------------------------
		/**
		 * @private
		 */
		private function handler_fomItemContainer_listener(e : LayoutEvent) : void {
			this.dispatchEvent(new LayoutEvent(LayoutEvent.LAYOUT_CHANGE));
		}

		/**
		 * @private
		 */
		private function label_change(e : FormLayoutEvent) : void {
			
			var label : FormItemLabel = e.target as FormItemLabel;
			if(this.labelWidth != label.actualLabelTextWidth) this.labelWidth = label.actualLabelTextWidth;
			this.dispatchEvent(new FormLayoutEvent(FormLayoutEvent.LABEL_ADDED));
		}

		/**
		 * @private
		 */
		private function updateTextFields(textformat : TextFormat) : void {
			var arrLength : int = textfieldArr.length;
			if(arrLength < 1) return;
			for (var i : int = 0;i < arrLength; i++) {
				var textFieldToChg : TextField = textfieldArr[i];
				var str : String = textFieldToChg.text;
				textFieldToChg.defaultTextFormat = textformat;
				textFieldToChg.htmlText = str;
			}
		}

		/**
		 * @private
		 */
		private function updatelabelAlign(value : String) : void {
			switch(value) {
				case FormLayoutStyle.TOP:
					formItemLayout.direction = "vertical";
					break;
					
				case FormLayoutStyle.LEFT:
					formItemLayout.direction = "horizontal";
					break;
					
				case FormLayoutStyle.RIGHT:
					formItemLayout.direction = "horizontal";
					break;		
			}
			
			if(this.labelItem) LayoutManager.update(this.labelItem, "labelAlign", value);
		}
		
		/**
		 * @private
		 */
		private function addTextField(value : String) : TextField {
			var tf : TextField = FormLayoutStyle.defaultTextField;
			tf.defaultTextFormat = FormLayoutStyle.defaultStyles["textFormat"];
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.htmlText = value;
			return tf;
		}
		private function addLabel( txt : String = "") : FormItemLabel {
			var labelItem : FormItemLabel = new FormItemLabel();
			labelItem.addEventListener(FormLayoutEvent.LABEL_ADDED, label_change, false, 0, true);
			labelItem.attLabel(txt);
			return labelItem;
		}
		/**
		 * @private
		 */
		private function handler_validation_passed(e : FormDataManagerEvent = null) : void {
			gotResultBool &&= true;
			if(!gotResultBool && hasMultipleItems) return;
			if(showErrorMessageText && itemContainer.instructionTextField) instructionText = "";
			if(errorGrayBox && showErrorMessageBox) errorGrayBox.visible = false;
		}
		/**
		 * @private
		 */
		private function handler_validation_failed(e : FormDataManagerEvent = null) : void {
			gotResultBool = false;
			if(showErrorMessageText) instructionText = e.errorMsg ? e.errorMsg.toString() : this.errorString;
			if(!showErrorMessageBox) return;
			if(!errorGrayBox) {
				errorGrayBox = Sprite(this.addChildAt(new Sprite(), 0));
				// if FormItem is nested by FormContainer, w will be width of FormContainer
				var w : Number = (this.parent.parent.parent is IForm) ? this.parent.parent.parent.width : fomItemContainer.width;
				var h : Number = (itemVerticalGap) ? itemVerticalGap : FormLayoutStyle.DEFAULT_FORMITEM_VERTICAL_GAP;
				doDrawRect(errorGrayBox, 0, -h / 2, w, fomItemContainer.height + h, FormLayoutStyle.ERR_BOX_COLOR, FormLayoutStyle.ERR_BOX_ALPHA);
			}
			errorGrayBox.visible = true;
		}
		
		/**
		 * @private
		 */
		private function addLiestners() : void {
			this.addEventListener(FormDataManagerEvent.VALIDATION_PASSED, handler_validation_passed, false, 0, true);
			this.addEventListener(FormDataManagerEvent.VALIDATION_FAILED, handler_validation_failed, false, 0, true);
		}

		/**
		 * @private
		 */
		private function removeLiestners() : void {
			this.removeEventListener(FormDataManagerEvent.VALIDATION_PASSED, handler_validation_passed);
			this.removeEventListener(FormDataManagerEvent.VALIDATION_FAILED, handler_validation_failed);
		}

		/**
		 * @private
		 */
		private function doDrawRect(sprite : Sprite,x : Number, y : Number, w : Number, h : Number, clr : uint = 0xffffff, alpha : Number = 0) : Sprite {
			sprite.graphics.beginFill(clr, alpha);
			sprite.graphics.drawRect(x, y, w, h);
			sprite.graphics.endFill();
			return sprite;
		}
	}
}

