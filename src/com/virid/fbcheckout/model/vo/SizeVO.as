package com.virid.fbcheckout.model.vo
{
	import flash.events.EventDispatcher;
	
	public class SizeVO extends EventDispatcher
	{
		public var name     	: String;
		public var OID			: String;
		public var style_id     : String;
		public var price		: Number;
		public var color_code	: String;
		public var size     	: String;
		public var size_code	: String;
		public var size2     	: String;
		public var size2_code	: String;	
		public var qty			: Number;
		
		public var inStock		: Boolean;
		public var index    	: Number;
		public var image    	: String;
		//public var parent_sku    	: SKUVO;
		public var isdefault	: Boolean;
	}
}