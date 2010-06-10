package org.handbones.mvcs 
{
	import org.handbones.base.ActionMap;
	import org.handbones.core.IActionMap;
	import org.handbones.model.SettingsModel;
	import org.robotlegs.mvcs.Mediator;

	/**
	 * @author Matan Uberstein
	 */
	public class RootActionMediator extends Mediator 
	{

		[Inject]
		public var settingsModel : SettingsModel;

		protected var _actionMap : IActionMap;

		public function RootActionMediator()
		{
		}

		override public function preRemove() : void 
		{
			if(_actionMap)
				_actionMap.unmapActions();
			super.preRemove();
		}

		protected function get actionMap() : IActionMap 
		{
			return _actionMap || (_actionMap = new ActionMap(eventDispatcher, settingsModel.actions));
		}
	}
}
