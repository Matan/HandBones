package org.handbones.core.wrappers 
{
	import org.robotlegs.core.IViewMap;

	/**
	 * @author Matan Uberstein
	 */
	public interface IViewMapWrapper extends IViewMap 
	{
		/**
		 * Unmaps all package mappings made on this instance.
		 */
		function unmapPackages() : void

		/**
		 * Unmaps all type mappings made on this instance.
		 */
		function unmapTypes() : void

		/**
		 * Unmaps both package and type mappings made on this instance.
		 */
		function unmap() : void
	}
}
