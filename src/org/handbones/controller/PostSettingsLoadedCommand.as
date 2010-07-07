package org.handbones.controller 
{
	import org.handbones.model.SizeModel;
	import org.assetloader.base.AssetType;
	import org.assetloader.base.Param;
	import org.assetloader.core.IAssetLoader;
	import org.assetloader.core.IGroupLoader;
	import org.assetloader.events.SWFAssetEvent;
	import org.handbones.base.ActionMap;
	import org.handbones.base.HandBonesError;
	import org.handbones.base.Navigator;
	import org.handbones.base.page.PageCommandMap;
	import org.handbones.base.page.PageInjector;
	import org.handbones.base.page.PageMediatorMap;
	import org.handbones.base.page.PageViewMap;
	import org.handbones.core.IActionMap;
	import org.handbones.core.INavigator;
	import org.handbones.model.ContextMenuModel;
	import org.handbones.model.PageModel;
	import org.handbones.model.SettingsModel;
	import org.handbones.model.vo.ActionVO;
	import org.handbones.model.vo.AssetVO;
	import org.handbones.model.vo.TrackVO;
	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.mvcs.Command;

	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.describeType;

	/**
	 * @author Matan Uberstein
	 */
	public class PostSettingsLoadedCommand extends Command 
	{

		[Inject]
		public var settingsModel : SettingsModel;

		[Inject]
		public var contextMenuModel : ContextMenuModel;

		[Inject]
		public var sizeModel : SizeModel;

		[Inject]
		public var assetLoader : IAssetLoader;

		protected var _trackActionPropertyNames : Array;

		override public function execute() : void 
		{
			parseForTrackingVars();
			parseForAssets();
			populatePageModels();
			
			//Instantiate Navigator now to ensure that it only fires event after settings are ready.
			injector.mapValue(INavigator, injector.instantiate(Navigator));
			
			//Construct and map ActionMap 
			var actionMap : IActionMap = new ActionMap(eventDispatcher, settingsModel.actions); 
			injector.mapValue(IActionMap, actionMap);
			
			//This will map all actions that don't have a reference to the shell dispatcher.
			actionMap.mapAction(eventDispatcher, "");
			
			//Command will error before settingsModel is populated.
			commandMap.mapEvent(SWFAssetEvent.LOADED, PageLoadedCommand, SWFAssetEvent);
			
			//Ensure that sizing model is populated before any reference to it occures
			sizeModel.updateSize(contextView.stage.stageWidth, contextView.stage.stageHeight);
			
			if(settingsModel.shellDispatchContextStartupComplete)
				dispatch(new ContextEvent(ContextEvent.STARTUP_COMPLETE));
				
			//Set size again to esure that views that have been added during STARTUP_COMPLETE receives update event.
			sizeModel.updateSize(contextView.stage.stageWidth, contextView.stage.stageHeight);
				
			//This will start loading the page swf's then all the other assets.
			assetLoader.start();
		}

		//--------------------------------------------------------------------------------------------------------------------------------//
		// PAGE MODELS
		//--------------------------------------------------------------------------------------------------------------------------------//
		protected function populatePageModels() : void
		{
			var pL : int = settingsModel.pages.length;
			for(var i : int = 0;i < pL;i++) 
			{
				var model : PageModel = settingsModel.pages[i];
				
				model.injector = injector.instantiate(PageInjector);				model.commandMap = injector.instantiate(PageCommandMap);				model.mediatorMap = injector.instantiate(PageMediatorMap);				model.viewMap = injector.instantiate(PageViewMap);				model.groupLoader = assetLoader.getGroupLoader(model.assetGroupId);
			}
		}

		//--------------------------------------------------------------------------------------------------------------------------------//
		// ASSETLOADER
		//--------------------------------------------------------------------------------------------------------------------------------//
		protected function parseForAssets() : void
		{
			var pL : int = settingsModel.pages.length;
			for(var i : int = 0;i < pL;i++) 
			{
				var pageModel : PageModel = settingsModel.pages[i];
				var params : Array = [];
				
				if(!isNaN(pageModel.loadPriority))
					params.push(new Param(Param.PRIORITY, pageModel.loadPriority));
				
				params.push(new Param(Param.ON_DEMAND, pageModel.loadOnDemand));
				params.push(new Param(Param.LOADER_CONTEXT, new LoaderContext(false, ApplicationDomain.currentDomain)));
				
				assetLoader.addLazy(pageModel.id, pageModel.src, AssetType.SWF, params);
								if(!pageModel.assetGroupId)
					pageModel.assetGroupId = pageModel.id + "-ASSET_GROUP";
						
				addAssetsToLoader(pageModel.assets, assetLoader.addGroup(pageModel.assetGroupId));
			}
			
			if(settingsModel.assets.length > 0)
				addAssetsToLoader(settingsModel.assets, assetLoader);
		}

		protected function addAssetsToLoader(assets : Array, loader : IGroupLoader) : void
		{
			var aL : int = assets.length;
			for(var i : int = 0;i < aL;i++) 
			{
				var assetVo : AssetVO = assets[i];
				var params : Array = [];
				
				if(!isNaN(assetVo.priority))
					params.push(new Param(Param.PRIORITY, assetVo.priority));
				
				params.push(new Param(Param.WEIGHT, assetVo.weight));				params.push(new Param(Param.RETRIES, assetVo.retries));				params.push(new Param(Param.ON_DEMAND, assetVo.onDemand));				params.push(new Param(Param.PREVENT_CACHE, assetVo.preventCache));
				
				loader.addLazy(assetVo.id, assetVo.src, assetVo.type, params);
			}
		}

		//--------------------------------------------------------------------------------------------------------------------------------//
		// TRACKING VARS PARSING
		//--------------------------------------------------------------------------------------------------------------------------------//
		protected function parseForTrackingVars() : void
		{
			_trackActionPropertyNames = getProperyList(new TrackVO());
			
			parseActionsForTrackingVars(settingsModel.actions);
			
			var pL : int = settingsModel.pages.length;
			for(var i : int = 0;i < pL;i++) 
			{
				parseActionsForTrackingVars(settingsModel.pages[i].actions);
			}
			
			parseActionsForTrackingVars(contextMenuModel.actions);
		}

		protected function parseActionsForTrackingVars(actions : Array) : void
		{
			var aL : int = actions.length;
			for(var k : int = 0;k < aL;k++) 
			{
				var action : ActionVO = actions[k];
				
				var tL : int = action.trackers.length;
				for(var i : int = 0;i < tL;i++) 
				{
					var track : TrackVO = action.trackers[i];
				
					var pL : int = _trackActionPropertyNames.length;
					for(var j : int = 0;j < pL;j++) 
					{
						var property : String = _trackActionPropertyNames[j];
						setVarValue(action, track, property);
					}
				}
			}
		}

		protected function setVarValue(action : ActionVO, track : TrackVO, property : String) : void
		{
			var varName : String = getVarName(track[property]);
			if(varName)
			{
				try
				{
					if(!track[property] is String)
						track[property] = action[varName];
					else
					{
						var value : String = track[property];
						track[property] = value.replace("{" + varName + "}", action[varName]);
					}
				}catch(error : Error)
				{
					throw new HandBonesError(HandBonesError.TRACK_VAR_NOT_ASSIGNED(varName, property));
				}
			}
		}

		protected function getVarName(str : String) : String
		{
			var sI : int = str.indexOf("{");
			var eI : int = str.lastIndexOf("}");
			if(sI != -1 && eI != -1 && sI < eI)
				return str.slice(sI + 1, eI);
			return null;
		}

		protected function getProperyList(obj : Object) : Array
		{
			//Get the description of the class
			var description : XML = describeType(obj);
			var properties : Array = [];
			
				//Get accessors from description
			for each(var a:XML in description.accessor) 
			{
				properties.push(a.@name.toString());
			}
				
				//Get variables from description
			for each(var v:XML in description.variable) 
			{
				properties.push(v.@name.toString());
			}
				
			//Get dynamic properties if the class is dynamic
			if(description.@isDynamic == "true") 
			{
				for(var p : String in obj) 
				{
					properties.push(p);
				}
			}
			return properties;
		}
	}
}
