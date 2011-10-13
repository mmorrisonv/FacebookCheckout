package com.virid.fbcheckout.model.vo
{
	import flash.events.EventDispatcher;
	
	public class AltViewVO extends EventDispatcher
	{
		public var name : String;
		public var styleid : String;
		public var color : String;
		public var source : String;
		public var thumb : String;
		public var main : Boolean;
		public var success : Boolean;
		public var loaded:Boolean;
	}
}