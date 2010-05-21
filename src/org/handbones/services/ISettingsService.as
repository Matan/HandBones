package org.handbones.services 
{
	import flash.net.URLRequest;

	/**
	 * @author Matan Uberstein
	 */
	public interface ISettingsService 
	{
		/**
		 * Invodes loading of the settings file.
		 * A cache killer url variable will be added automatically to make user that changes to this file is not cached.
		 * 
		 * @param request <code>URLRequest</code> of the settings file.
		 */
		function load(request : URLRequest) : void
	}
}
