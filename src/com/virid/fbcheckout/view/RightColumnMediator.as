package com.virid.fbcheckout.view
{
	import com.virid.fbcheckout.model.Model;
	
	import flash.events.Event;

	public class RightColumnMediator
	{
		private var model:Model = Model.getInstance();
		private var ui:rightColumn;
		public function AltViewsMediator()
		{
			
		}
		
		public function register(_ui:rightColumn):void
		{
			this.ui = _ui;
			this.model.addEventListener(Model.MainProductChanged,onProductChange);
			onProductChange(null);
		}
		
		protected function onProductChange(event:Event):void
		{
			ui.prodName.text = model.MainProduct.name;
			ui.selectedColor.text = model.MainProduct.colorObj.name;
		}
	}
}