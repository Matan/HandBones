package org.handbones.core 
{
	import flash.events.IEventDispatcher;

	/**
	 * @author Matan Uberstein
	 * 
	 * Maintains a list of actions mapped for easy (lazy) unmapping.
	 */
	public interface IActionMap 
	{
		/**
		 * Map an action to an <code>IEventDispatcher</code>. Actions are defined in your init settings.
		 * 
		 * @param eventDispatcher The <code>IEventDispatcher</code> that will dispatch the event.
		 * @param reference <code>String</code> identifier to match with init settings.
		 * @param eventClass Optional <code>Event</code> class for a stronger mapping. Defaults to <code>flash.events.Event</code>.
		 * @param listener Optional <code>Event</code> handler that will execute before the action.
		 * @param useCapture
		 * @param priority
		 * @param useWeakReference
		 */
		function mapAction(eventDispatcher : IEventDispatcher, reference : String, eventClass : Class = null, listener : Function = null, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = true) : void 

		/**
		 * Unmap an action from an <code>IEventDispatcher</code>.
		 *
		 * @param eventDispatcher The <code>IEventDispatcher</code> the mapping was made to.
		 * @param reference <code>String</code> identifier to which the mapping was made.
		 * @param eventClass Optional <code>Event</code> class for a stronger mapping. Defaults to <code>flash.events.Event</code>.
		 * @param useCapture
		 */
		function unmapAction(eventDispatcher : IEventDispatcher, reference : String, eventClass : Class = null, useCapture : Boolean = false) : void 

		/**
		 * Unmaps all actions.
		 */
		function unmapActions() : void
	}
}
