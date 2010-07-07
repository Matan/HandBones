package org.handbones.base 
{
	import org.handbones.core.IActionMap;
	import org.handbones.events.ActionMapEvent;
	import org.handbones.model.vo.ActionVO;

	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;

	/**
	 * @author Matan Uberstein
	 */
	public class ActionMap implements IActionMap
	{
		protected var _eventDispatcher : IEventDispatcher;

		protected var _actions : Array;
		protected var _mappings : Array;

		protected var _rollOverType : String;		protected var _rollOutType : String;
		public function ActionMap(eventDispatcher : IEventDispatcher, actions : Array) 
		{
			_actions = actions;
			_eventDispatcher = eventDispatcher;
			_mappings = [];
			
			_rollOverType = MouseEvent.ROLL_OVER;			_rollOutType = MouseEvent.ROLL_OUT;
		}

		public function mapAction(eventDispatcher : IEventDispatcher, reference : String, eventClass : Class = null, listener : Function = null, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = true) : void 
		{
			var matchedActions : Array = getActionsByRef(reference);
			
			eventClass = eventClass || Event;
			
			var mL : int = matchedActions.length;
			for(var a : int = 0;a < mL;a++) 
			{
				var action : ActionVO = matchedActions[a];
				
				var mapping : Mapping = new Mapping();
				
				mapping.eventDispatcher = eventDispatcher;
				mapping.eventClass = eventClass;
				mapping.useCapture = useCapture;
				mapping.listener = listener;
				mapping.action = action;
				
				mapping.callback = function(event : Event):void
				{
					if(listener != null)
						listener(event);
				
					dispatch(new ActionMapEvent(ActionMapEvent.EXECUTE, action));
				};
				eventDispatcher.addEventListener(action.event, mapping.callback, useCapture, priority, useWeakReference);
				
				//Check if action should show status and if action is navigational.
				if(action.showStatus && (action.gotoPageId || action.changeAddress || action.invokeUrl))
				{
					//Rollover callback
					mapping.statusRolloverCallback = function(event : MouseEvent):void
					{
						dispatch(new ActionMapEvent(ActionMapEvent.SET_STATUS, action));
					};
					eventDispatcher.addEventListener(_rollOverType, mapping.statusRolloverCallback, useCapture, priority, useWeakReference);
					
					//Rollout callback
					mapping.statusRolloutCallback = function(event : MouseEvent):void
					{
						dispatch(new ActionMapEvent(ActionMapEvent.REMOVE_STATUS, action));
					};
					eventDispatcher.addEventListener(_rollOutType, mapping.statusRolloutCallback, useCapture, priority, useWeakReference);
				}
				
				_mappings.push(mapping);
			}
		}

		public function unmapAction(eventDispatcher : IEventDispatcher, reference : String, eventClass : Class = null, useCapture : Boolean = false) : void 
		{
			var matchedActions : Array = getActionsByRef(reference);
			
			eventClass = eventClass || Event;
			
			var mL : int = matchedActions.length;
			for(var a : int = 0;a < mL;a++) 
			{
				var action : ActionVO = matchedActions[a];
				
				var mapping : Mapping;
				var i : int = _mappings.length;
				while (i--)
				{
					mapping = _mappings[i];
					
					if(mapping.eventDispatcher == eventDispatcher && mapping.useCapture == useCapture && mapping.eventClass == eventClass && mapping.action == action)
					{
						removeMappingListeners(mapping);
							
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
				removeMappingListeners(mapping);
			}
		}

		protected function getActionsByRef(reference : String) : Array 
		{
			var matched : Array = [];
			
			var dL : int = _actions.length;
			for(var i : int = 0;i < dL;i++) 
			{
				var action : ActionVO = _actions[i];
				
				if(action.ref == reference)
					matched.push(action);
			}
			
			return matched;
		}

		protected function removeMappingListeners(mapping : Mapping) : void
		{
			var eventDispatcher : IEventDispatcher = mapping.eventDispatcher;
			var action : ActionVO = mapping.action;
				
			eventDispatcher.removeEventListener(action.event, mapping.callback, mapping.useCapture);
				
			if(mapping.statusRolloverCallback != null)
				eventDispatcher.removeEventListener(_rollOverType, mapping.statusRolloverCallback, mapping.useCapture);
							
			if(mapping.statusRolloutCallback != null)
				eventDispatcher.removeEventListener(_rollOutType, mapping.statusRolloutCallback, mapping.useCapture);
		}

		protected function dispatch(event : Event) : Boolean
		{
			if(_eventDispatcher.hasEventListener(event.type))
 		        return _eventDispatcher.dispatchEvent(event);
			return false;
		}
	}
}

import org.handbones.model.vo.ActionVO;

import flash.events.IEventDispatcher;

/**
 * @author Matan Uberstein
 */
class Mapping 
{
	public var eventDispatcher : IEventDispatcher;
	public var eventClass : Class;
	public var callback : Function;	public var statusRolloverCallback : Function;	public var statusRolloutCallback : Function;
	public var useCapture : Boolean;
	public var action : ActionVO;

	public var listener : Function;
}
