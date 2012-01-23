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
			
			
			ui.addEventListener(PopupColorSelect.COLOR_CHANGED,colorChanged);
			
			
			
			if(this.model.productSetup){
				setupUIColorList();
			}
			else{
				
				var reloadTimer:Timer = new Timer(300,1);
			
				reloadTimer.addEventListener(TimerEvent.TIMER_COMPLETE,function (evt:TimerEvent):void{
					setupUIColorList();
				});
				reloadTimer.start();
				
			}
			
		}
		protected function setupUIColorList():void{
			this.ui.colorSelect.dataProvider = this.model.AllSKUs;
		}
		protected function colorChanged(event:CustomEvent):void
		{
			if(event.data != null )
			{
				var newColor:ColorVO = event.data as ColorVO;
				//newColor.currentSize = null; // reset currentSize so we dont have conflicts
				
				//check to see if requestedsize is instock
				
				//if instock change to requestedsize
				this.model.MainProductColor = newColor;
				
				//this.model.requestedSize.name;
				///this.model.SelectedProduct.colorObj.Sizes;
				for each( var size:SizeVO in this.model.SelectedProduct.colorObj.Sizes )
				{
					if(this.model.requestedSize != null && size.name == this.model.requestedSize.name && size.inStock)
					{
						this.model.MainProductSKU = size;
						this.model.SelectedProduct.colorObj.currentSize = size;
					}
				}
				
			}
			
			this.ui.visible = false;
			
		}		

		
	}
}