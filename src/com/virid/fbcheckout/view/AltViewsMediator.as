package com.virid.fbcheckout.view
{
	import com.virid.fbcheckout.model.Model;
	import com.virid.fbcheckout.model.vo.AltViewVO;
	
	import controller.events.CustomEvent;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.sampler.NewObjectSample;
	import flash.utils.Timer;
	
	import mx.effects.Sequence;
	
	import org.osmf.events.TimeEvent;
	
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
			this.ui.altViewList.dataProvider = this.model.SelectedProduct.altViews;
			this.ui.addEventListener(AltViews.UI_ALTVIEW_SELECTION_CHANGED,changeProductImage);
			//model listeners
			this.model.addEventListener(Model.DisplayCheckoutPanel,ui_gotoCheckoutMode);
			this.model.addEventListener(Model.StartProdDetail,ui_gotoProdDetailMode);
			this.model.addEventListener(Model.MainProductColorChanged,setupAltViewList);
			
			if(this.model.productSetup)
				setupAltViewList(null);
			else{
				var reloadTimer:Timer = new Timer(300,1);
				reloadTimer.addEventListener(TimerEvent.TIMER_COMPLETE,function (evt:TimerEvent):void{
					setupAltViewList(null);
				});
				reloadTimer.start();
			}
			
		}
		/*
		* Model Listeners*/
		protected function setupAltViewList(event:Event):void
		{
			if( this.model.SelectedProduct.colorObj != null && this.model.SelectedProduct.colorObj.AltViews != null && this.model.SelectedProduct.colorObj.AltViews.length > 0 )
				this.ui.altViewList.dataProvider = this.model.SelectedProduct.colorObj.AltViews;
			else if(  this.model.SelectedProduct.altViews != null && this.model.SelectedProduct.altViews != null && this.model.SelectedProduct.altViews.length > 0 )
				this.ui.altViewList.dataProvider = this.model.SelectedProduct.altViews;
			else
				this.ui_gotoSlimView();
			
		}
		
		private function ui_gotoSlimView():void
		{
			this.ui.showMini.play();
			
		}
		protected function ui_gotoProdDetailMode(event:Event):void
		{
			/*var a1:Animate = new Animate();
			a1.target = this.ui; a1.duration = 300;
			m = new SimpleMotionPath();
			m.property = 'y'; m.valueTo = 247;
			v = new Vector.<MotionPath>();v.push(m);
			a1.motionPaths = v;
			var p2:Sequence = new Sequence();
			p2.addChild(a1);
			p2.play();*/
			this.ui.showMini.play();
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