package com.yahoo.astra.containers.formClasses {
	import com.yahoo.astra.containers.formClasses.RequiredIndicator;
	import com.yahoo.astra.containers.formClasses.FormLayoutStyle;
	import com.yahoo.astra.containers.formClasses.IForm;
	import com.yahoo.astra.events.FormLayoutEvent;
	import com.yahoo.astra.layout.LayoutContainer;
	import com.yahoo.astra.layout.LayoutManager;
	import com.yahoo.astra.layout.modes.BoxLayout;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;	

	/**
	 * LayoutContainer to contain and align form inputs and handling required fields. No explicit use is intended.
	 * 
	 * @author kayoh
	 */
	public class FormItemContainer extends LayoutContainer  implements IForm {
		//--------------------------------------
		//  Constructor
		//--------------------------------------
	
		/**
		 * Constructor.
		 * A container arranges formItems and attaches required field indicators. 
		 */
		public function FormItemContainer() {
			itemContainerLayout = new BoxLayout();
			itemContainerLayout.direction = FormLayoutStyle.HORIZONTAL;
			super(itemContainerLayout);
			init();
		}

		private var formEventObserver : FormEventObserver = null;

		
		//--------------------------------------
		//  Properties
		//--------------------------------------
		/**
		 * @private
		 */
		internal var reqBox_l : RequiredIndicator = null;
		/**
		 * @private
		 */
		internal var reqBox_r : RequiredIndicator = null;
		/**
		 * @private
		 */
		internal var gotRequiredField : Boolean = false;
		/**
		 * @private
		 */
		internal var instructionTextField : TextField = null;
		/**
		 * @private
		 */
		internal var subItemContainer : LayoutContainer = null;
		/**
		 * @private
		 */
		private var itemContainerLayout : BoxLayout = null;
		/**
		 * @private
		 */
		private var itemLayoutMode : BoxLayout = null;
		/**
		 * @private
		 */
		private var preferredInstrunctionTextformat : TextFormat;
		/**
		 * @private
		 */
		private var itemOutterContainer : LayoutContainer = null;
		/**
		 * @private
		 */
		private var ItemOutterLayoutMode : BoxLayout = null;
		/**
		 * @private
		 */
		private var tempHeight : Number = NaN;
		/**
		 * @private
		 */
		private var loopCatcher : int = 0;
		/**
		 * @private
		 */
		private var _isformHeadingLabel : Boolean = false;
		/**
		 * Setting whether this ItemContainer is assigned for FormHeading or not.
		 * @private
		 */
		internal function get isFormHeadingLabel() : Boolean {
			return _isformHeadingLabel;
		}
		/**
		 * @private
		 */
		internal function set isFormHeadingLabel(value : Boolean) : void {
			if(_isformHeadingLabel == value) return;
			_isformHeadingLabel = value;
		}
		/**
		 * @private
		 */
		private var _itemAlign : String = FormLayoutStyle.DEFAULT_ITEM_ALIGN;
		/**
		 * @copy com.yahoo.astra.containers.formClasses.FormItem#itemAlign
		 */
		public function get itemAlign() : String {
			return _itemAlign;
		}

		/**
		 * @private
		 */
		public function set itemAlign(value : String) : void {
			if(_itemAlign == value) return;
			itemLayoutMode.direction = _itemAlign = value;
		}
		/**
		 * @private
		 */
		private var _itemVerticalGap : Number = FormLayoutStyle.DEFAULT_FORMITEM_VERTICAL_GAP ;

		/**
		 * @private
		 */
		internal function get itemVerticalGap() : Number {
			return _itemVerticalGap;
		}

		/**
		 * @private
		 */
		internal function set itemVerticalGap(value : Number) : void {
			_itemVerticalGap = value;
		}

		/**
		 * @private
		 */
		private var _itemHorizontalGap : Number = FormLayoutStyle.DEFAULT_FORMITEM_HORIZONTAL_GAP;

		/**
		 * @copy com.yahoo.astra.fl.containers.FormClasses.FormItem#itemHorizontalGap
		 */
		internal function get itemHorizontalGap() : Number {
			return _itemHorizontalGap;
		}

		/**
		 * @private
		 */
		internal function set itemHorizontalGap(value : Number) : void {
			_itemHorizontalGap = value;
		}

		/**
		 * @private
		 */		
		internal var _labelAlign : String = FormLayoutStyle.DEFAULT_LABELALIGN;

		/**
		 * @private
		 */
		internal function get labelAlign() : String {
			return _labelAlign;	
		}

		/**
		 * @private
		 */
		internal function set labelAlign(value : String) : void {
			if(_labelAlign == value) return;
			
			_labelAlign = value;
		}

		/**
		 * @private
		 */		
		internal var _indicatorLocation : String = FormLayoutStyle.INDICATOR_NONE;

		/**
		 * @private 
		 */
		internal function get indicatorLocation() : String {
			return _indicatorLocation;	
		}

		/**
		 * @private
		 */
		internal function set indicatorLocation(value : String) : void {
			if(_indicatorLocation == value) return;
			
			_indicatorLocation = value;
			update_indicatiorLocation(value);
		}

		/**
		 * @private
		 */		
		private var _required : Boolean = false;

		/**
		 * @private
		 */
		internal function get required() : Boolean {
			return _required;	
		}

		/**
		 * @private
		 */
		internal function set required(value : Boolean) : void {
			if(_required == value) return;
			_required = value;
		}

		/**
		 * @copy com.yahoo.astra.fl.containers.formClasses.FormItem#instructionText 
		 */

		internal function set instructionText(value : String) : void {
			if(!instructionTextField) {
				instructionTextField = FormLayoutStyle.instructionTextField;
				if(preferredInstrunctionTextformat) instructionTextField.defaultTextFormat = preferredInstrunctionTextformat;
				itemOutterContainer.addChild(instructionTextField);
			}
			instructionTextField.htmlText = value;
		}

		
		//--------------------------------------
		//  Public Methods
		//--------------------------------------
		/**
		 * @private
		 * @see com.yahoo.astra.containers.formClasses.FormItem#subscribeObserver 
		 */
		public function subscribeObserver(formEventObserver : FormEventObserver) : IFormEventObserver {
			this.formEventObserver = formEventObserver;	
			
			reqBox_l.subscribeObserver(formEventObserver);
			reqBox_r.subscribeObserver(formEventObserver);
			
			return formEventObserver.subscribeObserver(this);
		}

		
		/**
		 * @private
		 * @see com.yahoo.astra.containers.formClasses.FormItem#update 
		 */
		public function update(target : String, value : Object = null) : void {
			
			switch(target) {
					
				case FormLayoutEvent.UPDATE_GOT_REQUIRED_ITEM:
					gotRequiredField = true;
					update_indicatiorLocation(indicatorLocation);
					break;
						
				case FormLayoutEvent.UPDATE_INSTRUCTION_FONT_CHANGE:
					updateTextFields(value as TextFormat);
					break;
						
				case FormLayoutEvent.UPDATE_ERROR_MSG_TEXT:
					if(isFormHeadingLabel) return;
					if(!instructionTextField) instructionText = " ";
					break;
											
				case FormLayoutEvent.UPDATE_ITEM_VERTICAL_GAP:
				
					if(itemVerticalGap == Number(value)) return;
					itemVerticalGap = itemLayoutMode.verticalGap = Number(value);
					break;
						
				case FormLayoutEvent.UPDATE_ITEM_HORIZONTAL_GAP:
					if(itemHorizontalGap == Number(value)) return;
					itemHorizontalGap = itemLayoutMode.horizontalGap = Number(value);
					break;
						
				case FormLayoutEvent.UPDATE_REQUIRED_ITEM:
					
					if(required == Boolean(value)) return;
					required = Boolean(value);
					break;
						
				case FormLayoutEvent.UPDATE_INDICATOR_LOCATION:
					indicatorLocation = String(value);
					break;
						
				case FormLayoutEvent.UPDATE_LABEL_ALIGN:
					this.labelAlign = String(value);
					update_indicatiorLocation(indicatorLocation);
					break;
			}
		}

		
		
		
		//--------------------------------------
		//  Private Methods
		//--------------------------------------

		/**
		 * @private
		 */	
		private function init() : void {
		
			reqBox_l = new RequiredIndicator();
			reqBox_r = new RequiredIndicator();
		
			
			itemOutterContainer = attItemOutterContainer();
			subItemContainer = attItemContainer();
			this.autoMask = itemOutterContainer.autoMask = subItemContainer.autoMask = false;

			this.addChild(reqBox_l);
			itemOutterContainer.addChild(subItemContainer);
			this.addChild(itemOutterContainer);
			this.addChild(reqBox_r);
			
			LayoutManager.invalidateParentLayout(this);
		}

		
		/**
		 * @private
		 */
		private function attItemOutterContainer() : LayoutContainer {
			ItemOutterLayoutMode = new BoxLayout();
			ItemOutterLayoutMode.direction = FormLayoutStyle.VERTICAL ;
			return new LayoutContainer(ItemOutterLayoutMode);
		}

		/**
		 * @private
		 */
		private function attItemContainer() : LayoutContainer {
			itemLayoutMode = new BoxLayout();
			itemLayoutMode.direction = itemAlign; //(this.itemAlign != FormLayoutStyle.DEFAULT_ITEM_ALIGN) ? FormLayoutStyle.HORIZONTAL : this.itemAlign;
			itemLayoutMode.verticalGap = itemVerticalGap;
			itemLayoutMode.horizontalGap = itemHorizontalGap;
			return new LayoutContainer(itemLayoutMode);
		}

		
		
		/**
		 * @private
		 */
		protected function updateTextFields(value : TextFormat) : void {
			if(!instructionTextField && value is TextFormat) { 
				preferredInstrunctionTextformat = value;
				return;
			}
			
			var textFieldToChg : TextField = instructionTextField;
			var str : String = textFieldToChg.text;
			textFieldToChg.defaultTextFormat = value;
			textFieldToChg.htmlText = str;
		}

		//--------------------------------------
		//  Internal Methods
		//--------------------------------------
		/**
		 * add DisplayObject into ItemContainer.
		 * 
		 * @param child DisplayObject includes UIComponent.
		 */
		public function addItem(child : DisplayObject) : void {
			child.addEventListener(Event.ENTER_FRAME, handler_enterFrame, false, 0, true);
			
			subItemContainer.addChild(child);
		}

		/**
		 * @private
		 */
		private function handler_enterFrame(e : Event) : void {
			var child : DisplayObject = e.target as DisplayObject;
			if(loopCatcher > 30 || child.width == 0) {
				child.removeEventListener(Event.ENTER_FRAME, handler_enterFrame);
				loopCatcher = 0;
				return;
			}
			if(subItemContainer.height != 0 && subItemContainer.height == tempHeight) {
				child.removeEventListener(Event.ENTER_FRAME, handler_enterFrame);
			}
			loopCatcher++;
			tempHeight = subItemContainer.height ;
			LayoutManager.invalidateParentLayout(child);
		}

		/**
		 * @private
		 */
		protected function cleanRequiredIndicatorBoxs() : void {
			reqBox_l.cleanBox();
			reqBox_r.cleanBox();
		}

		
		/**
		 * @private
		 */
		internal function update_indicatiorLocation(value : String) : void {
			cleanRequiredIndicatorBoxs();
			switch(value) {
				case FormLayoutStyle.INDICATOR_RIGHT:
					if(required) reqBox_r.showIndicator();
					if(gotRequiredField) reqBox_r.makeEmptyGap();
					break;
				case FormLayoutStyle.INDICATOR_LEFT:
					if(labelAlign == FormLayoutStyle.TOP) reqBox_l.makeEmptyGap();
					break;
				case FormLayoutStyle.INDICATOR_LABEL_RIGHT:
					break;
				case FormLayoutStyle.INDICATOR_NONE:
					break;
			}
			
			LayoutManager.invalidateParentLayout(this);
		}
	}
}
