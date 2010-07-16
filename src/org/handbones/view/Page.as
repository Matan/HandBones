package org.handbones.view 
{
	import org.assetloader.core.IGroupLoader;
	import org.handbones.core.IPage;
	import org.handbones.core.IPageModel;
	import org.handbones.core.page.IPageCommandMap;
	import org.handbones.core.page.IPageInjector;
	import org.handbones.core.page.IPageMediatorMap;
	import org.handbones.core.page.IPageViewMap;
	import org.handbones.events.PageEvent;

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
		protected var _model : IPageModel;

		public function Page() 
		{
		}

		public function preStartup() : void
		{
			dispatch(new PageEvent(PageEvent.STARTUP, _model));
		}

		/**
		 * @inheritDoc
		 */
		public function startup() : void 
		{
			dispatch(new PageEvent(PageEvent.STARTUP_COMPLETE, _model));
		}

		/**
		 * @inheritDoc
		 */
		public function preShutdown() : void
		{
			dispatch(new PageEvent(PageEvent.SHUTDOWN, _model));

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
			dispatch(new PageEvent(PageEvent.SHUTDOWN_COMPLETE, _model));
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

		public function get model() : IPageModel
		{
			return _model;
		}

		[Inject]

		/**
		 * @private
		 */
		public function set model(value : IPageModel) : void
		{
			_model = value;
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

		public function get injector() : IPageInjector
		{
			return _model.injector;
		}

		public function get mediatorMap() : IPageMediatorMap
		{
			return _model.mediatorMap;
		}

		public function get commandMap() : IPageCommandMap
		{
			return _model.commandMap;
		}

		public function get viewMap() : IPageViewMap
		{
			return _model.viewMap;
		}

		public function get groupLoader() : IGroupLoader
		{
			return _model.groupLoader;
		}
	}
}
