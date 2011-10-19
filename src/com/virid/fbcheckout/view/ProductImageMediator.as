package com.virid.fbcheckout.view
{
	import com.virid.fbcheckout.model.Model;
	
	import flash.events.Event;

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
			this.model.addEventListener(Model.MainProductColorChanged,changeProductImage);
			this.model.addEventListener(Model.MainProductImageChanged,changeAltView);
		}
		
		protected function changeAltView(event:Event):void
		{
			this.ui.productImage.source = this.model.MainProductImage.source;
		}
		
		protected function changeProductImage(event:Event):void
		{
			this.ui.productImage.source = this.model.MainProduct.colorObj.imageFS;
		}
	}
}