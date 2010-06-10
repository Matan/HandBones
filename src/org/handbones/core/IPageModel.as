package org.handbones.core 
{
	import org.assetloader.core.IGroupLoader;
	import org.handbones.core.page.IPageCommandMap;
	import org.handbones.core.page.IPageInjector;
	import org.handbones.core.page.IPageMediatorMap;
	import org.handbones.core.page.IPageViewMap;

	/**
	 * @author Matan Uberstein
	 */
	public interface IPageModel 
	{
		function get id() : String

		function get src() : String

		function get address() : String

		function get title() : String

		function get loadPriority() : int

		function get loadOnDemand() : Boolean

		function get assetGroupId() : String

		function get autoStartup() : Boolean

		function get autoShutdown() : Boolean

		function get actions() : Array
		
		function get assets() : Array

		function get data() : XML

		function get commandMap() : IPageCommandMap;
		function get injector() : IPageInjector;
		function get mediatorMap() : IPageMediatorMap;

		function get viewMap() : IPageViewMap;		
		function get groupLoader() : IGroupLoader;	}
}
