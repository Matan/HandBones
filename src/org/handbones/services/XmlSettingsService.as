package org.handbones.services 
{
	import org.assetloader.base.AssetType;
	import org.assetloader.base.Param;
	import org.assetloader.core.IAssetLoader;
	import org.assetloader.core.ILoader;
	import org.handbones.controller.ParseSettingsXmlCommand;
	import org.handbones.core.ISettingsService;
	import org.handbones.events.SettingsEvent;
	import org.robotlegs.core.ICommandMap;
	import org.robotlegs.core.IInjector;
	import org.robotlegs.mvcs.Actor;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;

	/**
	 * @author Matan Uberstein
	 */
	public class XmlSettingsService extends Actor implements ISettingsService 
	{

		[Inject]
		public var assetLoader : IAssetLoader;

		[Inject]
		public var commandMap : ICommandMap;

		[Inject]
		public var injector : IInjector;

		protected var _assetId : String = "site.xml";
		protected var _loader : ILoader;

		public function XmlSettingsService() 
		{
		}

		public function load(request : URLRequest) : void 
		{
			_loader = assetLoader.add(_assetId, request, AssetType.XML, new Param(Param.PREVENT_CACHE, true));
			
			eventMap.mapListener(_loader, Event.COMPLETE, loader_complete_handler, Event);			eventMap.mapListener(_loader, IOErrorEvent.IO_ERROR, loader_ioError_handler, Event);
			
			assetLoader.startAsset(_assetId);
		}

		//--------------------------------------------------------------------------------------------------------------------------------//
		// HANDLERS
		//--------------------------------------------------------------------------------------------------------------------------------//
		protected function loader_ioError_handler(event : IOErrorEvent) : void 
		{
			eventMap.unmapListeners();
			
			handleError(event.text);
		}

		protected function loader_complete_handler(event : Event) : void 
		{
			eventMap.unmapListeners();
			
			try
			{
				var xml : XML = new XML(_loader.data);
			}catch(err : Error)
			{
				handleError(err.message);
				return;
			}
			
			commandMap.execute(ParseSettingsXmlCommand, xml, XML);
			
			assetLoader.remove(_assetId);
			
			dispatch(new SettingsEvent(SettingsEvent.LOADED));
		}

		//--------------------------------------------------------------------------------------------------------------------------------//
		// PROTECTED
		//--------------------------------------------------------------------------------------------------------------------------------//
		protected function handleError(message : String) : void
		{
			var errorEvent : SettingsEvent = new SettingsEvent(SettingsEvent.ERROR);
			errorEvent.errorMessage = message;
				
			assetLoader.remove(_assetId);
				
			dispatch(errorEvent);
		}
	}
}
