package org.handbones.controller 
{
	import org.assetloader.base.AssetType;
	import org.assetloader.base.Param;
	import org.assetloader.core.IAssetLoader;
	import org.assetloader.core.IGroupLoader;
	import org.handbones.base.page.PageCommandMap;
	import org.handbones.base.page.PageInjector;
	import org.handbones.base.page.PageMediatorMap;
	import org.handbones.base.page.PageViewMap;
	import org.handbones.model.PageModel;
	import org.handbones.model.SettingsModel;
	import org.handbones.model.vo.ActionVO;
	import org.handbones.model.vo.AssetVO;
	import org.handbones.model.vo.TrackVO;
	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.mvcs.Command;

	import flash.utils.describeType;

	/**
	 * @author Matan Uberstein
	 */
	internal class ParseSettingsCommand extends Command 
	{

		[Inject]
		public var settingsModel : SettingsModel;

		[Inject]
		public var assetLoader : IAssetLoader;

		protected var _trackActionPropertyNames : Array;

		override public function execute() : void 
		{
			parseForTrackingVars();
			parseForAssets();
			injectPageModelValues();
			
			if(settingsModel.shellDispatchContextStartupComplete)
				dispatch(new ContextEvent(ContextEvent.STARTUP_COMPLETE));
		}

		//--------------------------------------------------------------------------------------------------------------------------------//
		// PAGE MODELS
		//--------------------------------------------------------------------------------------------------------------------------------//
		protected function injectPageModelValues() : void
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
					throw new Error("Variable (" + varName + ") defined in Settings could not be assigned to TrackAction property (" + property + ")");
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
