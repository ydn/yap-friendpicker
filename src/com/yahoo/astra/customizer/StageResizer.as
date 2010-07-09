package com.yahoo.astra.customizer
{
	import flash.display.Stage;
	import flash.display.*;
	import flash.events.EventDispatcher;
	import flash.external.*;
	import flash.events.*;
	import com.yahoo.astra.customizer.events.*;
	import com.yahoo.astra.customizer.net.LocalConnectionDispatcher;
	import flash.external.ExternalInterface;
	import flash.system.Capabilities;
	/**
	 * Sizes the application to fit into available space while maintaining aspect ratio.
	 *
	 * <ul>
	 * <li>Used by Customizer to resize the application to fit into the BadgeCentral preview area.</li>
	 * <li>If the application is larger than the available space, shrink to the largest possible size</li>
	 * <li>If the application is smaller than the available space, display at the actual size.</li> 
	 * </ul>
	 */
	public class StageResizer
	{
		/**
		 * @private (protected)
		 *
		 * The actual width of the application. 
		 */
		protected var _actualStageWidth:Number;
		
		/**
		 * Gets or sets the actual width of the stage.  This value will be used for any resizing algorithms.
		 *
		 */
		public function get actualStageWidth():Number
		{
			return _actualStageWidth;
		}
		
		/**
		 * @private (setter)
		 *
		 */
		public function set actualStageWidth(value:Number):void
		{
			_actualStageWidth = value;
			if(!isNaN(actualStageHeight))
			{
				_aspectRatio = actualStageWidth/actualStageHeight;
				_reverseAspectRatio = actualStageHeight/actualStageWidth;
			}
			else
			{
				_aspectRatio = actualStageWidth/_stage.stageHeight;
				_reverseAspectRatio = _stage.stageHeight/actualStageWidth;				
			}
		}
		
		/**
		 * @private (protected)
		 *
		 * The actual height of the application.
		 */
		protected var _actualStageHeight:Number;
		
		/**
		 * Gets or sets the actual height of the stage.  This value will be used for any resizing algorithms.
		 *
		 */
		public function get actualStageHeight():Number
		{
			return _actualStageHeight;
		}
		
		/**
		 * @private (setter)
		 *
		 */
		public function set actualStageHeight(value:Number):void
		{
			_actualStageHeight = value;
			if(!isNaN(actualStageWidth))
			{
				_aspectRatio = actualStageWidth/actualStageHeight;
				_reverseAspectRatio = actualStageHeight/actualStageWidth;
			}
			else
			{
				_aspectRatio = _stage.stageWidth/actualStageHeight;
				_reverseAspectRatio = actualStageHeight/_stage.stageWidth;				
			}
		}		
		
		/**
		 * @private (protected)
		 *
		 * Aspect ratio of the stage
		 */
		protected var _aspectRatio:Number;
		
		/**
		 * @private (protected)
		 *
		 * Reverse aspect ratio of the stage
		 */
		protected var _reverseAspectRatio:Number;
		
		/**
		 * @private (protected)
		 *
		 * Instance of the Stage
		 */
		protected var _stage:Stage;
		
		/**
		 * @private (protected)
		 *
		 * LocalConnectionDispatcher used to communicate through LocalConnection.
		 */		
		protected var _localConnectionDispatcher:LocalConnectionDispatcher;
		
		/**
		 * @private (protected)
		 *
		 * Holds the value for the current width of the application.
		 */
		protected var _currentWidth:Number;

		/**
		 * @private (protected)
		 *
		 * Holds the value for the current height of the application.
		 */		
		protected var _currentHeight:Number;
		
		/**
		 * Constructor
		 *
		 * @param thisStage 
		 * @param localConnectionDispatcher The <code>LocalConnectionDispatcher</code> instance to be used.
		 *
		 */
		public function StageResizer(thisStage:Stage, localConnectionDispatcher:LocalConnectionDispatcher)
		{
			_stage = thisStage;
			actualStageWidth = _stage.stageWidth;
			actualStageHeight = _stage.stageHeight;	
			_localConnectionDispatcher = localConnectionDispatcher;
			_localConnectionDispatcher.addEventListener(CustomizerEvent.RESIZE_APP, updateStageSize);
			_localConnectionDispatcher.sendData({currentWidth:_actualStageWidth, currentHeight:_actualStageHeight, actualWidth:_actualStageWidth, actualHeight:_actualStageHeight, type:"updateAppSizes"});
		}
		
		/**
		 * @private (protected)
		 *
		 * Event handler for the <code>CustomizerEvent.RESIZE_APP</code> event.  Passes the <code>availableWidth</code>
		 * and <code>availableHeight</code> values to the <code>measureDimensions</code> method.
		 *
		 * @param event
		 */
		protected function updateStageSize(event:CustomizerEvent):void
		{		
			measureDimensions(event.availableWidth, event.availableHeight);
		}
		
		/**
		 * @private (protected)
		 *
		 * Passes the <code>availableWidth</code> and <code>availableHeight</code> values to the <code>adjustDimensions</code> method if they are not 
		 * equal to the <code>stageWidth</code> and <code>stageHeight</code> values.  Passes dimensions parameters to the <code>sendData</code> method of 
		 * LocalConnectionDispatcher instance.
		 *
		 * @param availableWidth The maximum width available for the application to display.
		 * @param availableHeight The maximum height available for the application to display.
		 */
		protected function measureDimensions(availableWidth:Number, availableHeight:Number):void
		{
			if(_stage.stageWidth != availableWidth && _stage.stageHeight != availableHeight)
			{
				adjustDimensions(availableWidth, availableHeight);
			}	
			_localConnectionDispatcher.sendData({currentWidth:_currentWidth, currentHeight:_currentHeight, actualWidth:_actualStageWidth, actualHeight:_actualStageHeight, type:"updateAppSizes"});
		}
		
		/**
		 * @private (protected)
		 *
		 * Calculates the appropriate dimensions to display the application.
		 *
		 * @param availableWidth The maximum width available for the application to display.
		 * @param availableHeight The maximum height available for the application to display.
		 */
		protected function adjustDimensions(availableWidth:Number, availableHeight:Number):void
		{
			var availableRatio:Number = availableWidth/availableHeight;
			if(availableRatio >= _aspectRatio)
			{

				if(actualStageHeight > availableHeight)
				{	
					_currentWidth = availableHeight * _aspectRatio; 
					_currentHeight = availableHeight
				}
				else
				{	
					_currentWidth = actualStageWidth;
					_currentHeight = actualStageHeight;					
				}
			}
			else
			{
				//check width first
				if(actualStageWidth > availableWidth)
				{
					_currentWidth = availableWidth; 
					_currentHeight = availableWidth * _reverseAspectRatio;					
				}
				else
				{
					_currentWidth = actualStageWidth; 
					_currentHeight = actualStageHeight; 					
				}
			}
		}
		
	}
	
	
}