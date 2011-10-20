package com.virid.fbcheckout.model
{
	import com.virid.fbcheckout.model.Model;
	import com.virid.fbcheckout.model.vo.AltViewVO;
	import com.virid.fbcheckout.model.vo.ColorVO;
	import com.virid.fbcheckout.model.vo.ProductVO;
	import com.virid.fbcheckout.model.vo.SizeVO;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;

	[Event(name="MainProductChanged", type="flash.events.Event")]
	[Event(name="MainProductColorChanged", type="flash.events.Event")]
	
	public class Model extends EventDispatcher
	{
		
		/*Singelton Model code*/
		private static var instance:Model;
		public function Model(){
			instance=this;	
		}

		public static function getInstance():Model{
			if(instance == null)
				instance = new Model();
			return instance;
		}
		/*End Singleton Model code*/
		
		
		/*
		 *Event Definition
		*/
		public static const MainProductChanged:String = "MPC";
		public static const MainProductColorSKUChanged:String = "MPCSC";
		public static const MainProductImageChanged:String = "MPIC";
		public static const StartCheckout:String = "SCOUT";
		public static const StartProdDetail:String = "SPDETAIL";
		/*
		 * */
		//public var AltViews:ArrayCollection = new ArrayCollection(); - default alt views stored on the MainProduct
		public var Colors:ArrayCollection = new ArrayCollection();
		//public var SKUs:ArrayCollection = new ArrayCollection();
		private var _MainProductImage:AltViewVO = new AltViewVO();
		private var _MainProduct:ProductVO = new ProductVO();
		private var _MainProductColor:ColorVO = new ColorVO();
		private var _MainProductSKU:SizeVO = new SizeVO();
		
		/*
		 * Setters and Getters for Main Elements*/
		public function get MainProduct():ProductVO
		{
			return _MainProduct;
		}

		public function set MainProduct(value:ProductVO):void
		{
			_MainProduct = value;
			_MainProductColor = _MainProduct.colorObj;
			var e:Event = new Event(MainProductChanged,true,false);
			this.dispatchEvent(e);
		}
		public function set MainProductColor(value:ColorVO):void
		{
			_MainProductColor= value;
			_MainProduct.colorObj = value;
			var e:Event = new Event(MainProductColorSKUChanged,true,false);
			this.dispatchEvent(e);
		}
		public function set MainProductSKU(value:SizeVO):void
		{
			_MainProductSKU = value;
			_MainProduct.colorObj.currentSKU = value;
			var e:Event = new Event(MainProductColorSKUChanged,true,false);
			this.dispatchEvent(e);
		}
		public function get MainProductImage():AltViewVO
		{
			return _MainProductImage;	
		}
		public function set MainProductImage(value:AltViewVO):void
		{
			_MainProductImage = value;
			var e:Event = new Event(MainProductImageChanged,true,false);
			this.dispatchEvent(e);
		}
		public function set initiateCheckout(value:Object):void
		{
			var e:Event = new Event(StartCheckout,true,false);
			this.dispatchEvent(e);
		}
		public function set initiateProdDetail(value:Object):void
		{
			var e:Event = new Event(StartProdDetail,true,false);
			this.dispatchEvent(e);
		}
	}	
}