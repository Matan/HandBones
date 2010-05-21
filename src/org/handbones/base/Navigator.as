package org.handbones.base 
{
	import com.asual.address.SWFAddress;
	import com.asual.address.SWFAddressEvent;

	import org.handbones.core.INavigator;
	import org.handbones.core.IPage;
	import org.handbones.events.NavigatorEvent;
	import org.handbones.events.PageServiceEvent;
	
	import org.handbones.model.SettingsModel;
	import org.handbones.services.PageService;
	import org.robotlegs.mvcs.Actor;

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
		public var pageService : PageService;

		[Inject]
		public var pageCache : PageCache;

		[PostConstruct]

		public function init() : void 
		{
			SWFAddress.addEventListener(SWFAddressEvent.INIT, swfAddress_init_handler);
		}

		//-----------------------------------------------------------------------------------------------------------//
		// PUBLIC
		//-----------------------------------------------------------------------------------------------------------//
		public function gotoPageId(id : String) : void 
		{
			var pageSettings : PageSettings = settingsModel.getPageSettingsById(id);
			
			if(pageSettings)
				setAddress(pageSettings.address);
		}

		public function invokeURL(url : String, window : String = null) : void 
		{
			window = window || "_blank";
			navigateToURL(new URLRequest(url), window);
		}

		public function setAddress(address : String, history : Boolean = true) : void 
		{
			if(!history)
				SWFAddress.setHistory(false);
			
			SWFAddress.setValue(address);
			
			if(!history)
				SWFAddress.setHistory(true);
		}

		public function setTitle(title : String) : void 
		{
			if(title && title != "") 
				SWFAddress.setTitle(title);
		}

		public function clearUrlVariables() : void
		{
			SWFAddress.href(SWFAddress.getBaseURL() + "#" + getAddressNames().join("/"));
		}

		public function getAddressNames() : Array 
		{
			return SWFAddress.getPathNames();
		}

		public function getRootAddress() : String 
		{
			return getAddressNames()[0];
		}

		public function getUrlVariables() : URLVariables 
		{
			var qString : String = SWFAddress.getQueryString();
			if(qString != "")
				return new URLVariables(qString);
			
			return new URLVariables();
		}

		//-----------------------------------------------------------------------------------------------------------//
		// PROTECTED
		//-----------------------------------------------------------------------------------------------------------//
		protected function navigateToPage(settings : PageSettings) : void 
		{
			if(settings) 
			{
				if(pageCache.isCached(settings.id)) 
					dispatchNavigatorEvent(NavigatorEvent.PAGE_CHANGE, pageCache.getPage(settings.id));
				else 
				{
					eventMap.mapListener(eventDispatcher, PageServiceEvent.LOADED, service_loaded_handler, PageServiceEvent);
					pageService.load(settings);
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
		protected function service_loaded_handler(event : PageServiceEvent) : void 
		{
			eventMap.unmapListener(eventDispatcher, PageServiceEvent.LOADED, service_loaded_handler, PageServiceEvent);
			dispatchNavigatorEvent(NavigatorEvent.PAGE_CHANGE, event.page);
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
			
			navigateToPage(settingsModel.getPageSettingsByAddress(getRootAddress()));
		}
	}
}
