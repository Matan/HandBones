package org.handbones.model 
{
	import org.assetloader.core.IGroupLoader;
	import org.handbones.core.IPageModel;
	import org.handbones.core.page.IPageCommandMap;
	import org.handbones.core.page.IPageInjector;
	import org.handbones.core.page.IPageMediatorMap;
	import org.handbones.core.page.IPageViewMap;
	import org.robotlegs.mvcs.Actor;

	/**
	 * @author Matan Uberstein
	 */
	public class PageModel extends Actor implements IPageModel
	{
		protected var _id : String;
		protected var _src : String;
		protected var _address : String;
		protected var _title : String;

		protected var _loadPriority : int = NaN;
		protected var _loadOnDemand : Boolean = false;
		protected var _assetGroupId : String;

		protected var _autoStartup : Boolean = true;
		protected var _autoShutdown : Boolean = true;

		protected var _actions : Array;
		protected var _assets : Array;
		protected var _data : XML;

		protected var _commandMap : IPageCommandMap;
		protected var _injector : IPageInjector;		protected var _mediatorMap : IPageMediatorMap;		protected var _viewMap : IPageViewMap;		protected var _groupLoader : IGroupLoader;

		public function PageModel() 
		{
		}

		//--------------------------------------------------------------------------------------------------------------------------------//
		// GETTERS
		//--------------------------------------------------------------------------------------------------------------------------------//
		public function get id() : String
		{
			return _id;
		}

		public function get src() : String
		{
			return _src;
		}

		public function get address() : String
		{
			return _address;
		}

		public function get title() : String
		{
			return _title;
		}

		public function get loadPriority() : int
		{
			return _loadPriority;
		}

		public function get loadOnDemand() : Boolean
		{
			return _loadOnDemand;
		}

		public function get assetGroupId() : String
		{
			return _assetGroupId;
		}

		public function get autoStartup() : Boolean
		{
			return _autoStartup;
		}

		public function get autoShutdown() : Boolean
		{
			return _autoShutdown;
		}

		public function get actions() : Array
		{
			return _actions;
		}
		
		public function get assets() : Array
		{
			return _assets;
		}

		public function get data() : XML
		{
			return _data;
		}

		public function get commandMap() : IPageCommandMap
		{
			return _commandMap;
		}

		public function get injector() : IPageInjector
		{
			return _injector;
		}

		public function get mediatorMap() : IPageMediatorMap
		{
			return _mediatorMap;
		}

		public function get viewMap() : IPageViewMap
		{
			return _viewMap;
		}

		public function get groupLoader() : IGroupLoader
		{
			return _groupLoader;
		}

		//--------------------------------------------------------------------------------------------------------------------------------//
		// SETTERS
		//--------------------------------------------------------------------------------------------------------------------------------//
		public function set id(id : String) : void
		{
			_id = id;
		}

		public function set src(src : String) : void
		{
			_src = src;
		}

		public function set address(address : String) : void
		{
			_address = address;
		}

		public function set title(title : String) : void
		{
			_title = title;
		}

		public function set loadPriority(loadPriority : int) : void
		{
			_loadPriority = loadPriority;
		}

		public function set loadOnDemand(loadOnDemand : Boolean) : void
		{
			_loadOnDemand = loadOnDemand;
		}

		public function set assetGroupId(assetGroupId : String) : void
		{
			_assetGroupId = assetGroupId;
		}

		public function set autoStartup(autoStartup : Boolean) : void
		{
			_autoStartup = autoStartup;
		}

		public function set autoShutdown(autoShutdown : Boolean) : void
		{
			_autoShutdown = autoShutdown;
		}

		public function set actions(actions : Array) : void
		{
			_actions = actions;
		}

		public function set assets(assets : Array) : void
		{
			_assets = assets;
		}

		public function set data(data : XML) : void
		{
			_data = data;
		}

		public function set commandMap(commandMap : IPageCommandMap) : void
		{
			_commandMap = commandMap;
		}

		public function set injector(injector : IPageInjector) : void
		{
			_injector = injector;
		}

		public function set mediatorMap(mediatorMap : IPageMediatorMap) : void
		{
			_mediatorMap = mediatorMap;
		}

		public function set viewMap(viewMap : IPageViewMap) : void
		{
			_viewMap = viewMap;
		}

		public function set groupLoader(groupLoader : IGroupLoader) : void
		{
			_groupLoader = groupLoader;
		}
	}
}
