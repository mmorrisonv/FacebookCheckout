package com.virid.fbcheckout.view
{
	import com.virid.fbcheckout.model.Model;
	import com.virid.fbcheckout.model.vo.SKUVO;
	
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
			this.ui.colorSelect.dataProvider = this.model.AllSKUs;
			
			ui.addEventListener(PopupColorSelect.COLOR_CHANGED,colorChanged);
			
		}
		
		protected function colorChanged(event:CustomEvent):void
		{
			if(event.data != null )
			{
				var newColor:SKUVO = event.data as SKUVO;
				this.model.MainProductColor = newColor;
			}
			
			this.ui.visible = false;
			
		}		

		
	}
}