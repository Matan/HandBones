package org.handbones.mvcs 
{
	import org.assetloader.AssetLoader;
	import org.assetloader.core.IAssetLoader;
	import org.handbones.base.ActionMap;
	import org.handbones.base.GoogleTracker;
	import org.handbones.controller.ExecuteActionCommand;
	import org.handbones.controller.PageChangeCommand;
	import org.handbones.controller.PageShutdownCompleteCommand;
	import org.handbones.controller.PageStartupCommand;
	import org.handbones.controller.PostSettingsLoadedCommand;
	import org.handbones.core.IActionMap;
	import org.handbones.core.ISettingsService;
	import org.handbones.core.ITracker;
	import org.handbones.events.ActionMapEvent;
	import org.handbones.events.NavigatorEvent;
	import org.handbones.events.PageEvent;
	import org.handbones.events.SettingsEvent;
	import org.handbones.model.ContextMenuModel;
	import org.handbones.model.NavigatorModel;
	import org.handbones.model.SettingsModel;
	import org.handbones.model.SizeModel;
	import org.handbones.services.XmlSettingsService;
	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.mvcs.Context;

	import flash.display.DisplayObjectContainer;

	/**
	 * @author Matan Uberstein
	 */
	public class HandBonesContext extends Context 
	{
		public function HandBonesContext(contextView : DisplayObjectContainer)
		{
			super(contextView, true);
			mapCommands();
		}
		
		protected function mapCommands() : void
		{
			commandMap.mapEvent(SettingsEvent.LOADED, PostSettingsLoadedCommand, SettingsEvent, true);
			
			commandMap.mapEvent(ActionMapEvent.EXECUTE_ACTION, ExecuteActionCommand, ActionMapEvent);
			commandMap.mapEvent(NavigatorEvent.PAGE_CHANGE, PageChangeCommand, NavigatorEvent);
			
			commandMap.mapEvent(PageEvent.STARTUP, PageStartupCommand, PageEvent);
			commandMap.mapEvent(PageEvent.SHUTDOWN_COMPLETE, PageShutdownCompleteCommand, PageEvent);
		}

		override protected function mapInjections() : void 
		{
			injector.mapSingletonOf(IActionMap, ActionMap);
			injector.mapSingletonOf(ITracker, GoogleTracker);
			
			injector.mapSingleton(SettingsModel);
			injector.mapSingleton(NavigatorModel);
			injector.mapSingleton(SizeModel);
			injector.mapSingleton(ContextMenuModel);
			
			injector.mapSingletonOf(IAssetLoader, AssetLoader);
			injector.mapSingletonOf(ISettingsService, XmlSettingsService);
			
			super.mapInjections();
		}

		/**
		 * Prevents Robotlegs from dispatching <code>ContextEvent.STARTUP_COMPLETE</code>.
		 * At default HandBones will dispatch <code>ContextEvent.STARTUP_COMPLETE</code> when the settings have been loaded.
		 * <p>This will dispatch <code>ContextEvent.STARTUP</code>.</p>
		 * 
		 * @see org.robotlegs.base.ContextEvent
		 */
		override public function startup() : void 
		{
			dispatchEvent(new ContextEvent(ContextEvent.STARTUP));
		}
	}
}
