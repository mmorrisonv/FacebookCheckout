package com.virid.fbcheckout.view
{
	import com.virid.fbcheckout.model.Model;
	
	import flash.events.Event;
	
	import spark.effects.Animate;
	import spark.effects.animation.MotionPath;
	import spark.effects.animation.SimpleMotionPath;
	import spark.effects.easing.Power;
	import mx.effects.Sequence;

	public class RightColumnMediator
	{
		private var model:Model = Model.getInstance();
		private var ui:rightColumn;
		
		//tranition variables
		private var bigease:Power = new Power();
		private var v:Vector.<MotionPath> = new Vector.<MotionPath>();
		private var a1:Animate = new Animate();
		private var m:SimpleMotionPath = new SimpleMotionPath();
		
		public function AltViewsMediator():void
		{
			
		}
		
		public function register(_ui:rightColumn):void
		{
			this.ui = _ui;
			this.ui.addEventListener(rightColumn.BUYITNOWCLICKED,ui_OnBuyItNowClicked);
			this.ui.addEventListener(rightColumn.PRODDETAIL,ui_OnProdDetail);
			
			this.model.addEventListener(Model.MainProductChanged,onProductChange);
			this.model.addEventListener(Model.MainProductColorSKUChanged,onProdColorSKUChanged);
			//model listeners:ui
			this.model.addEventListener(Model.DisplayCheckout,ui_gotoCheckoutMode);
			this.model.addEventListener(Model.StartProdDetail,ui_gotoProdDetail);
			
			onProductChange(null);
		}
		
		protected function ui_OnProdDetail(event:Event):void
		{
			var obj:Object = new Object();
			obj.start = "NOW";
			this.model.initiateProdDetail = obj;
		}
		
		protected function ui_OnBuyItNowClicked(event:Event):void
		{
			var obj:Object = new Object();
			obj.start = "NOW";
			this.model.initiateCheckout = obj;
		}
		
		protected function onProductChange(event:Event):void
		{
			if(this.model.SelectedProduct.colorObj != null){
				ui.prodName.text = model.SelectedProduct.name;
				ui.selectedColor.text = model.SelectedProduct.colorObj.name;
				ui.selectedSize.text = model.SelectedProduct.colorObj.currentSKU.name;
			}
		}
		protected function onProdColorSKUChanged(event:Event):void
		{
			ui.selectedColor.text = model.SelectedProduct.colorObj.name;
			ui.selectedSize.text = model.SelectedProduct.colorObj.currentSKU.name;
		}
		
		protected function ui_gotoCheckoutMode(event:Event):void
		{
			a1 = new Animate();
			a1.target = this.ui; a1.duration = 600; a1.easer = bigease;
			m = new SimpleMotionPath();
			m.property = 'y'; m.valueTo = 1000;
			v = new Vector.<MotionPath>();v.push(m);
			a1.motionPaths = v;
			var p:Sequence = new Sequence();
			p.addChild(a1);
			p.play( );
		}
		
		protected function ui_gotoProdDetail(event:Event):void
		{
			a1 = new Animate();
			a1.target = this.ui; a1.duration = 500; a1.easer = bigease;
			m = new SimpleMotionPath();
			m.property = 'y'; m.valueTo = 0;
			v = new Vector.<MotionPath>();v.push(m);
			a1.motionPaths = v;
			var p:Sequence = new Sequence();
			p.addChild(a1);
			p.play( );
			
		}
		

	}
}