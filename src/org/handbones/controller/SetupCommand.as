package org.handbones.controller 
{
	import org.assetloader.core.IAssetLoader;
	import org.assetloader.events.AssetLoaderEvent;
	import org.handbones.base.Navigator;
	import org.handbones.core.IActionMap;
	import org.handbones.core.INavigator;
	import org.handbones.model.SizeModel;
	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.mvcs.Command;

	/**
	 * @author Matan Uberstein
	 */
	internal class SetupCommand extends Command 
	{

		[Inject]
		public var sizeModel : SizeModel;

		[Inject]
		public var actionMap : IActionMap;

		[Inject]
		public var assetLoader : IAssetLoader;

		override public function execute() : void 
		{
			injector.mapValue(INavigator, injector.instantiate(Navigator));
			
			//Have to do mapping here to make this command execute AFTER views have been created and added to state.
			commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, PostStartupCompleteCommand, ContextEvent, true);
			
			//Command will error before settingsModel is populated.
			commandMap.mapEvent(AssetLoaderEvent.ASSET_LOADED, AssetLoadedCommand, AssetLoaderEvent);
			
			//Ensure that sizing model is populated before any reference to it occures
			sizeModel.updateSize(contextView.stage.stageWidth, contextView.stage.stageHeight);
			
			//This will map all actions that don't have a reference to the shell dispatcher.
			actionMap.mapAction(eventDispatcher, "");
			
			//This will start loading the page swf's then all the assets.
			assetLoader.start();
		}
	}
}
