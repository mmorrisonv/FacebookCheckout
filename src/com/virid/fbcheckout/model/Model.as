package com.virid.fbcheckout.model
{
	import com.virid.fbcheckout.model.Model;
	import com.virid.fbcheckout.model.vo.AddressVO;
	import com.virid.fbcheckout.model.vo.AltViewVO;
	import com.virid.fbcheckout.model.vo.ColorVO;
	import com.virid.fbcheckout.model.vo.ProductVO;
	import com.virid.fbcheckout.model.vo.ShippingOptionVO;
	import com.virid.fbcheckout.model.vo.SizeVO;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.http.HTTPService;

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
		public static const CheckoutModal:String = "CM";
		public static const DisplayCheckout:String = "SCOUT";
		public static const StartProdDetail:String = "SPDETAIL";
		/*
		 * */
		//public var AltViews:ArrayCollection = new ArrayCollection(); - default alt views stored on the MainProduct
		
		public var urlRoot:String = "http://www.journeys.com/api/";
		public var httpService:HTTPService = new HTTPService();
		public var productID:String = '201046';		//main root product id
		
		public var AllSKUs:ArrayCollection = new ArrayCollection(); // basically all colors available - size/oids within
		//public var SKUs:ArrayCollection = new ArrayCollection();
		private var _MainProductImage:AltViewVO = new AltViewVO();
		private var _MainProduct:ProductVO = new ProductVO();
		private var _MainProductColor:ColorVO = new ColorVO();
		private var _MainProductSKU:SizeVO = new SizeVO();
		
		
		/*
		 * Checkout Based info*/
		public var _ShippingOptions:ShippingOptionVO = new ShippingOptionVO();
		public var _shippingAddress:AddressVO = new AddressVO();
		public var _blillingAddress:AddressVO = new AddressVO();
		public var Addresses:ArrayCollection = new ArrayCollection();
		
		/*
		 * Setters and Getters for Main Elements*/
		
		public function get SelectedProduct():ProductVO
		{
			return _MainProduct;
		}

		public function set SelectedProduct(value:ProductVO):void
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
			for each(var size:SizeVO in _MainProduct.colorObj.Sizes)
			{
				if(size.isdefault)
				this.MainProductSKU = size;
				//_MainProduct.colorObj.currentSize
			}
			this.SelectedProduct = _MainProduct;
			var e:Event = new Event(MainProductColorSKUChanged,true,false);
			this.dispatchEvent(e);
		}
		public function set MainProductSKU(value:SizeVO):void
		{
			_MainProductSKU = value;
			_MainProduct.colorObj.currentSize = value;
			
			this.SelectedProduct = _MainProduct;
			
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
			var e:Event = new Event(CheckoutModal,true,false);
			this.dispatchEvent(e);
		}
		public function set displayCheckout(value:Object):void
		{
			var e:Event = new Event(DisplayCheckout,true,false);
			this.dispatchEvent(e);
		}
		public function set initiateProdDetail(value:Object):void
		{
			var e:Event = new Event(StartProdDetail,true,false);
			this.dispatchEvent(e);
		}
		
		public function PurchaseCurrent():void
		{
			;
		}
	}	
}