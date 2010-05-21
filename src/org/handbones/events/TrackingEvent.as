package org.handbones.events 
{
	import mu.utils.ToStr;

	import flash.events.Event;

	/**
	 * @author Matan Uberstein
	 */
	public class TrackingEvent extends Event
	{
		public static const TRACK : String = "TRACK";

		protected var _url : String;		protected var _action : String;
		protected var _category : String;		protected var _label : String;		protected var _value : Number;

		public function TrackingEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			super(type, bubbles, cancelable);
		}

		public function get url() : String
		{
			return _url;
		}

		public function set url(url : String) : void
		{
			_url = url;
		}

		public function get category() : String
		{
			return _category;
		}

		public function set category(category : String) : void
		{
			_category = category;
		}

		public function get label() : String
		{
			return _label;
		}

		public function set label(label : String) : void
		{
			_label = label;
		}

		public function get value() : Number
		{
			return _value;
		}

		public function set value(value : Number) : void
		{
			_value = value;
		}

		public function get action() : String
		{
			return _action;
		}

		public function set action(action : String) : void
		{
			_action = action;
		}

		override public function clone() : Event 
		{
			var event : TrackingEvent = new TrackingEvent(type, bubbles, cancelable);
			event.url = url;			event.action = action;			event.category = category;			event.label = label;			event.value = value;
			
			return event;
		}

		override public function toString() : String 
		{
			return String(new ToStr(this));
		}
	}
}
