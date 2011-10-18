package com.virid.fbcheckout.model.vo
{
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	
	public class ProductVO extends EventDispatcher
	{
		public var name     : String;
		public var sku      : String;
		public var styleid  : String;
		public var colorName: String;
		public var colorObj : ColorVO;
		public var size     : String;
		public var source   : String;
		public var price    : String;
		
		//meta
		public var rating:Number;
		
		//lists

	}
}