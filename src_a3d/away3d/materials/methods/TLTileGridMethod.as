/**
 * Created by gaord on 2016/12/23.
 */
package away3d.materials.methods
{
	import away3d.arcane;
	import away3d.core.managers.Stage3DProxy;
	import away3d.materials.compilation.ShaderRegisterCache;
	import away3d.materials.compilation.ShaderRegisterElement;
	import away3d.materials.utils.DefaultMaterialManager;
	import away3d.textures.BitmapTexture;
	import away3d.textures.Texture2DBase;
	import away3d.textures.TextureProxyBase;

	import flash.display.BitmapData;

	use namespace arcane;

	/**
	 * TLTileGridMethod is a method to determine the grid binds to tiles.
	 * */
	public class TLTileGridMethod extends BasicDiffuseMethod
	{
		private var _gridTexture:Texture2DBase;
		//平铺数量
		private var _tileData:Array;

		private static var gridTexture :BitmapTexture;
		/**
		 * 显示网格 ，一个顶点一格
		 * 注意： 整幅地形共享的method
		 * @param tileData  顶点总数(即平铺数量)
		 * */
		public function TLTileGridMethod(tileData:Array , gridT:Texture2DBase = null)
		{
			super();
			if (gridT == null)
			{
				if(gridTexture == null )
				{
					// 只对应UV坐标，所以无关这里的尺寸，这里只为显示效果足够即可
					var bmd:BitmapData = new BitmapData(32, 32, false, 0x0);
					for (var i:int = 0; i < 32; i++)
					{
						bmd.setPixel32(0, i, 0xffCCCCCC);
						bmd.setPixel32(31, i, 0xffCCCCCC);
						bmd.setPixel32(i, 0, 0xffCCCCCC);
						bmd.setPixel32(i, 31, 0xffCCCCCC);
					}
					gridTexture = new BitmapTexture(bmd);
				}
				_gridTexture = gridTexture;
			}
			else
				_gridTexture = gridT;
			_tileData = tileData;
		}


//		override arcane function initVO(vo:MethodVO):void
//		{
//			vo.needsNormals = false;
//		}


		override arcane function initConstants(vo:MethodVO):void
		{
			var data:Vector.<Number> = vo.fragmentData;
			var index:int = vo.fragmentConstantsIndex;
			data[index] = _tileData? _tileData[0] : 1;
			data[index+1] = _tileData? _tileData[1] : 1;
			data[index+2] = 0.1;//alpha
		}


		override arcane function getFragmentPostLightingCode(vo:MethodVO, regCache:ShaderRegisterCache, targetReg:ShaderRegisterElement):String
		{
			var textureReg:ShaderRegisterElement = regCache.getFreeTextureReg();
			var code:String="";
			vo.texturesIndex = textureReg.index;

			// UV缩放寄存器 (_tileData)   // fc
			var scaleRegister:ShaderRegisterElement;
			scaleRegister = regCache.getFreeFragmentConstant();
			vo.fragmentConstantsIndex = scaleRegister.index*4;

			// 请求一个变化后的UV存储器
			var uv:ShaderRegisterElement = regCache.getFreeFragmentVectorTemp();
			regCache.addFragmentTempUsages(uv, 1);
			//默认UV
			var uvReg:ShaderRegisterElement = _sharedRegisters.uvVarying;
			// UV要mul
			code += "mul " + uv + ", " + uvReg + ", " + scaleRegister + ".xy\n" +
					getTex2DSampleCode(vo,targetReg,textureReg,_gridTexture,uv);
//			code += "mul " + targetReg + ".xyz, " + uv + ".w, " + targetReg + "\n";
//			code += "mul " + targetReg + ".xyz, " + uv + ".w, " + targetReg + "\n";

			regCache.removeFragmentTempUsage(uv);

			return code;
		}


		override protected function getTex2DSampleCode(vo:MethodVO, targetReg:ShaderRegisterElement, inputReg:ShaderRegisterElement, texture:TextureProxyBase, uvReg:ShaderRegisterElement = null, forceWrap:String = null):String
		{
			uvReg ||= _sharedRegisters.uvVarying;
			return super.getTex2DSampleCode(vo, targetReg, inputReg, texture, uvReg, forceWrap);
		}

		override arcane function activate(vo:MethodVO, stage3DProxy:Stage3DProxy):void
		{
			stage3DProxy._context3D.setTextureAt(vo.texturesIndex, _gridTexture.getTextureForStage3D(stage3DProxy));

		}
	}
}
