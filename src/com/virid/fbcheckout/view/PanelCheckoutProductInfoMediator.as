package com.virid.fbcheckout.view
{
	import com.virid.fbcheckout.model.Model;
	import com.virid.fbcheckout.model.vo.ColorVO;
	import controller.events.CustomEvent;
	import flash.events.Event;

	public class PanelCheckoutProductInfoMediator
	{
		private var model:Model = Model.getInstance();
		private var ui:PanelCheckoutProductInfo;
		
		public function register(_ui:PanelCheckoutProductInfo):void
		{
			this.ui = _ui;
			
			this.model.addEventListener(Model.StartProdDetail,ui_ShowProDetail);
			this.model.addEventListener(Model.DisplayCheckout,ui_ShowCheckout);
			
			ui.addEventListener(PanelCheckoutProductInfo.SHOWPRODDETAIL,initateProDetail );
			this.model.addEventListener(Model.MainProductChanged,onProductChange);
			onProductChange(null);
		}
		
		protected function onProductChange(event:Event):void
		{
			this.ui.productImage.source = this.model.MainProduct.colorObj.imageFS;	
			this.ui.productName.text = model.MainProduct.name;
			this.ui.productDetail.text = "Size: " + model.MainProduct.colorObj.currentSKU.name;
			this.ui.productColor.text = "Color: " + model.MainProduct.colorObj.name;
			this.ui.productPriceDisplay.text = "$" + String(this.model.MainProduct.colorObj.currentSKU.price) + " USD";
		}
		
		protected function initateProDetail(event:Event):void
		{
			var obj:Object = new Object();
			obj.start = "NOW";
			this.model.initiateProdDetail = obj;
			
		}
		
		protected function ui_ShowCheckout(event:Event):void
		{
			this.ui.visible = true;
			
		}
		
		protected function ui_ShowProDetail(event:Event):void
		{
			this.ui.visible = false;
		}
		
		protected function colorChanged(event:CustomEvent):void
		{
			if(event.data != null )
			{
				var newColor:ColorVO = event.data as ColorVO;
				this.model.MainProductColor = newColor;
			}
			
			this.ui.visible = false;
			
		}		

		
	}
}