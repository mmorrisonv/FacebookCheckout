package controller.commands
{
	import com.adobe.serialization.json.JSON;
	import com.virid.fbcheckout.model.vo.ColorVO;
	import com.virid.fbcheckout.model.vo.SizeVO;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;

	public class extractColorOptions
	{
		//--------------
		//class related
		private var httpService:HTTPService = new HTTPService();
		private var _colorCallback:Function;
		private var _productLoaderCallback:Function;
		
		//--------------
		//data
		private var returnableListofSKUVOs:ArrayCollection = new ArrayCollection();
		private var uniqueSizes:Array = new Array();
		private var uniqueColors:Array = new Array();
		
		public function extractColorOptions(url:String, colorCallback:Function, productLoader:Function):void
		{			
			this._colorCallback = colorCallback;
			this._productLoaderCallback = productLoader;
			this.httpService.resultFormat="text";
			this.httpService.url = url;
			this.httpService.addEventListener("result", onHTTPResult); 
			this.httpService.addEventListener("fault", onHTTPFault);
			this.httpService.send();
		}
		
		protected function onHTTPFault(event:FaultEvent):void
		{
			Alert.show('HTTP FAULT' + event.message.toString() );
			trace( event.message.toString() );
		}
		
		protected function onHTTPResult(event:ResultEvent):void
		{
			// TODO Auto-generated method stub
			var rawArray:Object;
			var rawData:String = String(event.result);
			rawArray = JSON.decode(rawData);
			
			
			createAllSKUs(rawArray);
			
			createAllSizes(rawArray);			
			
			
			if(_colorCallback != null)
				_colorCallback(returnableListofSKUVOs);
			
			if(_productLoaderCallback != null)
				_productLoaderCallback(rawArray);
			
			
		}

		private function createAllSizes(rawArray:Object):void
		{
			//for each size within each SKU
			/*create a size with size info
			 *then add to returnableListofSKUVOs object
			*/
			var iter:Number = -1;
			for each( var jsonSize:Object in rawArray.SKUS)
			{
				//traverse over all orderable SKUS
				//set this data up as a size for now
				iter++;
				var newSize:SizeVO = new SizeVO();
				
				newSize.OID 		= jsonSize.OID;
				newSize.style_id	= jsonSize.STYLE_ID;
				newSize.index 		= iter;
				newSize.name 		= jsonSize.SIZE1_VALUE;
				newSize.color_code	= jsonSize.COLOR_CODE;
				newSize.price 		= jsonSize.PRICE; //todo : what to do with LPRICE
				
				newSize.size 		= jsonSize.SIZE1_VALUE;
				newSize.size_code	= jsonSize.SIZE1_VALUE;
				newSize.size2 		= jsonSize.SIZE2_VALUE;
				newSize.size2_code	= jsonSize.SIZE2_VALUE;
				
				newSize.inStock 	= (jsonSize.INSTOCK == 'Y');
				newSize.isdefault	= (jsonSize.ISDEFAULT == 1);
				newSize.qty 		= jsonSize.QTY_IN_STOCK;
				var test:uint 		= 0; 
				test =  uniqueColors.indexOf(jsonSize.COLOR_CODE) ;					
				
				//traverse over all SKUs and add newSize. 
				for each( var matchedSKU:ColorVO in this.returnableListofSKUVOs )
				{				
					if(matchedSKU.colorcode == newSize.color_code)
					{
						if(newSize.isdefault)
							matchedSKU.currentSize = newSize;
						//add it to our list of SKUs, and correlate these sizes to a SKU/Color
						newSize.parent_sku = matchedSKU;
						matchedSKU.Sizes.addItem(newSize);
						
					}
				}
			}
		}
		
		private function createAllSKUs(rawArray : Object):void
		{
			//traverse through all SKU's and add them to an array of SKUVO's if colorCode is unique
			for each( var jsonsku:Object in rawArray.SKUS){
				if(uniqueColors.indexOf(jsonsku.COLOR_CODE) == -1)
				{
					//newSize is a member of a new unique color
					uniqueColors.push(jsonsku.COLOR_CODE);
					var newSKU:ColorVO = new ColorVO();
					newSKU.colorcode = jsonsku.COLOR_CODE;
					newSKU.name = jsonsku.COLOR_CODE;
					newSKU.imageFS = jsonsku.FULL_IMAGE;
					newSKU.imageTB = jsonsku.SWATCH_IMAGE;
					newSKU.imagePVW= jsonsku.PREVIEW_IMAGE;
					
					newSKU.hex = '';
					
					
					returnableListofSKUVOs.addItem(newSKU);
					
				}
			}
		}
	}
}