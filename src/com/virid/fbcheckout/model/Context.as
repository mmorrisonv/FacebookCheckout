package com.virid.fbcheckout.model
{
	import com.adobe.serialization.json.JSON;
	import com.virid.fbcheckout.model.vo.AltViewVO;
	import com.virid.fbcheckout.model.vo.ColorVO;
	import com.virid.fbcheckout.model.vo.ProductVO;
	import com.virid.fbcheckout.model.vo.SizeVO;
	
	import flash.sampler.NewObjectSample;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;

	public class Context
	{
		private var model:Model = Model.getInstance();
		public function Context()
		{

			buildProductColors();
			/*buildSKUs();
			buildMainProduct();
			buildTestAltViews();*/
		}
		

		private function buildMainProduct():void
		{
			var Product:ProductVO = new ProductVO();
			
			
			var tcolor: ColorVO = this.model.Colors[1];
			Product.name = "Womens Osiris NYC 83 Slim Skate Shoe - White/Zebra";
			Product.colorObj = tcolor;
			//Product.sku  = null;
			Product.source = "assets/images/data/prodimage.jpg";
			
			
			
			model.MainProduct = Product;
			
			
		}
		
		private function buildTestAltViews():void{
			
			//build some test data
			for( var i:int = 2; i <= 4; i++)
			{
				var testView:AltViewVO = new AltViewVO();
				testView.source = "assets/data/alt-view"+i+".jpg";
				testView.thumb = testView.source;
				model.MainProduct.altViews.addItem(testView);
			}
		}
		
		private function buildProductColors():void
		{
			//build some test color data
			
			model.httpService.resultFormat="text";
			model.httpService.url = model.urlRoot + "getproduct.aspx?id=" + model.productID;
			model.httpService.addEventListener("result", buildColorHTTPResult); 
			model.httpService.addEventListener("fault", buildColorHTTPFault);
			model.httpService.send();
			/*
			var color:ColorVO = new ColorVO();
			//add item to main product
			color.name = 'Grey/Black/Purple';
			color.imageTB = 'assets/data/colors/1_198001_SW.jpg';
			color.imageFS = 'assets/data/colors/1_198001_FS.jpg';
			color.hex = '53874a';
			color.styleid = '471219';
			build471219AltViews(color);
			model.Colors.addItem(color);
			
			
			//add item to main product
			color = new ColorVO();
			color.name = 'White/Neon Pink/Black';
			color.imageTB = 'assets/data/colors/1_167758_SW.jpg';
			color.imageFS = 'assets/data/colors/1_167758_FS.jpg';
			color.hex = 'd4326b';
			color.styleid = '471180';
			model.Colors.addItem(color);
			
			color = new ColorVO();
			//add item to main product
			color.name = 'White/Zebra';
			color.imageTB = 'assets/data/colors/1_167748_SW.jpg';
			color.imageFS = 'assets/data/colors/1_167748_FS.jpg';
			color.hex = 'c6323e';
			color.styleid = '471177';
			color.defaultColor = true;
			model.Colors.addItem(color);

			color = new ColorVO();
			//add item to main product
			color.name = 'Black/Blue/Green';
			color.imageTB = 'assets/data/colors/1_182022_SW.jpg';
			color.imageFS = 'assets/data/colors/1_182022_FS.jpg';
			color.hex = '6dc9f0';
			color.styleid = '471192';
			model.Colors.addItem(color);*/
		}
		
		protected function buildColorHTTPFault(event:FaultEvent):void
		{
			var faultString:String = event.fault.faultString;
			Alert.show(faultString);
		}
		
		protected function buildColorHTTPResult(event:ResultEvent):void
		{
			var result:Object = event.result;	
			result = JSON.decode( result.toString() );
			
			trace(result);
		}
		
		private function build471219AltViews(color:ColorVO):void
		{
			var thumbs:Array = new Array('assets/data/alt-views/1_201046_SW.JPG','assets/data/alt-views/1_201046_SW_BACK.JPG','assets/data/alt-views/1_201046_SW_FRONT.JPG','assets/data/alt-views/1_201046_SW_SIDE.JPG','assets/data/alt-views/1_201046_SW_TOP.JPG');
			var fullsize:Array = new Array('assets/data/alt-views/1_201046_FS.JPG','assets/data/alt-views/1_201046_FS_BACK.JPG','assets/data/alt-views/1_201046_FS_FRONT.JPG','assets/data/alt-views/1_201046_FS_SIDE.JPG','assets/data/alt-views/1_201046_FS_TOP.JPG');
			for(var i:uint = 0; i < thumbs.length; i++)
			{
				var newAltView:AltViewVO = new AltViewVO();
				newAltView.thumb = thumbs[i];
				newAltView.source = fullsize[i];
				color.AltViews.addItem(newAltView);
			}
		}
		
		private function buildSKUs():void
		{
			var sizes:Array = new Array('XS','S','M','L','XL');
			for each(var c:ColorVO in model.Colors)
			{
				for( var i:Number = 0; i < 5; i++){
					var nSKU:SizeVO = new SizeVO();
					nSKU.index = i;
					nSKU.name = sizes[i];
					nSKU.size = nSKU.name;
					nSKU.sku = i + '_' + c.styleid;
					nSKU.price = (i==0)?50.49:74.99;
					c.SKUs.addItem(nSKU);
				}
				
				c.currentSKU = c.SKUs[0];
			}
		}
		
	}
}