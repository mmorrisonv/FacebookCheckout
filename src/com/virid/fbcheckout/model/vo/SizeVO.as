package com.virid.fbcheckout.model.vo
{
	import flash.events.EventDispatcher;
	
	public class SizeVO extends EventDispatcher
	{
		public var name     : String;
		public var sku      : String;
		public var price	: Number;
		public var size     : String;
		public var size_code: String
		public var index    : Number;
		public var image    : String;
		public var color    : ColorVO;
	}
}