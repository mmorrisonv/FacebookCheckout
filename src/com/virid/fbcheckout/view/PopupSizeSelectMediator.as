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
			this.ui.sizeSelect.dataProvider = this.model.MainProduct.colorObj.SKUs;
			
			ui.addEventListener(PopupSizeSelect.UI_SIZE_CHANGED,ui_sizeChanged);
			
		}
		
		protected function ui_sizeChanged(event:CustomEvent):void
		{
			if(event.data != null )
			{
				this.model.MainProductSKU = event.data as SizeVO;
				//this.model.MainProductColor.currentSKU = event.data as SizeVO;
			}
			
			this.ui.visible = false;
			
		}		

		
	}
}