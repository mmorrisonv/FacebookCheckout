package com.virid.fbcheckout.view
{
	import com.virid.fbcheckout.model.Model;
	
	import flash.events.Event;

	public class RightColumnMediator
	{
		private var model:Model = Model.getInstance();
		private var ui:rightColumn;
		public function AltViewsMediator():void
		{
			
		}
		
		public function register(_ui:rightColumn):void
		{
			this.ui = _ui;
			this.ui.addEventListener(rightColumn.CHECKOUT,ui_OnCheckout);
			this.ui.addEventListener(rightColumn.PRODDETAIL,ui_OnProdDetail);
			
			this.model.addEventListener(Model.MainProductChanged,onProductChange);
			this.model.addEventListener(Model.MainProductColorSKUChanged,onProdColorSKUChanged);
			onProductChange(null);
		}
		
		protected function ui_OnProdDetail(event:Event):void
		{
			var obj:Object = new Object();
			obj.start = "NOW";
			this.model.initiateProdDetail = obj;
		}
		
		protected function ui_OnCheckout(event:Event):void
		{
			var obj:Object = new Object();
			obj.start = "NOW";
			this.model.initiateCheckout = obj;
		}
		
		protected function onProductChange(event:Event):void
		{
			ui.prodName.text = model.MainProduct.name;
			ui.selectedColor.text = model.MainProduct.colorObj.name;
			ui.selectedSize.text = model.MainProduct.colorObj.currentSKU.name;
		}
		protected function onProdColorSKUChanged(event:Event):void
		{
			ui.selectedColor.text = model.MainProduct.colorObj.name;
			ui.selectedSize.text = model.MainProduct.colorObj.currentSKU.name;
		}
	}
}