package org.handbones.model 
{
	import org.handbones.core.IPage;
	import org.handbones.core.IPageModel;
	import org.robotlegs.mvcs.Actor;

	/**
	 * @author Matan Uberstein
	 */
	public class NavigatorModel extends Actor 
	{
		protected var _currentPage : IPage;
		protected var _previousPage : IPage;

		public function NavigatorModel() 
		{
		}

		public function set currentPage(currentPage : IPage) : void 
		{
			_previousPage = _currentPage;
			_currentPage = currentPage;
		}

		public function get currentPage() : IPage 
		{
			return _currentPage;
		}

		public function get previousPage() : IPage 
		{
			return _previousPage;
		}

		public function get currentPageVo() : IPageModel
		{
			if(_currentPage)
				return _currentPage.model;
			return null;
		}

		public function get previousPageVo() : IPageModel
		{
			if(_previousPage)
				return _previousPage.model;
			return null;
		}

		public function get currentPageId() : String
		{
			if(_currentPage)
				return _currentPage.model.id;
			return null;
		}

		public function get previousPageId() : String
		{
			if(_previousPage)
				return _previousPage.model.id;
			return null;
		}
	}
}
