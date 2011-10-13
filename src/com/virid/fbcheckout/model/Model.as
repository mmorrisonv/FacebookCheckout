package com.virid.fbcheckout.model
{
	import com.virid.fbcheckout.model.Model;
	import com.virid.fbcheckout.model.vo.ProductVO;
	
	import mx.collections.ArrayCollection;

	public class Model
	{
		
		/*Singelton Model code*/
		private static var instance:Model;
		public function Model()
		{
			instance=this;	
		}
		
		public static function getInstance():Model
		{
			if(instance == null)
				instance = new Model();
			return instance;
		}
		/*End Singleton Model code*/
		
		
		
		
		public var AltViews:ArrayCollection = new ArrayCollection();
		public var MainProduct:ProductVO = new ProductVO();
	}	
}