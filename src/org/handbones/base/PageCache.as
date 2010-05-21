package org.handbones.base 
{
	import org.handbones.core.IPage;

	import flash.utils.Dictionary;

	/**
	 * @author Matan Uberstein
	 */
	public class PageCache 
	{

		protected var _pages : Dictionary;

		[PostConstruct]

		public function init() : void 
		{
			_pages = new Dictionary();
		}

		public function addPage(page : IPage) : void 
		{
			_pages[page.settings.id] = page;
		}

		public function getPage(id : String) : IPage 
		{
			return _pages[id];
		}

		public function isCached(id : String) : Boolean 
		{
			return (getPage(id)) ? true : false;
		}
	}
}
