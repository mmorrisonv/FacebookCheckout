package com.virid.fbcheckout.model.vo
{
	import flash.events.EventDispatcher;
	
	public class SkuVO extends EventDispatcher
	{
		public var name : String;
		public var size_code : String;
		public var size_name: String;
		public var parentColor : ColorVO;
		public var qty : Number;
		public var price : Number;
	}
}