package org.handbones.controller 
{
	import org.assetloader.core.IAssetLoader;
	import org.assetloader.core.IGroupLoader;
	import org.handbones.core.IPage;
	import org.handbones.core.IPageModel;
	import org.handbones.core.page.IPageCommandMap;
	import org.handbones.core.page.IPageInjector;
	import org.handbones.core.page.IPageMediatorMap;
	import org.handbones.core.page.IPageViewMap;
	import org.handbones.events.PageEvent;
	import org.handbones.model.SettingsModel;
	import org.robotlegs.mvcs.Command;

	/**
	 * @author Matan Uberstein
	 */
	internal class PageStartupCommand extends Command 
	{

		[Inject]
		public var event : PageEvent;

		[Inject]
		public var settingsModel : SettingsModel;

		[Inject]
		public var assetLoader : IAssetLoader;

		override public function execute() : void 
		{
			var model : IPageModel = event.model;
			
			injector.mapValue(IPage, assetLoader.getAsset(model.id));
			injector.mapValue(IPageModel, model);			injector.mapValue(IPageCommandMap, model.commandMap);			injector.mapValue(IPageInjector, model.injector);			injector.mapValue(IPageMediatorMap, model.mediatorMap);			injector.mapValue(IPageViewMap, model.viewMap);
			injector.mapValue(IGroupLoader, model.groupLoader);
		}
	}
}
