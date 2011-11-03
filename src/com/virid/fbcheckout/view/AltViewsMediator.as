package com.virid.fbcheckout.view
{
	import com.virid.fbcheckout.model.Model;
	import com.virid.fbcheckout.model.vo.AltViewVO;
	
	import controller.events.CustomEvent;
	
	import flash.events.Event;
	import flash.sampler.NewObjectSample;
	
	import mx.effects.Sequence;
	
	import spark.effects.Animate;
	import spark.effects.animation.MotionPath;
	import spark.effects.animation.SimpleMotionPath;
	import spark.effects.easing.Power;

	public class AltViewsMediator
	{
		private var model:Model = Model.getInstance();
		private var ui:AltViews;
		
		private var bigease:Power = new Power();
		private var v:Vector.<MotionPath> = new Vector.<MotionPath>();
		private var m:SimpleMotionPath = new SimpleMotionPath();
		
		
		public function AltViewsMediator()
		{
			bigease.exponent = 2;
		}
		
		public function register(_ui:AltViews):void
		{
			this.ui = _ui;
			//ui listeners
			this.ui.altViewList.dataProvider = this.model.MainProduct.altViews;
			this.ui.addEventListener(AltViews.UI_ALTVIEW_SELECTION_CHANGED,changeProductImage);
			//model listeners
			this.model.addEventListener(Model.DisplayCheckout,ui_gotoCheckoutMode);
			this.model.addEventListener(Model.StartProdDetail,ui_gotoProdDetailMode);
			this.model.addEventListener(Model.MainProductColorSKUChanged,changeAltViewList);
			
			changeAltViewList(null);
		}
		/*
		* Model Listeners*/
		protected function changeAltViewList(event:Event):void
		{
			if( this.model.MainProduct.colorObj != null && this.model.MainProduct.colorObj.AltViews != null && this.model.MainProduct.colorObj.AltViews.length > 0 )
				this.ui.altViewList.dataProvider = this.model.MainProduct.colorObj.AltViews;
			else
				this.ui.altViewList.dataProvider = this.model.MainProduct.altViews;
			
		}
		protected function ui_gotoProdDetailMode(event:Event):void
		{
			var a1:Animate = new Animate();
			a1.target = this.ui; a1.duration = 300;
			m = new SimpleMotionPath();
			m.property = 'y'; m.valueTo = 247;
			v = new Vector.<MotionPath>();v.push(m);
			a1.motionPaths = v;
			var p2:Sequence = new Sequence();
			p2.addChild(a1);
			p2.play();
			
		}
		
		protected function ui_gotoCheckoutMode(event:Event):void
		{

			//move main prouduct image over to the left
			//anticipate action
			var a1:Animate = new Animate();
			a1.target = this.ui; a1.duration = 240; a1.easer = bigease;
			m.property = 'y';m.valueBy = -5;
			v.push(m);
			a1.motionPaths = v;
			var p:Sequence = new Sequence();
			p.addChild(a1);
			//animate out
			a1 = new Animate();
			a1.target = this.ui; a1.duration = 700; a1.easer = bigease;
			m = new SimpleMotionPath();
			m.property = 'y'; m.valueTo = 500;
			v = new Vector.<MotionPath>();v.push(m);
			a1.motionPaths = v;
			p.addChild(a1);
			p.play( );
		}		

		/*
		 * UI Listeners*/
		protected function changeProductImage(event:CustomEvent):void
		{
			this.model.MainProductImage = event.data as AltViewVO; 
		}		
		

	}
}