package com.virid.fbcheckout.model
{
	import com.virid.fbcheckout.model.vo.AltViewVO;
	import com.virid.fbcheckout.model.vo.ColorVO;
	import com.virid.fbcheckout.model.vo.ProductVO;
	
	import mx.collections.ArrayCollection;

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
			
			Product.Colors = new ArrayCollection();
			
			model.MainProduct = Product;
			
			buildTestColors();
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
		
		private function buildTestColors():void
		{
			//build some test color data
			
			var color:ColorVO = new ColorVO();
			//add item to main product
			color.name = 'Grey/Black/Purple';
			color.imageTB = 'assets/data/colors/1_198001_SW.jpg';
			color.imageFS = 'assets/data/colors/1_198001_FS.jpg';
			color.hex = '53874a';
			color.styleid = '471219';
			model.MainProduct.Colors.addItem(color);
			
			//add item to main product
			color = new ColorVO();
			color.name = 'White/Neon Pink/Black';
			color.imageTB = 'assets/data/colors/1_167758_SW.jpg';
			color.imageFS = 'assets/data/colors/1_167758_FS.jpg';
			color.hex = 'd4326b';
			color.styleid = '471180';
			model.MainProduct.Colors.addItem(color);
			
			color = new ColorVO();
			//add item to main product
			color.name = 'White/Zebra';
			color.imageTB = 'assets/data/colors/1_167748_SW.jpg';
			color.imageFS = 'assets/data/colors/1_167748_FS.jpg';
			color.hex = 'c6323e';
			color.styleid = '471177';
			model.MainProduct.Colors.addItem(color);

			color = new ColorVO();
			//add item to main product
			color.name = 'Black/Blue/Greem';
			color.imageTB = 'assets/data/colors/1_182022_SW.jpg';
			color.imageFS = 'assets/data/colors/1_182022_FS.jpg';
			color.hex = '6dc9f0';
			color.styleid = '471192';
			model.MainProduct.Colors.addItem(color);
		}
		
	}
}