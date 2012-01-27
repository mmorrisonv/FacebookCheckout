package com.virid.fbcheckout.model
{	

	import com.adobe.serialization.json.JSON;
	import com.virid.fbcheckout.model.vo.AltViewVO;
	import com.virid.fbcheckout.model.vo.ColorVO;
	import com.virid.fbcheckout.model.vo.ProductVO;
	import com.virid.fbcheckout.model.vo.ShippingOptionVO;
	import com.virid.fbcheckout.model.vo.SizeVO;
	
	import controller.commands.extractColorOptions;
	
	import flash.sampler.NewObjectSample;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;

	public class Context
	{
		private var model:Model = Model.getInstance();
		public function Context()
		{
			buildShippingOptions();
			buildProductColors();
		}
		

		private function buildProductColors():void
		{
			//use ajax to get SKU / image / price information for the current productID
			
			var url:String = model.urlRootSecure + "api/getproduct.aspx?id=" + model.productID;
			var colorExtractor:extractColorOptions = new extractColorOptions(url,buildMainProduct);
			
		}
		private function buildMainProduct(rawArray:Object):void
		{//function gets called when data is returned on buildProductColors by extractColorOptions object
			
			//check to make sure the extracColorOptions Command setup the product and current color / sizes. if not setup defaults
			if(model.productSetup == false)
			{
				var Product:ProductVO = new ProductVO();
				
				var tcolor: ColorVO = this.model.AllSKUs[0];
				var tsize: SizeVO = tcolor.Sizes[0];
				tcolor.currentSize = tsize;
				Product.name = rawArray.NAME;
				Product.colorObj = tcolor;
				
				model.SelectedProduct = Product;
				model.MainProductSKU = tsize;
				model.productSetup = true; 
			}
		}

		private function buildShippingOptions():void
		{
			var tempSO:ShippingOptionVO = new ShippingOptionVO();
			tempSO.id = 'STD';
			tempSO.index = 0;
			tempSO.desc = '$4.95 UPS Ground Shipping';
			tempSO.name = 'Ground Shipping';
			tempSO.price = 4.95;
			
			this.model.AllShippingOptions.addItem(tempSO);
			
			tempSO = new ShippingOptionVO();
			tempSO.id = '2DAY';
			tempSO.index = 1;
			tempSO.desc = '$13.95 2-3 Day Air';
			tempSO.name = '2 Day Air';
			tempSO.price = 13.95;
			
			this.model.AllShippingOptions.addItem(tempSO);
			
			tempSO = new ShippingOptionVO();
			tempSO.id = '1DAY';
			tempSO.index = 2;
			tempSO.desc = '$22.95 Next Day Air';
			tempSO.name = 'Next Day Air';
			tempSO.price = 22.95;
			
			this.model.AllShippingOptions.addItem(tempSO);			
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

		
	}
}