package com.yahoo.astra.mx.controls
{
	import com.yahoo.astra.animation.Animation;
	import com.yahoo.astra.animation.AnimationEvent;
	import com.yahoo.astra.mx.controls.colorPickerClasses.*;
	import com.yahoo.astra.mx.events.ColorRequestEvent;
	import com.yahoo.astra.mx.skins.halo.EditableColorViewerSkin;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
	import mx.controls.colorPickerClasses.*;
	import mx.core.ClassFactory;
	import mx.core.IFactory;
	import mx.core.UIComponent;
	import mx.events.ColorPickerEvent;
	import mx.events.DropdownEvent;
	import mx.events.FlexEvent;
	import mx.managers.IFocusManagerComponent;
	import mx.managers.PopUpManager;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.ISimpleStyleClient;
	import mx.styles.StyleManager;

	//--------------------------------------
	//  Events
	//--------------------------------------
	
	/**
	 * Dispatched when the selected color 
	 * changes as a result of user interaction.
	 *
	 * @eventType mx.events.ColorPickerEvent.CHANGE
	 */
	[Event(name="change", type="mx.events.ColorPickerEvent")]
	
	/**
	 * Dispatched when the user rolls the mouse out of a color in the
	 * drop down picker.
	 *
	 * @eventType mx.events.ColorPickerEvent.ITEM_ROLL_OUT
	 */
	[Event(name="itemRollOut", type="mx.events.ColorPickerEvent")]
	
	/**
	 * Dispatched when the user rolls the mouse over a color in the
	 * drop down picker.
	 *
	 * @eventType mx.events.ColorPickerEvent.ITEM_ROLL_OVER
	 */
	[Event(name="itemRollOver", type="mx.events.ColorPickerEvent")]
	
	/**
	 * Dispatched when the color swatch panel opens.
	 *
	 * @eventType mx.events.DropdownEvent.OPEN
	 */
	[Event(name="open", type="mx.events.DropdownEvent")]
	
	/**
	 * Dispatched when the picker drop down closes.
	 *
	 * @eventType mx.events.DropdownEvent.CLOSE
	 */
	[Event(name="close", type="mx.events.DropdownEvent")]
	
	//--------------------------------------
	//  Styles
	//--------------------------------------
	
	//Flex framework styles
	include "../styles/metadata/FocusStyles.inc"
	include "../styles/metadata/IconColorStyles.inc"
	include "../styles/metadata/LeadingStyle.inc"
	include "../styles/metadata/TextStyles.inc"
	
	/**
	 * The styleName value for the viewer.
	 * 
	 * @default yahoo_DropDownColorPicker_viewerStyleName
	 */
	[Style(name="viewerStyleName", type="String")]
	
	/**
	 * The styleName value for the picker.
	 * 
	 * @default yahoo_DropDownColorPicker_pickerStyleName
	 */
	[Style(name="pickerStyleName", type="String")]
	
	/**
	 * The distance in pixels from the primary control and the popup drop down.
	 * 
	 * @default 4
	 */
	[Style(name="dropDownGap", type="Number")]
	
	//--------------------------------------
	//  Other Metadata
	//--------------------------------------
	
	[DefaultTriggerEvent("change")]
	
	/**
	 * A color picker similar to the standard Flex ColorPicker control, except
	 * that both the color viewer and the drop-down picker may be replaced with
	 * custom controls.
	 * 
	 * <p>The default renderers match the appearance and functionality of the
	 * standard Flex ColorPicker control.</p>
	 * 
	 * @see mx.controls.ColorPicker 
	 * 
	 * @author Josh Tynjala
	 */
	public class DropDownColorPicker extends UIComponent implements IColorPicker, IFocusManagerComponent
	{
		
	//--------------------------------------
	//  Static Properties
	//--------------------------------------
		
		/**
		 * @private
		 * The default value used for the viewerStyleName style.
		 */
		private static const DEFAULT_VIEWER_STYLE_NAME:String = "yahoo_DropDownColorPicker_viewerStyleName";
		
		/**
		 * @private
		 * The default value used for the pickerStyleName style.
		 */
		private static const DEFAULT_PICKER_STYLE_NAME:String = "yahoo_DropDownColorPicker_pickerStyleName";
		
	//--------------------------------------
	//  Static Methods
	//--------------------------------------
	
		/**
		 * @private
		 * Sets the default style values for new instances of this control.
		 */
		private static function initializeStyles():void
		{
			var styleDeclaration:CSSStyleDeclaration = StyleManager.getStyleDeclaration("DropDownColorPicker");
			if(!styleDeclaration)
			{
				styleDeclaration = new CSSStyleDeclaration();
			}
			
			//TODO: Add openEasingFunction and closeEasingFunction
			styleDeclaration.defaultFactory = function():void
			{
				this.closeDuration = 250;
				this.dropDownGap = 4;
				this.openDuration = 250;
				this.viewerStyleName = DEFAULT_VIEWER_STYLE_NAME;
				this.pickerStyleName = DEFAULT_PICKER_STYLE_NAME;
			};
			
			StyleManager.setStyleDeclaration("DropDownColorPicker", styleDeclaration, false);
			
			styleDeclaration = StyleManager.getStyleDeclaration("." + DEFAULT_VIEWER_STYLE_NAME);
			if(!styleDeclaration)
			{
				styleDeclaration = new CSSStyleDeclaration();
			}
			
			styleDeclaration.defaultFactory = function():void
			{
				this.skin = EditableColorViewerSkin;
			}
			StyleManager.setStyleDeclaration("." + DEFAULT_VIEWER_STYLE_NAME, styleDeclaration, false);
		}
		initializeStyles();
		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
		
		/**
		 * Constructor.
		 */
		public function DropDownColorPicker()
		{
			super();
			this.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler2);
		}
		
	//--------------------------------------
	//  Properties
	//--------------------------------------
		
		/**
		 * @private
		 * The main viewer.
		 */
		protected var viewer:IColorViewer;
		
		/**
		 * @private
		 * The color picker dropdown.
		 */
		protected var picker:IColorPicker;
		
		/**
		 * @private
		 * Flag indicating if the viewerRenderer property has changed.
		 */
		protected var viewerRendererChanged:Boolean = true;
		
		/**
		 * @private
		 * Storage for the viewerRenderer property.
		 */
		private var _viewerRenderer:IFactory = new ClassFactory(DefaultColorViewer);
		
		/**
		 * The custom IColorViewer for this control.
		 * 
		 * <p><strong>Usage:</strong> <code>picker.viewerRenderer = new ClassFactory(<em>ClassReference</em>);</code></p>
		 */
		public function get viewerRenderer():IFactory
		{
			return this._viewerRenderer;
		}
		
		/**
		 * @private
		 */
		public function set viewerRenderer(value:IFactory):void
		{
			this._viewerRenderer = value;
			this.viewerRendererChanged = true;
			this.invalidateProperties();
			this.invalidateSize();
			this.invalidateDisplayList();
		}
		
		/**
		 * @private
		 * Flag indicating if the pickerRenderer property has changed.
		 */
		protected var pickerRendererChanged:Boolean = true;
		
		/**
		 * @private
		 * Storage for the pickerRenderer property.
		 */
		private var _pickerRenderer:IFactory = new ClassFactory(SwatchPickerDropDown);
		
		/**
		 * The custom IColorPicker for this control's drop down. 
		 * 
		 * <p><strong>Usage:</strong> <code>picker.viewerRenderer = new ClassFactory(<em>ClassReference</em>);</code></p>
		 */
		public function get pickerRenderer():IFactory
		{
			return this._pickerRenderer;
		}
		
		/**
		 * @private
		 */
		public function set pickerRenderer(value:IFactory):void
		{
			this._pickerRenderer = value;
			this.pickerRendererChanged = true;
			this.invalidateProperties();
		}
		
		/**
		 * @private
		 * Storage for the selectedColor property.
		 */
		private var _selectedColor:uint;
		
		[Bindable("valueCommit")]
		/**
		 * @inheritDoc
		 */
		public function get selectedColor():uint
		{
			return this._selectedColor;
		}
		
		/**
		 * @private
		 */
		public function set selectedColor(value:uint):void
		{
			if(this._selectedColor != value)
			{
				this._selectedColor = value;
				this.invalidateProperties();
				this.dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
			}
		}
		
		/**
		 * @private
		 * Storage for the drop down animation.
		 */
		private var _animation:Animation;
		
		/**
		 * @private
		 * Flag indicating if the drop down is down.
		 */
		private var _dropDownShowing:Boolean = false;
		
		/**
		 * @private
		 * Flag indicating if the drop down is closing.
		 */
		private var _closing:Boolean = false;
		
		/**
		 * @private
		 * The event that triggered the drop down opening or closing.
		 */
		private var dropDownTriggerEvent:Event;
		
	//--------------------------------------
	//  Public Methods
	//--------------------------------------
		
		/**
		 * @private
		 */
		override public function styleChanged(styleProp:String):void
		{
			var allStyles:Boolean = !styleProp || styleProp == this.styleName;
			
			super.styleChanged(styleProp);
			
			if(allStyles || styleProp == "viewerStyleName")
			{
				if(this.viewer && this.viewer is ISimpleStyleClient)
				{
					ISimpleStyleClient(this.viewer).styleName = this.getStyle("viewerStyleName");
				}
			}
			
			if(allStyles || styleProp == "pickerStyleName")
			{
				if(this.picker && this.picker is ISimpleStyleClient)
				{
					ISimpleStyleClient(this.picker).styleName = this.getStyle("pickerStyleName");
				}
			}
		}
		
	//--------------------------------------
	//  Protected Methods
	//--------------------------------------
		
		/**
		 * @private
		 */
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			//remove and recreate the viewer, if needed
			if(this.viewerRendererChanged)
			{
				if(this.viewer)
				{
					this.removeChild(DisplayObject(this.viewer));
					this.viewer.removeEventListener(ColorRequestEvent.REQUEST_COLOR, viewerRequestEditHandler);
					this.viewer = null;
				}
				this.viewer = this._viewerRenderer.newInstance();
				if(this.viewer is ISimpleStyleClient)
				{
					ISimpleStyleClient(this.viewer).styleName = this.getStyle("viewerStyleName");
				}
				this.viewer.focusEnabled = false;
				this.viewer.owner = this;
				this.viewer.addEventListener(ColorRequestEvent.REQUEST_COLOR, viewerRequestEditHandler, false, 0, true);
				this.addChild(DisplayObject(this.viewer));
				this.viewerRendererChanged = false;
			}
			this.viewer.color = this.selectedColor;
			
			//remove and recreate the picker, if needed
			if(this.pickerRendererChanged)
			{
				//TODO: Make sure picker isn't on the display list
				if(this.picker)
				{
					this.picker.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler2);
					this.picker = null;
				}
				
				this.picker = this._pickerRenderer.newInstance();
				if(this.picker is ISimpleStyleClient)
				{
					ISimpleStyleClient(this.picker).styleName = this.getStyle("pickerStyleName");
				}
				this.picker.owner = this;
				this.picker.scrollRect = new Rectangle(0, 0, 0, 0);
				this.pickerRendererChanged = false;
				this.picker.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler2);
			}
			this.picker.selectedColor = this.selectedColor;
		}
		
		/**
		 * @private
		 */
		override protected function measure():void
		{
			super.measure();
			
			//measurement doesn't include the size of the drop down
			this.measuredWidth = this.viewer.getExplicitOrMeasuredWidth();
			this.measuredHeight = this.viewer.getExplicitOrMeasuredHeight();	
		}
		
		/**
		 * @private
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			this.viewer.setActualSize(unscaledWidth, unscaledHeight);
			
			//picker may not be created until it is needed
			if(this.picker)
			{
				this.picker.setActualSize(this.picker.getExplicitOrMeasuredWidth(), this.picker.getExplicitOrMeasuredHeight());
			}
		}
		
		/**
		 * Opens the picker drop down.
		 */
		protected function showDropDown(trigger:Event = null):void
		{
			this.dropDownTriggerEvent = trigger;
			
			var dropDownGap:Number = this.getStyle("dropDownGap") as Number;
        	var openDuration:Number = this.getStyle("openDuration") as Number;
			
			var position:Point = new Point(0, 0);
			position = this.localToGlobal(position);
			
			var startY:Number = 0;
			var endY:Number = 0;
				
			//this._closing = false;
        	//show the picker pop up	
			PopUpManager.addPopUp(this.picker, this.parent, false);
			
			//determine if the drop down should open on the top or bottom
			if(position.y + this.height + dropDownGap + this.picker.height > this.systemManager.screen.height && position.y > (this.height + this.picker.height))
			{
				//open up
				startY = -this.picker.height / this.scaleY;
				position.y -= dropDownGap + this.picker.height;
			}
			else //open down
			{
				startY = this.picker.height / this.scaleY;
				position.y += this.height + dropDownGap;
			}
			
			//determine if the drop down should be aligned to the left or right
			if (position.x + this.picker.width > this.systemManager.screen.width && position.x > (this.width + this.picker.width))
			{
				//align to right edge
				position.x -= (this.picker.width - this.width);
			}
        	
        	this.picker.x = position.x;
        	this.picker.y = position.y;
			this.picker.addEventListener(ColorPickerEvent.CHANGE, pickerChangeHandler);
			this.picker.addEventListener(ColorPickerEvent.ITEM_ROLL_OVER, pickerRollOverHandler); 
			this.picker.addEventListener(ColorPickerEvent.ITEM_ROLL_OUT, pickerRollOutHandler);
			this.stage.addEventListener(MouseEvent.MOUSE_DOWN, stageMouseDownHandler, false, 0, true);
        	
        	this.clearAnimation();
        	
			this._animation = new Animation(openDuration, {y: startY}, {y: endY});
			this._animation.addEventListener(AnimationEvent.UPDATE, showHideUpdateHandler);
			this._animation.addEventListener(AnimationEvent.COMPLETE, showHideCompleteHandler);
			this._dropDownShowing = true;
		}
		
		/**
		 * Closes the picker drop down.
		 */
		protected function hideDropDown(trigger:Event = null):void
		{
			this.dropDownTriggerEvent = trigger;
			
			var dropDownGap:Number = this.getStyle("dropDownGap") as Number;
			var closeDuration:Number = this.getStyle("closeDuration") as Number;
			
			var position:Point = new Point(0, 0);
			position = this.localToGlobal(position);
			
			var startY:Number = 0;
			var endY:Number = 0;
			if(this.picker.parent)
			{
				//hide it
				this.stage.removeEventListener(MouseEvent.MOUSE_DOWN, stageMouseDownHandler);
				this.picker.removeEventListener(ColorPickerEvent.CHANGE, pickerChangeHandler);
				this.picker.removeEventListener(ColorPickerEvent.ITEM_ROLL_OVER, pickerRollOverHandler); 
				this.picker.removeEventListener(ColorPickerEvent.ITEM_ROLL_OUT, pickerRollOutHandler);
				
				//opened down
				if(this.picker.y > position.y + this.height)
				{
					endY = this.picker.height / this.scaleY;	
				}
				else //opened up
				{
					endY = -this.picker.height / this.scaleY;
				}
			}

        	this.clearAnimation();
        	
			this._animation = new Animation(closeDuration, {y: startY}, {y: endY});
			this._animation.addEventListener(AnimationEvent.UPDATE, showHideUpdateHandler);
			this._animation.addEventListener(AnimationEvent.COMPLETE, showHideCompleteHandler);
			this._dropDownShowing = false;
			this.picker.enabled = false;
		}
		
		/**
		 * Resets the picker color and clears the preview.
		 */
		protected function cancelColorChange():void
		{
			this.picker.selectedColor = this.selectedColor;
			this.clearPreview();
		}
		
		/**
		 * If the viewer shows a preview color, clear it.
		 */
		protected function clearPreview():void
		{
			if(this.viewer is IColorPreviewViewer)
			{
				var preview:IColorPreviewViewer = IColorPreviewViewer(this.viewer);
				preview.showPreview = false;
			}
			this.dispatchEvent(new ColorPickerEvent(ColorPickerEvent.ITEM_ROLL_OUT)); 
		}
		
	//--------------------------------------
	//  Protected Event Handlers
	//--------------------------------------
		
		/**
		 * @private
		 * If the picker's selected color changes, update our selected color.
		 */
		protected function pickerChangeHandler(event:ColorPickerEvent):void
		{
			this.hideDropDown(event);
			this.selectedColor = event.color;
			this.clearPreview();
			this.dispatchEvent(new ColorPickerEvent(ColorPickerEvent.CHANGE, false, false, -1, this.selectedColor));
		}
		
		/**
		 * @private
		 * Update the preview color on rollover, if applicable.
		 */
		protected function pickerRollOverHandler(event:ColorPickerEvent):void
		{
			if(this.viewer is IColorPreviewViewer)
			{
				var preview:IColorPreviewViewer = IColorPreviewViewer(this.viewer);
				preview.showPreview = true;
				preview.previewColor = event.color;
			}
			this.dispatchEvent(new ColorPickerEvent(ColorPickerEvent.ITEM_ROLL_OVER, false, false, -1, event.color)); 
		}
		
		/**
		 * @private
		 * Clear the preview color on rollout, if applicable.
		 */
		protected function pickerRollOutHandler(event:ColorPickerEvent):void
		{
			this.clearPreview();
		}
		
		/**
		 * @private
		 * Handle keystrokes. Escape closes the dropdown if it is open.
		 */
		protected function keyDownHandler2(event:KeyboardEvent):void
		{	
			if(this._dropDownShowing)
			{
				if(event.ctrlKey && event.keyCode == Keyboard.UP || event.keyCode == Keyboard.ESCAPE)
				{
					this.hideDropDown(event);
					this.cancelColorChange();
				}
				//should ENTER be handled here?
			}
			//not showing
			else if(event.ctrlKey && event.keyCode == Keyboard.DOWN)
			{
				this.showDropDown(event);
			}
		}
		
		/**
		 * @private
		 * If the viewer is an IColorRequester (and it should be!),
		 * we toggle the picker if it gets clicked.
		 */
		protected function viewerRequestEditHandler(event:ColorRequestEvent):void
		{
			if(this._dropDownShowing)
			{
				this.hideDropDown(event);
				this.cancelColorChange();
			}
			else this.showDropDown(event);
		}
		
		/**
		 * @private
		 * Show the focus indicator when we're focused.
		 */
		override protected function focusInHandler(event:FocusEvent):void
		{
			if(this.focusManager)
			{
				this.focusManager.showFocusIndicator = true;
			}
			super.focusInHandler(event);
		}
		
	//--------------------------------------
	//  Private Methods
	//--------------------------------------
		
		/**
		 * @private
		 * Stops the animation.
		 */
		private function clearAnimation():void
		{
        	if(this._animation)
        	{
				this._animation.removeEventListener(AnimationEvent.UPDATE, showHideUpdateHandler);
				this._animation.removeEventListener(AnimationEvent.COMPLETE, showHideCompleteHandler);
				this._animation = null;
        	}
		}
		
		/**
		 * @private
		 * When the animation is running, the picker's scrollrect is updated.
		 */
		private function showHideUpdateHandler(event:AnimationEvent):void
		{
			this.picker.scrollRect = new Rectangle(0, event.parameters.y, this.picker.width, this.picker.height); 
		}
		
		/**
		 * @private
		 * When the animation is complete, we handle drop down events 
		 */
		private function showHideCompleteHandler(event:AnimationEvent):void
		{
			this.showHideUpdateHandler(event);
			this.clearAnimation();
			
			//closing
			if(!this._dropDownShowing)
			{
				//get rid of the pop up
				PopUpManager.removePopUp(this.picker);
				this.dispatchEvent(new DropdownEvent(DropdownEvent.CLOSE, false, false, this.dropDownTriggerEvent));
			}
			else
			{
				UIComponent(this.picker).setFocus();
				this.picker.enabled = true;
				this.dispatchEvent(new DropdownEvent(DropdownEvent.OPEN, false, false, this.dropDownTriggerEvent));
			}
		}
		
		/**
		 * @private
		 * Toggle the drop down if the user clicks on the stage outside the
		 * drop down while it is visible.
		 */
		private function stageMouseDownHandler(event:MouseEvent):void
		{
			var target:DisplayObject = DisplayObject(event.target);
			if(event.target != this && !this.contains(target) && !DisplayObjectContainer(this.picker).contains(DisplayObject(target)))
			{
				this.hideDropDown(event);
				
				//we take the selected color from the drop down picker
				this.selectedColor = this.picker.selectedColor;
				this.clearPreview();
				this.invalidateProperties();
				this.dispatchEvent(new ColorPickerEvent(ColorPickerEvent.CHANGE, false, false, -1, this.selectedColor));
			}
		}
	}
}