package org.handbones.controller 
{
	import org.handbones.base.ActionMap;
	import org.handbones.base.GoogleTracker;
	import org.handbones.base.Navigator;
	import org.handbones.base.PageCache;
	import org.handbones.base.wrappers.CommandMapWrapper;
	import org.handbones.base.wrappers.InjectorWrapper;
	import org.handbones.base.wrappers.MediatorMapWrapper;
	import org.handbones.base.wrappers.ViewMapWrapper;
	import org.handbones.core.IActionMap;
	import org.handbones.core.INavigator;
	import org.handbones.core.ITracker;
	import org.handbones.core.wrappers.ICommandMapWrapper;
	import org.handbones.core.wrappers.IInjectorWrapper;
	import org.handbones.core.wrappers.IMediatorMapWrapper;
	import org.handbones.core.wrappers.IViewMapWrapper;
	import org.handbones.events.NavigatorEvent;
	import org.handbones.events.PageServiceEvent;
	import org.handbones.events.SettingsEvent;
	import org.handbones.events.TrackingEvent;
	import org.handbones.model.PageModel;
	import org.handbones.model.SettingsModel;
	import org.handbones.model.SizeModel;
	import org.handbones.services.ISettingsService;
	import org.handbones.services.PageService;
	import org.handbones.services.XmlSettingsService;
	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.mvcs.Command;

	/**
	 * @author Matan Uberstein
	 */
	public class HandBonesStartupCommand extends Command 
	{
		override public function execute() : void 
		{
			commandMap.mapEvent(SettingsEvent.LOADED, HandBonesSettingsLoadedCommand, SettingsEvent, true);
			
			commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, HandBonesStartupCompleteCommand, ContextEvent, true);
			
			commandMap.mapEvent(PageServiceEvent.LOADED, PageLoadedCommand, PageServiceEvent);
			
			commandMap.mapEvent(NavigatorEvent.HANDLE_ACTION, HandleActionCommand, NavigatorEvent);
			commandMap.mapEvent(NavigatorEvent.PAGE_CHANGE, PageChangeCommand, NavigatorEvent);
			
			commandMap.mapEvent(TrackingEvent.TRACK, HandleTrackingCommand, TrackingEvent);

			injector.mapClass(IInjectorWrapper, InjectorWrapper);
			injector.mapClass(ICommandMapWrapper, CommandMapWrapper);
			injector.mapClass(IMediatorMapWrapper, MediatorMapWrapper);
			injector.mapClass(IViewMapWrapper, ViewMapWrapper);
			
			injector.mapSingletonOf(IActionMap, ActionMap);
			injector.mapSingletonOf(INavigator, Navigator);
			injector.mapSingletonOf(ITracker, GoogleTracker);
			
			injector.mapSingleton(PageModel);
			injector.mapSingleton(SizeModel);
			injector.mapSingleton(SettingsModel);
			injector.mapSingleton(PageCache);
			
			injector.mapSingleton(PageService);
			injector.mapClass(ISettingsService, XmlSettingsService);
		}
	}
}
