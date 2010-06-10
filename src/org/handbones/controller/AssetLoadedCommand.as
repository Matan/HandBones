package org.handbones.controller 
{
	import org.assetloader.core.IAssetLoader;
	import org.assetloader.events.AssetLoaderEvent;
	import org.handbones.base.HandBonesError;
	import org.handbones.base.PageMediator;
	import org.handbones.core.IPage;
	import org.handbones.core.IPageModel;
	import org.handbones.events.PageEvent;
	import org.handbones.model.SettingsModel;
	import org.robotlegs.mvcs.Command;

	import flash.utils.getQualifiedClassName;

	/**
	 * @author Matan Uberstein
	 */
	internal class AssetLoadedCommand extends Command 
	{

		[Inject]
		public var event : AssetLoaderEvent;

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
						page = event.data;
					}catch(error : Error)
					{
						throw new HandBonesError(HandBonesError.NOT_IPAGE);
					}
					
					if(page)
					{
						if(!page.model)
						{
							page.model = pageModel;
							mediatorMap.mapView(getQualifiedClassName(page).replace("::", "."), PageMediator, IPage, pageModel.autoStartup, pageModel.autoShutdown);
							
							dispatch(new PageEvent(PageEvent.LOADED, pageModel));						}
					}
				}
			}
		}
	}
}
