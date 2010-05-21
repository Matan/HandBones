package org.handbones.base 
{
	import org.handbones.core.IPage;
	import org.handbones.core.wrappers.ICommandMapWrapper;
	import org.handbones.core.wrappers.IInjectorWrapper;
	import org.handbones.core.wrappers.IMediatorMapWrapper;
	import org.handbones.core.wrappers.IViewMapWrapper;
	import org.handbones.events.PageEvent;
	

	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;

	/**
	 * @author Matan Uberstein
	 */
	public class Page extends Sprite implements IPage 
	{
		/**
		 * @private
		 */
		protected var _eventDispatcher : IEventDispatcher;

		/**
		 * @private
		 */
		protected var _settings : PageSettings;

		/**
		 * @inheritDoc
		 */
		[Inject]
		public var injector : IInjectorWrapper;

		/**
		 * @inheritDoc
		 */
		[Inject]
		public var mediatorMap : IMediatorMapWrapper;

		/**
		 * @inheritDoc
		 */
		[Inject]
		public var commandMap : ICommandMapWrapper;

		/**
		 * @inheritDoc
		 */
		[Inject]
		public var viewMap : IViewMapWrapper;

		/**
		 * @inheritDoc
		 */
		[Inject]
		public var contextView : DisplayObjectContainer;

		
		public function Page() 
		{
		}

		public function preStartup() : void
		{
			dispatch(new PageEvent(PageEvent.STARTUP, _settings));
		}

		/**
		 * @inheritDoc
		 */
		public function startup() : void 
		{
			dispatch(new PageEvent(PageEvent.STARTUP_COMPLETE, _settings));
		}

		/**
		 * @inheritDoc
		 */
		public function preShutdown() : void
		{
			dispatch(new PageEvent(PageEvent.SHUTDOWN, _settings));

			while(numChildren > 0)
			{
				removeChild(getChildAt(0));
			}

			injector.unmapAll();
			commandMap.unmapEvents();
			mediatorMap.unmapViews();
			viewMap.unmap();
		}

		/**
		 * @inheritDoc
		 */
		public function shutdown() : void 
		{
			dispatch(new PageEvent(PageEvent.SHUTDOWN_COMPLETE, _settings));
		}

		/**
		 * @inheritDoc
		 */
		public function get eventDispatcher() : IEventDispatcher 
		{
			return _eventDispatcher;
		}

		[Inject]

		/**
		 * @private
		 */
		public function set eventDispatcher(value : IEventDispatcher) : void 
		{
			_eventDispatcher = value;
		}

		public function get settings() : PageSettings 
		{
			return _settings;
		}

		public function set settings(settings : PageSettings) : void 
		{
			_settings = settings;
		}

		/**
		 * Dispatch helper method
		 *
		 * @param event The <code>Event</code> to dispatch on the <code>IContext</code>'s <code>IEventDispatcher</code>
		 */
		protected function dispatch(event : Event) : Boolean 
		{
			if(eventDispatcher.hasEventListener(event.type))
 		        return eventDispatcher.dispatchEvent(event);
			return false;
		}
	}
}
