package org.handbones.controller 
{
	import org.assetloader.core.IGroupLoader;
	import org.handbones.core.IPage;
	import org.handbones.core.IPageModel;
	import org.handbones.core.page.IPageCommandMap;
	import org.handbones.core.page.IPageInjector;
	import org.handbones.core.page.IPageMediatorMap;
	import org.handbones.core.page.IPageViewMap;
	import org.robotlegs.mvcs.Command;

	/**
	 * @author Matan Uberstein
	 */
	internal class PageShutdownCompleteCommand extends Command 
	{
		override public function execute() : void 
		{
			injector.unmap(IPage);
			injector.unmap(IPageModel);
			injector.unmap(IPageCommandMap);
			injector.unmap(IPageInjector);
			injector.unmap(IPageMediatorMap);
			injector.unmap(IPageViewMap);
			injector.unmap(IGroupLoader);
		}
	}
}
