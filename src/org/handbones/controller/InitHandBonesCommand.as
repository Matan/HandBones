package org.handbones.controller 
{
	import org.assetloader.AssetLoader;
	import org.assetloader.core.IAssetLoader;
	import org.handbones.base.ActionMap;
	import org.handbones.base.GoogleTracker;
	import org.handbones.core.IActionMap;
	import org.handbones.core.ITracker;
	import org.handbones.events.ActionMapEvent;
	import org.handbones.events.NavigatorEvent;
	import org.handbones.events.PageEvent;
	import org.handbones.events.SettingsEvent;
	import org.handbones.model.NavigatorModel;
	import org.handbones.model.SettingsModel;
	import org.handbones.model.SizeModel;
	import org.handbones.core.ISettingsService;
	import org.handbones.services.XmlSettingsService;
	import org.robotlegs.mvcs.Command;

	/**
	 * @author Matan Uberstein
	 */
	public class InitHandBonesCommand extends Command 
	{
		override public function execute() : void 
		{
			commandMap.mapEvent(SettingsEvent.LOADED, ParseSettingsCommand, SettingsEvent, true);
			commandMap.mapEvent(SettingsEvent.LOADED, SetupCommand, SettingsEvent, true);
			
			commandMap.mapEvent(ActionMapEvent.EXECUTE_ACTION, ExecuteActionCommand, ActionMapEvent);
			commandMap.mapEvent(NavigatorEvent.PAGE_CHANGE, PageChangeCommand, NavigatorEvent);
			
			commandMap.mapEvent(PageEvent.STARTUP, PageStartupCommand, PageEvent);
			commandMap.mapEvent(PageEvent.SHUTDOWN_COMPLETE, PageShutdownCompleteCommand, PageEvent);
			
			injector.mapSingletonOf(IActionMap, ActionMap);
			injector.mapSingletonOf(ITracker, GoogleTracker);
			
			injector.mapSingleton(SettingsModel);
			injector.mapSingleton(NavigatorModel);
			injector.mapSingleton(SizeModel);
			
			injector.mapSingletonOf(IAssetLoader, AssetLoader);
			injector.mapSingletonOf(ISettingsService, XmlSettingsService);
		}
	}
}
