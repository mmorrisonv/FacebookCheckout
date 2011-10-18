package controller.events
{
	import flash.events.Event;
	/**
	 * General event class than has a custom payload
	 * */	
	public class CustomEvent extends Event
	{
		public var data: Object;
		public function CustomEvent(type:String,_data:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = _data;
			super(type, bubbles, cancelable);
		}
	}
}