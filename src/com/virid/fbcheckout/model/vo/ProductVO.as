package com.virid.fbcheckout.model.vo
{
	import flash.events.EventDispatcher;
	
	public class ProductVO extends EventDispatcher
	{
		public var name : String;
		public var sku : String;
		public var styleid : String;
		public var color : String;
		public var size: String;
		public var source : String;
		public var price : String;
		
		//meta
		public var rating:Number;
	}
}