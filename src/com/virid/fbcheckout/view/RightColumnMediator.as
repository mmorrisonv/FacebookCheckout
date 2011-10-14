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
			model.addEventListener("MainProductChanged",onProductChange);
			onProductChange(null);
		}
		
		protected function onProductChange(event:Event):void
		{
			ui.prodName.text = model.MainProduct.name;
		}
	}
}