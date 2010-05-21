package org.handbones.core.wrappers 
{
	import org.robotlegs.core.IInjector;

	/**
	 * @author Matan Uberstein
	 */
	public interface IInjectorWrapper extends IInjector
	{
		/**
		 * Unmaps all injection mappings made on this instance.
		 */
		function unmapAll() : void
	}
}
