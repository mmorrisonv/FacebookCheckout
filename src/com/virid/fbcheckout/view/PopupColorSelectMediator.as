package com.virid.fbcheckout.view
{
	import com.virid.fbcheckout.model.Model;

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
			this.ui.colorSelect.dataProvider = this.model.MainProduct.Colors;
			
		}
	}
}