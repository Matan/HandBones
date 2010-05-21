package org.handbones.base 
{
	import org.handbones.core.IPage;
	import org.robotlegs.mvcs.Mediator;

	/**
	 * @author Matan Uberstein
	 */
	public class PageMediator extends Mediator
	{

		[Inject]
		public var page : IPage;
		
		override public function preRegister() : void 
		{
			page.preStartup();
			super.preRegister();
		}

		override public function onRegister() : void 
		{
			page.startup();
		}

		override public function preRemove() : void 
		{
			page.preShutdown();
			super.preRemove();
		}

		override public function onRemove() : void 
		{
			page.shutdown();
		}
	}
}
