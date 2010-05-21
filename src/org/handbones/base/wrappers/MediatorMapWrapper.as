package org.handbones.base.wrappers 
{
	import org.handbones.core.wrappers.IMediatorMapWrapper;
	import org.robotlegs.core.IMediator;
	import org.robotlegs.core.IMediatorMap;

	import flash.display.DisplayObjectContainer;

	/**
	 * @author Matan Uberstein
	 */
	public class MediatorMapWrapper implements IMediatorMapWrapper 
	{
		[Inject]
		public var mediatorMap : IMediatorMap;
		
		protected var _mappings : Array;

		public function MediatorMapWrapper()
		{
			_mappings = [];
		}

		public function mapView(viewClassOrName : *, mediatorClass : Class, injectViewAs : Class = null, autoCreate : Boolean = true, autoRemove : Boolean = true) : void 
		{
			_mappings.push({viewClassOrName:viewClassOrName});
			mediatorMap.mapView(viewClassOrName, mediatorClass, injectViewAs, autoCreate, autoRemove);
		}

		public function unmapView(viewClassOrName : *) : void 
		{
			var mapping : Object;
			var i : int = _mappings.length;
			while (i--)
			{
				mapping = _mappings[i];
				if(mapping.viewClassOrName == viewClassOrName)
					_mappings.splice(i, 1);
			}
			mediatorMap.unmapView(viewClassOrName);
		}

		public function unmapViews() : void
		{
			var mapping : Object;
			while (mapping = _mappings.pop())
			{
				mediatorMap.unmapView(mapping.viewClassOrName);
			}
		}
		
		public function hasMediatorForView(viewComponent : Object) : Boolean
		{
			return mediatorMap.hasMediatorForView(viewComponent);
		}
		
		public function createMediator(viewComponent : Object) : IMediator
		{
			return mediatorMap.createMediator(viewComponent);
		}
		
		public function hasMediator(mediator : IMediator) : Boolean
		{
			return mediatorMap.hasMediator(mediator);
		}
		
		public function removeMediatorByView(viewComponent : Object) : IMediator
		{
			return mediatorMap.removeMediatorByView(viewComponent);
		}
		
		public function registerMediator(viewComponent : Object, mediator : IMediator) : void
		{
			mediatorMap.registerMediator(viewComponent, mediator);
		}
		
		public function removeMediator(mediator : IMediator) : IMediator
		{
			return mediatorMap.removeMediator(mediator);
		}
		
		public function retrieveMediator(viewComponent : Object) : IMediator
		{
			return mediatorMap.retrieveMediator(viewComponent);
		}
		
		public function get enabled() : Boolean
		{
			return mediatorMap.enabled;
		}
		
		public function get contextView() : DisplayObjectContainer
		{
			return mediatorMap.contextView;
		}
		
		public function set contextView(value : DisplayObjectContainer) : void
		{
			mediatorMap.contextView = value;
		}
		
		public function set enabled(value : Boolean) : void
		{
			mediatorMap.enabled = enabled;
		}
	}
}
