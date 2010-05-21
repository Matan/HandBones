package org.handbones.model 
{
	import org.handbones.core.IPage;
	import org.handbones.events.PageEvent;
	import org.robotlegs.mvcs.Actor;

	/**
	 * @author Matan Uberstein
	 */
	public class PageModel extends Actor 
	{

		protected var _currentPage : IPage;
		protected var _previousPage : IPage;

		public function PageModel() 
		{
		}

		public function get currentPageId() : String
		{
			if(_currentPage)
				return _currentPage.settings.id;
			return null;
		}

		public function get previousPageId() : String
		{
			if(_previousPage)
				return _previousPage.settings.id;
			return null;
		}

		public function set currentPage(currentPage : IPage) : void 
		{
			_previousPage = _currentPage;
			_currentPage = currentPage;
			dispatch(new PageEvent(PageEvent.PAGE_CHANGE, (_currentPage) ? _currentPage.settings : null));
		}

		public function get currentPage() : IPage 
		{
			return _currentPage;
		}

		public function get previousPage() : IPage 
		{
			return _previousPage;
		}
	}
}
