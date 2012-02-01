package com.virid.fbcheckout.view
{
	import com.adobe.serialization.json.JSON;
	import com.virid.fbcheckout.model.Model;
	import com.virid.fbcheckout.model.vo.ShippingOptionVO;
	
	import controller.commands.checkoutArbiter;
	
	import flash.events.Event;
	
	import mx.controls.Alert;
	import mx.controls.CheckBox;
	import mx.core.UIComponent;
	import mx.effects.Sequence;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	import spark.components.TextInput;
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
			this.ui.addEventListener(Checkout.BILLING_SAME_AS,onBillingSameAsShippingClicked);
			this.ui.addEventListener(Checkout.CHECKOUT_PURCHASE,onPurchase);
			this.ui.addEventListener(Checkout.SHIPPING_OPTION_CHANGED,onCurrentShippingOptionsChanged);
			this.ui.addEventListener(Checkout.SHIPPING_ADDRESS_CHANGED,trySendingShippingAddress);
			
			this.model.addEventListener(Model.MainProductSKUChanged,onProdColorSKUChanged);
			this.model.addEventListener(Model.CheckoutComplete,onCheckoutComplete);
			this.model.addEventListener(Model.CheckoutFailed,onCheckoutFailed);
			this.model.addEventListener(Model.ShippingOptionsLoaded,onNewShippingOptions);
			this.model.addEventListener(Model.ChargeTotalsChanged,onCartTotalsChanged);
			//checkouterrors
			this.model.addEventListener(Model.CheckoutErrorsInAddCart,onErrorsCheckoutAddingToCart);
			this.model.addEventListener(Model.CheckoutErrorsInShipping,onErrorsCheckoutShippingAddress);
			this.model.addEventListener(Model.CheckoutErrorsInBilling,onErrorsCheckoutBilling);
			this.model.addEventListener(Model.CheckoutErrorsInCCard,onErrorsCheckoutCCard);
			this.model.addEventListener(Model.CheckoutErrorsInPurchase,onErrorsCheckoutPurchasing);
			
			onNewShippingOptions(null);
			onProdColorSKUChanged(null);//just in case event has already been thrown
			
			//model listeners:ui
			this.model.addEventListener(Model.DisplayCheckoutPanel,ui_gotoCheckoutMode);
			this.model.addEventListener(Model.StartProdDetail,ui_gotoProdDetail);
			mapUIFieldsToModel();
	
		}
		
		protected function trySendingShippingAddress(event:Event):void
		{
			this.sendShippingAddress();
			
		}		
	
	
		
		protected function onNewShippingOptions(event:Event):void
		{
			this.ui.soptions.dataProvider = this.model.AllShippingOptions;
			this.ui.soptions.selectedItem = this.model.AllShippingOptions[0];
			onCurrentShippingOptionsChanged(null);
		}
		
		protected function onCurrentShippingOptionsChanged(event:Event):void
		{
			var shpOptPrice:Number = new Number();
			var selectedShippingOption:ShippingOptionVO = this.ui.soptions.selectedItem;
			this.model.chargeShipping = selectedShippingOption.price;
		}
		
		protected function onCartTotalsChanged(event:Event):void
		{
			updateCartDisplays();
		}
		
		protected function onCheckoutComplete(event:Event):void
		{
			// Checkout process is complete, show confirmation panel
			this.ui.showConfirmationPanel();
			
		}
		protected function onCheckoutFailed(event:Event):void
		{
			this.ui.enableCheckoutBtn();
			this.ui.hideConfirmationStatusPanel();
			
		}	
		protected function onPurchase(event:Event):void
		{
			//updateCartTotals();
			
			this.ui.disableCheckoutBtn('purchasing',true);
			this.ui.showConfirmationStatusPanel();
			clearAllFormErrors();

			setCheckoutFieldsOnModel();
			
			//send addresses and card info to class that will handle checkout
			var checkoutProcess:checkoutArbiter = new checkoutArbiter();
			
			//call up the notice modal
			/*var obj:Object = new Object();
			obj.start = "NOW";
			this.model.showStatus = obj;*/
		}
		
		private function setCheckoutFieldsOnModel():void
		{
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
			
			//onCurrentShippingOptionsChanged(null);
			
			//record ccard info
			this.model._ccard.number = this.ui.bcardnum.text;
			this.model._ccard.ccv = this.ui.bcardcvv.text;
			this.model._ccard.month = this.ui.bcardmonth.text;
			this.model._ccard.year = this.ui.bcardyear.text;
			this.model._ccard.exp = this.model._ccard.month + "/" + this.model._ccard.year;
		}
		
		protected function onBillingSameAsShippingClicked(event:Event):void
		{
			removeFieldError(this.ui.bfname);
			removeFieldError(this.ui.blname);
			removeFieldError(this.ui.baddress1);
			removeFieldError(this.ui.bcity);
			removeFieldError(this.ui.bstate);
			removeFieldError(this.ui.bzip);
			removeFieldError(this.ui.phonenum);
			removeFieldError(this.ui.email);
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
			
			
		}
		
		protected function onCartJSONResult(event:ResultEvent):void
		{
			try{
				var jsonDecodedCartTotals:Object = JSON.decode(String(event.result),false);
			}
			catch(e:Error){
				trace('Error Parsing JSON');
			}
			this.model.updateCartTotalsInOneFunction(jsonDecodedCartTotals);
			
			updateCartDisplays();
		}
		
		private function updateCartDisplays():void
		{
			this.ui.cartPrice.text = "$" + this.model.chargeTotal.toFixed(2) + " USD";
		}
		
		
		protected function ui_gotoCheckoutMode(event:Event):void
		{
			this.ui.enableCheckoutBtn();
			updateCartTotals();
			this.ui.visible = true;
			this.ui.includeInLayout = true;
			a1 = new Animate();
			a1.target = this.ui; a1.duration = 600; a1.easer = bigease;
			m = new SimpleMotionPath();
			m.property = 'y'; m.valueTo = 0;
			v = new Vector.<MotionPath>();v.push(m);
			a1.motionPaths = v;
			var p:Sequence = new Sequence();
			p.addChild(a1);
			p.play( );
		}
		
		
		public function sendShippingAddress():void
		{
			setCheckoutFieldsOnModel();
			
			//set shipping address
			var shipAddressService:HTTPService = new HTTPService();
			shipAddressService.resultFormat="text";
			shipAddressService.url = model.urlRootSecure + "api/setshipping.aspx";
			
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
			
			shipAddressService.addEventListener("result", onAddressShippingAdd); 
			shipAddressService.send(paramsShip);
		}
		
		protected function onAddressShippingAdd(event:ResultEvent):void
		{
			try{
				var obj:Object = JSON.decode(String(event.result));
			}
			catch(e:Error){
				trace('Error Parsing JSON');
			}
			
			if(obj.errors.length == 0)
			{
				trace('shipping address sent to server and response received without errror - checkoutMediator');
				var cartInterspectionService:HTTPService = new HTTPService();
				cartInterspectionService.resultFormat="text";
				cartInterspectionService.url = model.urlRoot + "api/cart.aspx";
				cartInterspectionService.addEventListener("result", onCartJSONResult); 
				cartInterspectionService.send();
			}
		}
		
		
		
		
		
		
		
		
		
		
		protected function ui_gotoProdDetail(event:Event):void
		{
			this.ui.animateToProdDetail.play();
			this.ui.confirmationPanel.hidePanel();
			this.ui.itemizedView.hide.play();
			
		}
		
		
		
		
		//checkoutError Handelers
		protected function onErrorsCheckoutAddingToCart(event:Event):void
		{
			
			for each( var err:Object in this.model.lastCheckoutErrors )
			{
				switch(err.field)
				{
					case "":
					{
						break;
					}
					case "":
					{
						break;
					}
					default:
						trace('nothing');
							
				}
					
			}
		}
		
		protected function onErrorsCheckoutPurchasing(event:Event):void
		{
			var errorStr:String = "";
			for each( var err:Object in this.model.lastCheckoutErrors )
			{
				switch(err.field)
				{
					case "general":
						Alert.show( sanitzeErrorsBeforeAlert( err.message ) );
						break;
					case "":
					{
						break;
					}
					default:
						trace('nothing');
						
				}
			}
		}
		
		protected function onErrorsCheckoutCCard(event:Event):void
		{
			var errorStr:String = "";
			for each( var err:Object in this.model.lastCheckoutErrors )
			{
				switch(err.field)
				{
					case "general":
						Alert.show( sanitzeErrorsBeforeAlert( err.message ) );
						break;
					case "cardnum":
						convertFieldToError(this.ui.bcardnum,err.message);
					case "cardcvv":
						convertFieldToError(this.ui.bcardcvv,err.message);
						break;
					case "cardexp":
						convertFieldToError(this.ui.bcardmonth,err.message);
						convertFieldToError(this.ui.bcardyear,err.message);
						break;

					default:
						trace('nothing');
						
				}
			}
		}
		
		protected function onErrorsCheckoutBilling(event:Event):void
		{
			if(this.ui.sameAsShipping.selected)//we never want to show errors if billing is just duplicates of shipping
				return
			for each( var err:Object in this.model.lastCheckoutErrors )
			{
				switch(err.field)
				{
					case "general":
						Alert.show( sanitzeErrorsBeforeAlert( err.message ) );
						break;
					
					case "firstname":
						convertFieldToError(this.ui.bfname,err.message);
						break;
					
					case "lastname":
						convertFieldToError(this.ui.blname,err.message);
						break;
					
					case "address1":
						convertFieldToError(this.ui.baddress1,err.message);
						break;
					
					case "city":
						convertFieldToError(this.ui.bcity,err.message);
						break;
					
					case "state":
						convertFieldToError(this.ui.bstate,err.message);
						break;
					
					case "zip":
						convertFieldToError(this.ui.bzip,err.message);
						break;
					
					case "phone":
						convertFieldToError(this.ui.phonenum,err.message);
						break;
					
					case "email":
						convertFieldToError(this.ui.email,err.message);
						break;
					default:
						;
						break;
					
				}
			}
		}
		
		protected function onErrorsCheckoutShippingAddress(event:Event):void
		{
			var errorStr:String = "";
			for each( var err:Object in this.model.lastCheckoutErrors )
			{
				switch(err.field)
				{
					case "":
						break;
					
					case "general":
						Alert.show( sanitzeErrorsBeforeAlert( err.message ) );
						break;
					
					case "firstname":
						convertFieldToError(this.ui.sfname,err.message);
						break;
					
					case "lastname":
						convertFieldToError(this.ui.slname,err.message);
						break;
					
					case "address1":
						convertFieldToError(this.ui.saddress1,err.message);
						break;
					
					case "city":
						convertFieldToError(this.ui.scity,err.message);
						break;
					
					case "state":
						convertFieldToError(this.ui.sstate,err.message);
						break;
					
					case "zip":
						convertFieldToError(this.ui.szip,err.message);
						break;
					
					case "phone":
						convertFieldToError(this.ui.phonenum,err.message);
						break;
					
					case "phone":
						convertFieldToError(this.ui.email,err.message);
						break;
					
					default:
						;
						break;
						
				}
			}
		}	
		
		private function sanitzeErrorsBeforeAlert(text:String):String
		{
			var s:String;
			var pat:RegExp = /<br>/g
			s = text.replace(pat,'\n');
			return s;
		}
		
		private function convertFieldToError(uiElement:UIComponent,toolTipError:String = ""):void
		{
			uiElement.toolTip = toolTipError;
			uiElement.styleName = "errorField";
		}
		
		private function removeFieldError(uiElement:UIComponent):void
		{
			uiElement.toolTip = '';
			uiElement.styleName = "";
		}
		
		private function clearAllFormErrors():void
		{
			removeFieldError(this.ui.bfname);
			removeFieldError(this.ui.sfname);
			removeFieldError(this.ui.blname);
			removeFieldError(this.ui.slname);
			removeFieldError(this.ui.baddress1);
			removeFieldError(this.ui.saddress1);
			removeFieldError(this.ui.baddress2);
			removeFieldError(this.ui.saddress2);
			removeFieldError(this.ui.sstate);
			removeFieldError(this.ui.bstate);
			removeFieldError(this.ui.bzip);
			removeFieldError(this.ui.szip);
			removeFieldError(this.ui.bcity);
			removeFieldError(this.ui.scity);
			removeFieldError(this.ui.email);
			removeFieldError(this.ui.phonenum);
			
			removeFieldError(this.ui.bcardnum);
			removeFieldError(this.ui.bcardcvv);
			removeFieldError(this.ui.bcardmonth);
			removeFieldError(this.ui.bcardyear);

		}
		

	}
}