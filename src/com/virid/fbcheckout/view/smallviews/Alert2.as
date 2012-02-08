package com.virid.fbcheckout.view.smallviews
{
	import flash.display.Stage;
	
	import mx.controls.Alert;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.events.MoveEvent;
	import mx.events.ResizeEvent;

	public class Alert2
	{
		public static var stage:UIComponent;
		private static var alertBox:Alert;
		public static function posAlert():void
		{
			var newX:Number = 403 / 2 - alertBox.width / 2;
			var newY:Number = 227 / 2 - alertBox.height / 2;
			alertBox.x = newX;
			alertBox.y = newY;
		}
		public function Alert2()
		{
			
		}
		public static function show(msg:String, title:String = ""):void
		{
			var alert:Alert = Alert.show( msg, title );
			//PopUpManager.centerPopUp (alert);

			//alert.move (0, 0);
			alert.addEventListener(ResizeEvent.RESIZE,onResize);
			alert.addEventListener("move",onMoved);
			alert.addEventListener("show",onShow);
			
			setTimeout ( posAlert,500);import flash.utils.setTimeout
			
			//alert.x = 0;
			//alert.y = 0;
			alertBox = alert;
		}
		
		protected static function onShow(event:FlexEvent):void
		{
			alertBox.removeEventListener("show",onShow);
			posAlert();
		}
		
		protected static function onMoved(event:MoveEvent):void
		{
			alertBox.removeEventListener("move",onMoved);
			posAlert();
		}
		
		protected static function onResize(event:ResizeEvent):void
		{
			alertBox.removeEventListener("resize",onResize);
			posAlert();
		}
	}
}