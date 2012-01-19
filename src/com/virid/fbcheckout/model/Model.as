package com.virid.fbcheckout.model
{
	import com.virid.fbcheckout.model.Model;
	import com.virid.fbcheckout.model.vo.AddressVO;
	import com.virid.fbcheckout.model.vo.AltViewVO;
	import com.virid.fbcheckout.model.vo.CCardVO;
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
		public static const MainProductSKUChanged:String = "MPSC";
		public static const MainProductColorChanged:String = "MPCC";
		public static const MainProductImageChanged:String = "MPIC";
		public static const StatusUpdate:String = "SU";
		public static const CheckoutModal:String = "CM";
		public static const DisplayCheckoutPanel:String = "SCOUT";
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
		public var _ccard:CCardVO = new CCardVO();
		//public var Addresses:ArrayCollection = new ArrayCollection();
		
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

			var e:Event = new Event(MainProductColorChanged,true,false);

			/*for each(var size:SizeVO in _MainProduct.colorObj.Sizes)
			{
				if(size.isdefault){
					this.MainProductSKU = size;
					_MainProduct.colorObj.currentSize = size;
				}
			}*/
			this.SelectedProduct = _MainProduct;

			this.dispatchEvent(e);
		}
		public function set MainProductSKU(value:SizeVO):void
		{
			_MainProductSKU = value;
			_MainProduct.colorObj.currentSize = value;
			
			this.SelectedProduct = _MainProduct;
			
			var e:Event = new Event(MainProductSKUChanged,true,false);
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
		
		/*
		*---------------------------------------------------
		*Panel and Modal Transitions
		*/
		//show status modal
		public function set showStatus(value:Object):void
		{
			var e:Event = new Event(StatusUpdate,true,false);
			this.dispatchEvent(e);
		}		
		//show chekcout options modal
		public function set initiateCheckoutPanel(value:Object):void
		{
			var e:Event = new Event(CheckoutModal,true,false);
			this.dispatchEvent(e);
		}
		//show checkout panel
		public function set displayCheckout(value:Object):void
		{
			var e:Event = new Event(DisplayCheckoutPanel,true,false);
			this.dispatchEvent(e);
		}
		//show the main product detail panel
		public function set initiateProdDetail(value:Object):void
		{
			var e:Event = new Event(StartProdDetail,true,false);
			this.dispatchEvent(e);
		}
		
	}	
}