package com.yahoo.astra.customizer.net
{
	import flash.net.LocalConnection;
	import flash.events.StatusEvent;
	import flash.events.EventDispatcher;
	import com.yahoo.astra.customizer.events.CustomizerEvent;
	import flash.external.ExternalInterface;
	
	/**
	 * LocalConnectionDispatcher extends EventDispatcher and manages LocalConnections for the
	 * Customizer and BadgeCentral.  It allows for one "sending" connection and one "receiving" connection.
	 * There is a single function that handles all received data and fires the appropriate customizer event
	 * based on the object's data.
	 *
	 */
	 //TB - This should be broken up into 2 classes.  A LocalConnectionDispatcher class which is agnostic and fires a single 
	 //event when the connection is received.  Have a wrapper class that listens for the event and fires necessary events based on 
	 //the data of the object.
	public class LocalConnectionDispatcher extends EventDispatcher
	{
		/**
		 * @private (protected)
		 *
		 * sending connection
		 *
		 */
		protected var _sendingConnection:LocalConnection;
		
		/**
		 * @private (protected)
		 *
		 * receiving connection
		 *	 
		 */
		protected var _receivingConnection:LocalConnection; 
		
		/**
		 * @private (protected)
		 *
		 * connection key for sending connection
		 */
		protected var _sendConnectionKey:String;

		/**
		 * @private (protected)
		 *
		 * connection key for receiving connection
		 *
		 */
		protected var _receivingConnectionKey:String;
		
		/**
		 * @private (protected)
		 *
		 * array of allowed domains
		 *
		 * @default ["*"]
		 */
		protected var _allowedSendingDomains:Array = [];
		
		/**
		 * @private (protected)
		 *
		 * array of allowed receiving domains
		 *
		 * @default ["*"]
		 *
		 */
		protected var _allowedReceivingDomains:Array = [];
		
		/**
		 * Constructor
		 *
		 *
		 */
		public function LocalConnectionDispatcher()
		{
			super();
		}
		
		/**
		 * Creates a local connection for sending data.
		 * <p>If the connection already exists, close the connection first.</p>
		 * <p>Allow all domains that exist in the <code>_allowedSendingConnections</code> array</p>
		 * <p>Set the value of <code>_sendConnectionKey</code> to that of the connection parameter</p>
		 *
		 * @param connection The value indicating the name of the LocalConnection.
		 */
		public function setSendingConnection(connection:String):void
		{
			if(connection == _sendConnectionKey)
			{
				try
				{
					_sendingConnection.close();
				}
				catch(e:Error)
				{
					//throw new Error(e);
				}
			}
			_sendingConnection = new LocalConnection();
			
			for(var i:int; i < _allowedSendingDomains.length;i++)
			{
				_sendingConnection.allowDomain(_allowedSendingDomains[i]);
			}
			
			_sendingConnection.addEventListener(StatusEvent.STATUS, sendStatus);
			_sendConnectionKey = connection;
			
		}
		
		/**
		 * Receives an object and passes it to the <code>_sendingConnection</code> LocalConnection.
		 *
		 * @param obj The information to be sent
		 */
		public function sendData(obj:Object):void
		{
			try
			{
				_sendingConnection.send(_sendConnectionKey, "connectionHandler", obj);
			}
			catch(e:Error)
			{
				//throw new Error(obj.type);
			}
		}
	
		/**
		 *  Creates a local connection for receiving data.
		 *
		 * @param connection The name of the connection.
		 */
		public function setReceivingConnection(connection:String):void
		{
			if(connection == _receivingConnectionKey)
			{
				try
				{
					_receivingConnection.close();
				}
				catch(e:Error)
				{
					//throw new Error(e);
				}
			}
			
			_receivingConnectionKey = connection;
			_receivingConnection = new LocalConnection();
			
			for(var i:int;i < _allowedReceivingDomains.length;i++)
			{
				_receivingConnection.allowDomain(_allowedReceivingDomains[i]);
			}
			
			_receivingConnection.client = this;
			
			try
			{
				_receivingConnection.connect(connection);
			}
			catch(e:ArgumentError)
			{
				//throw new Error("Failed to connect");
			}
		}
		
		/**
		 * Listener function for the <code>_receivingConnection</code>.  Fires customizer events
		 * based on the <code>type</code> attribute of the received param.
		 *
		 * @param obj The data that is received.
		 */
		public function connectionHandler(obj:Object):void
		{
			var customizerEvent:CustomizerEvent;
			
			if(obj.type == "registeredBindings")
			{
				customizerEvent = new CustomizerEvent(CustomizerEvent.REGISTERED_BINDINGS);
				customizerEvent.bindings = obj.bindings;
				customizerEvent.binding = obj.binding;
			}
			
			if(obj.type == "resizeApp")
			{
				customizerEvent = new CustomizerEvent(CustomizerEvent.RESIZE_APP);
				customizerEvent.availableWidth = obj.availableWidth;
				customizerEvent.availableHeight = obj.availableHeight;				
			}
			
			if(obj.type == "updateAppSizes")
			{
				customizerEvent = new CustomizerEvent(CustomizerEvent.UPDATE_APP_SIZES);
				customizerEvent.currentWidth = obj.currentWidth;
				customizerEvent.currentHeight = obj.currentHeight;
				customizerEvent.actualWidth = obj.actualWidth;
				customizerEvent.actualHeight = obj.actualHeight;
			}
			
			if(obj.type == "updateFlashParam")
			{
				customizerEvent = new CustomizerEvent(CustomizerEvent.UPDATE_FLASH_PARAM);
				customizerEvent.flashParams = obj.flashParams;
				customizerEvent.flashParam = obj.flashParam;								
			}
			
			if(obj.type == "newGroup")
			{
				customizerEvent = new CustomizerEvent(CustomizerEvent.NEW_GROUP);
				customizerEvent.group = obj;
			}
			
			dispatchEvent(customizerEvent);	
		}
		
		/**
		 * Captures send errors.
		 * 
		 * @param event The event that is received.
		 */
		protected function sendStatus(event:StatusEvent):void
		{
			switch(event.level)
			{
				case "status" :
					
				break;
				case "error" :
					//throw new Error("send failed");			
				break;
			}
		}	
		
		/**
		 * Overwrites the <code>_allowedSendingDomains</code> array.
		 *
		 * @param value The domains to be set.
		 */
		public function setSendingDomains(value:Array):void
		{
			_allowedSendingDomains = value;
		}
		
		/**
		 * Overwrites the <code>_allowedReceivingDomains</code> array.
		 *
		 * @param value The domains to be set.
		 */
		public function setReceivingDomains(value:Array):void
		{
			_allowedReceivingDomains = value;
		}
		
		/**
		 * Adds a new domain to the <code>_allowedSendingDomains</code> array.
		 *
		 * @param value The domain to be added.
		 *
		 */
		public function addSendingDomain(value:String):void
		{
			_allowedSendingDomains.push(value);
		}
		
		/**
		 * Adds a new domain to the <code>_allowedReceivingDomains</code> array.
		 *
		 * @param value The domain to be added.
		 *
		 */		
		public function addReceivingDomain(value:String):void
		{
			_allowedReceivingDomains.push(value);
		}
	}
}