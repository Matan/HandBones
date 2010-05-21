package org.handbones.events {
	import flash.events.Event;

	/**
	 * @author Matan Uberstein
	 */
	public class SettingsEvent extends Event {

		public static const ERROR : String = "ERROR";
		public static const LOADED : String = "LOADED";
		
		public var errorMessage : String;
		
		public function SettingsEvent(type : String) {
			super(type);
		}
	}
}
