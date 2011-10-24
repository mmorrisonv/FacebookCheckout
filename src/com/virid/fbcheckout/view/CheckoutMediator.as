package com.virid.fbcheckout.view
{
	import com.virid.fbcheckout.model.Model;
	
	import flash.events.Event;
	
	import mx.controls.CheckBox;
	import mx.effects.Sequence;
	
	import spark.effects.Animate;
	import spark.effects.animation.MotionPath;
	import spark.effects.animation.SimpleMotionPath;
	import spark.effects.easing.Power;

	public class CheckoutMediator
	{
		private var model:Model = Model.getInstance();
		private var ui:Checkout;
		
		//tranition variables
		private var bigease:Power = new Power();
		private var v:Vector.<MotionPath> = new Vector.<MotionPath>();
		private var a1:Animate = new Animate();
		private var m:SimpleMotionPath = new SimpleMotionPath();
		
		public function CheckoutMediator():void
		{
			
		}
		
		public function register(_ui:Checkout):void
		{
			this.ui = _ui;
			
			this.model.addEventListener(Model.MainProductColorSKUChanged,onProdColorSKUChanged);
			//model listeners:ui
			this.model.addEventListener(Model.DisplayCheckout,ui_gotoCheckoutMode);
			this.model.addEventListener(Model.StartProdDetail,ui_gotoProdDetail);
			
	
		}
		
		protected function onProdColorSKUChanged(event:Event):void
		{
			// TODO Auto-generated method stub
			
		}
		
		protected function ui_gotoCheckoutMode(event:Event):void
		{
			this.ui.visible = true;
			this.ui.includeInLayout = true;
			a1 = new Animate();
			a1.target = this.ui; a1.duration = 600; a1.easer = bigease;
			m = new SimpleMotionPath();
			m.property = 'y'; m.valueTo = 95;
			v = new Vector.<MotionPath>();v.push(m);
			a1.motionPaths = v;
			var p:Sequence = new Sequence();
			p.addChild(a1);
			p.play( );
		}
		
		protected function ui_gotoProdDetail(event:Event):void
		{
			a1 = new Animate();
			a1.target = this.ui; a1.duration = 700; a1.easer = bigease;
			m = new SimpleMotionPath();
			m.property = 'y'; m.valueTo = 1000;
			v = new Vector.<MotionPath>();v.push(m);
			a1.motionPaths = v;
			var p:Sequence = new Sequence();
			p.addChild(a1);
			p.play( );
			
			/*this.ui.visible = false;
			this.ui.includeInLayout = false;*/
			
		}

	}
}