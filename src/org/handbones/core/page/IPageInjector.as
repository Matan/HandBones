package org.handbones.core.page 
{
	import org.robotlegs.core.IInjector;

	/**
	 * @author Matan Uberstein
	 */
	public interface IPageInjector extends IInjector
	{
		/**
		 * Unmaps all injection mappings made on this instance.
		 */
		function unmapAll() : void
	}
}
