package com.virid.fbcheckout.view.smallviews
{
	import com.virid.fbcheckout.model.Model;
	
	import flash.events.Event;
	
	import mx.effects.Sequence;
	import mx.effects.easing.Elastic;
	
	import spark.effects.Animate;
	import spark.effects.animation.MotionPath;
	import spark.effects.animation.SimpleMotionPath;
	import spark.effects.easing.Power;

	public class ModalErrorAlertMediator
	{
		private var model:Model = Model.getInstance();
		private var ui:ModalErrorAlert;
		
		//tranition variables
		private var bigease:Power = new Power();
		private var v:Vector.<MotionPath> = new Vector.<MotionPath>();
		private var a1:Animate = new Animate();
		private var m:SimpleMotionPath = new SimpleMotionPath();
		private var p2:Sequence = new Sequence();
		
		
		public function register(_ui:ModalErrorAlert):void
		{
			this.ui = _ui;
			this.ui.addEventListener(ModalErrorAlert.REMOVE_UI_FROMSTAGE,ui_OnRemoveUI);
			
			//model listeners:ui
			this.model.addEventListener(Model.StatusUpdate,showStatusUpdate);
		}
		
		
		protected function ui_OnRemoveUI(event:Event):void
		{
			if(p2)
				p2.stop();
			var a1:Animate = new Animate();
			a1.target = this.ui; a1.duration = 300;
			m = new SimpleMotionPath();
			m.property = 'horizontalCenter'; m.valueTo = 500;
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
		
		protected function showErrorModal(event:Event):void
		{
			var e:Elastic = new Elastic();
			
			var a1:Animate = new Animate();
			a1.target = this.ui; a1.duration = 800;a1.easer = e;
			m = new SimpleMotionPath();
			m.property = 'horizontalCenter'; m.valueTo = 0;
			v = new Vector.<MotionPath>();v.push(m);
			a1.motionPaths = v;
			p2 = new Sequence();
			p2.addChild(a1);
			p2.play();
			//this.ui.visible = true;
			
		}
		
		
	}
}