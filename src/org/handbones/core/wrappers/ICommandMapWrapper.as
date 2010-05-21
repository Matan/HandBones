package org.handbones.core.wrappers 
{
	import org.robotlegs.core.ICommandMap;

	/**
	 * @author Matan Uberstein
	 */
	public interface ICommandMapWrapper extends ICommandMap 
	{
		/**
		 * Unmaps all command mappings made on this instance.
		 */
		function unmapEvents() : void
	}
}
