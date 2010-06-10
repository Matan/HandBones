package org.handbones.core.page 
{
	import org.robotlegs.core.IMediatorMap;

	/**
	 * @author Matan Uberstein
	 */
	public interface IPageMediatorMap extends IMediatorMap 
	{
		/**
		 * Unmaps all mediator mappings made on this instance.
		 */
		function unmapViews() : void
	}
}
