package org.handbones.mvcs 
{
	import org.handbones.core.IPageModel;
	import org.assetloader.core.IGroupLoader;
	import org.handbones.core.page.IPageViewMap;
	import org.handbones.core.page.IPageMediatorMap;
	import org.handbones.core.page.IPageCommandMap;
	import org.handbones.core.page.IPageInjector;

	/**
	 * @author Matan Uberstein
	 */
	public class PageCommand
	{
		[Inject]
		public var pageModel : IPageModel;

		[Inject]
		public var commandMap : IPageCommandMap;

		[Inject]
		public var injector : IPageInjector;

		[Inject]
		public var mediatorMap : IPageMediatorMap;

		[Inject]
		public var viewMap : IPageViewMap;

		[Inject]
		public var groupLoader : IGroupLoader;

		public function execute() : void
		{
		}
	}
}
