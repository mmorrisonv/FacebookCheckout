package com.virid.fbcheckout.view
{
	import com.virid.fbcheckout.model.Model;

	public class RightColumnMediator
	{
		private var model:Model = Model.getInstance();
		private var ui:rightColumn;
		public function AltViewsMediator()
		{
			
		}
		
		public function register(_ui:rightColumn):void
		{
			this.ui = _ui;
			
			
		}
	}
}