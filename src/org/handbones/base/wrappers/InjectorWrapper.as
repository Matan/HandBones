package org.handbones.base.wrappers 
{
	import org.handbones.core.wrappers.IInjectorWrapper;
	import org.robotlegs.core.IInjector;

	/**
	 * @author Matan Uberstein
	 */
	public class InjectorWrapper implements IInjectorWrapper
	{

		[Inject]
		public var injector : IInjector;
		
		protected var _mappings : Array;

		public function InjectorWrapper() 
		{
			_mappings = [];			
		}

		public function mapValue(whenAskedFor : Class, useValue : Object, named : String = "") : *
		{
			saveMapping(whenAskedFor, named);
			return injector.mapValue(whenAskedFor, useValue, named);
		}

		public function mapClass(whenAskedFor : Class, instantiateClass : Class, named : String = "") : *
		{
			saveMapping(whenAskedFor, named);
			return injector.mapClass(whenAskedFor, instantiateClass, named);
		}

		public function mapSingleton(whenAskedFor : Class, named : String = "") : *
		{
			saveMapping(whenAskedFor, named);
			return injector.mapSingleton(whenAskedFor, named);
		}

		public function mapSingletonOf(whenAskedFor : Class, useSingletonOf : Class, named : String = "") : *
		{
			saveMapping(whenAskedFor, named);
			return injector.mapSingletonOf(whenAskedFor, useSingletonOf, named);
		}

		public function mapRule(whenAskedFor : Class, useRule : *, named : String = "") : *
		{
			saveMapping(whenAskedFor, named);
			return injector.mapRule(whenAskedFor, useRule, named);
		}

		public function injectInto(target : Object) : void
		{
			injector.injectInto(target);
		}

		public function instantiate(clazz : Class) : *
		{
			return injector.instantiate(clazz);
		}

		public function unmap(clazz : Class, named : String = "") : void
		{
			var mapping : Object;
			var i : int = _mappings.length;
			while (i--)
			{
				mapping = _mappings[i];
				if(mapping.clazz == clazz && mapping.named == named)
					_mappings.splice(i, 1);
			}
			injector.unmap(clazz, named);
		}

		public function unmapAll() : void
		{
			var mapping : Object;
			while (mapping = _mappings.pop())
			{
				injector.unmap(mapping.clazz, mapping.named);
			}
		}

		protected function saveMapping(whenAskedFor : Class, named : String = "") : void
		{
			_mappings.push({clazz:whenAskedFor, named:named});
		}
	}
}
