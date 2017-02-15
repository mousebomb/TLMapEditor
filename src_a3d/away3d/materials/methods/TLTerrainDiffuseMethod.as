package away3d.materials.methods
{
	import away3d.arcane;
	import away3d.core.managers.Stage3DProxy;
	import away3d.materials.compilation.ShaderRegisterCache;
	import away3d.materials.compilation.ShaderRegisterElement;
	import away3d.textures.Texture2DBase;
	import away3d.textures.TextureProxyBase;
	
	import flash.display3D.Context3D;

	import tool.StageFrame;

	use namespace arcane;

	/**
	 * TerrainDiffuseMethod provides a diffuse method that uses different tiled textures with alpha masks to create a
	 * large surface with high detail and less apparent tiling.
	 */
	public class TLTerrainDiffuseMethod extends BasicDiffuseMethod
	{
		private var _blendingTexture:Texture2DBase;
		private var _splats:Vector.<Texture2DBase>;
		private var _numSplattingLayers:uint;
		private var _tileData:Array;
		
		/**
		 * 地形融合纹理； 四张贴图+splatalpha
		 * 平铺于地形内；网格对应地形的的UV是0~1
		 *  只用于屠龙的3D编辑器
		 *  @see TLTileView,TLTileVO
		 * Creates a new TerrainDiffuseMethod.
		 * @param splatTextures An array of Texture2DProxyBase containing the detailed textures to be tiled.
		 * @param blendingTexture 融合alphamask层，RGBA分别表示4个融合纹理各自的不透明度
		 * @param tileData 贴图在地形上的平铺数量；   [0] [1] 是背景纹理 UV 平铺.  [2] [3] 是融合层纹理 UV 平铺.
		 */
		public function TLTerrainDiffuseMethod(splatTextures:Array, blendingTexture:Texture2DBase, tileData:Array)
		{
			super();
			_splats = Vector.<Texture2DBase>(splatTextures);
			_tileData = tileData;
			_blendingTexture = blendingTexture;
			_numSplattingLayers = _splats.length;
			if (_numSplattingLayers > 4)
				throw new Error("More than 4 splatting layers is not supported!");
		}

		/**
		 * @inheritDoc
		 */
		override arcane function initConstants(vo:MethodVO):void
		{
			var data:Vector.<Number> = vo.fragmentData;
			var index:int = vo.fragmentConstantsIndex;
			// 修改了，现在 [1][2] 代表UV缩放
			data[index] = _tileData? _tileData[0] : 1;
			data[index+1] = _tileData? _tileData[1] : 1;
			data[index+2] = _tileData? _tileData[2] : 1;
			data[index+3] = _tileData? _tileData[3] : 1;
		}

		/**
		 * @inheritDoc
		 */
		arcane override function getFragmentPostLightingCode(vo:MethodVO, regCache:ShaderRegisterCache, targetReg:ShaderRegisterElement):String
		{
			var code:String = "";
			var albedo:ShaderRegisterElement;
			var scaleRegister:ShaderRegisterElement;

			// incorporate input from ambient
			if (vo.numLights > 0) {
				if (_shadowRegister)
					code += "mul " + _totalLightColorReg + ".xyz, " + _totalLightColorReg + ".xyz, " + _shadowRegister + ".w\n";
				code += "add " + targetReg + ".xyz, " + _totalLightColorReg + ".xyz, " + targetReg + ".xyz\n" +
					"sat " + targetReg + ".xyz, " + targetReg + ".xyz\n";
				regCache.removeFragmentTempUsage(_totalLightColorReg);
				
				albedo = regCache.getFreeFragmentVectorTemp();
				regCache.addFragmentTempUsages(albedo, 1);
			} else
				albedo = targetReg;
			
			if (!_useTexture)
				throw new Error("TerrainDiffuseMethod requires a diffuse texture!");
			_diffuseInputRegister = regCache.getFreeTextureReg();
			vo.texturesIndex = _diffuseInputRegister.index;
			var blendTexReg:ShaderRegisterElement = regCache.getFreeTextureReg();

			// UV缩放寄存器 (_tileData)
			scaleRegister = regCache.getFreeFragmentConstant();

			// 请求一个变化后的UV存储器 ft5
			var uv:ShaderRegisterElement = regCache.getFreeFragmentVectorTemp();
			regCache.addFragmentTempUsages(uv, 1);
			// 获得默认的UV寄存器   v0
			var uvReg:ShaderRegisterElement = _sharedRegisters.uvVarying;

			// 主贴图UV缩放  xy
			code += "mul " + uv + ", " + uvReg + ", " + scaleRegister + ".xy\n" +
				getSplatSampleCode(vo, albedo, _diffuseInputRegister, texture, uv);
			
			var blendValues:ShaderRegisterElement = regCache.getFreeFragmentVectorTemp();
			regCache.addFragmentTempUsages(blendValues, 1);
			code += getTex2DSampleCode(vo, blendValues, blendTexReg, _blendingTexture, uvReg, "clamp");
			var splatTexReg:ShaderRegisterElement;
			
			vo.fragmentConstantsIndex = scaleRegister.index*4;
			var comps:Vector.<String> = Vector.<String>([ ".x", ".y", ".z", ".w" ]);
			
			for (var i:int = 0; i < _numSplattingLayers; ++i) {
				// splat贴图UV缩放
				var scaleRegName:String = scaleRegister +".zw";
				splatTexReg = regCache.getFreeTextureReg();
				code += "mul " + uv + ", " + uvReg + ", " + scaleRegName + "\n" +  // mul ft5,v0,fc6.zw  // splat UV缩放
					getSplatSampleCode(vo, uv, splatTexReg, _splats[i], uv);

				code += "sub " + uv + ", " + uv + ", " + albedo + "\n" +
						"mul " + uv + ", " + uv + ", " + blendValues + comps[i] + "\n" +  //mul ft5, ft5, ft6.z
						"add " + albedo + ", " + albedo + ", " + uv + "\n";
			}

			regCache.removeFragmentTempUsage(uv);
			regCache.removeFragmentTempUsage(blendValues);
			
			if (vo.numLights > 0) {
				code += "mul " + targetReg + ".xyz, " + albedo + ".xyz, " + targetReg + ".xyz\n" +
					"mov " + targetReg + ".w, " + albedo + ".w\n";
				
				regCache.removeFragmentTempUsage(albedo);
			}

			return code;
		}

		/**
		 * @inheritDoc
		 */
		arcane override function activate(vo:MethodVO, stage3DProxy:Stage3DProxy):void
		{
			var context:Context3D = stage3DProxy._context3D;
			var i:int;
			var texIndex:int = vo.texturesIndex;
			super.activate(vo, stage3DProxy);
			context.setTextureAt(texIndex + 1, _blendingTexture.getTextureForStage3D(stage3DProxy));
			
			texIndex += 2;
			for (i = 0; i < _numSplattingLayers; ++i)
				context.setTextureAt(i + texIndex, _splats[i].getTextureForStage3D(stage3DProxy));
		}

		/**
		 * @inheritDoc
		 */
		override public function set alphaThreshold(value:Number):void
		{
			if (value > 0)
				throw new Error("Alpha threshold not supported for TerrainDiffuseMethod");
		}

		/**
		 * Gets the sample code for a single splat.
		 */
		protected function getSplatSampleCode(vo:MethodVO, targetReg:ShaderRegisterElement, inputReg:ShaderRegisterElement, texture:TextureProxyBase, uvReg:ShaderRegisterElement = null):String
		{
			uvReg ||= _sharedRegisters.uvVarying;
			return getTex2DSampleCode(vo, targetReg, inputReg, texture, uvReg, "wrap");
		}
	}
}
