package com.virid.fbcheckout.model
{	

	import com.adobe.serialization.json.JSON;
	import com.virid.fbcheckout.model.vo.AltViewVO;
	import com.virid.fbcheckout.model.vo.ProductVO;
	import com.virid.fbcheckout.model.vo.ColorVO;
	import com.virid.fbcheckout.model.vo.SizeVO;
	
	import controller.commands.extractColorOptions;
	
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
			buildMainProduct();*/
			//build471219AltViews();
		}
		
		private function buildProductColors():void
		{
			//use ajax to get SKU / image / price information for the current productID
			
			var url:String = model.urlRoot + "getproduct.aspx?id=" + model.productID;
			var colorExtractor:extractColorOptions = new extractColorOptions(url,buildMainProduct);
			
		}
		private function buildMainProduct(rawArray:Object):void
		{//function gets called when data is returned on buildProductColors by extractColorOptions object
			
			var Product:ProductVO = new ProductVO();
			
			var tcolor: ColorVO = this.model.AllSKUs[7];
			var tsize: SizeVO = tcolor.Sizes[0];
			tcolor.currentSize = tsize;
			Product.name = rawArray.NAME;
			Product.colorObj = tcolor;
			
			model.SelectedProduct = Product;
			
		}

		private function buildTestAltViews():void{
			
			//build some test data
			for( var i:int = 2; i <= 4; i++)
			{
				var testView:AltViewVO = new AltViewVO();
				testView.source = "assets/data/alt-view"+i+".jpg";
				testView.thumb = testView.source;
				model.SelectedProduct.altViews.addItem(testView);
			}
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
			for each(var c:ColorVO in model.AllSKUs)
			{
				for( var i:Number = 0; i < 5; i++){
					var nSKU:SizeVO = new SizeVO();
					nSKU.index = i;
					nSKU.name = sizes[i];
					nSKU.size = nSKU.name;
					nSKU.style_id = i + '_' + c.styleid;
					nSKU.price = (i==0)?50.49:74.99;
					c.Sizes.addItem(nSKU);
				}
				
				c.currentSize = c.Sizes[0];
			}
		}
		
	}
}