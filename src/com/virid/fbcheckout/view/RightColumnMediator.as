package com.virid.fbcheckout.view
{
	import com.virid.fbcheckout.model.Model;
	
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import mx.effects.Sequence;
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
			var urlR:URLRequest = new URLRequest(this.model.urlRoot + '/product.aspx?id=' + this.model.productID);
			navigateToURL(urlR, '_self');
			
			
		}
		
		protected function ui_OnSeeMoreClicked(event:Event):void
		{
			var urlR:URLRequest = new URLRequest(this.model.urlRoot + '/product.aspx?id=' + this.model.productID);
			navigateToURL(urlR, '_self');
			
		}		

		
		protected function ui_OnProdDetail(event:Event):void
		{
			var obj:Object = new Object();
			obj.start = "NOW";
			this.model.initiateProdDetail = obj;
		}
		
		protected function ui_OnBuyItNowClicked(event:Event):void
		{
			var cartAddService:HTTPService = new HTTPService();
			//add current sku to cart
			//add current sku to cart
			cartAddService.resultFormat="text";
			//this.cartAddService.addEventListener("fault", onAddedToCart_Fault);
			cartAddService.url = model.urlRoot + "api/cart.aspx";//?action=update&id="+sku+"&qty=1";
			var paramsCart:Object = {};
			paramsCart['action'] = "update";
			paramsCart['qty'] = 1;
			paramsCart['id'] = this.model.SelectedProduct.colorObj.currentSize.OID;
			//this.cartAddService.addEventListener("result", onAddedToCart); 
			cartAddService.send(paramsCart);
			
			var obj:Object = new Object();
			obj.start = "NOW";
			this.model.initiateCheckoutPanel = obj;
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