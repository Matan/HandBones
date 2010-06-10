package org.handbones.controller 
{
	import org.handbones.core.IPageModel;
	import org.handbones.core.INavigator;
	import org.handbones.core.ITracker;
	import org.handbones.events.NavigatorEvent;
	import org.handbones.model.NavigatorModel;
	import org.handbones.model.SettingsModel;
	import org.robotlegs.mvcs.Command;

	/**
	 * @author Matan Uberstein
	 */
	internal class PageChangeCommand extends Command 
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
		public var navModel : NavigatorModel;

		override public function execute() : void 
		{
			var title : String = settingsModel.titleBody;			var track : String = "/";
			
			if(event.page)
			{
				var pageVo : IPageModel = event.page.model;
				
				title = pageVo.title;
				track = pageVo.address;
			}
			
			navigator.setTitle(settingsModel.titlePrefix + title + settingsModel.titleSuffix);
			tracker.trackPageview(track);
				
			navModel.currentPage = event.page;
		}
	}
}
