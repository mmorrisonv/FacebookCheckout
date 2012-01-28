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
	import com.virid.fbcheckout.view.smallviews.shippingOptionsItemRenderer;
	
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
		public static const MainProductSetup:String = "MPSU";
		public static const MainProductImageChanged:String = "MPIC";
		public static const CheckoutComplete:String = "CHOCMPLT";
		public static const CheckoutFailed:String = "COFAIL";
		public static const StatusUpdate:String = "SU";
		public static const CheckoutModal:String = "CM";
		public static const DisplayCheckoutPanel:String = "SCOUT";
		public static const StartProdDetail:String = "SPDETAIL";
		public static const ShippingOptionsLoaded:String = "SOL";
		public static const ChargeTotalsChanged:String = "CTC";
		//checkout errors
		public static const CheckoutErrorsInAddCart:String = "EAC";
		public static const CheckoutErrorsInShipping:String = "ESA";
		public static const CheckoutErrorsInBilling:String = "EBA";
		public static const CheckoutErrorsInCCard:String = "ECC";
		public static const CheckoutErrorsInPurchase:String = "EPP";
		/*
		 * */
		//public var AltViews:ArrayCollection = new ArrayCollection(); - default alt views stored on the MainProduct
		
		
		public var urlRoot:String = "http://www.journeys.com/";
		public var urlRootSecure:String = "https://www.journeys.com/";
		public var urlRootTracking:String = "http://www.journeys.com/pagetrack.aspx?campaignid=1182&action=VIEW&link=/"
		public var httpService:HTTPService = new HTTPService();
		public var productID:String = '56064';		//main root product id
		private var _productSetup:Boolean = false;
		
		//extra app data
		public var lastError:String;
		public var requestedSize:SizeVO;
		public var checkoutComplete:Boolean = false;
		
		
		public function updateCartTotalsInOneFunction(jsonDecodedCartTotals:Object):void
		{
			var newShippingCharge:Number = jsonDecodedCartTotals.shipping as Number;
			var newTaxCharge:Number = jsonDecodedCartTotals.taxes as Number;
			var newServicesCharge:Number = jsonDecodedCartTotals.services as Number;
			var newProductCharge:Number = jsonDecodedCartTotals.subtotal as Number;
			
			if( newShippingCharge && newShippingCharge != 0 && !isNaN(newShippingCharge) )
				this._chargeShipping = Number(newShippingCharge);
			if( newTaxCharge && newTaxCharge != 0 && !isNaN(newTaxCharge) )
				this._chargeTax = Number(newTaxCharge);
			
			this.chargeProduct = Number(jsonDecodedCartTotals.subtotal);
			this._chargeService = Number(jsonDecodedCartTotals.services);
			updateChargeTotal();
			
		}
		public var chargeProduct:Number = 0;
		private var _chargeShipping:Number = 4.95;
		public var chargeShippingVO:ShippingOptionVO;
		public function get chargeShipping():Number
		{
			return _chargeShipping;
		}

		public function set chargeShipping(value:Number):void
		{
			if(value <= 0 || isNaN(value) )
				return;
			
			//correlate our new shipping option to one of the hardcoded values
			for each( var shipOpt:ShippingOptionVO in this.AllShippingOptions)
			{
				if(shipOpt.price == value)
					chargeShippingVO = shipOpt;
			}
			_chargeShipping = value;
			updateChargeTotal();
		}

		private var _chargeTax:Number = 0;

		public function get chargeTax():Number
		{
			return _chargeTax;
		}

		public function set chargeTax(value:Number):void
		{
			_chargeTax = value;
			updateChargeTotal();
		}

		private var _chargeService:Number = 0;

		public function get chargeService():Number
		{
			return _chargeService;
		}

		public function set chargeService(value:Number):void
		{
			if( isNaN(value) )
				return;
			_chargeService = value;
			updateChargeTotal();
		}

		public var _chargeTotal:Number;
		public function get chargeTotal():Number
		{
			return _chargeTotal;
		}
		
		private function updateChargeTotal():void
		{
			_chargeTotal = chargeProduct + chargeTax + 	chargeService + chargeShipping;
			var e:Event = new Event(ChargeTotalsChanged,true,false);
			this.dispatchEvent(e);
		}
		
		/*public function set chargeTotal(value:Number):void
		{
			return _chargeTotal;
		}*/
		public var AllShippingOptions:ArrayCollection = new ArrayCollection(); // basically every elligible shipping option as shippiongoptionVO setupin context
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
			//_MainProductSKU = _MainProduct.colorObj.currentSize;
			var e:Event = new Event(MainProductChanged,true,false);
			this.dispatchEvent(e);
		}
		
		public function get productSetup():Boolean
		{
			return _productSetup;
		}
		
		public function set productSetup(value:Boolean):void
		{
			_productSetup = value;
			var e:Event = new Event(MainProductSetup,true,false);
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
			Checkout Error Handelers		
		*/
		
		public var lastCheckoutErrors:Object;
		
		public function handleCheckoutAddCartErrors(errors:Object):void
		{
			this.lastCheckoutErrors = errors;
			if(errors == null || errors.length == 0)
				return
			var e:Event = new Event(CheckoutErrorsInAddCart,true,false);
			this.dispatchEvent(e);
			var ef:Event = new Event(CheckoutFailed,true,false);
			this.dispatchEvent(ef);
		}

		public function handleCheckoutBillingAddressErrors(errors:Object):void
		{
			
			this.lastCheckoutErrors = errors;
			if(errors == null || errors.length == 0)
				return
			var e:Event = new Event(CheckoutErrorsInBilling,true,false);
			this.dispatchEvent(e);
			var ef:Event = new Event(CheckoutFailed,true,false);
			this.dispatchEvent(ef);
		}

		public function handleCheckoutShippingAddressErrors(errors:Object):void
		{
			this.lastCheckoutErrors = errors;
			if(errors == null || errors.length == 0)
				return;
			var e:Event = new Event(CheckoutErrorsInShipping,true,false);
			this.dispatchEvent(e);
			var ef:Event = new Event(CheckoutFailed,true,false);
			this.dispatchEvent(ef);
		}
		
		public function handleCheckoutCCardErrors(errors:Object):void
		{
			this.lastCheckoutErrors = errors;
			if(errors == null || errors.length == 0)
				return;
			var e:Event = new Event(CheckoutErrorsInCCard,true,false);
			this.dispatchEvent(e);
			var ef:Event = new Event(CheckoutFailed,true,false);
			this.dispatchEvent(ef);
		}
		
		public function handleCheckoutPurchaseErrors(errors:Object):void
		{
			this.lastCheckoutErrors = errors;
			var e:Event = new Event(CheckoutErrorsInPurchase,true,false);
			this.dispatchEvent(e);
			var ef:Event = new Event(CheckoutFailed,true,false);
			this.dispatchEvent(ef);
		}
		
		/*
		*---------------------------------------------------
		*Panel and Modal Transitions
		*/
		//show status modal
		public function set showError(value:String):void
		{
			this.lastError = value;
			var e:Event = new Event(StatusUpdate,true,false);
			this.dispatchEvent(e);
		}	
		//show status modal
		public function set showStatus(value:Object):void
		{
			var e:Event = new Event(StatusUpdate,true,false);
			this.dispatchEvent(e);
		}		
		//show confirmation panel
		public function onCheckoutComplete(value:Object):void{
			this.checkoutComplete=true;
			var e:Event = new Event(CheckoutComplete,true,false);
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