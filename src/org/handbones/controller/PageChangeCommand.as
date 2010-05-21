package org.handbones.controller 
{
	import org.handbones.core.ITracker;
	import org.handbones.core.INavigator;
	import org.handbones.model.SettingsModel;
	import org.handbones.events.NavigatorEvent;
	import org.handbones.model.PageModel;
	import org.handbones.base.PageSettings;
	import org.robotlegs.mvcs.Command;

	/**
	 * @author Matan Uberstein
	 */
	public class PageChangeCommand extends Command 
	{

		[Inject]
		public var event : NavigatorEvent;

		[Inject]
		public var settingsModel : SettingsModel;

		[Inject]
		public var navigator : INavigator;

		[Inject]
		public var tracker : ITracker;

		[Inject]
		public var pageModel : PageModel;

		override public function execute() : void 
		{
			injector.unmap(PageSettings);
			
			var title : String = settingsModel.titleBody;			var track : String = "/";
			
			if(event.page)
			{
				var pageSettings : PageSettings = event.page.settings;
				
				injector.mapValue(PageSettings, pageSettings);
				
				title = pageSettings.title;
				track = pageSettings.address;
			}
			
			navigator.setTitle(settingsModel.titlePrefix + title + settingsModel.titleSuffix);
			tracker.trackPageview(track);
				
			pageModel.currentPage = event.page;
		}
	}
}
