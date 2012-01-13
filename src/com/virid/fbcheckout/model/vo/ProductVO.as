package com.virid.fbcheckout.model.vo
{
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	
	public class ProductVO extends EventDispatcher
	{
		public var name     : String;
		//public var sku      : SizeVO;
		//public var styleid  : String;
		public var colorObj : ColorVO;
		//public var size     : String;
		//public var source   : String;
		//public var price    : String;
		public var altViews : ArrayCollection = new ArrayCollection();
		
		//meta
		public var rating:Number;
		
		//lists

	}
}