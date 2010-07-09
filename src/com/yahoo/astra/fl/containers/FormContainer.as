package com.yahoo.astra.fl.containers {
	import fl.core.UIComponent;

	import com.yahoo.astra.containers.formClasses.FormEventObserver;
	import com.yahoo.astra.containers.formClasses.FormItem;
	import com.yahoo.astra.containers.formClasses.FormItemContainer;
	import com.yahoo.astra.containers.formClasses.FormLayoutStyle;
	import com.yahoo.astra.containers.formClasses.IForm;
	import com.yahoo.astra.containers.formClasses.IFormEventObserver;
	import com.yahoo.astra.events.FormLayoutEvent;
	import com.yahoo.astra.fl.containers.BoxPane;
	import com.yahoo.astra.fl.containers.layoutClasses.BaseLayoutPane;
	import com.yahoo.astra.layout.LayoutContainer;
	import com.yahoo.astra.layout.LayoutManager;
	import com.yahoo.astra.layout.events.LayoutEvent;
	import com.yahoo.astra.layout.modes.BoxLayout;
	import com.yahoo.astra.managers.FormDataManager;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;	

	/**
	 * 
	 *	The FormContainer is a layout element containing multiple component items arranged vertically along with the definition for each item. 
	 *	Similar to the Flex Form container, it is mainly used with nested FormItems which are containers defined by a label and one or more children arranged horizontally or vertically. 
	 *	It also lets you set styles to configure the appearance of your forms.
	 *	
	 * @example The following code shows a use of <code>FormContainer</code>:
	 *  <listing version="3.0">
	 *  
	 *		import com.adobe.as3Validators.as3DataValidation;
	 *		import com.yahoo.astra.containers.formClasses.FormLayoutStyle;
	 *		import com.yahoo.astra.fl.containers.FormContainer;
	 *		import com.yahoo.astra.fl.utils.FlValueParser;
	 *		import com.yahoo.astra.managers.FormDataManager;
	 *		
	 *		var myFormContainer = new FormContainer("Contact Us");
	 *		// additional parameters for FormContainer
	 *		myFormContainer.autoSize = true;
	 *		myFormContainer.subFormHeading(asteriskMC, " is required field.");
	 *		myFormContainer.indicatorLocation = FormLayoutStyle.INDICATOR_LEFT;
	 *		myFormContainer.labelAlign = FormLayoutStyle.TOP;
	 *		myFormContainer.setStyle("skin", "FormSkin");
	 *		myFormContainer.verticalGap = 15;
	 *		myFormContainer.itemVerticalGap = 15;
	 *		myFormContainer.showErrorMessageBox = true;
	 *		
	 *		// sets data manager with value parser for UIcompoenets.
	 *		formDataManager = new FormDataManager(FlValueParser); 
	 *		// add trigger on a DisplayObject, and define event handlers for validation success and fail.
	 *		formDataManager.addTrigger(submitButton, handler_success, handler_fail);
	 *		
	 *		// define formDataManager in FormContainer before set dataProvider.
	 *		myFormContainer.formDataManager = formDataManager;  
	 *		
	 *		// initiate validation class you want to use.
	 *		// in this example, we using <a href="http://code.google.com/p/flash-validators/">as3DataValidation</a> from Adobe.
	 *		var validator : as3DataValidation = new as3DataValidation();
	 *		
	 *		var myFormDataArr : Array = [{label:"Name", items:nameInput, id:"name", source:nameInput},
	 *			{label:"Email", items:emailInput, id:"email", source:emailInput, required:true, validator:validator.isEmail},
	 *			{label:"Message", items:commentInput, required:true, id:"message", source:commentInput, validator:validator.isNotEmpty},
	 *			{label:"", items:submitButton}];
	 *		// define dataProvider with data array.	
	 *		myFormContainer.dataProvider = myFormDataArr;
	 *		
	 *		this.addChild(myFormContainer);  
	 *		
	 *	</listing>
	 *	
	 *	
	 * @author kayoh
	 */

	
	public class FormContainer extends BoxPane implements IForm {
		 

		//--------------------------------------
		//  Constructor
		//--------------------------------------
	
		/**
		 * Constructor.
		 * 
		 * @param formHeadingString		String for optional text field of <code>"FormHeading"</code>.
		 */

		public function FormContainer(formHeadingString : String = null) {
			super();
			this.visible = false;
			this.addEventListener(Event.ENTER_FRAME, handler_enterFrame, false, 0, true);
			formItemArr = [];
			formEventObserver = new FormEventObserver();
	
			boxLayoutMode = new BoxLayout();
			boxLayoutMode.horizontalGap = horizontalGap;
			boxLayoutMode.verticalGap = verticalGap;
			boxLayoutMode.direction = FormLayoutStyle.VERTICAL;
			
			mainLayoutContainer = new LayoutContainer(boxLayoutMode);
			mainLayoutContainer.autoMask = false;
			this.addChild(mainLayoutContainer);
			subscribeObserver(formEventObserver);
				
			if(formHeadingString && !headFormItem) attachFormHeadingLabel(formHeadingString);
		}

		//--------------------------------------
		//  Properties
		//--------------------------------------
		/**
		 * @private
		 */
		private var temp_adjusting_height : Number;
		/**
		 * @private
		 */
		private var mainLayoutContainer : LayoutContainer = null;
		/**
		 * @private
		 */
		private var formItemArr : Array = [];
		/**
		 * @private
		 */	
		private var gotRequiredField : Boolean = false;
		/**
		 * @private
		 */
		private var headingLabelField : TextField = null;
		/**
		 * @private
		 */
		private var boxLayoutMode : BoxLayout = null;
		/**
		 * @private
		 */
		private var subHeadLineTxtFieldArray : Array = [];
		/**
		 * @private
		 */
		private var longestlabelWidth : Number = NaN;
		/**
		 * @private
		 */
		private var preferredheadLabelTextFormat : TextFormat = null;
		/**
		 * @private
		 */
		private var preferredLabelTextFormat : TextFormat = null;
		/**
		 * @private
		 */
		private var preferredInstructionTextFormat : TextFormat = null;
		/**
		 * @private
		 */
		private var dataManager : FormDataManager = null;
		/**
		 * @private
		 */
		private var headFormItem : FormItem = null;
		/**
		 * @private
		 */
		private var loopCatcher : int = 0;
		/**
		 * @private
		 */
		private var formEventObserver : FormEventObserver = null;

		/**
		 * Setting dataManager for FormContainer to collect and validate data.
		 * 
		 * @example The following code shows a use of <code>formDataManager</code>:
		 *  <listing version="3.0">
		 *  
		 *  import com.yahoo.astra.managers.FormDataManager;
		 *  import com.yahoo.astra.fl.utils.FlValueParser;
		 *  
		 *  formDataManager = new FormDataManager(FlValueParser); 
		 *  formDataManager.addTrigger(submitButton, handler_success, handler_fail);
		 *  
		 *	myFormContainer.formDataManager = formDataManager;  
		 *  </listing>
		 * 
		 * @see com.yahoo.astra.managers.FormDataManager
		 */
		public function set formDataManager(value : FormDataManager) : void {
			dataManager = value;
		}

		/**
		 * @private 
		 * Storage for the dataProvider property.
		 */
		private var _dataObject : Object = null;

		/**
		 * Gets or sets the data to be shown and validated in <code>FormContainer</code>. 
		 * 
		 * <p><strong>Property Options:</strong></p>
		 * <dl>
		 * 	<dt><strong><code>label</code></strong> : String</dt>
		 * 		<dd>The String for label text field.(e.g. lable:"State")</dd>
		 * 	<dt><strong><code>items</code></strong> : Object or String(or Object or String Array)</dt>
		 * 		<dd>The DisplayObject to be contained  and to be shown in a FormItem. String value will be attached as a textfield object.If there is multiple items, nest them into an array.(e.g.items:[stateComboBox,"Zip Code",zipcodeInput])</dd>
		 * 	<dt><strong><code>itemAlign</code></strong> : String</dt>
		 * 		<dd>The alignment of multiple items in a FormItem. The default alignment is "horizontal"(<code>FormLayoutStyle.HORIZONTAL</code>)(e.g. itemAlign:FormLayoutStyle.VERTICAL)</dd>
		 * 	<dt><strong><code>instructionText</code></strong> : String</dt>
		 * 		<dd>The String for additional label text field bottom of the item(s).(e.g. instructionText:"we'll not spam you!")</dd>
		 * 	<dt><strong><code>id</code></strong> : String(or String Array)</dt>
		 * 		<dd>The property of collected data.(e.g. id:"zip"  will be saved in FormDataManager as <code>FormDataManager.collectedData</code>["zip"] = "94089")</dd>
		 * 	<dt><strong><code>source</code></strong> : Object(or Object Array)</dt>
		 * 		<dd>The actual input source contains user input data.(e.g. source:[stateComboBox, zipcodeInput])</dd>
		 * 	<dt><strong><code>property</code></strong> : Object(or Object Array)</dt>
		 * 		<dd>The additional property of <code>source</code>. If you defined <code>valuePaser</code> of FormDataManager as <code>FlValueParser</code>, don't need to set this property in general(e.g. source:[comboBox, textInput] , property:["abbreviation","text"]</dd>
		 * 	<dt><strong><code>validator</code></strong> : Function(or Function Array)</dt>
		 * 		<dd>The Function to validate the <code>source</code>.(e.g.  validator:validator.isZip)</dd>
		 * 	<dt><strong><code>required</code></strong> : Boolean(or Boolean Array)</dt>
		 * 		<dd>The Boolean to decide to show required filed indicator(~~) and apply validation(<code>validator</code>).(e.g. id:["stateComboBox", "zipcodeInput"], required:[false, true]) </dd>
		 *  <dt><strong><code>errorString</code></strong> : String</dt>
		 * 		<dd>The String to show under the item(s) fail to validation when <code>showErrorMessageText</code> is set <code>true</code>. If there is existing <code>instructionText</code>, will be replaced by <code>errorString</code>.(e.g. errorString:"What kind of zipcode is that?.")</dd>
		 * </dl>
		 * 
		 * @example The following code shows a use of <code>dataProvider</code>:
		 *  <listing version="3.0">
		 *  // Init validator to be used.
		 *  import com.adobe.as3Validators.as3DataValidation;
		 *	var validator : as3DataValidation = new as3DataValidation();
		 *	
		 * 	var myFormDataArr : Array = [
		 * 	{label:"Name", items:nameInput, id:"name", source:nameInput},
		 * 	{label:"Address", items:[addressInput_line_1,addressInput_line_2 ], id:["address_line_1", "address_line_2"], source:[addressInput_line_1,addressInput_line_2]},
		 *	{label:"Email", items:emailInput, id:"email", instructionText :"we'll not spam you!", source:emailInput, required:true, validator:validator.isEmail},
		 *	{label:"", items:submitButton}];
		 *	
		 *	myFormContainer.dataProvider = new DataProvider(myFormDataArr);
		 * </listing>
		 * 
		 * @default null
		 */
		public function get dataProvider() : Object {
			return this._dataObject;
		}

		/**
		 * @private
		 */
		public function set dataProvider(value : Object) : void {
			this._dataObject = value;
			buildFromDataProvider();
		}

		
		/**
		 * Setting string for optional text field on top of the formContainer.
		 * @param string Text to be shown in the FormHeading text field.
		 */
		public function set formHeading(string : String) : void {
			if(!string) return;
			if(!headFormItem) attachFormHeadingLabel(string);
			headingLabelField.htmlText = string;
		}

		/**
		 * @private
		 * Storage for the showErrorMessageText property.
		 */
		private var _showErrorMessageText : Boolean = false;

		/**
		 * @copy com.yahoo.astra.containers.formClasses.FormItem#showErrorMessageText
		 * 
		 * @default false
		 */
		public function get showErrorMessageText() : Boolean {
			return _showErrorMessageText;
		}

		/**
		 * @private
		 */
		public function set showErrorMessageText(value : Boolean) : void {
			_showErrorMessageText = value;
		}

		/**
		 * @private
		 * Storage for the showErrorMessageBox property.
		 */
		private var _showErrorMessageBox : Boolean = false;

		/**
		 * @copy com.yahoo.astra.containers.formClasses.FormItem#showErrorMessageBox
		 * 
		 * @default false
		 */
		public function get showErrorMessageBox() : Boolean {
			return _showErrorMessageBox;
		}

		/**
		 * @private
		 * Storage for the showErrorMessageBox property.
		 */
		public function set showErrorMessageBox(value : Boolean) : void {
			_showErrorMessageBox = value;
		}

		/**
		 * @private
		 * Storage for the labelWidth property.
		 */
		private var _labelWidth : Number = NaN;

		/**
		 * @copy com.yahoo.astra.containers.formClasses.FormItem#labelWidth
		 * 
		 * @default NaN;
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
			if(headFormItem) {
				if(headFormItem.labelItem)	LayoutManager.update(headFormItem.labelItem, "preferredWidth", labelWidth);
			}
		}

		/**
		 * @private
		 * Storage for the itemVerticalGap property.
		 */
		private var _itemVerticalGap : Number = FormLayoutStyle.DEFAULT_FORMITEM_VERTICAL_GAP;

		/**
		 * @copy com.yahoo.astra.containers.formClasses.FormItem#itemVerticalGap
		 * 
		 * @default FormLayoutStyle.DEFAULT_FORMITEM_VERTICAL_GAP(6 px)
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
		 * @copy com.yahoo.astra.containers.formClasses.FormItem#itemHorizontalGap 
		 * 
		 * @default FormLayoutStyle.DEFAULT_FORMITEM_HORIZONTAL_GAP(6 px)
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
		 * @copy com.yahoo.astra.containers.formClasses.FormItem#horizontalGap 
		 * 
		 *  @default FormLayoutStyle.DEFAULT_HORIZONTAL_GAP(6 px)
		 */
		override public function get horizontalGap() : Number {
			return _horizontalGap;
		}

		/**
		 * @private
		 */
		override public function set horizontalGap(value : Number) : void {
			_horizontalGap = value;
		}

		/**
		 * @private
		 * Storage for the verticalGap property.
		 */
		private var _verticalGap : Number = FormLayoutStyle.DEFAULT_VERTICAL_GAP;

		/**
		 * The number of pixels in gaps between FormItems.
		 * 
		 * @param value Number of pixels.
		 * @default FormLayoutStyle.DEFAULT_VERTICAL_GAP(6 px)
		 */
		override public function get verticalGap() : Number {
			return _verticalGap;
		}

		/**
		 * @private
		 */
		override public function set verticalGap(value : Number) : void {
			boxLayoutMode.verticalGap = super.verticalGap = _verticalGap = value;
		}

		/**
		 * @private
		 * Storage for the indicatorLocation property.
		 */
		private var _indicatorLocation : String = FormLayoutStyle.DEFAULT_INDICATOR_LOCATION; 

		/**
		 *  @copy com.yahoo.astra.containers.formClasses.FormItem#indicatorLocation 
		 *  
		 *  @default FormLayoutStyle.INDICATOR_LABEL_RIGHT
		 */
		public function get indicatorLocation() : String {
			return _indicatorLocation;
		}

		/**
		 * @private
		 */
		public function set indicatorLocation(value : String) : void {
			_indicatorLocation = value;
		}

		/**
		 * @private
		 * Storage for the labelAlign property.
		 */
		private var _labelAlign : String = FormLayoutStyle.DEFAULT_LABELALIGN;

		/**
		 * @copy com.yahoo.astra.containers.formClasses.FormItem#labelAlign 
		 * 
		 * @default FormLayoutStyle.RIGHT
		 */
		public function get labelAlign() : String {
			return _labelAlign;
		}

		/**
		 * @private
		 */
		public function set labelAlign(value : String) : void {
			_labelAlign = value;
		}

		//--------------------------------------
		//  Public Methods
		//--------------------------------------
		/**
		 * Adds DisplayObject into FormContainer. If data is provied by DataProvider, <code>addItem</code> will not be used explicitly.
		 * If <code>child</code> is not a <code>FormItem</code> instance, it will be aligned to left edge of <code>FormContainer</code>.
		 * 
		 * @param child DisplayObject to be contained.
		 * @param required Optional parameter determines the requirement of the form.
		 */
		public function addItem(child : DisplayObject, required : Boolean = false) : void {
			if(child is FormItem) {
				var formItem : FormItem = child as FormItem;
			
				formItem = child as FormItem;
				formItem.subscribeObserver(formEventObserver);
				
				if(preferredLabelTextFormat) {
					notifyObserver(FormLayoutEvent.UPDATE_LABEL_FONT_CHANGE, preferredLabelTextFormat);	
				}
				if(preferredInstructionTextFormat) {
					notifyObserver(FormLayoutEvent.UPDATE_INSTRUCTION_FONT_CHANGE, preferredInstructionTextFormat);	
				}
				if(isNaN(labelWidth)) {
					
					if(!isNaN(formItem.labelWidth)) findLongestLabelWidth(formItem.labelWidth);
					
					if(longestlabelWidth > 0) {
						notifyObserver(FormLayoutEvent.UPDATE_LABEL_WIDTH, longestlabelWidth);
					}
					
					formItem.addEventListener(FormLayoutEvent.LABEL_ADDED, handler_formItemLabelAdded, false, 0, true);
				} else {
					notifyObserver(FormLayoutEvent.UPDATE_LABEL_WIDTH, labelWidth);
				}
				
				if(required) {
					formItem.required = true;	
					gotRequiredField = true;
				}

				if(gotRequiredField)  notifyObserver(FormLayoutEvent.UPDATE_GOT_REQUIRED_ITEM, gotRequiredField);
				if(showErrorMessageText)  notifyObserver(FormLayoutEvent.UPDATE_ERROR_MSG_TEXT, showErrorMessageText);
				if(showErrorMessageBox)  notifyObserver(FormLayoutEvent.UPDATE_ERROR_MSG_BOX, showErrorMessageBox);
				
				if(horizontalGap != FormLayoutStyle.DEFAULT_HORIZONTAL_GAP) {
					notifyObserver(FormLayoutEvent.UPDATE_HORIZONTAL_GAP, horizontalGap);
				}
				if(itemVerticalGap != FormLayoutStyle.DEFAULT_FORMITEM_VERTICAL_GAP) notifyObserver(FormLayoutEvent.UPDATE_ITEM_VERTICAL_GAP, itemVerticalGap);
				if(itemHorizontalGap != FormLayoutStyle.DEFAULT_FORMITEM_HORIZONTAL_GAP)  notifyObserver(FormLayoutEvent.UPDATE_ITEM_HORIZONTAL_GAP, itemHorizontalGap);
				if(gotRequiredField && indicatorLocation)  notifyObserver(FormLayoutEvent.UPDATE_INDICATOR_LOCATION, indicatorLocation);
				if(labelAlign != FormLayoutStyle.DEFAULT_LABELALIGN)  notifyObserver(FormLayoutEvent.UPDATE_LABEL_ALIGN, labelAlign);
				
				
				formItem.addEventListener(LayoutEvent.LAYOUT_CHANGE, handler_formItemLayoutChg, false, 0, true);
								
				mainLayoutContainer.addChild(formItem);
			} else {
				var container : FormItemContainer = new FormItemContainer();
				container.addItem(child);
				mainLayoutContainer.addChild(container);	
			}
		}

		/**
		 * Setting additional items under the FormHeading field.
		 * 
		 *  @example The following code shows a use of <code>subFormHeading</code>:
		 *  <listing version="3.0">
		 *  var myFormContainer = new FromContainer();
		 * 	var asteriskMC : MovieClip = new indicatorSkin();
		 *	myFormContainer.subFormHeading(asteriskMC, "is required field.");
		 * 	</listing>
		 * 	
		 * @param args Elements to be contained in subFormHeading field. Any String or DisplayObjects will be accepted.
		 */
		public function subFormHeading(...args) : void {
			if(args.length < 1) return;
			if(!headFormItem) attachFormHeadingLabel("");
			var boxLayout : BoxLayout = new BoxLayout();
			boxLayout.direction = FormLayoutStyle.HORIZONTAL;
		
			var subHeadLabel : LayoutContainer = new LayoutContainer(boxLayout);
			subHeadLineTxtFieldArray = [];
			for (var i : int = 0;i < args.length; i++) {
				var obj : * = args[i];
				if(obj is String) {
					var subHeadLineTxtField : TextField = FormLayoutStyle.instructionTextField;
					if(preferredInstructionTextFormat) {
						subHeadLineTxtField.setTextFormat(preferredInstructionTextFormat);
					}
					
					subHeadLineTxtField.htmlText = obj.toString();	
					subHeadLabel.addChild(subHeadLineTxtField);
					subHeadLineTxtFieldArray.push(subHeadLineTxtField);
				} else {
					subHeadLabel.addChild(obj);
				}
			}
			headFormItem.itemContainer.addItem(subHeadLabel);
		}

		/**
		 * Sets a style property on this component instance. This style may 
		 * override a style that was set globally.
		 *
		 * <p>See the default style from <code>FormLayoutStyle</code>.</p>
		 *
		 * <p>Calling this method can result in decreased performance. 
		 * Use it only when necessary.</p>
		 * 
		 * 	  <p><strong>Additional Styles for FormContainer:</strong></p>
		 * <dl>
		 * 	<dt><strong><code>skin</code></strong> : Object</dt>
		 * 		<dd>The skin of FormContainer. Default is none.</code>)</dd>
		 * 	<dt><strong><code>indicatorSkin</code></strong> : DisplayObjectContainer</dt>
		 * 		<dd>The skin of required field indicator's skin. Default is "indicatorSkin" of component skins.</dd>
		 * 	<dt><strong><code>textFormat</code></strong> : TextFormat</dt>
		 * 		<dd>The text format of all the labels in the <code>FormContainer</code>. Default is : "_sans", 11, 0x000000.</dd>
		 * 	<dt><strong><code>instructionTextFormat</code></strong> : TextFormat</dt>
		 * 		<dd>The text format of all the <code>instructionText</code> fields in the <code>FormContainer</code>. Default is : "_sans", 10, 0x000000.</dd>
		 * 	<dt><strong><code>headTextFormat</code></strong> : TextFormat</dt>
		 * 		<dd>The text format of <code>formHeading</code> field in the <code>FormContainer</code>. Default is : "_sans", 11, 0x000000, bold.</dd>
		 * 	</dl>
		 *  
		 * @example The following code shows a use of <code>setStyle</code>:
		 *  <listing version="3.0">
		 *  var myFormContainer = new FormContainer();
		 *  myFormContainer.setStyle("indicatorSkin", "myCustomIndicatorSkinMC");  
		 *  myFormContainer.setStyle("textFormat",  new TextFormat("Times", 13, 0xFF0000));
		 *  </listing>
		 * 
		 * 
		 *  @param style The name of the style property.
		 *
		 *  @param value The value of the style. 
		 *  
		 *  @see com.yahoo.astra.containers.formClasses.FormLayoutStyle
		 */
		override public function setStyle(style : String, value : Object) : void {
			if(value && style == "textFormat") {
				longestlabelWidth = 0;
				preferredLabelTextFormat = value as TextFormat;
				return;
			}
			if(value && style == "instructionTextFormat") {
				preferredInstructionTextFormat = value as TextFormat;
				if(subHeadLineTxtFieldArray) {
					var subHeadLineTxtFieldArrayLeng : int = subHeadLineTxtFieldArray.length;
					for (var i : int = 0;i < subHeadLineTxtFieldArrayLeng; i++) {
						var subTextField : TextField = subHeadLineTxtFieldArray[i];
						subTextField.setTextFormat(preferredInstructionTextFormat);
					}
				}
				return;
			}
			if(value && style == "headTextFormat") {
				preferredheadLabelTextFormat = value as TextFormat;
				if(headingLabelField) {
					headingLabelField.defaultTextFormat = preferredheadLabelTextFormat;
					this.formHeading = headingLabelField.text;
				}
				return;
			}
			if(value && style == "indicatorSkin") {
				FormLayoutStyle.defaultStyles["indicatorSkin"] = value;
			}
			super.setStyle(style, value);
		}

		/**
		 * @private 
		 *  @see com.yahoo.astra.fl.containers.formClasses.FormItem#subscribeObserver 
		 */
		public function subscribeObserver(formEventObserver : FormEventObserver) : IFormEventObserver {
			return formEventObserver.subscribeObserver(this);
		}

		
		/**
		 * @private
		 * @see com.yahoo.astra.fl.containers.formClasses.FormItem#update 
		 */
		public function update(target : String,value : Object = null) : void {
			/*
			 * have no event to update in this class.
			 */
		}

		//--------------------------------------
		//  Private Methods
		//--------------------------------------
		/**
		 * @private
		 */
		override protected function drawLayout() : void {
		
			if(!this.autoSize) {
				if(mainLayoutContainer.width > 150 && mainLayoutContainer.width < this.width - this.verticalScrollBar.width) {
					LayoutManager.resize(mainLayoutContainer, this.width - this.verticalScrollBar.width, mainLayoutContainer.height);
				}
			}
			super.drawLayout();
		}

		/**
		 * @private
		 */
		private function notifyObserver(target : String, value : Object = null) : void {
			if(!formEventObserver) return;
			formEventObserver.setUpdate(target, value);
		}

		/**
		 * @private
		 */

		private function handler_enterFrame(e : Event) : void {
			if(this.height == temp_adjusting_height || loopCatcher > 30) {
				this.removeEventListener(Event.ENTER_FRAME, handler_enterFrame);	
				this.visible = true;
				loopCatcher = 0;
			}
			
			temp_adjusting_height = this.height;
			loopCatcher++;
		}

		
		/**
		 * @private
		 */	
		private function attachFormHeadingLabel(value : String) : void {
			headingLabelField = FormLayoutStyle.headTextField;
			if(preferredheadLabelTextFormat) headingLabelField.defaultTextFormat = preferredheadLabelTextFormat;
			headingLabelField.htmlText = value;
			headFormItem = new FormItem(headingLabelField);
			headFormItem.isFormHeadingLabel = true;
			headFormItem.itemAlign = FormLayoutStyle.VERTICAL;
			this.addItem(headFormItem, false);
		}

		/**
		 * @private
		 */
		private function handler_formItemLayoutChg(e : LayoutEvent = null) : void {
			mainLayoutContainer.invalidateLayout();
		}

		/**
		 * @private
		 */
		private function handler_formItemLabelAdded(e : FormLayoutEvent) : void {
			var formItem : FormItem = e.target as FormItem;
			findLongestLabelWidth(formItem.labelWidth);
		}

		/**
		 * @private
		 */
		private function findLongestLabelWidth(labelWidth : Number = 0) : void {
			if(isNaN(longestlabelWidth)) longestlabelWidth = 0;
			if(labelWidth > longestlabelWidth) {
				longestlabelWidth = labelWidth;
				notifyObserver(FormLayoutEvent.UPDATE_LABEL_WIDTH, longestlabelWidth);
			}
		}

		/**
		 * @private
		 */
		private function buildFromDataProvider() : void {
			var dataLength : int = dataProvider.length;
			
			for (var i : int = 0;i < dataLength; i++) {
				var curData : Object = dataProvider[i];
				if(curData["label"] == undefined ) {
					/*
					 * Item with no Label.
					 */
					var itemContainer : FormItemContainer = new FormItemContainer();
					if (curData["itemAlign"]) itemContainer.itemAlign = curData["itemAlign"];
					if(curData["items"] is Array) {
						var curItemDataLength : int = curData["items"].length;
						for (var j : int = 0;j < curItemDataLength; j++) {
							itemContainer.addItem(curData["items"][j]);
						}
					} else {
						itemContainer.addItem(curData["items"]);
					}
					this.addItem(itemContainer, curRequired);
				} else {
					var curLabel : String = (curData["label"]) ? curData["label"] : "";
					var curItmes : Object = (curData["items"]) ? curData["items"] : [];
					var curRequired : Boolean = false;
					if(curData["required"] is Array) {
						var reqLeng : int = curData["required"].length;
						for (var k : int = 0;k < reqLeng; k++) {
							var temp : Boolean = Boolean(curData["required"][k] as Boolean);
							curRequired ||= temp;
						}
					} else if(curData["required"] is String) {
						curRequired = (curData["required"] == "true") ? true : false;	
					} else {
						curRequired = (curData["required"]) ? curData["required"] : false;	
					}
					var curFormItem : FormItem = new FormItem(curLabel, curItmes);
					if (curData["width"]) curFormItem.width = Number(curData["width"]);
					if (curData["errorString"]) curFormItem.errorString = curData["errorString"];
					if (curData["itemAlign"]) curFormItem.itemAlign = curData["itemAlign"];
					if (curData["instructionText"]) curFormItem.instructionText = curData["instructionText"];
					this.addItem(curFormItem, curRequired);
				}
				if(!dataManager) continue;
				
				if(curData["id"] is Array) {
					var curIdDataLength : int = curData["id"].length;
					for (var l : int = 0;l < curIdDataLength; l++) {
						var curSource : Object = (curData["source"] is Array) ? curData["source"][l] : null;
						var curProperty : Object = (curData["property"] is Array) ? curData["property"][l] : null;
						var curValidator : Function = (curData["validator"] is Array) ? curData["validator"][l] : null;
						var curRequiredArr : Boolean = (curData["required"] is Array) ? curData["required"][l] : false;
						var curTargetObj : DisplayObject = (curData["targetObj"] is Array) ? curData["targetObj"][l] as DisplayObject: curFormItem;
						var curEventFunction_success : Function = (curData["eventFunction_success"] is Array) ? curData["eventFunction_success"][l] as Function: null;
						var curEventFunction_fail : Function = (curData["eventFunction_fail"] is Array) ? curData["eventFunction_fail"][l] as Function: null;
						if(curFormItem) curFormItem.hasMultipleItems = true;
						dataManager.addItem( curData["id"][l], curSource, curProperty, curValidator, curRequiredArr, curTargetObj, curEventFunction_success, curEventFunction_fail);	
					}
				} else {
					if(curData["id"] || curData["source"] ) if(!(curData["id"] && curData["source"])) throw new Error("id and source are needed.");
					dataManager.addItem( curData["id"], curData["source"], curData["property"], curData["validator"], curRequired, (curData["targetObj"] is DisplayObject)? curData["targetObj"]:curFormItem, curData["eventFunction_success"], curData["eventFunction_fail"]);	
				}
			}
		}
	}
}

