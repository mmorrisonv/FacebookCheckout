package com.virid.fbcheckout.view
{
	import com.virid.fbcheckout.model.Model;
	
	import flash.events.Event;
	
	import mx.effects.Move;
	import mx.effects.Parallel;
	import mx.effects.Sequence;
	import mx.effects.easing.Exponential;
	import mx.states.Transition;
	
	import spark.effects.Animate;
	import spark.effects.animation.MotionPath;
	import spark.effects.animation.SimpleMotionPath;
	import spark.effects.easing.EaseInOutBase;
	import spark.effects.easing.EasingFraction;
	import spark.effects.easing.Elastic;
	import spark.effects.easing.Power;

	public class ProductImageMediator
	{
		private var model:Model = Model.getInstance();
		private var ui:ProductImage;
		
		//tranition variables
		private var bigease:Power = new Power();
		private var v:Vector.<MotionPath> = new Vector.<MotionPath>();
		private var a1:Animate = new Animate();
		private var m:SimpleMotionPath = new SimpleMotionPath();
		
		
		public function ProductImageMediator(){
			bigease.exponent = 2;
		}
		
		public function register(_ui:ProductImage):void
		{
			this.ui = _ui;
			this.model.addEventListener(Model.StartProdDetail,ui_gotoProductDetailMode);
			this.model.addEventListener(Model.DisplayCheckoutPanel,ui_gotoCheckoutMode);
			
			this.model.addEventListener(Model.MainProductColorChanged,onProductColororSKUchanged);
			this.model.addEventListener(Model.MainProductSKUChanged,onProductColororSKUchanged);
			this.model.addEventListener(Model.MainProductImageChanged,changeAltView);
			onProductColororSKUchanged(null);
		}		
		
		
		protected function changeAltView(event:Event):void
		{
			this.ui.productImage.source = this.model.MainProductImage.source;
		}
		
		protected function onProductColororSKUchanged(event:Event):void
		{
			
			if(this.model.SelectedProduct.colorObj != null)
				this.ui.productImage.source = this.model.SelectedProduct.colorObj.imageFS;
			//if we have a currentSize - use that price . else use a guestimate of the price based on color
			if(this.model.SelectedProduct.colorObj.currentSize != null)
				this.ui.productPriceDisplay.text = '$' + String(this.model.SelectedProduct.colorObj.currentSize.price) + ' USD';
			else
				this.ui.productPriceDisplay.text = '$' + String(this.model.SelectedProduct.colorObj.priceOfSKUs) + ' USD';
			

		}
		
		
		protected function ui_gotoCheckoutMode(event:Event):void
		{
			//move main prouduct image over to the left
			a1 = new Animate();
			a1.target = this.ui.productImage; a1.duration = 180; a1.easer = bigease;
			m.property = 'x';m.valueBy= 10;
			v.push(m);
			a1.motionPaths = v;
			var p:Sequence = new Sequence();
			p.addChild(a1);
			
			a1 = new Animate();
			a1.target = this.ui.productImage; a1.duration = 500; a1.easer = bigease;
			m = new SimpleMotionPath();
			m.property = 'x'; m.valueTo = -500;
			v = new Vector.<MotionPath>();v.push(m);
			a1.motionPaths = v;
			p.addChild(a1);
			p.play( );
			
			//move productPriceDisplay to right
			a1 = new Animate();
			a1.target = this.ui.productPriceDisplay; a1.duration = 300;
			m = new SimpleMotionPath();
			m.property = 'right'; m.valueTo = -1000;
			v = new Vector.<MotionPath>();v.push(m);
			a1.motionPaths = v;
			var p2:Sequence = new Sequence();
			p2.addChild(a1);
			p2.play();
			
		}
		
		protected function ui_gotoProductDetailMode(event:Event):void
		{
			//move main proudctImage back
			a1 = new Animate();
			a1.target = this.ui.productImage; a1.duration = 500;
			m = new SimpleMotionPath();
			m.property = 'x'; m.valueTo = 0;
			v = new Vector.<MotionPath>();v.push(m);
			a1.motionPaths = v;
			var seqMI:Sequence = new Sequence();
			seqMI.addChild(a1);
			seqMI.play( );
			
			//move productPriceDisplay back
			a1 = new Animate();
			a1.target = this.ui.productPriceDisplay; a1.duration = 300;
			m = new SimpleMotionPath();
			m.property = 'right'; m.valueTo = 12;
			v = new Vector.<MotionPath>();v.push(m);
			a1.motionPaths = v;
			var p2:Sequence = new Sequence();
			p2.addChild(a1);
			p2.play();
			
		}

	}
}