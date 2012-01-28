package com.virid.fbcheckout.view
{
	import com.adobe.serialization.json.JSON;
	import com.virid.fbcheckout.model.Model;
	
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import mx.controls.Alert;
	import mx.effects.Sequence;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	import spark.effects.Animate;
	import spark.effects.animation.MotionPath;
	import spark.effects.animation.SimpleMotionPath;
	import spark.effects.easing.Power;

	public class RightColumnMediator
	{
		private var model:Model = Model.getInstance();
		private var ui:rightColumn;
		
		//tranition variables
		private var bigease:Power = new Power();
		private var v:Vector.<MotionPath> = new Vector.<MotionPath>();
		private var a1:Animate = new Animate();
		private var m:SimpleMotionPath = new SimpleMotionPath();
		
		public function AltViewsMediator():void
		{
			
		}
		
		public function register(_ui:rightColumn):void
		{
			this.ui = _ui;
			this.ui.addEventListener(rightColumn.BUYITNOWCLICKED,ui_OnBuyItNowClicked);
			this.ui.addEventListener(rightColumn.PRODDETAIL,ui_OnProdDetail);
			this.ui.addEventListener(rightColumn.AVAILCHECKCLICKED,ui_OnCheckAVailClicked);
			this.ui.addEventListener(rightColumn.SEEMORECLICKED,ui_OnSeeMoreClicked);
			
			this.model.addEventListener(Model.MainProductChanged,onProductChange);
			this.model.addEventListener(Model.MainProductSKUChanged,onProdSKUChanged);
			this.model.addEventListener(Model.MainProductColorChanged,onProdColorChanged);
			//model listeners:ui
			this.model.addEventListener(Model.DisplayCheckoutPanel,ui_gotoCheckoutMode);
			this.model.addEventListener(Model.StartProdDetail,ui_gotoProdDetail);
			
			onProductChange(null);
		}
		
	
		
		protected function ui_OnCheckAVailClicked(event:Event):void
		{
			var urlR:URLRequest = new URLRequest(this.model.urlRootTracking + '/product.aspx?id=' + this.model.productID);
			navigateToURL(urlR, '_blank');
			
			
		}
		
		protected function ui_OnSeeMoreClicked(event:Event):void
		{
			var urlR:URLRequest = new URLRequest(this.model.urlRootTracking + '/product.aspx?id=' + this.model.productID);
			navigateToURL(urlR, '_blank');
			
		}		

		
		protected function ui_OnProdDetail(event:Event):void
		{
			var obj:Object = new Object();
			obj.start = "NOW";
			this.model.initiateProdDetail = obj;
		}
		
		protected function ui_OnBuyItNowClicked(event:Event):void
		{
			clearCartThenAddCurrentItem();
			
			
			var obj:Object = new Object();
			obj.start = "NOW";
			this.model.initiateCheckoutPanel = obj;
		}
		
		private function getCartTotals():void
		{
			var cartTotalService:HTTPService = new HTTPService();
			//add current sku to cart
			cartTotalService.resultFormat="text";
			cartTotalService.url = model.urlRoot + "api/gettotals.aspx";
			cartTotalService.addEventListener(ResultEvent.RESULT,onCartTotalsReturned);
			cartTotalService..addEventListener(FaultEvent.FAULT,onHTTPFault);
			cartTotalService.send();
		}
		
		protected function onCartTotalsReturned(event:ResultEvent):void
		{
			try{
				var obj:Object = JSON.decode(String(event.result),false);
			}
			catch(e:Error){
				trace('Error Parsing JSON');
			}
			this.model.chargeProduct = Number(obj.subtotal);
			this.model.chargeShipping = Number(obj.shipping);
			this.model.chargeTax = Number(obj.taxes);
			this.model.chargeService = Number(obj.services);
			//make sure the total we are calculating equals the total the server has
			/*if(this.model.chargeTotal != Number(obj.total))
			{
				trace('totals for cart not equal in rightcoloumnmediator');
			}*/
		}
		
		private function addCurrentSkuToCart():void
		{
			var cartAddService:HTTPService = new HTTPService();
			//add current sku to cart
			cartAddService.resultFormat="text";
			//this.cartAddService.addEventListener("fault", onAddedToCart_Fault);
			cartAddService.url = model.urlRoot + "api/cart.aspx";
			var paramsCart:Object = {};
			paramsCart['action'] = "update";
			paramsCart['qty'] = 1;
			paramsCart['id'] = this.model.SelectedProduct.colorObj.currentSize.OID;
			cartAddService.addEventListener("result", onAddedToCart);
			cartAddService.addEventListener(FaultEvent.FAULT,onHTTPFault);
			cartAddService.send(paramsCart);
		}		
		
		protected function onHTTPFault(event:FaultEvent):void
		{
			Alert.show('HTTP Response Failed' + event.message,'Please try again later');	
		}
		
		protected function onAddedToCart(event:ResultEvent):void
		{
			getCartTotals();
		}
		
		private function clearCartThenAddCurrentItem():void
		{
			var clearService:HTTPService = new HTTPService();
			//add current sku to cart
			clearService.resultFormat="text";
			//this.cartAddService.addEventListener("fault", onAddedToCart_Fault);
			clearService.url = model.urlRoot + "api/cart.aspx";//?action=update&id="+sku+"&qty=1";
			var paramsCart:Object = {};
			paramsCart['action'] = "clear";
			paramsCart['qty'] = 1;
			paramsCart['id'] = this.model.SelectedProduct.colorObj.currentSize.OID;
			clearService.addEventListener("result", onCartClearedAddCurrentProduct);
			clearService..addEventListener(FaultEvent.FAULT,onHTTPFault);
			clearService.send(paramsCart);
		}
		
		protected function onCartClearedAddCurrentProduct(event:ResultEvent):void
		{
			addCurrentSkuToCart();
		}
		
		protected function onProductChange(event:Event):void
		{
			if(this.model.SelectedProduct.colorObj != null){
				
				ui.prodName.text = model.SelectedProduct.name;
				ui.selectedColor.text = model.SelectedProduct.colorObj.name;
				if(model.SelectedProduct.colorObj.currentSize != null)
				{
			
					ui.selectedSize.text = model.SelectedProduct.colorObj.currentSize.name;
					ui.buyItNowBtnBackground.color = 0xe07400;
					ui.buyItNowBtn.enabled = true;
				}
				else
				{
				
					ui.selectedSize.text = "Select a Size";
					ui.buyItNowBtnBackground.color = 0xeeeeee;
					ui.buyItNowBtn.enabled = false;
				}
			}
			else
			{
	
				ui.selectedSize.text = "Select a Size";
				ui.buyItNowBtnBackground.color = 0xeeeeee;
				ui.buyItNowBtn.enabled = false;
			}
		}
		protected function onProdColorChanged(event:Event):void
		{
			ui.selectedColor.text = model.SelectedProduct.colorObj.name;
			ui.buyItNowBtnBackground.color = 0xeeeeee;
			ui.buyItNowBtn.enabled = false;
		}
		protected function onProdSKUChanged(event:Event):void
		{
			ui.selectedSize.text = model.SelectedProduct.colorObj.currentSize.name;
			ui.buyItNowBtnBackground.color = 0xe07400;
			ui.buyItNowBtn.enabled = true;
		}
		protected function ui_gotoCheckoutMode(event:Event):void
		{
			a1 = new Animate();
			a1.target = this.ui; a1.duration = 600; a1.easer = bigease;
			m = new SimpleMotionPath();
			m.property = 'y'; m.valueTo = 1000;
			v = new Vector.<MotionPath>();v.push(m);
			a1.motionPaths = v;
			var p:Sequence = new Sequence();
			p.addChild(a1);
			p.play( );
		}
		
		protected function ui_gotoProdDetail(event:Event):void
		{
			a1 = new Animate();
			a1.target = this.ui; a1.duration = 500; a1.easer = bigease;
			m = new SimpleMotionPath();
			m.property = 'y'; m.valueTo = 0;
			v = new Vector.<MotionPath>();v.push(m);
			a1.motionPaths = v;
			var p:Sequence = new Sequence();
			p.addChild(a1);
			p.play( );
			
		}
		

	}
}