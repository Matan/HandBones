package org.handbones.base 
{
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
		public var assetLoader : IAssetLoader;
		
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
			var pageModel : IPageModel = settingsModel.getPageModelById(id);
			
			if(pageModel)
				setAddress(pageModel.address);
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
		protected function navigateToPage(pageModel : IPageModel) : void 
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
			
			navigateToPage(settingsModel.getPageModelByAddress(getRootAddress()));
		}
	}
}
