package com.virid.fbcheckout.model.vo
{
	import flash.events.EventDispatcher;
	
	public class ColorVO extends EventDispatcher
	{
		public var name : String;
		public var sku : String;
		public var colorcode: String;
		public var styleid : String;
		public var hex : String;
		public var imageFS : String;
		[Bindable]
		public var imageTB : String = "";
	}
}