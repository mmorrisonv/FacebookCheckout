package com.virid.fbcheckout.model.vo
{
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	
	public class ColorVO extends EventDispatcher
	{
		public var name 		: String;
		public var colorcode	: String;
		public var styleid 		: String;
		public var hex 			: String;
		public var currentSize 	: SizeVO;
		
		//linked data
		public var Sizes 		: ArrayCollection = new ArrayCollection();
		public var AltViews		:ArrayCollection = new ArrayCollection();
		
		//meta
		public var imageFS 		: String;
		public var imageTB 		: String = "";
		public var imagePVW		: String = "";
		public var defaultColor	:Boolean = false;
		
	}
}