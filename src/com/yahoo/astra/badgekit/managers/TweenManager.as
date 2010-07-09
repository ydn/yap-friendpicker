/*
Copyright (c) 2007 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package com.yahoo.astra.badgekit.managers
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import fl.core.UIComponent;
	import fl.transitions.easing.None;
	import flash.filters.BlurFilter;
	import com.yahoo.astra.badgekit.managers.*;
	import com.yahoo.astra.animation.Animation;
	import com.yahoo.astra.animation.AnimationEvent;
	
	/**
    * The tween manager class handles the tweens (animations) of components on show and hide events.
    *
    * @langversion ActionScript 3.0
	* @playerversion Flash 9
    * @author Allen Rabinovich
    */
	public class TweenManager extends EventDispatcher
	
	{
		/**
		* A dictionary of all tweens
		*/
		public var tweens:Dictionary;
		
		/**
		* A dictionary of all objects being tweened
		*/
		public var tweenObjects:Dictionary;
		
		/**
		 * A dictionary of targets mapped to the tween
		 */
		public var tweenTargets:Dictionary;
		
		/**
		* @private
		* The instance of this Singleton
		*/
		private static var instance:TweenManager;
		
		/**
		* @private
		* Whether the singleton is initialized
		*/
        private static var initialized:Boolean;
        
		/**
		* Singleton
		*/
		public static function getInstance():TweenManager 
		{
	         if (instance == null) 
	         {
	            instance = new TweenManager();
	            
	            initialized = true;
	            instance.tweens = new Dictionary();
			    instance.tweenObjects = new Dictionary();
			    instance.tweenTargets = new Dictionary();
	          }
	      		
	      	return instance;
       }

		/**
		* Constructor
		*/
		public function TweenManager () {
			if (initialized) 
			{
           		 throw new Error("Instantiation failed: Use TweenManager.getInstance()");
          	}
			
			
		}
		
		/**
		* Initialize a tween
		*
		* @param clip The element to be tweened
		* @param newVisibility Whether to animate the component to show, or to hide
		*/
		public function processTween (clip:UIComponent, newVisibility:Boolean) : void  {
			var onShowTween:String = clip.getStyle("onShow") as String;
			var onHideTween:String = clip.getStyle("onHide") as String;		
			var tweenData:Object;
			var newTween:Animation;
			var parameters:Object = {};
			
			if (newVisibility == true && onShowTween != null && tweens[onShowTween] != null) {
				clip.setStyle("newVisibility", true);
				clip.filters = [new BlurFilter(0,0,0)];
				clip.visible = true;
				tweenData = tweens[onShowTween];
				clip[tweenData.property] = tweenData.startval;
				parameters[tweenData.property] = tweenData.endval;
				newTween = Animation.create(clip, (tweenData.duration*1000), parameters, tweenData.autoStart, tweenData.clearAllRunning);
				tweenObjects[newTween] = newTween;
				tweenTargets[newTween] = clip;
				newTween.addEventListener(AnimationEvent.COMPLETE, finishTween);
				newTween.addEventListener(AnimationEvent.UPDATE, traceTween);
			}
			else if (newVisibility == false && onHideTween != null && tweens[onHideTween] != null) {
				clip.setStyle("newVisibility", false);
				clip.filters = [new BlurFilter(0,0,0)];
				tweenData = tweens[onHideTween];
				parameters[tweenData.property] = tweenData.endval;
				newTween = Animation.create(clip, (tweenData.duration*1000), parameters, tweenData.autoStart, tweenData.clearAllRunning);	
				newTween.addEventListener(AnimationEvent.COMPLETE, finishTween);
				newTween.addEventListener(AnimationEvent.UPDATE, traceTween);				
				tweenObjects[newTween] = newTween;
				tweenTargets[newTween] = clip;
			}
			else {
				clip.visible = newVisibility;
			}			
		}
		
		/**
		* Performs necessary steps to conclude a tween
		* 
		* @param evt The COMPLETE event associated with a particular Animation	
		*/
		public function finishTween(evt:AnimationEvent) : void {
			var currentElement:UIComponent = tweenTargets[evt.currentTarget] as UIComponent;
			var newVisibility:Boolean = currentElement.getStyle("newVisibility") as Boolean;
			if (!newVisibility) {
				currentElement.visible = false;
				currentElement.cacheAsBitmap = false;
			}
			currentElement.filters = [];
			delete tweenObjects[evt.currentTarget];
			delete tweenTargets[evt.currentTarget];
		}
		
		/**
		* 
		* @private
		*/
		public function traceTween (evt:AnimationEvent) : void {
			var mtw:Animation = evt.currentTarget as Animation;
		}
		
		
	}
}