package com.virid.fbcheckout.model
{
	import com.virid.fbcheckout.model.vo.AltViewVO;

	public class Context
	{
		private var model:Model = Model.getInstance();
		public function Context()
		{
			buildTestAltViews();
			buildMainProduct();
		}
		
		private function buildMainProduct():void
		{
			model.MainProduct.name = "Womens Osiris NYC 83 Slim Skate Shoe - White/Zebra";
			model.MainProduct.color= "0xfcfcfc";
			model.MainProduct.sku  = "we234";
			model.MainProduct.source = "assets/images/data/prodimage.jpg";
		}
		
		private function buildTestAltViews():void{
			
						//build some test data
			for( var i:int = 2; i <= 4; i++)
			{
				var testView:AltViewVO = new AltViewVO();
				testView.source = "assets/data/alt-view"+i+".jpg";
				model.AltViews.addItem(testView);
			}
			
		}
	}
}