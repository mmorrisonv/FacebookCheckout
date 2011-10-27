package com.virid.fbcheckout.model.vo
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class AddressVO extends EventDispatcher
	{
		public var name:String = new String();
		public var userfirstname:String = new String();
		public var userlastname:String = new String();
		public var address1:String = new String();
		public var address2:String = new String();
		public var city:String = new String();
		public var state:String = new String();
		public var country:String = new String();
		public var zip:String = new String();
		
		
	}
}