package org.handbones.core.page 
{
	import org.robotlegs.core.ICommandMap;

	/**
	 * @author Matan Uberstein
	 */
	public interface IPageCommandMap extends ICommandMap 
	{
		/**
		 * Unmaps all command mappings made on this instance.
		 */
		function unmapEvents() : void
	}
}
