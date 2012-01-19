package com.virid.fbcheckout.view
{
	import com.virid.fbcheckout.model.Model;
	import com.virid.fbcheckout.model.vo.ColorVO;
	import com.virid.fbcheckout.model.vo.ProductVO;
	import com.virid.fbcheckout.model.vo.SizeVO;
	
	import controller.events.CustomEvent;
	
	import flash.events.Event;

	public class PopupSizeSelectMediator
	{
		private var model:Model = Model.getInstance();
		private var ui:PopupSizeSelect;
		public function PopupSizeSelectMediator()
		{
			
		}
		
		public function register(_ui:PopupSizeSelect):void
		{
			this.ui = _ui;
			if(this.model.SelectedProduct != null && this.model.SelectedProduct.colorObj != null)
			{
				this.ui.sizeSelect.dataProvider = this.model.SelectedProduct.colorObj.Sizes;
				//this.ui.sizeSelect.selectedIndex = 0;
				//this.model.MainProductSKU = this.model.SelectedProduct.colorObj.Sizes[0];
			}
			
			ui.addEventListener(PopupSizeSelect.UI_SIZE_CHANGED,ui_sizeChanged);
			this.model.addEventListener(Model.MainProductColorChanged,onProductColorChanged);

			
		}
		
		protected function ui_sizeChanged(event:CustomEvent):void
		{
			if(event.data != null )
			{
				this.model.MainProductSKU = event.data as SizeVO;
				//this.model.MainProductColor.currentSize = event.data as SizeVO;
			}
			
			this.ui.visible = false;
			
		}		
		
		
		protected function onProductColorChanged(event:Event):void
		{
			
			if(this.model.SelectedProduct.colorObj != null){
				this.ui.sizeSelect.dataProvider = this.model.SelectedProduct.colorObj.Sizes;
				//this.ui.sizeSelect.selectedIndex = 0;//this.model.SelectedProduct.colorObj.currentSKU.name;
			}
		}

		
	}
}