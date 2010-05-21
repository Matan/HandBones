package org.handbones.services 
{
	import mu.loaders.SWFLoader;

	import org.handbones.core.IPage;
	import org.handbones.events.PageServiceEvent;
	import org.handbones.base.PageSettings;
	import org.robotlegs.mvcs.Actor;

	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;

	/**
	 * @author Matan Uberstein
	 */
	public class PageService extends Actor {

		protected var _settings : Dictionary;		protected var _loaders : Dictionary;

		[PostConstruct]

		public function init() : void {
			_settings = new Dictionary();
			_loaders = new Dictionary();
		}

		public function load(settings : PageSettings) : void {
			var loader : SWFLoader;
			
			var found : Boolean;
			for(var key : String in _loaders) {
				if(settings.id == key) {
					found = true;
					break;
				}
			}
			
			if(found) {
				
				loader = _loaders[settings.id];
				loader.addEventListener(Event.COMPLETE, loader_complete_handler);
				
				if(loader.percentageLoaded != 100) 
					loader.addEventListener(ProgressEvent.PROGRESS, loader_progress_handler);
				 else 
					loader.dispatchEvent(new Event(Event.COMPLETE));

			} else {
				
				loader = new SWFLoader();
				
				_settings[settings.id] = settings;
				_loaders[settings.id] = loader;
				
				loader.addEventListener(ProgressEvent.PROGRESS, loader_progress_handler);
				loader.addEventListener(Event.COMPLETE, loader_complete_handler);
				
				dispatchPageServiceEvent(PageServiceEvent.LOADING, settings);
				
				loader.load(new URLRequest(settings.src));
			}
		}

		protected function loader_complete_handler(e : Event) : void {
			var loader : SWFLoader = e.target as SWFLoader;
			
			loader.removeEventListener(ProgressEvent.PROGRESS, loader_progress_handler);
			loader.removeEventListener(Event.COMPLETE, loader_complete_handler);
			
			var id : String;
			for(var key : String in _loaders) {
				if(_loaders[key] == loader) {
					id = key;
					break;
				}
			}
			
			var page : IPage = loader.content as IPage;
			if(page) 
				dispatchPageServiceEvent(PageServiceEvent.LOADED, _settings[id], "", 100, page);
			else
				throw new Error("Page (" + id + ") does not implement IPage.");
			
			loader.destroy();
			delete _loaders[id];			delete _settings[id];
		}

		protected function loader_progress_handler(e : ProgressEvent) : void {
			dispatchPageServiceEvent(PageServiceEvent.PROGRESS, null, "", (e.bytesLoaded / e.bytesTotal) * 100);
		}

		protected function dispatchPageServiceEvent(type : String, vo : PageSettings = null, message : String = "", percentageLoaded : Number = 0, page : IPage = null) : Boolean {
			return dispatch(new PageServiceEvent(type, vo, message, percentageLoaded, page));
		}
	}
}
