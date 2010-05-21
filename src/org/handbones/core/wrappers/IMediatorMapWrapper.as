package org.handbones.core.wrappers 
{
	import org.robotlegs.core.IMediatorMap;

	/**
	 * @author Matan Uberstein
	 */
	public interface IMediatorMapWrapper extends IMediatorMap 
	{
		/**
		 * Unmaps all mediator mappings made on this instance.
		 */
		function unmapViews() : void
	}
}
