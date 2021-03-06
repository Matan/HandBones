package org.handbones.mvcs 
{
	import org.handbones.base.ActionMap;
	import org.handbones.core.IActionMap;
	import org.handbones.core.IPageModel;
	import org.robotlegs.mvcs.Mediator;

	/**
	 * @author Matan Uberstein
	 */
	public class PageActionMediator extends Mediator 
	{
		[Inject]
		public var pageModel : IPageModel;

		protected var _actionMap : IActionMap;

		public function PageActionMediator()
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
			return _actionMap || (_actionMap = new ActionMap(eventDispatcher, pageModel.actions));
		}
	}
}
