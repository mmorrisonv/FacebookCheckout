package com.virid.fbcheckout.view
{
	import com.virid.fbcheckout.model.Model;
	
	import flash.events.Event;
	
	import mx.effects.Move;
	
	import spark.effects.easing.EaseInOutBase;
	import spark.effects.easing.EasingFraction;
	import spark.effects.easing.Elastic;

	public class ProductImageMediator
	{
		private var model:Model = Model.getInstance();
		private var ui:ProductImage;
		public function ProductImageMediator()
		{
			
		}
		
		public function register(_ui:ProductImage):void
		{
			this.ui = _ui;
			this.model.addEventListener(Model.StartProdDetail,ui_gotoProductDetailMode);
			this.model.addEventListener(Model.StartCheckout,ui_gotoCheckoutMode);
			
			this.model.addEventListener(Model.MainProductColorSKUChanged,changeProductImage);
			this.model.addEventListener(Model.MainProductImageChanged,changeAltView);
			changeProductImage(null);
		}		
		protected function ui_gotoCheckoutMode(event:Event):void
		{

			//move main prouduct image over to the left
			var m:Move = new Move();
			m.target = this.ui.productImage;
			m.xTo = -500;
			m.duration = 800;
			m.play();
			
			
		}
		
		protected function ui_gotoProductDetailMode(event:Event):void
		{
			//var ease:Elastic = new Elastic();
			
			var m:Move = new Move();
			m.target = this.ui.productImage;
			m.xTo = 0;
			m.duration = 800;
			//m.easer = ease;
			m.play();
			
			
		}
		
		protected function changeAltView(event:Event):void
		{
			this.ui.productImage.source = this.model.MainProductImage.source;
		}
		
		protected function changeProductImage(event:Event):void
		{
			this.ui.productImage.source = this.model.MainProduct.colorObj.imageFS;
			this.ui.productPriceDisplay.text = '$' + String(this.model.MainProduct.colorObj.currentSKU.price);
		}
	}
}