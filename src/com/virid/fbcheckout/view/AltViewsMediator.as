package com.virid.fbcheckout.view
{
	import com.virid.fbcheckout.model.Model;

	public class AltViewsMediator
	{
		private var model:Model = Model.getInstance();
		private var ui:AltViews;
		public function AltViewsMediator()
		{
			
		}
		
		public function register(_ui:AltViews):void
		{
			this.ui = _ui;
			this.ui.altViewList.dataProvider = this.model.AltViews;
			
		}
	}
}