package org.handbones.core 
{
	import org.assetloader.core.IGroupLoader;
	import org.handbones.core.page.IPageCommandMap;
	import org.handbones.core.page.IPageInjector;
	import org.handbones.core.page.IPageMediatorMap;
	import org.handbones.core.page.IPageViewMap;

	import flash.display.ISprite;

	/**
	 * @author Matan Uberstein
	 */
	public interface IPage extends ISprite 
	{
		/**
		 * Executes before <code>startup</code>. At default this will dispatch <code>PageEvent.STARTUP</code>.
		 * 
		 * @see org.handbones.events.PageEvent
		 */
		function preStartup() : void

		/**
		 * Executes when page is added to the stage. At default this will dispatch <code>PageEvent.STARTUP_COMPLETE</code>.
		 * This is ment to be overritten for your custom mappings to be made.
		 * This will decouple this page from the rest of the site and prevent cross compiling.
		 * 
		 * @see org.handbones.events.PageEvent
		 */
		function startup() : void 

		/**
		 * Executes before <code>shutdown</code>.
		 * At default this will:
		 * 	Dispatch <code>PageEvent.SHUTDOWN</code>.
		 * 	Remove all children from this page.
		 * 	Unmap all injections mappings made on this page.
		 * 	Unmap all commands mappings made on this page.
		 * 	Unmap all mediators mappings made on this page.
		 * 	Unmap all views mappings made on this page.
		 * 
		 * @see org.handbones.events.PageEvent
		 * @see org.handbones.core.wrappers.IInjectorWrapper		 * @see org.handbones.core.wrappers.IMediatorMapWrapper		 * @see org.handbones.core.wrappers.ICommandMapWrapper		 * @see org.handbones.core.wrappers.IViewMapWrapper
		 */
		function preShutdown() : void

		/**
		 * Executes when page is removed from the stage. At default this will dispatch <code>PageEvent.SHUTDOWN_COMPLETE</code>.
		 * Mostly overriding won't be needed as the <code>preShutdown</code> unmaps everything mapped on this page.
		 * 
		 * @see org.handbones.events.PageEvent
		 */
		function shutdown() : void

		function get model() : IPageModel 

		function set model(value : IPageModel) : void 

		function get injector() : IPageInjector

		function get mediatorMap() : IPageMediatorMap

		function get commandMap() : IPageCommandMap

		function get viewMap() : IPageViewMap

		function get groupLoader() : IGroupLoader
	}
}
