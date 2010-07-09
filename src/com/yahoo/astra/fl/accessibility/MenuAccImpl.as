package com.yahoo.astra.fl.accessibility
{

import com.yahoo.astra.fl.controls.Menu;
import com.yahoo.astra.fl.controls.menuClasses.MenuCellRenderer;
import com.yahoo.astra.fl.events.MenuEvent;

import fl.accessibility.ListAccImpl;
import fl.core.UIComponent;

import flash.accessibility.Accessibility;
import flash.events.Event;



/**
 * The MenuAccImpl class, also called the Menu Accessiblity Implementation class, 
 * is used to make a Menu component accessible.
 * 
 * <p>The MenuAccImpl class supports system roles, object-based events, and states.</p>
 * 
 * <p>A Menu reports the role <code>ROLE_SYSTEM_MENUPOPUP</code> (0x0b) to a screen 
 * reader. Items of a Menu report the role <code>ROLE_SYSTEM_MENUITEM</code> (0x0c).</p>
 *
 * <p>A Menu reports the following states to a screen reader:</p>
 * <ul>
 *     <li><code>STATE_SYSTEM_NORMAL</code> (0x00000000)</li>
 *     <li><code>STATE_SYSTEM_UNAVAILABLE</code> (0x00000001)</li>
 *     <li><code>STATE_SYSTEM_FOCUSED</code> (0x00000004)</li>
 *     <li><code>STATE_SYSTEM_FOCUSABLE</code> (0x00100000)</li>
 * </ul>
 * 
 * <p>Additionally, items of a Menu report the following states:</p>
 * <ul>
 *     <li><code>STATE_SYSTEM_SELECTED</code> (0x00000002)</li>
 * 	   <li><code>STATE_SYSTEM_CHECKED</code> (0x00000010)</li>
 *     <li><code>STATE_SYSTEM_FOCUSED</code> (0x00000004)</li>
 * 	   <li><code>STATE_SYSTEM_HASPOPUP</code> (0x40000000)</li>
 *     <li><code>STATE_SYSTEM_HOTTRACKED</code> (0x00000080)</li> 	   
 * </ul>
 *
 * <p>A Menu dispatches the following events to a screen reader:</p>
 * <ul>
 *     <li><code>EVENT_OBJECT_FOCUS</code> (0x8005)</li>
 *     <li><code>EVENT_OBJECT_SELECTION</code> (0x8006)</li>
 *     <li><code>EVENT_OBJECT_MENUPOPUPSTART</code> (0x800A)</li>
 *     <li><code>EVENT_OBJECT_MENUPOPUPEND</code> (0x800C)</li>
 * </ul>
 *
 * @see com.yahoo.astra.fl.controls.Menu Menu
 * @see http://msdn.microsoft.com/en-us/library/ms697502(VS.85).aspx Microsoft Accessibility Developer Center User Interface Element Reference: Pop-Up Menu
 *
 */
public class MenuAccImpl extends ListAccImpl
{


	//--------------------------------------------------------------------------
	//
	//  Class initialization
	//
	//--------------------------------------------------------------------------

	/**
	 *  Static variable triggering the <code>hookAccessibility()</code> method.
	 *  This is used for initializing <code>MenuAccImpl</code> class to hook its
	 *  <code>createAccessibilityImplementation()</code> method to the <code>Menu</code> class 
	 *  before it gets called when <code>UIComponent</code> invokes the <code>initializeAccessibility()</code> method.
	 * 
	 *  @see fl.accessibility.UIComponent#createAccessibilityImplementation()
	 *  @see fl.accessibility.UIComponent#initializeAccessibility()
	 *  @see fl.accessibility.UIComponent#initialize()
	 */
	private static var accessibilityHooked:Boolean = hookAccessibility();

	/**
	 *  Static method that swaps the <code>createAccessibilityImplementation()</code>
	 *  method of <code>UIComponent</code> subclass with the appropriate <code>AccImpl</code> subclass.
	 * 
	 *  @see fl.accessibility.UIComponent#createAccessibilityImplementation()
	 *  @see fl.accessibility.UIComponent#initializeAccessibility()
	 *  @see fl.accessibility.UIComponent#initialize()
	 */
	private static function hookAccessibility():Boolean
	{
		Menu.createAccessibilityImplementation =
			createAccessibilityImplementation;

		return true;
	}

	//--------------------------------------------------------------------------
	//
	//  Class constants
	//
	//--------------------------------------------------------------------------

	/**
	 * The object represents a menu, which presents a list of options 
	 * from which the user can make a selection to perform an action. 
	 * All menu types must have this role, including drop-down menus that are 
	 * displayed by selecting from a menu bar, and shortcut menus that are displayed 
	 * by clicking the right mouse button. 
	 */
	private static const ROLE_SYSTEM_MENUPOPUP:uint = 0x0B;
	
	/**
	 * The object represents a menu item, which is an entry in a menu that a user can 
	 * choose to carry out a command, select an option, or display another menu. 
	 */
	private static const ROLE_SYSTEM_MENUITEM:uint = 0x0C;

	/**
	 *  The object's check box is selected. 
	 */
	private static const STATE_SYSTEM_CHECKED:uint = 0x00000010;

	/**
	 *  The object has the keyboard focus. 
	 */
	private static const STATE_SYSTEM_FOCUSED:uint = 0x00000004;
	
	/**
	 *  Object displays a pop-up menu or window when invoked. 
	 */
	private static const STATE_SYSTEM_HASPOPUP:uint = 0x40000000;

	/**
	 * The object is hot-tracked by the mouse, which means that 
	 * its appearance has changed to indicate that the mouse pointer is located over it.
	 */
	private static const STATE_SYSTEM_HOTTRACKED:uint = 0x00000080;
	
	/**
	 *  The object is unavailable. 
	 */
	private static const STATE_SYSTEM_UNAVAILABLE:uint = 0x00000001;
	
	/**
	 *  An object has received the keyboard focus. 
	 */
	private static const EVENT_OBJECT_FOCUS:uint = 0x8005;
	
	/**
	 *  The selection within a container object has changed. 
	 */
	private static const EVENT_OBJECT_SELECTION:uint = 0x8006;
	private static const EVENT_OBJECT_SHOW:uint             =  0x8002;
	
	/**
	 *  A pop-up menu has been displayed.
	 */
	private static const EVENT_SYSTEM_MENUPOPUPSTART:uint = 0x00000006;

	/**
	 *  A pop-up menu has been closed.
	 */
	private static const EVENT_SYSTEM_MENUPOPUPEND:uint = 0x00000007;

	//--------------------------------------------------------------------------
	//
	//  Class methods
	//
	//--------------------------------------------------------------------------

	/**
	 *  Method for creating the Accessibility Implementation class for a component.
	 *  <p>This method is called by the <code>initializeAccessibility()</code> method for the <code>UIComponent</code> subclass when the component initalizes.</p>
	 *  <p>All <code>AccImpl</code> subclasses must implement this method</p>
	 * 
	 *  @param component The UIComponent instance that this MenuAccImpl instance makes accessible.
	 * 
	 *  @see fl.accessibility.AccImpl#createAccessibilityImplementation()
	 *  @see fl.core.UIComponent#createAccessibilityImplementation() 
	 *  @see fl.core.UIComponent#initalizeAccessibility()
	 *  @see fl.core.UIComponent#initialize()
	 */
	public static function createAccessibilityImplementation(component:UIComponent):void
	{
		component.accessibilityImplementation = new MenuAccImpl(component);
	}

	/**
	 *  Method call for enabling accessibility for a component.
	 *  This method is required for the compiler to activate the accessibility classes for a component.
	 * 
	 */
	public static function enableAccessibility():void
	{
	}

	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 * Creates a new MenuAccImpl instance for the specified Menu component.
	 *
	 * @param master The UIComponent instance that this MenuAccImpl instance is making accessible.
	 * 
	 */
	public function MenuAccImpl(master:UIComponent)
	{
		super(master);

		role = ROLE_SYSTEM_MENUPOPUP;
	}

	//--------------------------------------------------------------------------
	//
	//  Overridden properties: AccImpl
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	//  eventsToHandle
	//----------------------------------

	/**
	 *  @inheritDoc
	 */
	override protected function get eventsToHandle():Array
	{
		return super.eventsToHandle.concat([ MenuEvent.ITEM_ROLL_OVER, MenuEvent.ITEM_ROLL_OUT, 
			MenuEvent.MENU_SHOW, MenuEvent.MENU_HIDE, MenuEvent.ITEM_CLICK ]);
	}

	//--------------------------------------------------------------------------
	//
	//  Overridden methods: AccessibilityImplementation
	//
	//--------------------------------------------------------------------------

	/**
	 * IAccessible method for returning system role for the component.
	 * System roles are predefined for all the components in MSAA.
	 * <p>A Menu component, ( <code>childID == 0</code> ), reports the role <code>ROLE_SYSTEM_MENUPOPUP</code> (0x0B).
	 * Items of a Menu component ( <code>childID >= 1</code> ) report the role <code>ROLE_SYSTEM_MENUITEM</code> (0x0C).</p>
	 *
	 * @param childID An unsigned integer corresponding to one of the component's child elements as defined by 
	 * <code><a href="#getChildIDArray()">getChildIDArray()</a></code>.
	 *
	 * @return Role associated with the component. 
	 *  
	 * @see ../../flash/accessibility/constants.html#roles AccessibilityImplementation Constants: Object Roles
	 * @see http://msdn.microsoft.com/en-us/library/ms696113(VS.85).aspx Microsoft Accessibility Developer Center: IAccessible::get_accRole
	 * @see http://msdn.microsoft.com/en-us/library/ms697502(VS.85).aspx Microsoft Accessibility Developer Center User Interface Element Reference: Pop-Up Menu
	 */
	override public function get_accRole(childID:uint):uint
	{
		//if it's the first child, it's the Menu itself
		if (childID == 0)
		{
			return role;			
		}

		//otherwise it's a menu item
		return ROLE_SYSTEM_MENUITEM;
	}

	 /**
	 *  IAccessible method for returning the value of the MenuItem/Menu
	 *  which is spoken out by the screen reader.
	 *  The Menu should return the name of the currently selected item (if any) when focus moves to Menu.
	 *
	 *  @param childID An unsigned integer corresponding to one of the component's child elements as defined by 
	 *  <code><a href="#getChildIDArray()">getChildIDArray()</a></code>.
	 *
	 *  @return Value String
	 * 
	 *  @see http://msdn.microsoft.com/en-us/library/ms697312(VS.85).aspx Microsoft Accessibility Developer Center: IAccessible::get_accValue
	 */
	override public function get_accValue(childID:uint):String
	{
		if (childID > 0)
			return "";

		var menu:Menu = Menu(master);
		var accValue:String = "";

		var selectedIndex:int = menu.selectedIndex;
		if (selectedIndex > -1)
		{
			var item:Object = menu.dataProvider.getItemAt(selectedIndex);

			accValue = menu.itemToLabel(item);
		}

		return accValue;
	}

	/**
	 *  IAccessible method for returning the state of the Menu.
	 *  States are predefined for all the components in MSAA.
	 *  Values are assigned to each state.
	 *  Depending upon the menuItem being Selected, Selectable,
	 *  Invisible, or Offscreen, a value is returned.
	 *
	 *  @param childID An unsigned integer corresponding to one of the component's child elements as defined by 
	 *  <code><a href="#getChildIDArray()">getChildIDArray()</a></code>.
	 *
	 *  @return State depending upon the menuItem being Unavailable, Hottracked, Focused, Checked, or Having a Pop-up
	 * 
	 *  @see #getChildIDArray()
	 *  @see flash.accessibility.AccessibilityImplementation#get_accState()
	 *  @see ../../flash/accessibility/constants.html#states AccessibilityImplementation Constants: Object State Constants
	 *  @see http://msdn.microsoft.com/en-us/library/ms696191(VS.85).aspx Microsoft Accessibility Developer Center: IAccessible::get_accState
	 */
	override public function get_accState(childID:uint):uint
	{
		var accState:uint = getState(childID);

		if (childID > 0 && childID < 100000)
		{
			var item:Object = Menu(master).dataProvider.getItemAt(childID - 1);
			var menu:Menu = Menu(master);
			var menuItem:MenuCellRenderer = menu.itemToCellRenderer(item) as MenuCellRenderer;
			if(!menuItem.enabled)
			{
				//using bitwise OR operations to mix together state information
				accState |= STATE_SYSTEM_UNAVAILABLE;
				return accState;
			}

			accState |= STATE_SYSTEM_HOTTRACKED | STATE_SYSTEM_FOCUSED;
			
			//see if it's checked, if it is a checkbox menu item
			if (menuItem.data.selected)
				accState |= STATE_SYSTEM_CHECKED;
				
			//see if it has a submenu
			if (menuItem.data.data)
				accState |= STATE_SYSTEM_HASPOPUP;
		}
		return accState;
	}

	/**
	 *  IAccessible method for returning the default action. For child menuItems, the default action 
	 *  is either Open or Execute depending on whether or 
	 *  not the menuItem is a branch or a leaf, but for the Menu component itself, <code>null</code> is returned. 
	 *
	 *  @param childID An unsigned integer corresponding to one of the component's child elements as defined by 
	 *  <code><a href="#getChildIDArray()">getChildIDArray()</a></code>.
	 *
	 *  @return DefaultAction String
	 *  @see http://msdn.microsoft.com/en-us/library/ms696144(VS.85).aspx Microsoft Accessibility Developer Center: IAccessible::get_accDefaultAction
	 *  @see http://msdn.microsoft.com/en-us/library/ms697502(VS.85).aspx Microsoft Accessibility Developer Center User Interface Element Reference: Pop-Up Menu
	 */
	override public function get_accDefaultAction(childID:uint):String
	{
		if (childID == 0)
			return null;

		var item:Object = Menu(master).dataProvider.getItemAt(childID - 1);

		var menuItem:MenuCellRenderer = Menu(master).itemToCellRenderer(item) as MenuCellRenderer;
		return menuItem.data.data ? "Open" : "Execute";
	}

	//--------------------------------------------------------------------------
	//
	//  Overridden methods: AccImpl
	//
	//--------------------------------------------------------------------------

	/**
	 *  Method for returning the name of the MenuItem/Menu
	 *  which is spoken out by the screen reader
	 *  The MenuItem should return the label as the name,
	 *  and Menu should return the name specified by its <code>AccessibilityProperties.name</code> property.
	 *
	 *  @param childID An unsigned integer corresponding to one of the component's child elements as defined by 
	 *  <code><a href="#getChildIDArray()">getChildIDArray()</a></code>.
	 *
	 *  @return Name of the MenuItem or Menu.
	 */
	override protected function getName(childID:uint):String
	{

		if (childID == 0 || childID > 100000)
			return "";

		var name:String;

		var menu:Menu = Menu(master);
		var item:Object = menu.dataProvider.getItemAt(Math.max(childID - 1, 0));

		name = menu.itemToLabel(item);

		return name;
	}

	//--------------------------------------------------------------------------
	//
	//  Overridden event handlers: AccImpl
	//
	//--------------------------------------------------------------------------

	/**
	 *  @inheritDoc
	 */
	override protected function eventHandler(event:Event):void
	{
		var index:int = 0;
		var childID:uint;

		switch (event.type)
		{
			case MenuEvent.ITEM_ROLL_OVER:
			{
				index = MenuEvent(event).index;
				if (index >= 0)
				{
					if(Accessibility.active) 
					{
				
						childID = index + 1;

						Accessibility.sendEvent(MenuEvent(event).menu, childID,
											EVENT_OBJECT_FOCUS);

						Accessibility.sendEvent(MenuEvent(event).menu, childID,
											EVENT_OBJECT_SELECTION);
					}
				}
				break;
			}

			case MenuEvent.ITEM_CLICK:
			{
				index = MenuEvent(event).menu.selectedIndex;
				if (index >= 0)
				{
					if(Accessibility.active) 
					{
				
						childID = index + 1;

						Accessibility.sendEvent(MenuEvent(event).menu, childID,
											EVENT_OBJECT_FOCUS);

						Accessibility.sendEvent(MenuEvent(event).menu, childID,
											EVENT_OBJECT_SELECTION);
					}
				}
				break;
			}

			case MenuEvent.MENU_SHOW:
			{
				if(Accessibility.active) 
				{
					//index = MenuEvent(event).index;
				//MenuEvent(event).menu.selectedIndex = 1;
					if (index == 0)
					
					
					{					
						//try
						{
							
						Accessibility.sendEvent(MenuEvent(event).menu, 0,
							EVENT_SYSTEM_MENUPOPUPSTART);
						}
						//catch(e:Error)
						{
							
						}
					}				
				//if (index >= 0)
				//{
				
				//MenuEvent(event).menu.dispatchEvent(new MenuEvent(MenuEvent.ITEM_ROLL_OVER, 
				//false, true, null, MenuEvent(event).menu, MenuEvent(event).menu.selectedItem, null, "hello", 0));
				
				/* childID = index + 1;
						Accessibility.sendEvent(MenuEvent(event).menu, childID,
											EVENT_OBJECT_FOCUS);

						Accessibility.sendEvent(MenuEvent(event).menu, childID,
											EVENT_OBJECT_SELECTION);  */
				}
				
				
				break;
			}

			case MenuEvent.MENU_HIDE:
			{
				if(Accessibility.active) 
				{
					if(!MenuEvent(event).menu.parentMenu)
					Accessibility.sendEvent(MenuEvent(event).menu, 0,
										EVENT_SYSTEM_MENUPOPUPEND);
				}
				break;
			}
			
		}
	}
}

}
