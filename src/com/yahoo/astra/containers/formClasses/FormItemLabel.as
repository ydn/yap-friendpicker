package com.yahoo.astra.containers.formClasses {
	import com.yahoo.astra.containers.formClasses.FormItemContainer;
	import com.yahoo.astra.containers.formClasses.IForm;
	import com.yahoo.astra.containers.formClasses.FormLayoutStyle;
	import com.yahoo.astra.events.FormLayoutEvent;
	import com.yahoo.astra.layout.LayoutManager;
	import com.yahoo.astra.layout.events.LayoutEvent;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;		

	/**
	 * <code>FormItemContainer</code> to contain and align label text field and handling required indicator. No explicit use is intended.
	 * 
	 * @see com.yahoo.astra.containers.formClasses.FormItemContainer
	 * @author kayoh
	 */
	public class FormItemLabel extends FormItemContainer  implements IForm {
		
		//--------------------------------------
		//  Constructor
		//--------------------------------------
		/**
		 * Constructor.
		 * A LayoutContainer attches and aligns a label. 
		 */
		public function FormItemLabel() {
			super();
		}
		//--------------------------------------
		//  Properties
		//--------------------------------------
		/**
		 * @private
		 */
		private var textField : TextField = null;
		/**
		 * @private
		 */
		private var lableText : String = null;
		/**
		 * @private
		 */
		private var lableSprite : Sprite = null;
		/**
		 * @private
		 */
		private var _actualLabelTextWidth : Number = NaN;
		/**
		 * @private
		 */
		internal function get actualLabelTextWidth() : Number {
			return _actualLabelTextWidth;	
		}
		/**
		 * @private
		 */
		internal function set actualLabelTextWidth(value : Number) : void {
			if(_actualLabelTextWidth == value) return;
			_actualLabelTextWidth = value;
		}
		/**
		 * @private
		 */
		private var _preferredWidth : Number;
		/**
		 * @private
		 */
		internal function get preferredLabelWidth() : Number {
			return _preferredWidth;	
		}
		/**
		 * @private
		 */
		internal function set preferredLabelWidth(value : Number) : void {
			if(_preferredWidth == value) return;
			_preferredWidth = value;
			
			var tempHeight : Number = (textField) ? textField.height : 0;
			LayoutManager.resize(subItemContainer, value, tempHeight);
			
			if(labelAlign)	this.alignLabel = labelAlign;
			this.dispatchEvent(new LayoutEvent(LayoutEvent.LAYOUT_CHANGE));
		}
		
		//--------------------------------------
		//  Internal Methods
		//--------------------------------------

		/**
		 * @private
		 */
		override internal function update_indicatiorLocation(value : String) : void {
			cleanRequiredIndicatorBoxs();
			switch(value) {
				case FormLayoutStyle.INDICATOR_LEFT:
					if(!lableText && labelAlign == FormLayoutStyle.TOP) {
						break;
						return;
					}
					if(required) reqBox_l.showIndicator();
					reqBox_l.makeEmptyGap();
					break;
					
				case FormLayoutStyle.INDICATOR_LABEL_RIGHT:
					if(!lableText && labelAlign == FormLayoutStyle.TOP) {
						break;
						return;
					}
					if(required) reqBox_r.showIndicator();
					reqBox_r.makeEmptyGap();
					break;
			}
		}
		//--------------------------------------
		//  Private Methods
		//--------------------------------------
		/**
		 * @private
		 */
		override public function update(target : String, value : Object = null) : void {
			switch(target) {
				case FormLayoutEvent.UPDATE_LABEL_FONT_CHANGE:
					updateTextFields(value as TextFormat);
					break;
				case FormLayoutEvent.UPDATE_LABEL_WIDTH:
					this.preferredLabelWidth = Number(value);
					break;
						
				case FormLayoutEvent.UPDATE_REQUIRED_ITEM:
					required = Boolean(value);
					break;
						
				case FormLayoutEvent.UPDATE_INDICATOR_LOCATION:
					indicatorLocation = String(value);
					break;
						
				case FormLayoutEvent.UPDATE_LABEL_ALIGN:
					labelAlign = String(value);
					break;
			}
		}
		/**
		 * @private
		 */
		override internal function set labelAlign(value : String) : void {
			if(this.labelAlign == value) return;
			this.alignLabel = _labelAlign = value;
			update_indicatiorLocation(indicatorLocation);
		}

		/**
		 * @private
		 */
		internal function attLabel(lableTxt : String) : void {
			
			lableSprite = new Sprite();
			if(lableTxt is String && lableTxt != "" ) {
				lableText = lableTxt;
				if(!textField) textField = FormLayoutStyle.labelTextField;
				textField.htmlText = lableText;
				actualLabelTextWidth = textField.width;
				textField.x = 0;
				lableSprite.addChild(textField);
			} else {
				lableText = null;
				actualLabelTextWidth = 0;
			}
			

			this.dispatchEvent(new FormLayoutEvent(FormLayoutEvent.LABEL_ADDED));
			
			this.addItem(lableSprite);
		}
		/**
		 * @private
		 */
		override protected function updateTextFields(textformat : TextFormat) : void {
			if(!textField) return;
			actualLabelTextWidth = NaN;
			var textFieldToChg : TextField = textField;
			var str : String = textFieldToChg.text;
			textFieldToChg.defaultTextFormat = textformat;
			textFieldToChg.htmlText = str;
			actualLabelTextWidth = textFieldToChg.width;
			this.dispatchEvent(new FormLayoutEvent(FormLayoutEvent.LABEL_ADDED));
		}
		/**
		 * @private
		 */
		private  function set alignLabel(value : String) : void {
			if(!lableText) return;
			switch(value) {
				case FormLayoutStyle.TOP:
					textField.x = 0;
					break;
				case FormLayoutStyle.RIGHT:
					textField.x = (preferredLabelWidth) ? preferredLabelWidth - actualLabelTextWidth : 0;
					break;
				case FormLayoutStyle.LEFT:
					textField.x = 0;
					break;
			}
		}
	}
}

