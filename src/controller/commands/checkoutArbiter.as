package controller.commands
{
	import com.adobe.serialization.json.JSON;
	import com.virid.fbcheckout.model.Model;
	
	import flash.events.Event;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;

	public class checkoutArbiter
	{
		
		private var model:Model = Model.getInstance();
		
		private var cartAddService:HTTPService = new HTTPService();
		private var shipAddressService:HTTPService = new HTTPService();
		private var billAddressService:HTTPService = new HTTPService();
		private var paymentService:HTTPService = new HTTPService();
		private var finalPurchaseService:HTTPService = new HTTPService();
		
		private var fxCallback:Function;
		
		private var contCheckout:Boolean;
		private var addCartErrors:Object;
		private var shippingErrors:Object;
		private var billingErrors:Object;
		private var ccardDetailErrors:Object;
		
		public function checkoutArbiter():void
		{
			//should we have a function to remove evertyhing from cart ::http://www.journeys.com/api/cart.aspx?action=remove&id=199852
			//add product to cart ::http://www.journeys.com/api/cart.aspx?action=update&id=199852&qty=1
			//get cart display ::http://www.journeys.com/api/cart.aspx
			//set shipping ::https://www.journeys.com/api/setshipping.aspx?
			//set billing ::https://www.journeys.com/api/setbilling.aspx?
			//set payment ::https://www.journeys.com/api/setpayment.aspx?
			//final checkout ::https://www.journeys.com/api/checkout.aspx
			
			//reset the checkout process
			contCheckout = true;
			
			//add current sku to cart
			this.cartAddService.resultFormat="text";
			this.cartAddService.addEventListener("fault", onAddedToCart_Fault);
			this.cartAddService.url = model.urlRoot + "api/cart.aspx";//?action=update&id="+sku+"&qty=1";
			var paramsCart:Object = {};
			paramsCart['action'] = "update";
			paramsCart['qty'] = 1;
			paramsCart['id'] = this.model.SelectedProduct.colorObj.currentSize.OID;
			this.cartAddService.addEventListener("result", onAddedToCart); 
			this.cartAddService.send(paramsCart);
		}
		
		public function sendShippingAddress():void
		{
			

			//set shipping address
			this.shipAddressService.resultFormat="text";
			this.shipAddressService.addEventListener("fault", onAddressShippingAdd_Fault);
			this.shipAddressService.url = model.urlRootSecure + "api/setshipping.aspx";
			
			var paramsShip:Object = {};
			paramsShip['firstname'] = this.model._shippingAddress.firstname;
			paramsShip['lastname'] = this.model._shippingAddress.lastname;
			paramsShip['address1'] = this.model._shippingAddress.address1;
			paramsShip['address2'] = this.model._shippingAddress.address2;
			paramsShip['state'] = this.model._shippingAddress.state;
			paramsShip['zip'] = this.model._shippingAddress.zip;
			paramsShip['city'] = this.model._shippingAddress.city;
			paramsShip['country'] = "US";
			paramsShip['email'] = this.model._shippingAddress.email;
			paramsShip['phone'] = this.model._shippingAddress.phone;
			paramsShip['Method'] = this.model.chargeShippingVO.id;
			
			this.shipAddressService.addEventListener("result", onAddressShippingAdd); 
			this.shipAddressService.send(paramsShip);
		}
		
		public function sendBillingAddress():void
		{
			//set billing address
			this.billAddressService.resultFormat="text";
			this.billAddressService.addEventListener("fault", onAddressBillingAdd_Fault);
			this.billAddressService.url = model.urlRootSecure + "api/setbilling.aspx";
			
			var paramsBill:Object = {};
			paramsBill['firstname'] = this.model._blillingAddress.firstname;
			paramsBill['lastname'] = this.model._blillingAddress.lastname; 			
			paramsBill['address1'] = this.model._blillingAddress.address1; 
			paramsBill['address2'] = this.model._blillingAddress.address2; 
			paramsBill['state'] = this.model._blillingAddress.state 
			paramsBill['zip'] = this.model._blillingAddress.zip;
			paramsBill['city'] = this.model._blillingAddress.city;
			paramsBill['country'] = "US";
			paramsBill['email'] = this.model._blillingAddress.email;
			paramsBill['phone'] = this.model._blillingAddress.phone;
			
			this.billAddressService.addEventListener("result", onAddressBillingAdd); 
			this.billAddressService.send(paramsBill);
			
		}
		
		public function sendPaymentInfo():void
		{
			//set payment info
			this.paymentService.resultFormat="text";
			this.paymentService.addEventListener("fault", onPaymentAdd_Fault);
			this.paymentService.url = model.urlRootSecure + "api/setpayment.aspx";
			
			var paramsCCard:Object = {};
			paramsCCard['cardnumber'] = this.model._ccard.number 
			paramsCCard['cardcvv'] = this.model._ccard.ccv 
			paramsCCard['cardexp'] = this.model._ccard.exp 
			this.paymentService.addEventListener("result", onPaymentAdded); 
			this.paymentService.send(paramsCCard);
		}
		
		public function finalCheckout():void
		{

			//final purchase
			this.finalPurchaseService.resultFormat="text";
			this.finalPurchaseService.addEventListener("fault", onPurchase_Fault);
			this.finalPurchaseService.url = model.urlRootSecure + "api/checkout.aspx";
			this.finalPurchaseService.addEventListener("result", onPurchaseComplete); 
			this.finalPurchaseService.send();
			
		}
		
		protected function onAddedToCart(event:ResultEvent):void
		{
			
			try{
				var obj:Object = JSON.decode(String(event.result));
			}
			catch(e:Error){
				Alert.show('Error Parsing JSON');
			}
			
			this.continueToNextStep(true,sendShippingAddress);
		}
		protected function onAddedToCart_Fault(event:FaultEvent):void
		{
			Alert.show('Adding Product To Cart Failed','Please try again later');
			
		}
		
		
		protected function onAddressShippingAdd(event:ResultEvent):void
		{
			try{
				var obj:Object = JSON.decode(String(event.result));
			}
			catch(e:Error){
				Alert.show('Error Parsing JSON');
			}
			trace(event.result);

			if( obj != null && obj.hasOwnProperty('errors') && obj.errors.length > 0 )
			{
				this.contCheckout = false;
				this.shippingErrors = obj.errors;
			}

			this.continueToNextStep( true ,sendBillingAddress);
		}		
		
		protected function onAddressShippingAdd_Fault(event:FaultEvent):void
		{
			
			Alert.show('Adding Address Failed','Please try again later');
			
		}
		
		
		protected function onAddressBillingAdd(event:ResultEvent):void
		{

			try{
				var obj:Object = JSON.decode(String(event.result));
			}
			catch(e:Error){
				Alert.show('Error Parsing JSON');
			}

			if( obj != null && obj.hasOwnProperty('errors') && obj.errors.length > 0 )
			{
				this.contCheckout = false;
				this.billingErrors = obj.errors;
			}

			this.continueToNextStep( true,sendPaymentInfo);//dontHalt here keep going on errors
		}
		

		
		protected function onAddressBillingAdd_Fault(event:FaultEvent):void
		{
			Alert.show('Adding Billing Address Failed','Please try again later');
			
		}
		

		
		protected function onPaymentAdded(event:ResultEvent):void
		{
			try{
				var obj:Object = JSON.decode(String(event.result));
			}
			catch(e:Error){
				Alert.show('Error Parsing JSON');
			}
			
			if( obj != null && obj.hasOwnProperty('errors') && obj.errors.length > 0 )
			{
				this.contCheckout = false;
				this.ccardDetailErrors = obj.errors;
			}
			
			this.showAllErrors();

			this.continueToNextStep(( obj.errors.length == 0 && contCheckout ),finalCheckout);
		}
		protected function showAllErrors():void
		{
			this.model.handleCheckoutAddCartErrors(this.addCartErrors);
			this.model.handleCheckoutShippingAddressErrors(this.shippingErrors);
			this.model.handleCheckoutBillingAddressErrors(this.billingErrors);
			this.model.handleCheckoutCCardErrors(this.ccardDetailErrors);
		}
		protected function onPaymentAdd_Fault(event:FaultEvent):void
		{
			Alert.show('Adding Payment Info Failed','Please try again later');
			
		}
		


		protected function onPurchaseComplete(event:ResultEvent):void
		{
			try{
				var obj:Object = JSON.decode(String(event.result));
			}
			catch(e:Error){
				Alert.show('Error Parsing JSON');
			}
			
			if( obj != null && obj.hasOwnProperty('errors') && obj.errors.length > 0 )
				this.model.handleCheckoutPurchaseErrors(obj.errors);
		}
		
		protected function onPurchase_Fault(event:FaultEvent):void
		{
			Alert.show('Purchasing Failed','Please try again later');
			
		}
		

		
		public function continueToNextStep(LastStepSuccesful:Boolean,fxok:Function):void
		{
			//this function is used a way of controling the flow of the checkoutprocess
			/*
			this.fxCallback = fxok;
			Alert.show(msg,title,Alert.OK,null,alertListner,null,Alert.OK );
			*/
			if(LastStepSuccesful)
				fxok();
		}
		
		private function alertListner(eventObj:CloseEvent):void {
			// Check to see if the OK button was pressed.
			if (eventObj.detail==Alert.OK) {
				this.fxCallback();
			}
		}
	}
}