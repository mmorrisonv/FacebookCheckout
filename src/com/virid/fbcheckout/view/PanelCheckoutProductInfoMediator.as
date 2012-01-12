package com.virid.fbcheckout.view
{
	import com.virid.fbcheckout.model.Model;
	import com.virid.fbcheckout.model.vo.SKUVO;
	
	import controller.events.CustomEvent;
	
	import flash.events.Event;
	
	import mx.effects.Sequence;
	
	import spark.effects.Animate;
	import spark.effects.animation.MotionPath;
	import spark.effects.animation.SimpleMotionPath;

	public class PanelCheckoutProductInfoMediator
	{
		private var model:Model = Model.getInstance();
		private var ui:PanelCheckoutProductInfo;
		
		private var m:SimpleMotionPath = new SimpleMotionPath();
		private var v:Vector.<MotionPath> = new Vector.<MotionPath>();
		
		public function register(_ui:PanelCheckoutProductInfo):void
		{
			this.ui = _ui;
			
			this.model.addEventListener(Model.StartProdDetail,ui_ShowProDetail);
			this.model.addEventListener(Model.DisplayCheckout,ui_ShowCheckout);
			
			ui.addEventListener(PanelCheckoutProductInfo.SHOWPRODDETAIL,initateProDetail );
			this.model.addEventListener(Model.MainProductChanged,onProductChange);
			onProductChange(null);
		}
		
		protected function onProductChange(event:Event):void
		{
			if(this.model.SelectedProduct.colorObj != null)
			{
				this.ui.productImage.source = this.model.SelectedProduct.colorObj.imageFS;	
				this.ui.productName.text = model.SelectedProduct.name;
				this.ui.productDetail.text = "Size: " + model.SelectedProduct.colorObj.currentSize.name;
				this.ui.productColor.text = "Color: " + model.SelectedProduct.colorObj.name;
				this.ui.productPriceDisplay.text = "$" + String(this.model.SelectedProduct.colorObj.currentSize.price) + " USD";
			}
		}
		
		protected function initateProDetail(event:Event):void
		{
			var obj:Object = new Object();
			obj.start = "NOW";
			this.model.initiateProdDetail = obj;
			
		}
		
		protected function ui_ShowCheckout(event:Event):void
		{
			this.ui.visible = true;
			var a1:Animate = new Animate();
			a1.target = this.ui.banner; a1.duration = 300;
			m = new SimpleMotionPath();
			m.property = 'y'; m.valueTo = 0;
			v = new Vector.<MotionPath>();v.push(m);
			a1.motionPaths = v;
			var p2:Sequence = new Sequence();
			p2.addChild(a1);
			p2.play();
			

			
			this.ui.visible = true;
			var a1:Animate = new Animate();
			a1.target = this.ui.details; a1.duration = 300;
			m = new SimpleMotionPath();
			m.property = 'x'; m.valueTo = 0;
			v = new Vector.<MotionPath>();v.push(m);
			a1.motionPaths = v;
			var p2:Sequence = new Sequence();
			p2.addChild(a1);
			p2.play();
		}
		
		protected function ui_ShowProDetail(event:Event):void
		{
			this.ui.visible = true;
			var a1:Animate = new Animate();
			a1.target = this.ui.banner; a1.duration = 300;
			m = new SimpleMotionPath();
			m.property = 'y'; m.valueTo = -50;
			v = new Vector.<MotionPath>();v.push(m);
			a1.motionPaths = v;
			var p2:Sequence = new Sequence();
			p2.addChild(a1);
			p2.play();
			
			
			
			this.ui.visible = true;
			var a1:Animate = new Animate();
			a1.target = this.ui.details; a1.duration = 300;
			m = new SimpleMotionPath();
			m.property = 'x'; m.valueTo = -500;
			v = new Vector.<MotionPath>();v.push(m);
			a1.motionPaths = v;
			var p2:Sequence = new Sequence();
			p2.addChild(a1);
			p2.play();
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