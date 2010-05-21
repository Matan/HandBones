package org.handbones.services 
{
	import org.handbones.base.Action;
	import org.handbones.base.PageSettings;
	import org.handbones.base.TrackAction;
	import org.handbones.events.SettingsEvent;
	import org.handbones.model.SettingsModel;
	import org.robotlegs.mvcs.Actor;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	/**
	 * @author Matan Uberstein
	 */
	public class XmlSettingsService extends Actor implements ISettingsService 
	{

		[Inject]
		public var model : SettingsModel;

		protected var _loader : URLLoader;

		public function XmlSettingsService() 
		{
		}

		public function load(request : URLRequest) : void 
		{
			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, loader_complete_handler);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, loader_ioError_handler);
			
			_loader.load(request);
		}

		protected function loader_ioError_handler(event : IOErrorEvent) : void 
		{
			var errorEvent : SettingsEvent = new SettingsEvent(SettingsEvent.ERROR);
			errorEvent.errorMessage = event.text;
			dispatch(errorEvent);
		}

		protected function loader_complete_handler(event : Event) : void 
		{
			var pages : Array = [];
			
			try
			{
				var xml : XML = new XML(_loader.data);
			}catch(err : Error)
			{
				var errorEvent : SettingsEvent = new SettingsEvent(SettingsEvent.ERROR);
				errorEvent.errorMessage = err.message;
				dispatch(errorEvent);
				return;
			}
			
			var children : XMLList = xml.children();
			
			var cL : int = children.length();
			for(var i : int = 0;i < cL;i++) 
			{
				var node : XML = children[i];
				
				switch(String(node.name())) 
				{
					case "page" :
						pages.push(parsePageNode(node));
						break;
					case "action" :
						actions.push(parseActionNode(node));
						break;
				}
			}
			
			model.titleBody = xml.title.@body || "";
			
			model.trackerDebug = (xml.tracker.@debug == "true") ? true : false;
			
			model.shellDispatchContextStartupComplete = (xml.shell.@dispatchContextStartupComplete == "false") ? false : true;
			
			model.pages = pages;
			
			
			dispatch(new SettingsEvent(SettingsEvent.LOADED));
		}

		protected function parsePageNode(xml : XML) : PageSettings 
		{
			var actions : Array = [];
			var children : XMLList = xml.children();
			
			var cL : int = children.length();
			for(var i : int = 0;i < cL;i++) 
			{
				var node : XML = children[i];
				
				switch(String(node.name())) 
				{
					case "action" :
						actions.push(parseActionNode(node));
						break;
				}
			}
			
			var pageSettings : PageSettings = new PageSettings();
			pageSettings.id = xml.@id;
			pageSettings.address = xml.@address;
			pageSettings.title = xml.@title;
			pageSettings.src = xml.@src;
			pageSettings.actions = actions;
			pageSettings.data = xml.data[0];
			
			if(xml.@autoCreate != null)
				pageSettings.autoStartup = (xml.@autoStartup == "false") ? false : true;
			
			if(xml.@autoRemove != null)
				pageSettings.autoShutdown = (xml.@autoShutdown == "false") ? false : true;
			
			return pageSettings;
		}

		protected function parseActionNode(xml : XML) : Action 
		{
			var action : Action = new Action();
			
			action.ref = xml.@ref || "";
			
			
			action.gotoPageId = xml.@gotoPageId;
			action.changeAddress = xml.@changeAddress;
			action.urlWindow = xml.@urlWindow;
				action.keepHistory = (xml.@keepHistory == "false") ? false : true;
			
			var trackActions : Array = [];
			var children : XMLList = xml.children();
			
			var cL : int = children.length();
			for(var i : int = 0;i < cL;i++) 
			{
				var node : XML = children[i];
				
				switch(String(node.name())) 
				{
					case "track" :
						trackActions.push(parseTrackNode(node));
						break;
				}
			}
			action.trackActions = trackActions;
			
			return action;
		}

		protected function parseTrackNode(xml : XML) : TrackAction 
		{
			var trackAction : TrackAction = new TrackAction();
			
			trackAction.url = xml.@url;
			
			
			return trackAction;
		}
	}
}