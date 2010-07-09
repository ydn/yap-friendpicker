package com.yahoo.astra.mx.controls
{
	import com.yahoo.astra.mx.controls.friendSelectorClasses.FriendSelectorController;
	import com.yahoo.astra.mx.controls.friendSelectorClasses.FriendSelectorEvent;
	import com.yahoo.astra.mx.controls.friendSelectorClasses.IFriendSelector;
	import com.yahoo.astra.mx.core.yahoo_mx_internal;
	import com.yahoo.astra.mx.managers.AutoCompleteManager;
	import com.yahoo.social.YahooApplication;
	
	import flash.events.Event;
	
	import flexlib.controls.PromptingTextInput;
	
	import mx.core.IFactory;
	import mx.events.FlexEvent;
		
	use namespace yahoo_mx_internal;
	
	[Event(name="autoCompleteUpdate", type="flash.events.Event")]
	[Event(name="dataProviderUpdate", type="flash.events.Event")]
	[Event(name="selectionChange", type="com.yahoo.astra.mx.controls.friendSelectorClasses.FriendSelectorEvent")]
	[Event(name="connectionsError", type="com.yahoo.astra.mx.controls.friendSelectorClasses.FriendSelectorEvent")]
	
	/**
	 * A simple friend selector using a TextInput and AutoCompleteManager that loads and displays the connections of a YahooUser.
	 * @see YahooUser
	 * @see AutoCompleteManager
	 * @see FriendSelectorController
	 * @author zachg
	 * 
	 */	
	public class FriendSelector extends PromptingTextInput implements IFriendSelector
	{
		/**
		 * Storage variable for the selector controller class.
		 * @private
		 */		
		private var $controller:FriendSelectorController;
		
		/**
		 * Storage variable for the list item renderer.
		 * @private
		 */		
		private var $itemRenderer:IFactory;
		
		/**
		 * Storage variable for the lists data provider
		 * @private
		 */		
		private var $listDataProvider:Object;
		
		/**
		 * Class constructor 
		 */
		public function FriendSelector()
		{
			super();
			
			$controller = new FriendSelectorController();
			$controller.addEventListener("dataProviderUpdate", controller_handleDataUpdate);
			$controller.addEventListener('autoCompleteUpdate', controller_handleAutoCompleteUpdate);
			$controller.addEventListener("selection", controller_handleSelection);
			$controller.addEventListener("connectionsError", controller_handleConnectionsError);
			
			this.addEventListener(FlexEvent.CREATION_COMPLETE, handleCreationComplete);
		}
		
		/**
		 * Returns the instance of YahooSession for this component.
		 * @return 
		 * 
		 */
		[Bindable] public function get application():YahooApplication
		{
			return this.controller.application;
		}
		
		/**
		 * @private
		 * @param value
		 * 
		 */		
		public function set application(value:YahooApplication):void
		{
			this.controller.application = value;
		}
		
		/**
		 * Returns the FriendSelectorController for this component.
		 * @return 
		 * 
		 */		
		public function get controller():FriendSelectorController
		{
			return this.$controller;
		}
		
		/**
		 * Returns the currently selected item of the list.
		 * @return 
		 * 
		 */		
		[Bindable(event="propertyChange")]
		public function get selectedItem():Object
		{
			return this.controller.dropdown.selectedItem;
		}
		
		/**
		 * @private
		 * @param value
		 * 
		 */		
		public function set selectedItem(value:Object):void
		{
			this.controller.dropdown.selectedItem = value;
		}
		
		/**
		 * Returns the currently selected index of the list.
		 * @return 
		 * 
		 */		
		[Bindable(event="propertyChange")]
		public function get selectedIndex():int
		{
			return this.controller.dropdown.selectedIndex;
		}
		
		/**
		 * @private
		 * @param value
		 * 
		 */		
		public function set selectedIndex(value:int):void
		{
			this.controller.dropdown.selectedIndex = value;
		}
		
		/**
		 * Returns an array of the users connections.
		 * @return 
		 * 
		 */		
		public function get connections():Array
		{
			return this.controller.connections;
		}
		
		/**
		 * Returns the GUID of the user.
		 * @return 
		 * 
		 */		
		[Bindable] public function get guid():String
		{
			return this.controller.guid;
		}
		
		/**
		 * @private
		 * @param value
		 * 
		 */		
		public function set guid(value:String):void
		{
			this.controller.guid = value;
		}
		
		/**
		 * Returns the current sortField of the controller and its connections. 
		 * @return 
		 * 
		 */		
		[Bindable] public function get sortFields():String
		{
			return this.controller.sortFields;
		}
		
		/**
		 * @private
		 * @param value
		 * 
		 */		
		public function set sortFields(value:String):void
		{
			this.controller.sortFields = value;
		}
		
		/**
		 * Returns an array of '|' seperated fields to display in the default item renderer.
		 * @return 
		 * 
		 */		
		[Bindable] public function get labelFields():String
		{
			return this.controller.labelFields;
		}
		
		/**
		 * @private
		 * @param value
		 * 
		 */		
		public function set labelFields(value:String):void
		{
			this.controller.labelFields = value;	
		}
		
		/**
		 * Returns a boolean determining if the auto-complete drop-down is to be displayed.
		 * @return 
		 * 
		 */		
		[Bindable] public function get popUpEnabled():Boolean
		{
			return $controller.popUpEnabled;
		}
		
    	/**
		 * @private
		 * @param value
		 * 
		 */		
		public function set popUpEnabled(value:Boolean):void
		{
			$controller.popUpEnabled=value;
		}
		
		/**
		 * Returns a Boolean determining if the auto-complete should 
		 * auto-fill the text input with the label of the first result.
		 * @param value
		 * 
		 */		
		public function set autoFillEnabled(value:Boolean):void
		{
			$controller.autoFillEnabled=value;
		}
		
		/**
		 * @private
		 * @return 
		 * 
		 */	
		[Bindable] public function get autoFillEnabled():Boolean
		{
			return $controller.autoFillEnabled;
		}
		
		/**
		 * Returns the text input assigned to the auto complete manager.
		 * @return 
		 * 
		 */		
		[Bindable] public function get selectedCategory():Number
		{
			return $controller.selectedCategory;
		}
		
		/**
		 * @private
		 * @param value
		 * 
		 */		
		public function set selectedCategory(value:Number):void
		{
			$controller.selectedCategory = value;
		}
    	
    	/**
    	 * Returns the current data provider assigned to the drop-down list.
    	 * @return 
    	 * 
    	 */
    	[Bindable(event="propertyChange")]
    	public function get listDataProvider():Object
    	{
    		return this.$listDataProvider;
    	}
    	
    	/**
    	 * @private 
    	 * @param value
    	 * 
    	 */    	
    	public function set listDataProvider(value:Object):void
    	{
    		var oldListData:Object = $listDataProvider;
    		this.$listDataProvider = value;
    		this.controller.dropdown.dataProvider = this.$listDataProvider;
    		this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "listDataProvider", oldListData, $listDataProvider));
    	}
    	
    	/**
    	 * Returns the current item renderer of the drop-down list.
    	 * @return 
    	 * 
    	 */    	
    	public function get itemRenderer():IFactory
    	{
    		// this sucks.
    		return (this.systemManager) ? this.controller.dropdown.itemRenderer : $itemRenderer;
    	}
    	
    	/**
		 * @private
		 * @param value
		 * 
		 */		
		public function set itemRenderer(value:IFactory):void
    	{
    		$itemRenderer = value;
    		setDropdownItemRenderer();
    	}
    	
    	/**
    	 * Returns the auto complete manager for this component.
    	 * @return 
    	 * 
    	 */    	
    	public function get autoCompleteManager():AutoCompleteManager
    	{
    		return this.controller.autoCompleteManager;
    	}
		
		/**
		 * Handles the selection of a user in the drop-down list.
		 * @private
		 * @param event
		 * 
		 */		
		private function controller_handleSelection(event:Event):void
		{
			event.stopImmediatePropagation();
			
			if($controller.dropdown.selectedItem)
			{ 
				this.setSelection(this.length, this.length);
				
				var evt:FriendSelectorEvent = new FriendSelectorEvent(FriendSelectorEvent.SELECTION_CHANGE);
				this.dispatchEvent(evt);
			}
		}
		
		private function controller_handleConnectionsError(event:Event):void
		{
			event.stopImmediatePropagation();
			
			var evt:FriendSelectorEvent = new FriendSelectorEvent(FriendSelectorEvent.CONNECTIONS_ERROR);
			this.dispatchEvent(evt);
		}
		
		/**
		 * Handles the data provider change event in the controller to update the lists data.
		 * @private 
		 * @param event
		 * 
		 */		
		private function controller_handleDataUpdate(event:Event):void
		{
			this.listDataProvider = this.controller.dropdown.dataProvider;
			
			this.dispatchEvent(event.clone());
		}
		
		private function controller_handleAutoCompleteUpdate(event:Event):void
		{
			this.dispatchEvent(event.clone());
		}
		
		/**
		 * Handles the Flex creation complete event for the component.
		 * @private
		 * @param event
		 * 
		 */		
		private function handleCreationComplete(event:FlexEvent):void
		{
			$controller.target = this;
			
			setDropdownItemRenderer();
		}
		
		/**
		 * Helper function to set the item renderer of the dropdown assuming
		 * the component has been properly initialized.
		 * @private
		 * 
		 */		
		private function setDropdownItemRenderer():void
		{
			// need to make sure our TextInput and auto complete component is 
			// fully initialized before trying to grab the dropdown. 
			// TODO: there is a better way to do this, somehow.  
			if(this.systemManager && $itemRenderer)
				this.controller.dropdown.itemRenderer = $itemRenderer;
		}
	}
}