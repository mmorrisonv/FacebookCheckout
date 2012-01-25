package com.virid.fbcheckout.model.vo
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class ShippingOptionVO extends EventDispatcher
	{
		public var id:String = new String();
		public var index:Number;
		public var name:String = new String();
		public var price:Number = new Number();
		public var desc:String;
		
	}
}