package com.virid.fbcheckout.view
{
	import com.virid.fbcheckout.model.Model;
	import com.virid.fbcheckout.model.vo.ColorVO;
	import com.virid.fbcheckout.model.vo.ProductVO;
	import com.virid.fbcheckout.model.vo.SizeVO;
	
	import controller.events.CustomEvent;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.osmf.events.TimeEvent;

	public class PopupSizeSelectMediator
	{
		private var model:Model = Model.getInstance();
		private var ui:PopupSizeSelect;
		
		public function register(_ui:PopupSizeSelect):void
		{
			this.ui = _ui;

			ui.addEventListener(PopupSizeSelect.UI_SIZE_CHANGED,ui_sizeChanged);
			ui.addEventListener(PopupSizeSelect.UI_SHOWN,ui_shownOnScreen);
			
			this.model.addEventListener(Model.MainProductColorChanged,onProductColorChanged);
			this.model.addEventListener(Model.MainProductSetup,onProductInit);

			if(this.model.productSetup){
				setupSizeList();
			}
			else{
				
				var reloadTimer:Timer = new Timer(700,1);
				reloadTimer.addEventListener(TimerEvent.TIMER_COMPLETE,function (evt:TimerEvent):void{
					register(_ui);
				});
				reloadTimer.start();
				
			}

		}
		
		protected function ui_shownOnScreen(event:Event):void
		{
			setupSizeList();
		}
		
		protected function onProductInit(event:Event):void
		{
			//setupSizeList();
			//make sure the model reflects the correct size etc
			if( this.model.SelectedProduct.colorObj != null && this.model.SelectedProduct.colorObj.currentSize != null )
			{
				this.model.requestedSize =  this.model.SelectedProduct.colorObj.currentSize;
				this.model.MainProductSKU =  this.model.SelectedProduct.colorObj.currentSize;
			}
		}
		
		protected function onProductColorChanged(event:Event):void
		{
			setupSizeList();
			/*
			if(this.model.SelectedProduct.colorObj != null){
			this.ui.sizeSelect.dataProvider = this.model.SelectedProduct.colorObj.Sizes;
			if( this.model.SelectedProduct.colorObj != null && this.model.SelectedProduct.colorObj.currentSize != null )
			this.ui.sizeSelect.selectedItem = this.model.SelectedProduct.colorObj.currentSize;
			}*/
		}
		
		private function setupSizeList():void
		{
			if(this.model.SelectedProduct != null && this.model.SelectedProduct.colorObj != null)
			{
				this.ui.sizeSelect.dataProvider = this.model.SelectedProduct.colorObj.Sizes;
				if( this.model.SelectedProduct.colorObj != null && this.model.SelectedProduct.colorObj.currentSize != null )
				{
					this.ui.sizeSelect.selectedItem = this.model.SelectedProduct.colorObj.currentSize;
				}
			}
			
			//check height of the list - if its beyond a certain size, increase the height of the ui
			if( this.ui.sizeSelect.dataProvider.length > 4 && this.ui.sizeSelect.dataProvider[0].name.length > 5)
			{
				this.ui.setupTallView();	
			}
			else
			{
				this.ui.setupTallView(false);
			}
		}
		
		protected function ui_sizeChanged(event:CustomEvent):void
		{
			if(event.data != null )
			{
				this.model.requestedSize = event.data as SizeVO;
				this.model.MainProductSKU = event.data as SizeVO;
				//this.model.MainProductColor.currentSize = event.data as SizeVO;
			}
			
			this.ui.visible = false;
			
		}		
		
		


		
	}
}