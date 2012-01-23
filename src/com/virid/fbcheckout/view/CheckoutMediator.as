package com.virid.fbcheckout.view
{
	import com.adobe.serialization.json.JSON;
	import com.virid.fbcheckout.model.Model;
	
	import controller.commands.checkoutArbiter;
	
	import flash.events.Event;
	
	import mx.controls.CheckBox;
	import mx.effects.Sequence;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	import spark.effects.Animate;
	import spark.effects.animation.MotionPath;
	import spark.effects.animation.SimpleMotionPath;
	import spark.effects.easing.Power;

	public class CheckoutMediator
	{
		private var model:Model = Model.getInstance();
		private var ui:Checkout;
		
		private var uiTOaddressPropertyMap:Array;
		
		private var cartHTTPService:HTTPService = new HTTPService();
		
		//tranition variables
		private var bigease:Power = new Power();
		private var v:Vector.<MotionPath> = new Vector.<MotionPath>();
		private var a1:Animate = new Animate();
		private var m:SimpleMotionPath = new SimpleMotionPath();
		
		public function CheckoutMediator():void
		{
			
		}
		
		public function register(_ui:Checkout):void
		{
			this.ui = _ui;
			this.ui.addEventListener(Checkout.BILLING_SAME_AS,billing_checkout);
			this.ui.addEventListener(Checkout.CHECKOUT_PURCHASE,onPurchase);
			
			this.model.addEventListener(Model.MainProductSKUChanged,onProdColorSKUChanged);
			onProdColorSKUChanged(null);//just in case event has already been thrown
			//model listeners:ui
			this.model.addEventListener(Model.DisplayCheckoutPanel,ui_gotoCheckoutMode);
			this.model.addEventListener(Model.StartProdDetail,ui_gotoProdDetail);
			mapUIFieldsToModel();
	
		}
		
		protected function onPurchase(event:Event):void
		{
			//updateCartTotals();
			

			this.model._blillingAddress.firstname = this.ui.bfname.text;
			this.model._shippingAddress.firstname = this.ui.sfname.text;
			this.model._blillingAddress.lastname = this.ui.blname.text 
			this.model._shippingAddress.lastname = this.ui.slname.text;
			this.model._blillingAddress.address1 = this.ui.baddress1.text 
			this.model._shippingAddress.address1 = this.ui.saddress1.text;
			this.model._blillingAddress.address2 = this.ui.baddress2.text 
			this.model._shippingAddress.address2 = this.ui.saddress2.text;
			this.model._blillingAddress.state = this.ui.bstate.text 
			this.model._shippingAddress.state = this.ui.sstate.text;
			this.model._blillingAddress.zip = this.ui.bzip.text 
			this.model._shippingAddress.zip= this.ui.szip.text;
			this.model._blillingAddress.city = this.ui.bcity.text 
			this.model._shippingAddress.city = this.ui.scity.text;
			
			this.model._blillingAddress.email = this.model._shippingAddress.email = this.ui.email.text;
			this.model._blillingAddress.phone = this.model._shippingAddress.phone = this.ui.phonenum.text;
			
			var shpOpt:Number = new Number();
			shpOpt = this.ui.soptions.selectedIndex;
			
			//this.model._shippingAddress.Method = "STD"
			switch(shpOpt)
			{
				case 0:
					this.model._shippingAddress.Method = "STD";
					break;
				case 1:
					this.model._shippingAddress.Method = "2DAY";
					break;
				case 2:
					this.model._shippingAddress.Method = "1DAY";
					break;
					
			}
			//record ccard info
			this.model._ccard.number = this.ui.bcardnum.text;
			this.model._ccard.ccv = this.ui.bcardcvv.text;
			this.model._ccard.month = this.ui.bcardmonth.text;
			this.model._ccard.year = this.ui.bcardyear.text;
			this.model._ccard.exp = this.model._ccard.month + "/" + this.model._ccard.year;
			
			//send addresses and card info to class that will handle checkout
			var checkoutProcess:checkoutArbiter = new checkoutArbiter();
			
			//call up the notice modal
			/*var obj:Object = new Object();
			obj.start = "NOW";
			this.model.showStatus = obj;*/
		}
		
		protected function billing_checkout(event:Event):void
		{
			// TODO Auto-generated method stub
			
		}
		
		private function mapUIFieldsToModel():void
		{
			this.ui.sfname;
		}
		
		protected function onProdColorSKUChanged(event:Event):void
		{
			//if(this.model.SelectedProduct.colorObj.currentSize != null)
			//this.ui.productPrice.text = '$' + String(this.model.SelectedProduct.colorObj.currentSize.price) + ' USD';
			
		}
		protected function updateCartTotals():void
		{
			//set shipping address
			this.cartHTTPService.resultFormat="text";
			this.cartHTTPService.addEventListener("fault", onCartJSONFault);
			var paramsCart:Object = {};
			paramsCart['action'] = "update";
			paramsCart['qty'] = 1;
			paramsCart['id'] = this.model.SelectedProduct.colorObj.currentSize.OID;
			this.cartHTTPService.url = this.model.urlRoot + "api/cart.aspx";
			this.cartHTTPService.addEventListener("result", onCartJSONResult); 
			this.cartHTTPService.send();
		}
		
		protected function onCartJSONFault(event:FaultEvent):void
		{
			// TODO Auto-generated method stub
			
		}
		
		protected function onCartJSONResult(event:ResultEvent):void
		{
			var obj:Object = JSON.decode(String(event.result));
			
			this.ui.cartPrice.text = "$" + obj.total + " USD";
		}
		
		
		protected function ui_gotoCheckoutMode(event:Event):void
		{
			updateCartTotals();
			this.ui.visible = true;
			this.ui.includeInLayout = true;
			a1 = new Animate();
			a1.target = this.ui; a1.duration = 600; a1.easer = bigease;
			m = new SimpleMotionPath();
			m.property = 'y'; m.valueTo = 95;
			v = new Vector.<MotionPath>();v.push(m);
			a1.motionPaths = v;
			var p:Sequence = new Sequence();
			p.addChild(a1);
			p.play( );
		}
		
		protected function ui_gotoProdDetail(event:Event):void
		{
			this.ui.animateToProdDetail.play();
			
		}

	}
}