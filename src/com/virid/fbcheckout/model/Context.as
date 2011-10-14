package com.virid.fbcheckout.model
{
	import com.virid.fbcheckout.model.vo.AltViewVO;
	import com.virid.fbcheckout.model.vo.ProductVO;

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
			var Product:ProductVO = new ProductVO();
			
			Product.name = "Womens Osiris NYC 83 Slim Skate Shoe - White/Zebra";
			Product.color= "0xfcfcfc";
			Product.sku  = "we234";
			Product.source = "assets/images/data/prodimage.jpg";
			
			model.MainProduct = Product;
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