package com.virid.fbcheckout.model.vo
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	public class CCardVO extends EventDispatcher
	{
		public var name:String = new String();
		public var type:String = new String();
		public var number:String = new String();
		public var exp:String = new String();
		public var ccv:String = new String();
		public var month:String = new String();
		public var year:String = new String();
	}
}