package com.yahoo.astra.mx.controls.friendSelectorClasses
{
	import com.adobe.serialization.json.JSON;
	import com.adobe.serialization.json.JSONParseError;
	import com.yahoo.astra.mx.managers.AutoCompleteManager;
	import com.yahoo.social.YahooApplication;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.controls.TextInput;
	import mx.controls.listClasses.ListBase;
	import mx.events.DropdownEvent;
	import mx.events.ListEvent;
	import mx.utils.StringUtil;
	
	/**
	 * Controller object providing data to a FriendSelector
	 * @see FriendSelector
	 * @author zachg
	 * 
	 */	
	public class FriendSelectorController extends EventDispatcher
	{
		/**
		 * Default start parameter.
		 */		
		private static const CONNECTION_START:int = 0;
		
		/**
		 * Default count parameter
		 */		
		private static const CONNECTION_COUNT:int = 5000;
		
		// component/view properties
		
		/**
		 * Storage variable containing the default sort field.
		 * @private
		 */		
		private var $sortFields:String = 'givenName|familyName';
		
		/**
		 * Storage variable containing the default label field.
		 * @private
		 */		
		private var $defaultLabelField:String = "nickname";
		
		/**
		 * Storage variable containing an array of '|' seperated fields to display in the default item renderer.
		 * @private
		 */		
		private var $labelFields:String = null;
		
		/**
		 * Storage variable determining the minimum character count to use auto-fill.
		 * @private
		 */		
		private var $minCharsForCompletion:int;
		
		/**
		 * Storage variable for the text input assigned to the auto complete manager.
		 * @private
		 */		
		private var $target:TextInput;
		
		// yahoo user properties		
		
		/**
		 * Storage variable containing the GUID of the user to use in the request.
		 * @private
		 */		
		private var $guid:String;
		
		/**
		 * Storage variable containing whether the GUID has changed since the last request.
		 * @private
		 */		
		private var $guidChanged:Boolean=false;
		
		// yahoo data objects
		
		/**
		 * Storage variable containing the yahoo application objet.
		 * @private
		 */		
		private var $application:YahooApplication;
		
		// response data
		/**
		 * Storage variable containing an ArrayCollection of profiles of the users connections.
		 * @private
		 */		
		private var $relations:ArrayCollection = new ArrayCollection();
		
		/**
		 * 
		 */
		private var $selectedCategory:Number = 0;
		private var $categories:ArrayCollection = new ArrayCollection();
		
		public static var RELATION_CATEGORIES:ArrayCollection = new ArrayCollection([
			{data:0, label:'All'}, 
			{data:-1401, label:'Friends'}, 
			{data:-1412, label:'Address Book'}, 
			{data:-1413, label:'Messenger'}
		]);
		
		/**
		 * Storage variable containing the lists sorted data provider.
		 * @private
		 */		
		private var $listDataProvider:ArrayCollection;
		
		/**
		 * Storage variable containing the data cache for all request.
		 * @private
		 */		
		private var $dataCache:ArrayCollection;
		
		// utils
		/**
		 * Storage variable containing the auto complete manager.
		 * @private
		 */		
		protected var $autoCompleteManager:AutoCompleteManager;
		
		/**
		 * Creates a new FriendSelectorController object.
		 * 
		 */		
		public function FriendSelectorController()
		{
			$dataCache = new ArrayCollection();
			
			$autoCompleteManager = new AutoCompleteManager();
			$autoCompleteManager.addEventListener('dataProviderUpdated', handleAutoCompleteDataProviderUpdated);
			$autoCompleteManager.addEventListener(ListEvent.CHANGE, handleAutoCompleteListChange);
			$autoCompleteManager.addEventListener(DropdownEvent.CLOSE, handleAutoCompleteListClose);
			$autoCompleteManager.filterFunction = this.autoCompleteFilterFunction;
			$autoCompleteManager.labelFunction = this.autoCompleteLabelFunction;
			$autoCompleteManager.minCharsForCompletion = 0;
		}
		
		/**
		 * Returns a boolean determining if the pop-up is enabled.
		 * @return 
		 * 
		 */		
		public function get popUpEnabled():Boolean
		{
			return $autoCompleteManager.popUpEnabled;
		}
		
		/**
		 * @private
		 * @param value
		 * 
		 */		
		public function set popUpEnabled(value:Boolean):void
		{
			$autoCompleteManager.popUpEnabled=value;
		}
		
		/**
		 * @private
		 * @param value
		 * 
		 */		
		public function set autoFillEnabled(value:Boolean):void
		{
			$autoCompleteManager.autoFillEnabled=value;
		}
		
		/**
		 * Returns a boolean determining if the auto-fill functionality should be enabled.
		 * @return 
		 * 
		 */		
		public function get autoFillEnabled():Boolean
		{
			return $autoCompleteManager.autoFillEnabled;
		}
		
		/**
		 * Returns a number containing the minimum character count to use auto-fill.
		 * @return 
		 * 
		 */		
		public function get minCharsForCompletion():int 
		{
			return $autoCompleteManager.minCharsForCompletion;
		}
		
		/**
		 * @private
		 * @param value
		 * 
		 */		
		public function set minCharsForCompletion(value:int):void
		{
			this.$autoCompleteManager.minCharsForCompletion = value;
		}
		
		/**
		 * Returns the GUID of the user.
		 * @return 
		 * 
		 */
		public function get guid():String
		{
			return $guid;
		}
		
		/**
		 * @private
		 * @param value
		 * 
		 */		
		public function set guid(value:String):void
		{
			if(value && value != guid)
			{	
				var oldGuid:String = $guid;
				$guid = value;
				$guidChanged = (oldGuid != $guid);
				
				watchSession();
			}
		}
		
		/**
		 * Returns a string containing the default sort field.
		 * @return 
		 * 
		 */
		public function get sortFields():String
		{
			return $sortFields;
		}
		
		/**
		 * @private
		 * @param value
		 * 
		 */		
		public function set sortFields(value:String):void
		{
			$sortFields = value;
			
			setConnectionsDataProvider($relations.source);
		}
		
		/**
		 * Returns a string containing an array of '|' seperated fields to display in the default item renderer.
		 * @return 
		 * 
		 */		
		[Bindable] public function get labelFields():String
		{
			return $labelFields;
		}
		
		/**
		 * @private
		 * @param value
		 * 
		 */		
		public function set labelFields(value:String):void
		{
			$labelFields = value;	
		}
		
		/**
		 * Returns the YahooSession assigned to the controller. 
		 * @return 
		 * 
		 */		
		public function get application():YahooApplication
		{
			return $application;
		}
		
		/**
		 * @private
		 * @param value
		 * 
		 */		
		public function set application(value:YahooApplication):void
		{
			$application = value;
			watchSession();
		}
		
		/**
		 * Returns the text input assigned to the auto complete manager.
		 * @return 
		 * 
		 */		
		public function get selectedCategory():Number
		{
			return this.$selectedCategory;
		}
		
		/**
		 * @private
		 * @param value
		 * 
		 */		
		public function set selectedCategory(value:Number):void
		{
			$selectedCategory = value;
			setTargetDropdownDataProvider();
		}
		
		/**
		 * Returns the text input assigned to the auto complete manager.
		 * @return 
		 * 
		 */		
		public function get target():TextInput
		{
			return $target;
		}
		
		/**
		 * @private
		 * @param value
		 * 
		 */		
		public function set target(value:TextInput):void
		{
			$target = value;
			
			$autoCompleteManager.target = $target;
			
			setTargetDropdownDataProvider();
		}
		
		/**
		 * Returns the ListBase created by the auto complete manager.
		 * @return 
		 * 
		 */		
		public function get dropdown():ListBase
		{
			return this.$autoCompleteManager.getDropdownForTarget(this.target);
		}
		
		/**
		 * Returns the auto complete manager instance.
		 * @return 
		 * 
		 */		
		public function get autoCompleteManager():AutoCompleteManager
		{
			return this.$autoCompleteManager;
		}
		
		/**
		 * Returns an array of the users connections.
		 * @return 
		 * 
		 */		
		public function get connections():Array
		{
			return $relations.source.concat();
		}
		
		//////////////////////////////////////////
		// Private functions
		//////////////////////////////////////////
		
		/**
		 * Watches the session for the currently assigned user.
		 * to fetch connections for.
		 * @private
		 * 
		 */		
		private function watchSession():void
		{
			if(this.$application && this.$application.token)
			{
				getConnections();
			}
		}
		
		/**
		 * Event handler for when the access token assigned to the session changes, we have to refresh the user & connections.
		 * @param event
		 * @private
		 */		
		private function handleSessionAccessTokenChange(event:Event):void
		{
			watchSession();
		}
		
		/**
		 * Fetches the connections for the current user using YQL.
		 * @private
		 */		
		private function getConnections():void
		{
			var categories:ArrayCollection = RELATION_CATEGORIES;
			var category_ids:Array = [];
			
			for each(var category:Object in categories.source) {
				category_ids.push( category.data );
			}
			
			var guid:String = this.guid || this.$application.guid();
			var query:String = "select * from social.relationships("+CONNECTION_START+","+CONNECTION_COUNT+") where owner_guid='"+guid+"' and categories in ("+ category_ids.join(',') +") and profile is not null;";
			
			this.$application.yql(query, {
				success: handleConnectionsYQLSuccess,
				failure: handleConnectionsYQLFailure
			}, 'GET', {debug:true, diagnostics:true});
		}
		
		private function parseResponse(response:Object):*
		{
			var data:* = null;
			if(response.hasOwnProperty('responseText') && !!response.responseText) {
				if(response.xmlParseSuccess) {
					data = response.responseXML;
				} else {
					try {
						data = JSON.decode(response.responseText, true);
					} catch(error:JSONParseError) {
						data = response.responseText;						
					}
				}
			}
			
			return data;
		}
		
		private function handleConnectionsYQLFailure(response:Object):void
		{
			this.dispatchEvent(new Event('connectionsError'));
		}
		
		/**
		 * Handles the success response from YQL.
		 * @param event
		 * @private
		 */		
		private function handleConnectionsYQLSuccess(response:Object):void
		{
			var data:Object = this.parseResponse(response) as Object;
			
			if(data.query && data.query.results) {
				var relations:Array = data.query.results.relation;
				this.setConnectionsDataProvider(relations);
			} else {
				handleConnectionsYQLFailure(response);
			}
		}
		
		/**
		 * Sorts and sets the users connections into the dropdown and auto-complete dataproviders.  
		 * @param value
		 * @private
		 */		
		private function setConnectionsDataProvider(value:Array):void
		{
			if(value) {
				this.$relations = new ArrayCollection(value);
				
				for each(var relation:Object in $relations) {
					var cats:Array = (relation.categories is String) ? new Array(relation.categories) : relation.categories;
					
					relation.categories = [];
					for each(var cat:Number in cats) {
						relation.categories.push(cat);
					}
					
					if(relation.profile.givenName && relation.profile.familyName) {
						relation.label = relation.profile.givenName + ' ' + relation.profile.familyName; 
					} else if(relation.profile.nickname) {
						relation.label = relation.profile.nickname;
					}
					
				}
				
				$relations.source.sortOn('label');
				this.setTargetDropdownDataProvider();
			}
		}
		
		
		private function setTargetDropdownDataProvider():void
		{
			if(this.target && this.dropdown && this.$relations) {
				
				var dataProvider:ArrayCollection;
				if($selectedCategory == 0) {
					dataProvider = $relations;
				} else {
					dataProvider = new ArrayCollection();
					
					for each(var relation:Object in $relations) {
						var categories:Array = (relation.categories as Array);
						
						if(categories.indexOf($selectedCategory) != -1) {
							dataProvider.addItem(relation);
						}
					}
				}
				
				this.dropdown.dataProvider = this.$autoCompleteManager.dataProvider = dataProvider;
				
				this.dispatchEvent(new Event("dataProviderUpdate"));
			}
		}
		
		//////////////////////////////////////////
		// Protected Functions
		//////////////////////////////////////////
		
		/**
		 * Normalizes a string.
		 * @param query
		 * @return 
		 * 
		 */		
		protected function normalize(str:String):String 
		{
			return str.replace(/,/g," ").replace(/\s\s*/g," ").toLowerCase();
		}
		
		/**
		 * Retrieves an ArrayCollection of connections from the cache based on a keyed id.
		 * @param id
		 * @return 
		 * 
		 */		
		protected function getCachedItem(id:String):ArrayCollection
		{
			for each(var item:Object in $dataCache)
			{
				if(item.id === id)
				{
					return item.connections as ArrayCollection;
				}
			}
			return null;
		}
		
		/**
		 * Event handler for the when the drop down auto complete list changes items.
		 * @param event
		 * 
		 */		
		protected function handleAutoCompleteListChange(event:ListEvent):void
		{
			var index:int = event.rowIndex;
			var selectedItem:Object;
			
			if(index != -1) {
				selectedItem = AutoCompleteManager(event.currentTarget).dataProvider.getItemAt(event.rowIndex);
			}
		}
		
		protected function handleAutoCompleteDataProviderUpdated(event:Event):void
		{
			this.dispatchEvent(new Event('autoCompleteUpdate'));
		}
		
		/**
		 * Event handler for when the drop down auto complete list closes indicating a selection has been made.
		 * @param event
		 * 
		 */		
		protected function handleAutoCompleteListClose(event:DropdownEvent):void
		{
			if(this.dropdown.selectedItem)
			{
				// TODO, make a better event
				this.dispatchEvent(new Event("selection"));
			}
		}
		
		/**
		 * Event handler for when the auto complete data provider has been updated. 
		 * @param event
		 * 
		 */		
		protected function handleAutoCompleteDataProviderUpdate(event:Event):void
		{
			this.dispatchEvent(event.clone());
		}
		
		/**
		 * The default labelFunction supplied to the auto complete manager.
		 * @param item
		 * @return 
		 * 
		 */		
		protected function autoCompleteLabelFunction(item:Object):String
		{
			return item.label;
		}
		
		/**
		 * The default filterFunction supplied to the auto complete manager.
		 * @param element
		 * @param text
		 * @return 
		 * 
		 */		
		protected function autoCompleteFilterFunction(element:*, text:String):Boolean
		{
			var itemTxt:String = " "+this.normalize($autoCompleteManager.itemToLabel(element).toLowerCase());
	    	var searchTxt:String = " "+StringUtil.trim(text).toLowerCase();
	    	
	    	return itemTxt.indexOf(searchTxt) != -1;
		}
		
		/**
		 * Resets the controller of its data.
		 * 
		 */		
		protected function reset():void
		{
			$relations = null;
			$application = null;
			$guid = null;
			$dataCache = null;
		}
		
	}
}