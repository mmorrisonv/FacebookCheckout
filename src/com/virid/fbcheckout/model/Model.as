package com.virid.fbcheckout.model
{
	import com.virid.fbcheckout.model.Model;
	import com.virid.fbcheckout.model.vo.ProductVO;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;

	[Event(name="MainProductChanged", type="flash.events.Event")]
	
	public class Model extends EventDispatcher
	{
		
		/*Singelton Model code*/
		private static var instance:Model;
		public function Model()
		{
			instance=this;	
		}
		
		public static function getInstance():Model
		{
			if(instance == null)
				instance = new Model();
			return instance;
		}
		/*End Singleton Model code*/
		
		
		/*
		 *Events  
		*/
		public static const MainProductChanged:String = "MPC";
		
		/*
		 * */
		public var AltViews:ArrayCollection = new ArrayCollection();
		private var _MainProduct:ProductVO = new ProductVO();

		public function get MainProduct():ProductVO
		{
			return _MainProduct;
		}

		public function set MainProduct(value:ProductVO):void
		{
			_MainProduct = value;
			var e:Event = new Event(MainProductChanged,true,false);
			this.dispatchEvent(e);
			
		}

		
	}	
}