package org.handbones.controller 
{
	import org.handbones.base.PageCache;
	import org.handbones.base.PageMediator;
	import org.handbones.core.IPage;
	import org.handbones.events.PageServiceEvent;
	import org.handbones.base.PageSettings;
	import org.robotlegs.mvcs.Command;

	import flash.utils.getQualifiedClassName;

	/**
	 * @author Matan Uberstein
	 */
	public class PageLoadedCommand extends Command 
	{

		[Inject]
		public var cache : PageCache;

		[Inject]
		public var event : PageServiceEvent;

		override public function execute() : void 
		{
			var page : IPage = event.page;			var pageSettings : PageSettings = event.pageSettings;
			
			page.settings = pageSettings;
			cache.addPage(page);
			
			mediatorMap.mapView(getQualifiedClassName(page).replace("::", "."), PageMediator, IPage, pageSettings.autoStartup, pageSettings.autoShutdown);
		}
	}
}
