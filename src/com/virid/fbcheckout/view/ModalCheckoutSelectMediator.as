package com.virid.fbcheckout.view
{
	import com.virid.fbcheckout.model.Model;
	
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import mx.controls.Alert;
	import mx.effects.Sequence;
	
	import spark.effects.Animate;
	import spark.effects.animation.MotionPath;
	import spark.effects.animation.SimpleMotionPath;
	import spark.effects.easing.Elastic;
	import spark.effects.easing.Power;

	public class ModalCheckoutSelectMediator
	{
		private var model:Model = Model.getInstance();
		private var ui:ModalCheckoutSelect;
		
		//tranition variables
		private var bigease:Power = new Power();
		private var v:Vector.<MotionPath> = new Vector.<MotionPath>();
		private var a1:Animate = new Animate();
		private var m:SimpleMotionPath = new SimpleMotionPath();
		private var p2:Sequence = new Sequence();
		
		public function ModalCheckoutSelectMediator():void
		{
			
		}
		
		public function register(_ui:ModalCheckoutSelect):void
		{
			this.ui = _ui;
			this.ui.addEventListener(ModalCheckoutSelect.DISPLAY_CHECKOUT,ui_OnCheckout);
			this.ui.addEventListener(ModalCheckoutSelect.GOTO_JOURNEYSCHECKOUT,gotoJourneys);
			this.ui.addEventListener(ModalCheckoutSelect.CLOSE_MODAL,onClose);
			//model listeners:ui
			this.model.addEventListener(Model.CheckoutModal,ui_HandleCheckout);
		}
		
		protected function onClose(event:Event):void
		{
			//Alert2.show(this.ui.parentApplication.scaleX);
		
			this.ui.y = 25;// (( this.ui.parentApplication.height / 2 ) - ( this.ui.height / 2 )* this.ui.parentApplication.scaleX );
			if(p2)
				p2.stop();
			var a1:Animate = new Animate();
			a1.target = this.ui; a1.duration = 300;
			m = new SimpleMotionPath();
			m.property = 'x'; m.valueTo = 500;
			v = new Vector.<MotionPath>();v.push(m);
			a1.motionPaths = v;
			var p2:Sequence = new Sequence();
			p2.addChild(a1);
			p2.play();
		}
		
		protected function gotoJourneys(event:Event):void
		{
			var urlR:URLRequest = new URLRequest(this.model.urlRootTracking + 'basket.aspx');
			navigateToURL(urlR, '_blank');
		}		
		
		
		
		
		protected function ui_HandleCheckout(event:Event):void
		{
			//Alert2.show(this.ui.parentApplication.scaleX);
			//this.ui.y = (( this.ui.parentApplication.height / 2 ) - ( this.ui.height / 2 ) * this.ui.parentApplication.scaleX);
			this.ui.y = 25;
			var e:Elastic = new Elastic();
		
			var a1:Animate = new Animate();
			a1.target = this.ui; a1.duration = 800;a1.easer = e;
			m = new SimpleMotionPath();
			m.property = 'x'; m.valueTo = 15;//m.valueTo = (( this.ui.parentApplication.width / 2 ) - (this.ui.width / 2) * this.ui.parentApplication.scaleX);
			v = new Vector.<MotionPath>();v.push(m);
			a1.motionPaths = v;
			p2 = new Sequence();
			p2.addChild(a1);
			p2.play();
			//this.ui.visible = true;
		}
		
		protected function ui_OnCheckout(event:Event):void
		{
			this.ui.y = 25;// (( this.ui.parentApplication.height / 2 ) - ( this.ui.height / 2 ) * this.ui.parentApplication.scaleX );
			if(p2)
				p2.stop();
			var a1:Animate = new Animate();
			a1.target = this.ui; a1.duration = 300;
			m = new SimpleMotionPath();
			m.property = 'x'; m.valueTo = 500;
			v = new Vector.<MotionPath>();v.push(m);
			a1.motionPaths = v;
			var p2:Sequence = new Sequence();
			p2.addChild(a1);
			p2.play();
			//this.ui.visible = false;
			var obj:Object = new Object();
			obj.start = "NOW";
			this.model.displayCheckout = obj;
		}


		

	}
}