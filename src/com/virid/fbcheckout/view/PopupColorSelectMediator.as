package com.virid.fbcheckout.view
{
	import com.virid.fbcheckout.model.Model;
	import com.virid.fbcheckout.model.vo.ColorVO;
	
	import controller.events.CustomEvent;
	
	import flash.events.Event;
	import com.virid.fbcheckout.model.vo.ProductVO;

	public class PopupColorSelectMediator
	{
		private var model:Model = Model.getInstance();
		private var ui:PopupColorSelect;
		public function PopupColorSelectMediator()
		{
			
		}
		
		public function register(_ui:PopupColorSelect):void
		{
			this.ui = _ui;
			this.ui.colorSelect.dataProvider = this.model.Colors;
			
			ui.addEventListener(PopupColorSelect.COLOR_CHANGED,colorChanged);
			
		}
		
		protected function colorChanged(event:CustomEvent):void
		{
			if(event.data != null )
			{
				var newColor:ColorVO = event.data as ColorVO;
				var newMP:ProductVO = this.model.MainProduct;
				newMP.colorObj = newColor;
			
				this.model.MainProduct = newMP;
			}
			
			this.ui.visible = false;
			
		}		

		
	}
}