package org.handbones.base 
{
	import org.handbones.core.IActionMap;
	import org.handbones.events.NavigatorEvent;
	import org.handbones.events.TrackingEvent;
	import org.handbones.model.SettingsModel;

	import flash.events.Event;
	import flash.events.IEventDispatcher;

	/**
	 * @author Matan Uberstein
	 */
	public class ActionMap implements IActionMap
	{
		protected var _eventDispatcher : IEventDispatcher;

		protected var _actions : Array;
		protected var _mappings : Array;
		public function ActionMap(eventDispatcher : IEventDispatcher, actions : Array = null) 
		{
			_actions = actions;
			_eventDispatcher = eventDispatcher;
			_mappings = [];
		}

		public function mapAction(eventDispatcher : IEventDispatcher, reference : String, eventClass : Class = null, listener : Function = null, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = true) : void 
		{
			var matchedActions : Array = getActionsByRef(reference);
			
			eventClass = eventClass || Event;
			
			var mL : int = matchedActions.length;
			for(var a : int = 0;a < mL;a++) 
			{
				var action : Action = matchedActions[a];
				
				var callback : Function = function(event : Event):void
				{
					executeAction(event, action, listener);
				};
				
				var mapping : Mapping = new Mapping();
				mapping.eventDispatcher = eventDispatcher;
				mapping.eventClass = eventClass;
				mapping.callback = callback;
				mapping.useCapture = useCapture;
				mapping.action = action;				mapping.listener = listener;
			
				_mappings.push(mapping);
			
				eventDispatcher.addEventListener(action.event, callback, useCapture, priority, useWeakReference);
			}
		}

		public function unmapAction(eventDispatcher : IEventDispatcher, reference : String, eventClass : Class = null, useCapture : Boolean = false) : void 
		{
			var matchedActions : Array = getActionsByRef(reference);
			
			eventClass = eventClass || Event;
			
			var mL : int = matchedActions.length;
			for(var a : int = 0;a < mL;a++) 
			{
				var action : Action = matchedActions[a];
				
				var mapping : Mapping;
				var i : int = _mappings.length;
				while (i--)
				{
					mapping = _mappings[i];
					if (mapping.eventDispatcher == eventDispatcher && mapping.useCapture == useCapture && mapping.eventClass == eventClass && mapping.action == action)
					{
						eventDispatcher.removeEventListener(action.event, mapping.callback, useCapture);
						_mappings.splice(i, 1);
						return;
					}
				}
			}
		}

		public function unmapActions() : void
		{
			var mapping : Mapping;
			while (mapping = _mappings.pop())
			{
				mapping.eventDispatcher.removeEventListener(mapping.action.event, mapping.callback, mapping.useCapture);
			}
		}

		protected function executeAction(event : Event, action : Action, listener : Function = null) : void 
		{
			//Call custom listener
			if(listener != null)
				listener(event);
			
			//Navigation
			var navigatorEvent : NavigatorEvent = new NavigatorEvent(NavigatorEvent.HANDLE_ACTION);
			navigatorEvent.action = action;
			dispatch(navigatorEvent);
			
			//Tracking
			var tL : int = action.trackActions.length;
			for(var i : int = 0;i < tL;i++) 
			{
				var trackAction : TrackAction = action.trackActions[i];
				
				var trackingEvent : TrackingEvent = new TrackingEvent(TrackingEvent.TRACK);
				trackingEvent.url = trackAction.url;				trackingEvent.category = trackAction.category;				trackingEvent.action = trackAction.action || event.type;				trackingEvent.label = trackAction.label;				trackingEvent.value = trackAction.value;
				
				dispatch(trackingEvent);
			}
		}

		protected function getActionsByRef(reference : String) : Array 
		{
			var matched : Array = [];
			
			var dL : int = _actions.length;
			for(var i : int = 0;i < dL;i++) 
			{
				var action : Action = _actions[i];
				
				if(action.ref == reference)
					matched.push(action);
			}
			
			return matched;
		}

		protected function dispatch(event : Event) : Boolean
		{
			if(eventDispatcher.hasEventListener(event.type))
 		        return eventDispatcher.dispatchEvent(event);
			return false;
		}

		[Inject]

		public function set settingsModel(value : SettingsModel) : void 
		{
			_actions = _actions || value.actions;
		}

		public function get eventDispatcher() : IEventDispatcher
		{
			return _eventDispatcher;
		}

		[Inject]

		public function set eventDispatcher(value : IEventDispatcher) : void
		{
			_eventDispatcher = value;
		}
	}
}

import org.handbones.base.Action;

import flash.events.IEventDispatcher;

/**
 * @author Matan Uberstein
 */
class Mapping 
{
	public var eventDispatcher : IEventDispatcher;
	public var eventClass : Class;
	public var callback : Function;
	public var useCapture : Boolean;
	public var action : Action;
	public var listener : Function;
}
