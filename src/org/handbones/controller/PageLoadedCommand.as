package org.handbones.controller 
{
	import org.assetloader.core.IAssetLoader;
	import org.assetloader.events.SWFAssetEvent;
	import org.handbones.base.HandBonesError;
	import org.handbones.view.PageMediator;
	import org.handbones.core.IPage;
	import org.handbones.core.IPageModel;
	import org.handbones.events.PageEvent;
	import org.handbones.model.SettingsModel;
	import org.robotlegs.mvcs.Command;

	import flash.utils.getQualifiedClassName;

	/**
	 * @author Matan Uberstein
	 */
	public class PageLoadedCommand extends Command 
	{

		[Inject]
		public var event : SWFAssetEvent;

		[Inject]
		public var assetLoader : IAssetLoader;

		[Inject]
		public var settingsModel : SettingsModel;

		/**
		 * @throws org.handbones.base.HandBonesError#NOT_IPAGE
		 */
		override public function execute() : void 
		{
			var pageModels : Array = settingsModel.pages;
			
			var pL : int = pageModels.length;
			for(var i : int = 0;i < pL;i++) 
			{
				var pageModel : IPageModel = pageModels[i];
				
				if(event.id == pageModel.id)
				{
					var page : IPage;
					
					try
					{
						page = IPage(event.sprite);
					}catch(error : Error)
					{
						throw new HandBonesError(HandBonesError.NOT_IPAGE);
					}
					
					if(page)
					{
						if(!page.model)
						{
							injector.mapValue(IPageModel, pageModel);
							injector.injectInto(page);
							injector.unmap(IPageModel);
							
							mediatorMap.mapView(getQualifiedClassName(page).replace("::", "."), PageMediator, IPage, pageModel.autoStartup, pageModel.autoShutdown);
							
							dispatch(new PageEvent(PageEvent.LOADED, pageModel));						}
					}
				}
			}
		}
	}
}
