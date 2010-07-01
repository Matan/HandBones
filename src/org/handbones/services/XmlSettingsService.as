package org.handbones.services 
{
	import org.handbones.model.ContextMenuModel;
	import org.assetloader.base.AssetType;
	import org.assetloader.base.Param;
	import org.assetloader.core.IAssetLoader;
	import org.assetloader.core.ILoader;
	import org.handbones.core.ISettingsService;
	import org.handbones.events.SettingsEvent;
	import org.handbones.model.PageModel;
	import org.handbones.model.SettingsModel;
	import org.handbones.model.vo.ActionVO;
	import org.handbones.model.vo.AssetVO;
	import org.handbones.model.vo.ContextMenuItemVO;
	import org.handbones.model.vo.ContextMenuVO;
	import org.handbones.model.vo.TrackVO;
	import org.robotlegs.mvcs.Actor;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;

	/**
	 * @author Matan Uberstein
	 */
	public class XmlSettingsService extends Actor implements ISettingsService 
	{

		[Inject]
		public var model : SettingsModel;

		[Inject]
		public var contextMenuModel : ContextMenuModel;

		[Inject]
		public var assetLoader : IAssetLoader;

		protected var _assetId : String = "hb-settings-xml";
		protected var _loader : ILoader;

		public function XmlSettingsService() 
		{
		}

		public function load(request : URLRequest) : void 
		{
			_loader = assetLoader.add(_assetId, request, AssetType.XML, new Param(Param.PREVENT_CACHE, true));
			
			_loader.addEventListener(Event.COMPLETE, loader_complete_handler);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, loader_ioError_handler);
			
			assetLoader.startAsset(_assetId);
		}

		//--------------------------------------------------------------------------------------------------------------------------------//
		// HANDLERS
		//--------------------------------------------------------------------------------------------------------------------------------//
		protected function loader_ioError_handler(event : IOErrorEvent) : void 
		{
			handleError(event.text);
		}

		protected function loader_complete_handler(event : Event) : void 
		{
			try
			{
				var xml : XML = new XML(_loader.data);
			}catch(err : Error)
			{
				handleError(err.message);
				return;
			}
			
			parseSiteNode(xml);
			
			removeLoaderListeners();
			assetLoader.remove(_assetId);
			
			dispatch(new SettingsEvent(SettingsEvent.LOADED));
		}

		//--------------------------------------------------------------------------------------------------------------------------------//
		// PROTECTED
		//--------------------------------------------------------------------------------------------------------------------------------//
		protected function handleError(message : String) : void
		{
			removeLoaderListeners();
			
			var errorEvent : SettingsEvent = new SettingsEvent(SettingsEvent.ERROR);
			errorEvent.errorMessage = message;
				
			assetLoader.remove(_assetId);
				
			dispatch(errorEvent);
		}

		protected function removeLoaderListeners() : void
		{
			if(_loader)
			{
				_loader.removeEventListener(Event.COMPLETE, loader_complete_handler);
				_loader.removeEventListener(IOErrorEvent.IO_ERROR, loader_ioError_handler);
			}
		}

		//--------------------------------------------------------------------------------------------------------------------------------//
		// PARSERS
		//--------------------------------------------------------------------------------------------------------------------------------//
		protected function parseSiteNode(xml : XML) : void
		{
			var pages : Array = [];
			var actions : Array = [];
			var assets : Array = [];
			
			var children : XMLList = xml.children();
			
			var cL : int = children.length();
			for(var i : int = 0;i < cL;i++) 
			{
				var node : XML = children[i];
				
				switch(String(node.name())) 
				{
					case "contextMenu":
						contextMenuModel.contextMenuVo = parseContextMenuNode(node);
						break;
					case "page" :
						pages.push(parsePageNode(node));
						break;
					case "action" :
						actions.push(parseActionNode(node));
						break;
					case "asset" :
						assets.push(parseAssetNode(node));
						break;
				}
			}
			
			model.titleBody = xml.title.@body || "";
			model.titlePrefix = xml.title.@prefix;
			model.titleSuffix = xml.title.@suffix;
			
			model.trackerUID = xml.tracker.@uid;
			model.trackerDebug = (xml.tracker.@debug == "true") ? true : false;
			
			model.shellDispatchContextStartupComplete = (xml.shell.@dispatchContextStartupComplete == "false") ? false : true;
			
			model.pages = pages;
			model.actions = actions;
			model.assets = assets;
			
			model.data = xml.data[0];
		}

		//--------------------------------------------------------------------------------------------------------------------------------//
		protected function parseContextMenuNode(xml : XML) : ContextMenuVO 
		{
			var items : Array = [];
			var children : XMLList = xml.children();
			
			var cL : int = children.length();
			for(var i : int = 0;i < cL;i++) 
			{
				var node : XML = children[i];
				
				switch(String(node.name())) 
				{
					case "item" :
						items.push(parseContextMenuItemNode(node));
						break;
				}
			}
			
			var vo : ContextMenuVO = new ContextMenuVO();
			
			vo.hideDefault = (xml.@hideDefault == "true") ? true : false;
			
			if(xml.@zoom != null)
				vo.zoom = (xml.@zoom == "false") ? false : true;
				
			if(xml.@quality != null)
				vo.quality = (xml.@quality == "false") ? false : true;
				
			if(xml.@print != null)
				vo.print = (xml.@print == "false") ? false : true;
				
			vo.items = items;
			
			return vo;
		}

		//--------------------------------------------------------------------------------------------------------------------------------//
		protected function parseContextMenuItemNode(xml : XML) : ContextMenuItemVO 
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
			
			var vo : ContextMenuItemVO = new ContextMenuItemVO();
			
			vo.caption = xml.@caption;
			
			vo.separator = (xml.@separator == "true") ? true : false;			vo.enabled = (xml.@enabled == "false") ? false : true;			vo.visible = (xml.@visible == "false") ? false : true;			
			vo.actions = actions;
			
			return vo;
		}

		//--------------------------------------------------------------------------------------------------------------------------------//
		protected function parsePageNode(xml : XML) : PageModel 
		{
			var actions : Array = [];			var assets : Array = [];
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
					case "asset" :
						assets.push(parseAssetNode(node));
						break;
				}
			}
			
			var pageModel : PageModel = new PageModel();
			
			pageModel.id = xml.@id;
			pageModel.address = xml.@address;
			pageModel.title = xml.@title;
			pageModel.src = xml.@src;			
			pageModel.assetGroupId = xml.@assetGroupId || null;
			pageModel.loadPriority = (xml.@loadPriority || NaN);
			
			if(xml.@loadOnDemand != null)
				pageModel.loadOnDemand = (xml.@loadOnDemand == "true") ? true : false;
						pageModel.actions = actions;			pageModel.assets = assets;
			pageModel.data = xml.data[0];
			
			if(xml.@autoCreate != null)
				pageModel.autoStartup = (xml.@autoStartup == "false") ? false : true;
			
			if(xml.@autoRemove != null)
				pageModel.autoShutdown = (xml.@autoShutdown == "false") ? false : true;
			
			return pageModel;
		}

		//--------------------------------------------------------------------------------------------------------------------------------//
		protected function parseActionNode(xml : XML) : ActionVO 
		{
			var action : ActionVO = new ActionVO();
			
			action.ref = xml.@ref || "";
						action.event = xml.@event || MouseEvent.CLICK;
			
			action.gotoPageId = xml.@gotoPageId;			action.invokeUrl = xml.@invokeUrl;
			action.changeAddress = xml.@changeAddress;			
			action.urlWindow = xml.@urlWindow;						if(xml.@keepHistory != null)
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
			action.trackers = trackActions;
			
			return action;
		}

		//--------------------------------------------------------------------------------------------------------------------------------//
		protected function parseTrackNode(xml : XML) : TrackVO 
		{
			var track : TrackVO = new TrackVO();
			
			track.url = xml.@url;
						track.category = xml.@category;			track.action = xml.@action;			track.label = xml.@label;			track.value = xml.@value;
			
			return track;
		}

		//--------------------------------------------------------------------------------------------------------------------------------//		protected function parseAssetNode(xml : XML) : AssetVO
		{
			var asset : AssetVO = new AssetVO();
			
			asset.id = xml.@id;
			asset.src = xml.@src;			asset.type = xml.@type || AssetType.AUTO;			asset.retries = xml.@retries || 3;			asset.weight = parseWeigtString(xml.@weight);			asset.priority = xml.@priority || NaN;			asset.onDemand = xml.@onDemand || false;			asset.preventCache = xml.@preventCache || false;			
			return asset;
		}

		//--------------------------------------------------------------------------------------------------------------------------------//
		protected function parseWeigtString(str : String) : uint
		{
			if(!str)
				return 0;
				
			str = str.replace(new RegExp(" ", "g"), "");
			
			var mbExp : RegExp = new RegExp("mb", "gi");
			if(mbExp.test(str))
				return Number(str.replace(mbExp, "")) * 1024 * 1024;
						var kbExp : RegExp = new RegExp("kb", "gi");
			if(kbExp.test(str))
				return Number(str.replace(kbExp, "")) * 1024;
			
			return 0;
		}
	}
}
