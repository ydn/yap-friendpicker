package com.yahoo.astra.fl.accessibility
{

import com.yahoo.astra.fl.controls.Tree;
import com.yahoo.astra.fl.controls.treeClasses.BranchNode;
import com.yahoo.astra.fl.controls.treeClasses.TNode;

import fl.accessibility.SelectableListAccImpl;
import fl.controls.listClasses.ICellRenderer;
import fl.core.UIComponent;
import fl.events.ListEvent;

import flash.accessibility.Accessibility;
import flash.events.Event;



/**
 * The TreeAccImpl class, also called the Tree Accessiblity Implementation class, 
 * is used to make a Tree component accessible.
 * 
 * <p>The TreeAccImpl class supports system roles, object-based events, and states.</p>
 * 
 * <p>A Tree reports the role <code>ROLE_SYSTEM_OUTLINE</code> (0x23) to a screen 
 * reader. Items of a Tree report the role <code>ROLE_SYSTEM_OUTLINEITEM</code> (0x24).</p>
 *
 * <p>A Tree reports the following states to a screen reader:</p>
 * <ul>
 *     <li><code>STATE_SYSTEM_NORMAL</code> (0x00000000)</li>
 *     <li><code>STATE_SYSTEM_UNAVAILABLE</code> (0x00000001)</li>
 *     <li><code>STATE_SYSTEM_FOCUSED</code> (0x00000004)</li>
 *     <li><code>STATE_SYSTEM_FOCUSABLE</code> (0x00100000)</li>
 * </ul>
 * 
 * <p>Additionally, items of a Tree report the following states:</p>
 * <ul>
 *     <li><code>STATE_SYSTEM_SELECTED</code> (0x00000002)</li>
 *     <li><code>STATE_SYSTEM_FOCUSED</code> (0x00000004)</li>
 *     <li><code>STATE_SYSTEM_INVISIBLE</code> (0x00008000)</li>
 *     <li><code>STATE_SYSTEM_OFFSCREEN</code> (0x00010000)</li>
 *     <li><code>STATE_SYSTEM_SELECTABLE</code> (0x00200000)</li>
 * 	   <li><code>STATE_SYSTEM_COLLAPSED</code> (0x00000400)</li>
 * 	   <li><code>STATE_SYSTEM_EXPANDED</code> (0x00000200)</li>
 * </ul>
 *
 * <p>A Tree dispatches the following events to a screen reader:</p>
 * <ul>
 *     <li><code>EVENT_OBJECT_FOCUS</code> (0x8005)</li>
 *     <li><code>EVENT_OBJECT_SELECTION</code> (0x8006)</li>
 *     <li><code>EVENT_OBJECT_STATECHANGE</code> (0x800A)</li>
 *     <li><code>EVENT_OBJECT_NAMECHANGE</code> (0x800C)</li>
 * </ul>
 *
 * @see com.yahoo.astra.fl.controls.Tree
 * @see fl.accessibility.AccImpl
 * @see http://msdn.microsoft.com/en-us/library/ms697605(VS.85).aspx Microsoft Accessibility Developer Center User Interface Element Reference: Tree View Control
 * 
 */
public class TreeAccImpl extends SelectableListAccImpl
{


	//--------------------------------------------------------------------------
	//
	//  Class initialization
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  Static variable triggering the <code>hookAccessibility()</code> method.
	 *  This is used for initializing <code>TreeAccImpl</code> class to hook its
	 *  <code>createAccessibilityImplementation()</code> method to the <code>Tree</code> class 
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
		Tree.createAccessibilityImplementation = createAccessibilityImplementation;

		return true;
	}

	//--------------------------------------------------------------------------
	//  Class constants
	//--------------------------------------------------------------------------
	
	/**
	 *  @private
	 *  Role of tree.
	 */
	private static const ROLE_SYSTEM_OUTLINE:uint =  0x23;
	
	/**
	 *  @private
	 *  Role of treeItem.
	 */
	private static const ROLE_SYSTEM_OUTLINEITEM:uint = 0x24; 

	/**
	 *  @private
	 */
	private static const STATE_SYSTEM_COLLAPSED:uint = 0x00000400;

	/**
	 *  @private
	 */
	private static const STATE_SYSTEM_EXPANDED:uint = 0x00000200;

	/**
	 *  @private
	 */
	private static const STATE_SYSTEM_FOCUSED:uint = 0x00000004;
	
	/**
	 *  @private
	 */
	private static const STATE_SYSTEM_INVISIBLE:uint = 0x00008000;
	
	/**
	 *  @private
	 */
	private static const STATE_SYSTEM_SELECTABLE:uint = 0x00200000;
	
	/**
	 *  @private
	 */
	private static const STATE_SYSTEM_SELECTED:uint = 0x00000002;
	
	/**
	 *  @private
	 *  An object has received the keyboard focus.
	 */
	private static const EVENT_OBJECT_FOCUS:uint = 0x8005; 
	
	/**
	 *  @private
	 *  The selection within a container object has changed.
	 */
	private static const EVENT_OBJECT_SELECTION:uint = 0x8006; 
	
	/**
	 *  @private
	 */
	private static const EVENT_OBJECT_STATECHANGE:uint = 0x800A;

	//--------------------------------------------------------------------------
	//
	//  Class methods
	//
	//--------------------------------------------------------------------------

	/**
	 *  Method for creating the Accessibility Implementation class for a component.
	 *  <p>This method is called by the <code>initializeAccessibility()</code> method for the <code>UIComponent</code> 
	 *  subclass when the component initializes.</p>
	 *  <p>All <code>AccImpl</code> subclasses must implement this method</p>
	 * 
	 *  @param component The UIComponent instance that this TreeAccImpl instance makes accessible.
	 * 
	 *  @see fl.accessibility.AccImpl#createAccessibilityImplementation()
	 *  @see fl.core.UIComponent#createAccessibilityImplementation() 
	 *  @see fl.core.UIComponent#initalizeAccessibility()
	 *  @see fl.core.UIComponent#initialize()
	 */
	public static function createAccessibilityImplementation(component:UIComponent):void
	{
		component.accessibilityImplementation = new TreeAccImpl(component);
	}

	/**
	 *  Method call for enabling accessibility for a component.
	 *  This method is required for the compiler to activate the accessibility classes for a component.
	 */
	public static function enableAccessibility():void
	{
		//empty
	}

	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 * Creates a new TreeAccImpl instance for the specified Tree component.
	 *
	 * @param master The UIComponent instance that this TreeAccImpl instance is making accessible.
	 * 
	 */
	public function TreeAccImpl(master:UIComponent)
	{
		super(master);

		role = ROLE_SYSTEM_OUTLINE;
	}

	//--------------------------------------------------------------------------
	//
	//  Overrides for AccImpl
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	//  eventsToHandle
	//----------------------------------

	/**
	 *	@inheritDoc
	 */
	override protected function get eventsToHandle():Array
	{
		return super.eventsToHandle.concat([Event.CHANGE, ListEvent.ITEM_CLICK, ListEvent.ITEM_DOUBLE_CLICK ]);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overridden methods: AccessibilityImplementation
	//
	//--------------------------------------------------------------------------

	/**
	 * IAccessible method for returning system role for the component.
	 * System roles are predefined for all the components in MSAA.
	 * <p>A Tree component, ( <code>childID == 0</code> ), reports the role <code>ROLE_SYSTEM_OUTLINE</code> (0x23).
	 * Items of a Tree ( <code>childID >= 1</code> ) report the role <code>ROLE_SYSTEM_OUTLINEITEM</code> (0x24).</p>
	 *
	 * @param childID An unsigned integer corresponding to one of the component's child elements as defined by 
	 * <code><a href="#getChildIDArray()">getChildIDArray()</a></code>.
	 *
	 * @return Role associated with the component. 
	 *  
	 * @see ../../flash/accessibility/constants.html#roles AccessibilityImplementation Constants: Object Roles
	 * @see http://msdn.microsoft.com/en-us/library/ms696113(VS.85).aspx Microsoft Accessibility Developer Center: IAccessible::get_accRole
	 * @see http://msdn.microsoft.com/en-us/library/ms697605(VS.85).aspx Microsoft Accessibility Developer Center User Interface Element Reference: Tree View Control
	 * 
	 */
	override public function get_accRole(childID:uint):uint
	{
		//return the Tree's role itself, or the role of the items
		if (childID == 0)
		{
			return role;			
		}

		return ROLE_SYSTEM_OUTLINEITEM;
	}

	/**
	 *  IAccessible method for returning the value of the TreeItem/Tree
	 *  which is spoken by the screen reader.
	 *  The Tree should return the name of the currently selected item
	 *  with an &quot;<code>m</code> of <code>n</code>&quot; string as its value.
	 *
	 *  @param childID uint
	 *
	 *  @return Value String
	 * 
	 *  @see http://msdn.microsoft.com/en-us/library/ms697312(VS.85).aspx Microsoft Accessibility Developer Center: IAccessible::get_accValue
	 *  @see http://msdn.microsoft.com/en-us/library/ms697605(VS.85).aspx Microsoft Accessibility Developer Center User Interface Element Reference: Tree View Control
	 */
	override public function get_accValue(childID:uint):String
	{
		var accValue:String = "";
		
		var tree:Tree = Tree(master);
		var index:int;
		var item:Object;

		if (childID == 0)
		{
			index = tree.selectedIndex;
			if (index > -1)
			{
				item = tree.dataProvider.getItemAt(index);
				if (!item)
					return accValue;
				
				if (tree.itemToLabel(item))
					accValue = tree.itemToLabel(item)
					
				//return the item plus its location
				accValue += getLocationDescription(item);
			}
		}
		else
		{
			// Assuming childID is always ItemID + 1
			// because getChildIDArray is not always invoked.
			index = childID - 1;
			if (index > -1)
			{
				item = tree.dataProvider.getItemAt(index);
				if (!item)
					return accValue;
				var node:TNode = item as TNode;
				accValue = node.nodeLevel + 1 + "";
			}
		}

		return accValue;
	}

	/**
	 *  IAccessible method for returning the state of the TreeItem.
	 *  States are predefined for all the components in MSAA.
	 *  Values are assigned to each state.
	 *  Depending upon the treeItem being Selected, Selectable,
	 *  Invisible, Offscreen, Expanded or Collapsed a value is returned.
	 *
	 *  @param childID An unsigned integer corresponding to one of the component's child elements as defined by 
	 *  <code><a href="#getChildIDArray()">getChildIDArray()</a></code>.
	 *
	 *  @return State depending upon the treeItem being Selected, Selectable,
	 *  Invisible, Offscreen, Expanded or Collapsed
	 * 
	 *
	 *  @see ../../flash/accessibility/constants.html#states AccessibilityImplementation Constants: Object State Constants
	 * 	@see http://msdn.microsoft.com/en-us/library/ms696191(VS.85).aspx Microsoft Accessibility Developer Center: IAccessible::get_accState
	 *  @see http://msdn.microsoft.com/en-us/library/ms697605(VS.85).aspx Microsoft Accessibility Developer Center User Interface Element Reference: Tree View Control
	 */
	override public function get_accState(childID:uint):uint
	{
		var accState:uint = getState(childID);
		
		if (childID > 0)
		{
			var tree:Tree = Tree(master);

			var index:int = childID - 1;

			// For returning states (OffScreen and Invisible)
			// when the list Item is not in the displayed rows.
			if (index < tree.verticalScrollPosition ||
				index >= tree.verticalScrollPosition + tree.rowCount)
			{
				accState |= STATE_SYSTEM_INVISIBLE;
			}
			else
			{
				accState |= STATE_SYSTEM_SELECTABLE;

				var item:Object = tree.dataProvider.getItemAt(index);
				var node:TNode = item as TNode;
		
				if (item && item is BranchNode)
				{
					if (BranchNode(item).isOpen())
						accState |= STATE_SYSTEM_EXPANDED;
					else
						accState |= STATE_SYSTEM_COLLAPSED;
				}

				var renderer:ICellRenderer = tree.itemToCellRenderer(item);

				if (renderer != null && tree.isItemSelected(renderer.data))
					accState |= STATE_SYSTEM_SELECTED | STATE_SYSTEM_FOCUSED;
			}
		}
		return accState;
	}

	/**
	 *  IAccessible method for returning the default action. For child treeItems, the default action is 
	 *  Expand or Collapse depending on the item state, but for the Tree component itself, 
	 *  <code>null</code> is returned. 
	 *
	 *  @param childID An unsigned integer corresponding to one of the component's child elements 
	 *  as defined by <code><a href="#getChildIDArray()">getChildIDArray()</a></code>.
	 *
	 *  @return DefaultAction String
	 *  @see http://msdn.microsoft.com/en-us/library/ms696144(VS.85).aspx Microsoft Accessibility Developer Center: IAccessible::get_accDefaultAction
	 *  @see http://msdn.microsoft.com/en-us/library/ms697605(VS.85).aspx Microsoft Accessibility Developer Center User Interface Element Reference: Tree View Control
	 */
	override public function get_accDefaultAction(childID:uint):String
	{
		if (childID == 0)
			return null;

		var tree:Tree = Tree(master);

		var item:Object = tree.dataProvider.getItemAt(childID - 1);
		if (!item)
			return null;
		
		if ( item is BranchNode)
			return BranchNode(item).isOpen() ? "Collapse" : "Expand";

		return null;
	}

	/**
	 * IAccessible method for performing the default action associated with a treeItem, 
	 * which is Expand or Collapse depending on the item state.
	 *
	 * @param childID An unsigned integer corresponding to one of the component's child elements 
	 * as defined by <code><a href="#getChildIDArray()">getChildIDArray()</a></code>.
	 * 
	 *  @see http://msdn.microsoft.com/en-us/library/ms696119(VS.85).aspx Microsoft Accessibility Developer Center: IAccessible::accDoDefaultAction
	 */
	override public function accDoDefaultAction(childID:uint):void
	{
		var tree:Tree = Tree(master);

		if (childID == 0 || !tree.enabled)
			return;

		var item:Object = tree.dataProvider.getItemAt(childID - 1);
		
		if (!item)
			return;
		
		if (item is BranchNode)
		{
			var node:BranchNode = item as BranchNode;
			
			if(node.isOpen()) node.closeNode();
			else node.openNode();
		}

	}

	/**
	 *  Method for returning the name of the TreeItem/Tree
	 *  which is spoken out by the screen reader.
	 *  The TreeItem should return the label as the name
	 *  with an &quot;<code>m</code> of <code>n</code>&quot; string and Tree should return the name
	 *  specified by the <code>AccessibilityProperties.name</code>.
	 *
	 *  @param childID uint
	 *
	 *  @return Name String
	 */
	override protected function getName(childID:uint):String
	{
		if (childID == 0)
			return "";

		var name:String = "";
		
		var tree:Tree = Tree(master);

		// Assuming childID is always ItemID + 1
		// because getChildIDArray is not always invoked.
		var index:int = childID - 1;
		if (index > -1)
		{
			var item:Object = tree.dataProvider.getItemAt(index);
			if (!item)
				return name;
		
		
			if (tree.itemToLabel(item))
				name = tree.itemToLabel(item);

			name += getLocationDescription(item);
		}
			
		return name;
	}

	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------


	/**
	 *  Returns a string with information about the location of a node within a tree structure. 
	 * 
	 * <p>E.g. "[item] 4 of 10 [items]"</p>
	 *
	 *  @param item Object
	 *
	 *  @return String.
	 */
	private function getLocationDescription(item:Object):String
	{
 		var tree:Tree = Tree(master);
		var i:int = 0;
		var n:int = 0;

		var node:TNode = item as TNode;
		var parent:BranchNode = node.parentNode;
		var childNodes:Array;
		/* if (node is BranchNode)
		{
			childNodes =  parent.children;
		}
		
		else 
		{ */
			//childNodes = tree.dataProvider.toArray();
			childNodes =  parent.children;
		//}
		
		if (childNodes)
		{
			n = childNodes.length;
			for (i = 0; i < n; i++)
			{
				//get the index of this node, in relation to sibling nodes
				if (item == childNodes[i])
					break;
			}
		}
		
		
		if (i == n)
			i = 0;

		//make it 1-based.
		if (n > 0)
			i++;
		
		return ", " + i + " of " + n; 
	}

	//--------------------------------------------------------------------------
	//
	//  Overridden event handlers: AccImpl
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 *  Override the generic event handler.
	 *  All AccImpl must implement this
	 *  to listen for events from its master component. 
	 *  Here we add a few events.
	 * 
     *  @param event The event object
     */
	override protected function eventHandler(event:Event):void
	{
		var index:int = Tree(master).selectedIndex;
		
		var childID:uint = index + 1;

		switch (event.type)
		{
			case Event.CHANGE:
			{
				if (index >= -1)
				{
					if(Accessibility.active) 
					{
						Accessibility.sendEvent(master, childID,
												EVENT_OBJECT_FOCUS);
	
						Accessibility.sendEvent(master, childID,
												EVENT_OBJECT_SELECTION);
					}
				}
				break;
			}
										
/* 			case TreeEvent.ITEM_OPEN:
			case TreeEvent.ITEM_CLOSE:
			{
				if (index >= -1)
				{
					if(Accessibility.active) 
					{
						Accessibility.sendEvent(master, childID,
											EVENT_OBJECT_STATECHANGE);
					}
				}
				break;
			} */
		}
	}
}

}
