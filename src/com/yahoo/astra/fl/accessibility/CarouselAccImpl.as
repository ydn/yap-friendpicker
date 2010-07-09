package com.yahoo.astra.fl.accessibility
{
	import flash.accessibility.Accessibility;
	import flash.events.Event;
	
	import com.yahoo.astra.fl.controls.Carousel;
	
	import fl.controls.listClasses.ICellRenderer;
	import fl.core.UIComponent;
	import fl.accessibility.SelectableListAccImpl;

	/**
     * The CarouselAccImpl class, also called the Carousel Accessiblity Implementation class, 
	 * is used to make a Carousel component accessible.
	 * 
	 * <p>The CarouselAccImpl class supports system roles, object-based events, and states.</p>
	 * 
	 * <p>A Carousel reports the role <code>ROLE_SYSTEM_LIST</code> (0x21) to a screen 
	 * reader. Its items report the role <code>ROLE_SYSTEM_LISTITEM</code> (0x22).</p>
     *
	 * <p>A Carousel reports the following states to a screen reader:</p>
	 * <ul>
     *     <li><code>STATE_SYSTEM_NORMAL</code> (0x00000000)</li>
     *     <li><code>STATE_SYSTEM_UNAVAILABLE</code> (0x00000001)</li>
     *     <li><code>STATE_SYSTEM_FOCUSED</code> (0x00000004)</li>
     *     <li><code>STATE_SYSTEM_FOCUSABLE</code> (0x00100000)</li>
	 * </ul>
	 * 
	 * <p>Additionally, items of a Carousel report the following states:</p>
	 * <ul>
     *     <li><code>STATE_SYSTEM_SELECTED</code> (0x00000002)</li>
     *     <li><code>STATE_SYSTEM_FOCUSED</code> (0x00000004)</li>
     *     <li><code>STATE_SYSTEM_INVISIBLE</code> (0x00008000)</li>
     *     <li><code>STATE_SYSTEM_OFFSCREEN</code> (0x00010000)</li>
     *     <li><code>STATE_SYSTEM_SELECTABLE</code> (0x00200000)</li>
	 * </ul>
     *
	 * <p>A Carousel dispatches the following events to a screen reader:</p>
	 * <ul>
     *     <li><code>EVENT_OBJECT_FOCUS</code> (0x8005)</li>
     *     <li><code>EVENT_OBJECT_SELECTION</code> (0x8006)</li>
     *     <li><code>EVENT_OBJECT_STATECHANGE</code> (0x800A)</li>
	 *     <li><code>EVENT_OBJECT_NAMECHANGE</code> (0x800C)</li>
	 * </ul>
     *
     * @see com.yahoo.astra.fl.controls.Carousel
     *
	 */
	public class CarouselAccImpl extends SelectableListAccImpl 
	{
		/**
         *  @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private static const STATE_SYSTEM_FOCUSED:uint = 0x00000004;
		
		/**
         *  @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private static const STATE_SYSTEM_INVISIBLE:uint = 0x00008000;
		
		/**
         *  @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private static const STATE_SYSTEM_OFFSCREEN:uint = 0x00010000;
		
		/**
         *  @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private static const STATE_SYSTEM_SELECTABLE:uint = 0x00200000;
		
		/**
         *  @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private static const STATE_SYSTEM_SELECTED:uint = 0x00000002;
		
		/**
		 *  @private
         *  Static variable triggering the <code>hookAccessibility()</code> method.
		 *  This is used for initializing CarouselAccImpl class to hook its
         *  <code>createAccessibilityImplementation()</code> method to Carousel class 
         *  before it gets called from UIComponent.
         *
		 */
		private static var accessibilityHooked:Boolean = hookAccessibility();

		/**
		 *  @private
         *  Static method for swapping the <code>createAccessibilityImplementation()</code>
         *  method of Carousel with the CarouselAccImpl class.
         *
		 */ 
		private static function hookAccessibility():Boolean 
		{
			Carousel.createAccessibilityImplementation = createAccessibilityImplementation;
			return true;
		}

		//--------------------------------------------------------------------------
		//  Class methods
		//--------------------------------------------------------------------------

		/**
		 *  @private
		 *  Method for creating the Accessibility class.
		 *  This method is called from UIComponent.
		 * 
		 *  @param component The UIComponent instance that this AccImpl instance
         *  is making accessible.
         *
		 */
		public static function createAccessibilityImplementation(component:UIComponent):void 
		{
			component.accessibilityImplementation = new CarouselAccImpl(component);
		}

		/**
		 *  Enables accessibility for a Carousel component.
		 *  This method is required for the compiler to activate
         *  the accessibility classes for a component.
		 */
		public static function enableAccessibility():void 
		{
			//empty
		}

		//--------------------------------------------------------------------------
		//  Constructor
		//--------------------------------------------------------------------------

        /**
		 *  Creates a new Carousel Accessibility Implementation.
		 *
		 *  @param master The UIComponent instance that this AccImpl instance
         *  is making accessible.
         *
		 */
		public function CarouselAccImpl(master:UIComponent) 
		{
			super(master);
		}

		
		//--------------------------------------------------------------------------
		//  Overridden methods: AccessibilityImplementation
		//--------------------------------------------------------------------------

		/**
		 *  @private
		 *  IAccessible method for returning the value of the List Item/Carousel
		 *  which is spoken out by the screen reader
		 *  The Carousel should return the name of the currently selected item
		 *  with m of n string as value when focus moves to Carousel.
		 * 
		 *  @param childID The child id
		 *
         *  @return Value
		 */
		override public function get_accValue(childID:uint):String 
		{
			var accValue:String;
			var list:Carousel = Carousel(master);
			var index:int = list.selectedIndex;
			if (childID == 0) {
				if (index > -1) {
					var ext:String = " " + (index + 1) + " of " + list.dataProvider.length;
					var item:Object = list.getItemAt(index);
					if (item is String) {
						accValue = item + ext;
					} else {
						accValue = list.itemToLabel(item) + ext;
					}
				}
			}
			return accValue;
		}

		//--------------------------------------------------------------------------
		//  Overridden methods: AccImpl
		//--------------------------------------------------------------------------
		/**
		 *  @private
		 *  IAccessible method for returning the state of the ListItem.
		 *  States are predefined for all the components in MSAA.
		 *  Values are assigned to each state.
		 *  Depending upon the listItem being Selected, Selectable,
		 *  Invisible, Offscreen, a value is returned.
		 *
		 *  @param childID The child id.
		 *
         *  @return State.
		 */
		override public function get_accState(childID:uint):uint 
		{
			var accState:uint = getState(childID);
			if (childID > 0) {
				var list:Carousel = Carousel(master);
				var index:uint = childID - 1;
				// For returning states (OffScreen and Invisible)
				// when the list Item is not in the displayed rows.
				if (index < list.horizontalScrollPosition || index >= list.horizontalScrollPosition + list.columnCount) {
					accState |= (STATE_SYSTEM_OFFSCREEN | STATE_SYSTEM_INVISIBLE);
				} else {
					accState |= STATE_SYSTEM_SELECTABLE;
					var item:Object = list.getItemAt(index);
					var selItems:Array = list.selectedIndices;
					for(var i:int = 0; i < selItems.length; i++) {
						if(selItems[i] == index) {
							accState |= STATE_SYSTEM_SELECTED | STATE_SYSTEM_FOCUSED;
							break;
						}
					}
				}
			}
			return accState;
		}

		/**
		 *  @private
		 *  method for returning the name of the ListItem/Carousel
		 *  which is spoken out by the screen reader.
		 *  The ListItem should return the label as the name
		 *  with m of n string and Carousel should return the name
		 *  specified in the Accessibility Panel.
		 *
		 *  @param childID The child id.
		 *
         *  @return Name.
         *
		 */
		override protected function getName(childID:uint):String 
		{
			if (childID == 0) {
				return "";
			}
			var list:Carousel = Carousel(master);
			// Assuming childID is always ItemID + 1
			// because getChildIDArray is not always invoked.
			if(list.dataProvider) 
			{
				var index:int = childID - 1;
		
				if (index > -1)
				{
					var item:Object = list.getItemAt(index);
					var ext:String = " " + childID + " of " + list.dataProvider.length;
					if (item is String) {
						return item + ext;
					} else {
						return list.itemToLabel(item) + ext;
					}
				}
			}
			return "";
		}

	}
}
