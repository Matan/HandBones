package org.handbones.base.wrappers 
{
	import org.handbones.core.wrappers.ICommandMapWrapper;
	import org.robotlegs.core.ICommandMap;

	/**
	 * @author Matan Uberstein
	 */
	public class CommandMapWrapper implements ICommandMapWrapper 
	{

		[Inject]
		public var commandMap : ICommandMap;

		protected var _mappings : Array;

		public function CommandMapWrapper() : void 
		{
			_mappings = [];
		}

		public function hasEventCommand(eventType : String, commandClass : Class, eventClass : Class = null) : Boolean
		{
			return commandMap.hasEventCommand(eventType, commandClass, eventClass);
		}

		public function mapEvent(eventType : String, commandClass : Class, eventClass : Class = null, oneshot : Boolean = false) : void
		{
			_mappings.push({eventType:eventType, commandClass:commandClass, eventClass:eventClass});
			commandMap.mapEvent(eventType, commandClass, eventClass, oneshot);
		}

		public function unmapEvent(eventType : String, commandClass : Class, eventClass : Class = null) : void
		{
			var mapping : Object;
			var i : int = _mappings.length;
			while (i--)
			{
				mapping = _mappings[i];
				if(mapping.eventType == eventType && mapping.commandClass == commandClass && mapping.eventClass == eventClass)
					_mappings.splice(i, 1);
			}
			commandMap.unmapEvent(eventType, commandClass, eventClass);
		}

		public function unmapEvents() : void
		{
			var mapping : Object;
			while (mapping = _mappings.pop())
			{
				commandMap.unmapEvent(mapping.eventType, mapping.commandClass, mapping.eventClass);
			}
		}
	}
}
