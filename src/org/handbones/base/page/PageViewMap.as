package org.handbones.base.page 
{
	import org.handbones.core.page.IPageViewMap;
	import org.robotlegs.core.IViewMap;

	import flash.display.DisplayObjectContainer;

	/**
	 * @author Matan Uberstein
	 */
	public class PageViewMap implements IPageViewMap
	{

		[Inject]
		public var viewMap : IViewMap;

		protected var _packageMappings : Array;		protected var _typeMappings : Array;

		public function PageViewMap()
		{
			_packageMappings = [];			_typeMappings = [];
		}

		public function mapPackage(packageName : String) : void 
		{
			_packageMappings.push(packageName);
			viewMap.mapPackage(packageName);
		}

		public function mapType(type : Class) : void 
		{
			_typeMappings.push(type);
			viewMap.mapType(type);
		}

		public function unmapPackage(packageName : String) : void 
		{
			var i : int = _packageMappings.length;
			while (i--)
			{
				if(_packageMappings[i] == packageName)
					_packageMappings.splice(i, 1);
			}
			viewMap.unmapPackage(packageName);
		}

		public function unmapType(type : Class) : void 
		{
			var i : int = _typeMappings.length;
			while (i--)
			{
				if(_typeMappings[i] == type)
					_typeMappings.splice(i, 1);
			}
			viewMap.unmapType(type);
		}

		public function unmapPackages() : void
		{
			var packageName : String;
			while (packageName = _packageMappings.pop())
			{
				viewMap.unmapPackage(packageName);
			}
		}

		public function unmapTypes() : void
		{
			var type : Class;
			while (type = _packageMappings.pop())
			{
				viewMap.unmapType(type);
			}
		}

		public function unmap() : void
		{
			unmapPackages();
			unmapTypes();
		}
		
		public function hasType(type : Class) : Boolean
		{
			return viewMap.hasType(type);
		}
		
		public function hasPackage(packageName : String) : Boolean
		{
			return viewMap.hasPackage(packageName);
		}
		
		public function get enabled() : Boolean
		{
			return viewMap.enabled;
		}
		
		public function get contextView() : DisplayObjectContainer
		{
			return viewMap.contextView;
		}
		
		public function set enabled(value : Boolean) : void
		{
			viewMap.enabled = value;
		}
		
		public function set contextView(value : DisplayObjectContainer) : void
		{
			viewMap.contextView = value;
		}
	}
}
