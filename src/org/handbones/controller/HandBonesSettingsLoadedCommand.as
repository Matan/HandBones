package org.handbones.controller 
{
	import org.handbones.base.Action;
	import org.handbones.base.TrackAction;
	import org.handbones.model.SettingsModel;
	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.mvcs.Command;

	import flash.utils.describeType;

	/**
	 * @author Matan Uberstein
	 */
	public class HandBonesSettingsLoadedCommand extends Command 
	{

		[Inject]
		public var settingsModel : SettingsModel;

		protected var _trackActionPropertyNames : Array;

		override public function execute() : void 
		{
			_trackActionPropertyNames = getProperyList(new TrackAction());
			
			parseActionsForTrackingVars(settingsModel.actions);
			
			var pL : int = settingsModel.pages.length;
			for(var i : int = 0;i < pL;i++) 
			{
				parseActionsForTrackingVars(settingsModel.pages[i].actions);
			}
			
			if(settingsModel.shellDispatchContextStartupComplete)
				dispatch(new ContextEvent(ContextEvent.STARTUP_COMPLETE));
		}

		protected function parseActionsForTrackingVars(actions : Array) : void
		{
			var aL : int = actions.length;
			for(var k : int = 0;k < aL;k++) 
			{
				var action : Action = actions[k];
				
				var tL : int = action.trackActions.length;
				for(var i : int = 0;i < tL;i++) 
				{
					var tA : TrackAction = action.trackActions[i];
				
					var pL : int = _trackActionPropertyNames.length;
					for(var j : int = 0;j < pL;j++) 
					{
						var property : String = _trackActionPropertyNames[j];
						setVarValue(action, tA, property);
					}
				}
			}
		}

		protected function setVarValue(action : Action, track : TrackAction, property : String) : void
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
			var eI : int = str.indexOf("}");
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
