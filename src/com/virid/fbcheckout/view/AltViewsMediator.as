package com.virid.fbcheckout.view
{
	import com.virid.fbcheckout.model.Model;
	import com.virid.fbcheckout.model.vo.AltViewVO;
	
	import controller.events.CustomEvent;
	
	import flash.events.Event;

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
			this.ui.altViewList.dataProvider = this.model.MainProduct.altViews;
			this.ui.addEventListener(AltViews.UI_ALTVIEW_SELECTION_CHANGED,changeProductImage);
			this.model.addEventListener(Model.MainProductColorSKUChanged,changeAltViewList);
			changeAltViewList(null);
		}
		

		/*
		 * UI Listeners*/
		protected function changeProductImage(event:CustomEvent):void
		{
			this.model.MainProductImage = event.data as AltViewVO; 
		}		
		
		/*
		 * Model Listeners*/
		protected function changeAltViewList(event:Event):void
		{
			if( this.model.MainProduct.colorObj.AltViews != null && this.model.MainProduct.colorObj.AltViews.length > 0 )
				this.ui.altViewList.dataProvider = this.model.MainProduct.colorObj.AltViews;
			else
				this.ui.altViewList.dataProvider = this.model.MainProduct.altViews;
			
		}
	}
}