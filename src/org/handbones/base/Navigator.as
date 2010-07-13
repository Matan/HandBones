package org.handbones.base 
{
	import org.handbones.model.NavigatorModel;

	import com.asual.address.SWFAddress;
	import com.asual.address.SWFAddressEvent;

	import org.assetloader.core.IAssetLoader;
	import org.assetloader.core.ILoader;
	import org.handbones.core.INavigator;
	import org.handbones.core.IPage;
	import org.handbones.core.IPageModel;
	import org.handbones.events.NavigatorEvent;
	import org.handbones.model.SettingsModel;
	import org.robotlegs.mvcs.Actor;

	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;

	/**
	 * @author Matan Uberstein
	 */
	public class Navigator extends Actor implements INavigator 
	{

		[Inject]
		public var settingsModel : SettingsModel;

		[Inject]
		public var navigatorModel : NavigatorModel;

		[Inject]
		public var assetLoader : IAssetLoader;

		protected var _baseUrl : String;

		[PostConstruct]

		public function init() : void 
		{
			SWFAddress.addEventListener(SWFAddressEvent.INIT, swfAddress_init_handler);
		}

		//-----------------------------------------------------------------------------------------------------------//
		// PUBLIC
		//-----------------------------------------------------------------------------------------------------------//
		/**
		 * @inheritDoc
		 */
		public function gotoPageId(id : String, history : Boolean = true) : void 
		{
			var pageModel : IPageModel = settingsModel.getPageModelById(id);
			
			if(pageModel)
				setAddress(pageModel.address, history);
		}

		/**
		 * @inheritDoc
		 */
		public function invokeURL(url : String, window : String = "_blank") : void 
		{
			navigateToURL(new URLRequest(url), window);
		}

		/**
		 * @inheritDoc
		 */
		public function getAddress() : String
		{
			return SWFAddress.getValue();
		}

		/**
		 * @inheritDoc
		 */
		public function setAddress(address : String, history : Boolean = true) : void 
		{
			if(!history)
				SWFAddress.setHistory(false);
			
			SWFAddress.setValue(address);
			
			if(!history)
				SWFAddress.setHistory(true);
		}

		/**
		 * @inheritDoc
		 */
		public function get title() : String
		{
			return SWFAddress.getTitle();
		}

		/**
		 * @inheritDoc
		 */
		public function set title(value : String) : void 
		{
			if(value && value != "") 
				SWFAddress.setTitle(value);
		}

		/**
		 * @inheritDoc
		 */
		public function getAddressNames() : Array 
		{
			return SWFAddress.getPathNames();
		}

		/**
		 * @inheritDoc
		 */
		public function getRootAddress() : String 
		{
			return getAddressNames()[0];
		}

		/**
		 * @inheritDoc
		 */
		public function clearUrlVariables() : void
		{
			SWFAddress.href(SWFAddress.getBaseURL() + "#/" + getAddressNames().join("/"));
		}

		/**
		 * @inheritDoc
		 */
		public function getUrlVariables() : URLVariables 
		{
			var qString : String = SWFAddress.getQueryString();
			if(qString != "")
				return new URLVariables(qString);
			
			return new URLVariables();
		}

		/**
		 * @inheritDoc
		 */
		public function setUrlVariables(value : URLVariables) : void 
		{
			SWFAddress.href(SWFAddress.getBaseURL() + "#/" + getAddressNames().join("/") + "?" + value);
		}

		/**
		 * @inheritDoc
		 */
		public function getUrlVariable(param : String) : String
		{
			return SWFAddress.getParameter(param);
		}

		/**
		 * @inheritDoc
		 */
		public function getUrlVariableNames() : Array
		{
			return SWFAddress.getParameterNames();
		}

		/**
		 * @inheritDoc
		 */
		public function back() : void
		{
			SWFAddress.back();
		}

		/**
		 * @inheritDoc
		 */
		public function forward() : void
		{
			SWFAddress.forward();
		}

		/**
		 * @inheritDoc
		 */
		public function up() : void
		{
			SWFAddress.up();
		}

		/**
		 * @inheritDoc
		 */
		public function get baseURL() : String
		{
			return SWFAddress.getBaseURL();
		}

		/**
		 * @inheritDoc
		 */
		public function get history() : Boolean
		{
			return SWFAddress.getHistory();
		}

		/**
		 * @inheritDoc
		 */
		public function set history(history : Boolean) : void
		{
			SWFAddress.setHistory(history);
		}

		/**
		 * @inheritDoc
		 */
		public function popup(url : String, name : String = "popup", options : String = '""', handler : String = "") : void
		{
			SWFAddress.popup(url, name, options, handler);
		}

		/**
		 * @inheritDoc
		 */
		public function resetStatus() : void
		{
			SWFAddress.resetStatus();
		}

		/**
		 * @inheritDoc
		 */
		public function get status() : String
		{
			return SWFAddress.getStatus();
		}

		/**
		 * @inheritDoc
		 */
		public function set status(status : String) : void
		{
			SWFAddress.setStatus(status);
		}

		//-----------------------------------------------------------------------------------------------------------//
		// PROTECTED
		//-----------------------------------------------------------------------------------------------------------//
		protected function navigateToPage(pageModel : IPageModel = null) : void 
		{
			if(pageModel) 
			{
				var id : String = pageModel.id;
				var loader : ILoader = assetLoader.getLoader(id);
				
				if(loader.loaded)
					dispatchNavigatorEvent(NavigatorEvent.PAGE_CHANGE, assetLoader.getAsset(id));
				else
				{
					eventMap.mapListener(loader, Event.COMPLETE, loader_complete_handler, Event);
					
					assetLoader.stop();
					assetLoader.startAsset(id);
				}
			} 
			
			else
				dispatchNavigatorEvent(NavigatorEvent.PAGE_CHANGE);
		}

		protected function dispatchNavigatorEvent(type : String, page : IPage = null) : void 
		{
			var event : NavigatorEvent = new NavigatorEvent(type, page);
			event.addressNames = getAddressNames();
			event.urlVariables = getUrlVariables();
			dispatch(event);
		}

		//-----------------------------------------------------------------------------------------------------------//
		// Handlers
		//-----------------------------------------------------------------------------------------------------------//
		protected function loader_complete_handler(event : Event) : void 
		{
			var loader : ILoader = ILoader(event.target);
			eventMap.mapListener(loader, Event.COMPLETE, loader_complete_handler, Event);
			
			dispatchNavigatorEvent(NavigatorEvent.PAGE_CHANGE, loader.data);
			
			assetLoader.start();
		}

		//-----------------------------------------------------------------------------------------------------------//
		// SWFAddress Handlers
		//-----------------------------------------------------------------------------------------------------------//
		protected function swfAddress_init_handler(e : SWFAddressEvent) : void 
		{
			SWFAddress.removeEventListener(SWFAddressEvent.INIT, swfAddress_init_handler);
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE, swfAddress_change_handler);
		}

		protected function swfAddress_change_handler(e : SWFAddressEvent) : void 
		{
			dispatchNavigatorEvent(NavigatorEvent.ADDRESS_CHANGE);
			
			var newPageModel : IPageModel = settingsModel.getPageModelByAddress(getRootAddress());
			
			if(newPageModel)
			{
				if(newPageModel.id != navigatorModel.currentPageId) 
					navigateToPage(newPageModel);
			}
			else if(!getRootAddress())
				navigateToPage();
				
			else
				dispatchNavigatorEvent(NavigatorEvent.INVALID_ADDRESS);
		}
	}
}
