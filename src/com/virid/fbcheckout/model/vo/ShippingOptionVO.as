package com.virid.fbcheckout.model.vo
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class ShippingOptionVO extends EventDispatcher
	{
		public var id:String = new String();
		public var index:Number;
		public var name:String = new String();
		public var discountPrice:Number = -1;
		public var price:Number = new Number();
		public var fullPrice:Number = new Number();
		private var _discountMode:Boolean = false;

		public function get discountMode():Boolean
		{
			return _discountMode;
		}

		public function set discountMode(value:Boolean):void
		{
			
			_discountMode = value;
			if( _discountMode && discountPrice != -1 )
			{
				this.price = discountPrice;
			}
			else
			{
				this.price = fullPrice
			}
			
		}

		public var desc:String;
		
		
	}
}