package tl.core.Wizard
{
	/**
	 * 精灵组合容器,把各个部件组合在此类中统一控制一个精灵
	 */

	import away3DExtend.MeshExtend;
	import away3DExtend.TextureMaterialExtend;

	import away3d.entities.Sprite3D;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.textures.BitmapTexture;
	import away3d.utils.Cast;

	import flash.display.BitmapData;
	import flash.geom.Vector3D;

	import tl.core.DataSources.Buff;
	import tl.core.DataSources.Item;
	import tl.core.old.WizardAction;
	import tl.core.old.WizardObject;
	import tl.mapeditor.ResourcePool;
	import tl.utils.HashMap;

	public class WizardActor3D extends MySprite3D
	{
		private var _clickMesh:MeshExtend;
		public function get clickMesh():MeshExtend  {  return _clickMesh;  }
		private static var cloenMaterial:TextureMaterialExtend;
		private static var cloenMesh:MeshExtend;
		
		private var _Entity_UID:Number = -1;				//精灵UID,与wizardObject一样
		/** 精灵UID,与wizardObject一样 **/
		public function get Entity_UID():Number { return _Entity_UID; }
		
		public var isUpdateY:Boolean = false;
		
		private var _IsInIt:Boolean=false;
		private var _WizardObject:WizardObject;
		private var _Stiff:Boolean=false;
		private var _ActionBoomTime:Number=0;
		private var _Shadow:Sprite3D;											//人物圆型阴影
		private var _IsShowShadow:Boolean = true;	       						//是否显示人物圆型阴影	
		private var _Transparent:Boolean=false;
		private var _Alpha:Number=1;
		
		private var _isSelect:Boolean = false;								//是否选中精灵
		private var _isLoaderMeshComplete:Boolean = false;					//是否加载完了body主模型
		
		private var _unitVec:Vector.<WizardUnit> = new Vector.<WizardUnit>();	//部件保存数组
		private var _bodyUnit:WizardUnit;										//主体部件
		private var _leftArmsUnit:WizardUnit;									//左手武器部件
		private var _rightArmsUnit:WizardUnit;									//右手武器部件
		private var _mountUnit:WizardUnit;										//坐骑部件
		private var _wingUnit:WizardUnit;										//翅膀部件
		private var _wizardNameBar:WizardNameBar;								//名字栏
		
		private var _effectVec:Vector.<WizardEffect> = new Vector.<WizardEffect>();	//自身特效保存数组
		
		//选中光圈
		private static var heroSelect:WizardEffect;		//主角光圈
		private static var otherSelect:WizardEffect;		//NPC/其他玩家选中管权
		private static var monsterSelect:WizardEffect;	//怪物光圈
		
//		private var _clickMesh:MeshExtend;	//点击区域块
//		private static var _initMaterial:TextureMaterial = new TextureMaterial(Cast.bitmapTexture(new BitmapData(1, 1, true, 0)));
		
		private var _lineMethod:Boolean = false;			//是否显示颜色边框
		
		public function WizardActor3D()  
		{  
			super();  
			
			cloenMaterial ||= new TextureMaterialExtend(Cast.bitmapTexture(new BitmapData(32,32,true,0x66000000)));
			cloenMesh ||= new MeshExtend(new PlaneGeometry(), cloenMaterial);
			
			cloenMaterial.alphaBlending = true;
			_clickMesh = MeshExtend(cloenMesh.clone());
			_clickMesh.y = 5;
			this.addChild(_clickMesh);
		}
		
		/**初始化*/
		public function actor3DInIt(value:WizardObject):void
		{
			_WizardObject = value;
			_Entity_UID = _WizardObject.Entity_UID;	//设置UID,用于判断用
			refreshShadow();						//刷新显示黑影
			_bodyUnit=new WizardUnit();
			_bodyUnit.owner = this;
			initEvent();
			_bodyUnit.wizardUnitInIt(String(this.wizardObject.resId));
			_unitVec.push(_bodyUnit);
			this.addChild(_bodyUnit);
			//添加点击区域
//			_initMaterial.alphaBlending = true;
//			if(!_clickMesh)
//			{
//				_clickMesh = new MeshExtend(new PlaneGeometry(80, 80), _initMaterial);
//				var min:Vector3D = _clickMesh.bounds.min;
//				var max:Vector3D = _clickMesh.bounds.max;
//				_clickMesh.bounds.fromExtremes(min.x, 0, min.z, max.x, 100, max.z);	//改变包围盒大小
//			}
//			this.addChild(_clickMesh);
			//更新线样式
			updateLineStype();
			//添加名字条
			refreshNameBar();
		}
		/**初始化-事件侦听*/
		private function initEvent():void{
			if(!_bodyUnit) return;
			_bodyUnit.addEventListener("WizardLoadComplete",onWizardLoadComplete);				//模型加载完成
			_bodyUnit.addEventListener("ActionOccurComplete",onActionOccurComplete);
			_bodyUnit.addEventListener(WizardKey.Action_ActionPlayOver,onActionPlayOver);			//非循环动作播放完毕以后
			_WizardObject.addEventListener(WizardKey.FirAction_PlayAction,onPlayAction);			//播放指定动作
			_WizardObject.addEventListener(WizardKey.Action_BindingUnit,onBindingUnit);				//绑定部件事件
			_WizardObject.addEventListener(WizardKey.Action_RemoveBindingUnit,onRemoveWizardUnit);	//移除部件事件
			_WizardObject.addEventListener(WizardKey.FirAction_PlayEffect,onPlayEffect);			//播放自身特效
			_WizardObject.addEventListener(WizardKey.Refresh_WizardObject, onRefreshWizardObject);	//精灵数据刷新
			
			_WizardObject.addBufCallBack = onAddBufCallBack;			//添加BUFF回调
			_WizardObject.removeBuffCallBack = onRemoveBuffCallBack;	//移除BUFF回调
			
			onRefreshWizardObject();	//初始化刷新一下数据
		}
		/** 添加BUFF回调 **/
		private function onAddBufCallBack($buff:Buff):void
		{
			var action:WizardAction = new WizardAction();
			action.refresh( String($buff.effectAdd) );
			if(!action.effect_Args) return;
			//添加BUFF特效
			var effect:WizardEffect = new WizardEffect();
			effect.effectName = "Buff_" + $buff.id;
			effect.isDisPatch = true;
			effect.addEventListener(WizardKey.Action_EffectOver, onBuffEffectOver);
//			effect.effectInIt(action.effect_ResName1, action.effect_FileName1);
			effect.effectInIt(action.effect_Args[1], action.effect_Args[0]);
			this.addChild(effect);
			//添加增加特效
			_addEffHashMap.put($buff.id, $buff);
		}
		
		private var _buffEffectVec:Vector.<WizardEffect> = new Vector.<WizardEffect>();	//持续特效保存数组
		private var _addEffHashMap:HashMap = new HashMap();								//需要添加持续特效保存字典
		
		/** 添加BUFF特效播放到指定时间 **/
		private function onBuffEffectOver(e:MyEvent):void
		{
			var effect:WizardEffect = WizardEffect(e.currentTarget);
			//移除添加特效
			this.removeChild(effect);
			effect.stop();
			effect.clear();
			var buff:Buff = _addEffHashMap.get( effect.effectName.replace("Buff_", "") ); 	//获得持续特效数据
			effect = null;
			//添加持续特效
			if(buff)
			{
				var action:WizardAction = new WizardAction();
				action.refresh( String(buff.effectHold) );
				if(!action.effect_Args) return;
				
				effect = new WizardEffect();
				effect.effectName = "Buff_" + buff.id;
//				effect.effectInIt(action.effect_ResName1, action.effect_FileName1);
				effect.effectInIt(action.effect_Args[1], action.effect_Args[0]);
				this.addChild(effect);
				_buffEffectVec.push(effect);
			}
		}
		
		/** 移除BUFF回调 **/
		private function onRemoveBuffCallBack($buffId:String):void
		{
			//获得添加持续特效的BUFF key
			var removeString:String;
			var len:int = _addEffHashMap.keys.length;
			for(var i:int = 0; i < len; i++)
			{
				if(_addEffHashMap.keys[i] == $buffId)
				{
					removeString = _addEffHashMap.keys[i];
					break;
				}
			}
			
			//移除BUFF特效
			len = _buffEffectVec.length;
			for(i = 0; i < len; i++)
			{
				if(_buffEffectVec[i].effectName.replace("Buff_", "") == $buffId)
				{
					this.removeChild(_buffEffectVec[i]);
					_buffEffectVec[i].stop();
					_buffEffectVec[i].clear();
					_buffEffectVec[i] = null;
					
					_buffEffectVec.splice(i, 1);
					//添加移除特效
					var buff:Buff = _addEffHashMap.get(removeString);
					var action:WizardAction = new WizardAction();
					action.refresh( String(buff.effectRemove) );
					if(!action.effect_Args) return;
					
					var effect:WizardEffect = new WizardEffect();
					effect.effectName = "Buff_" + buff.id;
					effect.isDisPatch = true;
					effect.addEventListener(WizardKey.Action_EffectOver, onEndBuffEffectOver);
//					effect.effectInIt(action.effect_ResName1, action.effect_FileName1);
					effect.effectInIt(action.effect_Args[1], action.effect_Args[0]);
					this.addChild(effect);
					break;
				}
			}
			//移除添加特效数组
			_addEffHashMap.remove(removeString);
		}
		/**
		 * 结束BUFF播放完成执行
		 */		
		private function onEndBuffEffectOver(e:MyEvent):void
		{
			var effect:WizardEffect = WizardEffect(e.currentTarget);
			//移除添加特效
			this.removeChild(effect);
			effect.stop();
			effect.clear();
			effect = null;
		}
		
		/** 更新名字条 **/
		private function refreshNameBar():void
		{
			if(!_wizardNameBar)
			{
				_wizardNameBar = new WizardNameBar();
				_wizardNameBar.init();
				_wizardNameBar.rotationX = -14;
			}
			this.addChild(_wizardNameBar);
			_wizardNameBar.y = 150;
			//更具数据刷新显示
			_wizardNameBar.wizardObject = _WizardObject;
			//刷新一下名字条显示
			isShowNameBar = isShowNameBar;
		}
		
		
		override public function set rotationY(val:Number):void
		{
			super.rotationY = val;
			if(_wizardNameBar)
				_wizardNameBar.rotationY = TLMapEditor.view3D.camera.rotationY - val;
		}
		
		/** 精灵数据刷新 **/
		private function onRefreshWizardObject(e:MyEvent = null):void
		{
			//刷新名字条
			if(_wizardNameBar)
				_wizardNameBar.wizardObject = _WizardObject;
			//判断武器是否改变,改变了才做替换武器操作
			if(_weaponLeft != _WizardObject.Player_WeaponLeft || _weaponRight != _WizardObject.Player_WeaponRight)
			{
				//刷新左手武器
				_weaponLeft = _WizardObject.Player_WeaponLeft;
				_weaponRight = _WizardObject.Player_WeaponRight;
				//刷新武器
				var item:Item = new Item();
				item.RefreshItemById( String(_weaponLeft) );
				
				var left:uint;
				if(!item.Item_PrivateData)	left = 0;
				else						left = ( _weaponLeft == 0 ? 0 : item.Item_PrivateData[0] );
				
				item.RefreshItemById( String(_weaponRight) );
				var right:uint;
				if(!item.Item_PrivateData)	right = 0;
				else						right = ( _weaponRight == 0 ? 0 : item.Item_PrivateData[0] );
				
				_WizardObject.setMyEquip(left, right, _weaponLeft, _weaponRight);
				item = null;
			}
		}
		private var _weaponLeft:uint = 0;	//当前左手武器ID
		private var _weaponRight:uint = 0;	//当前右手武器ID
		
		/** 是否显示名字条 **/
		public function set isShowNameBar(value:Boolean):void
		{
			_isShowNameBar = value;
			if(_wizardNameBar)
				_wizardNameBar.visible = value;
		}
		public function get isShowNameBar():Boolean { return _isShowNameBar; }
		private var _isShowNameBar:Boolean = true;
		
		/**主部件资源加载完成*/
		private function onWizardLoadComplete(e:MyEvent):void
		{
			_IsInIt=true;
			refreshNameBar();
			if(this.wizardObject == null) return;		//空对象保护
			this.wizardObject.actionPlayOver("0");
			_isLoaderMeshComplete = true;
			
//			if(!_clickMesh)
//			{
//				_clickMesh = new MeshExtend(new PlaneGeometry(80, 80), _initMaterial);
//				var min:Vector3D = _clickMesh.bounds.min;
//				var max:Vector3D = _clickMesh.bounds.max;
//				_clickMesh.bounds.fromExtremes(min.x, 0, min.z, max.x, 100, max.z);	//改变包围盒大小
//			}
//			this.addChild(_clickMesh);
		}
		/** 坐骑精灵加载完成 **/
		private function onMountWizardLoadComplete(e:MyEvent):void
		{
			//设置名字条位置
			if(this.wizardObject.isRide)
			{
				//设置名字条位置
				if(_mountUnit.skeleton)
				{
					var vec3D:Vector3D = _mountUnit.skeleton.jointVector3DFromName("ride");//获取骨骼点位置
					if(_wizardNameBar)
						_wizardNameBar.y = vec3D.y + _bodyUnit.maxY/2 + 20;
				}
			}
			else
			{
				if(_wizardNameBar)
					_wizardNameBar.y = (_bodyUnit.maxY==0 ? 150 : _bodyUnit.maxY + 20);
			}
		}
		
		/**播到动作爆点*/
		private function onActionOccurComplete(e:MyEvent):void
		{
			this.wizardObject.useSkillStage2();
		}
		/**绑定指定的部件*/
		public function onBindingUnit(e:MyEvent):void
		{
			//格式[部件标识，部件actionId,绑定到主部件的骨骼名]
			var _Args:Array = e.data as Array;
			var _WizardUnit:WizardUnit;
			var index:int;
			switch(_Args[0])
			{
				case WizardKey.WizardUnit_LeftArms:	//左手武器
					if(_leftArmsUnit && _leftArmsUnit.wizardAction.actionID == int(_Args[1]))
					{
						_bodyUnit.bindWizardUnitToSkeleton(_Args[2], _leftArmsUnit);
					}
					else
					{
						if(_leftArmsUnit) 
						{
							index = _unitVec.indexOf(_leftArmsUnit);
							_unitVec.splice(index,1);
							_leftArmsUnit.removeWizardUnitFromSkeleton(_Args[2]);
							_leftArmsUnit.clearWizardUnit();
							_leftArmsUnit = null;
						}
						_leftArmsUnit = new WizardUnit();
						_leftArmsUnit.owner = this;
						_leftArmsUnit.wizardUnitInIt(_Args[1]);
						_bodyUnit.bindWizardUnitToSkeleton(_Args[2], _leftArmsUnit);
					}
					_WizardUnit = _leftArmsUnit;
					break;
				case WizardKey.WizardUnit_RightArms:	//右手武器
					if(_rightArmsUnit && _rightArmsUnit.wizardAction.actionID == int(_Args[1]))
					{
						_bodyUnit.bindWizardUnitToSkeleton(_Args[2], _rightArmsUnit);
					}
					else
					{
						if(_rightArmsUnit) 
						{
							index = _unitVec.indexOf(_rightArmsUnit);
							_unitVec.splice(index,1);
							_rightArmsUnit.removeWizardUnitFromSkeleton(_Args[2]);
							_rightArmsUnit.clearWizardUnit();
							_rightArmsUnit = null;
						}
						_rightArmsUnit = new WizardUnit();
						_rightArmsUnit.owner = this;
						_rightArmsUnit.wizardUnitInIt(_Args[1]);
						_bodyUnit.bindWizardUnitToSkeleton(_Args[2], _rightArmsUnit);
					}
					_WizardUnit = _rightArmsUnit;
					break;
				case WizardKey.WizardUnit_Wing:			//翅膀
					if(_wingUnit && _wingUnit.wizardAction.actionID == int(_Args[1]))
					{
						_bodyUnit.bindWizardUnitToSkeleton(_Args[2], _wingUnit);
						if(_wingUnit.skeletonAnimator)
							_wingUnit.skeletonAnimator.start();
					}
					else
					{
						if(_wingUnit) 
						{
							index = _unitVec.indexOf(_wingUnit);
							_unitVec.splice(index,1);
							_wingUnit.removeWizardUnitFromSkeleton(_Args[2]);
							_wingUnit.clearWizardUnit();
							_wingUnit = null;
						}
						_wingUnit = new WizardUnit();
						_wingUnit.owner = this;
						_wingUnit.wizardUnitInIt(_Args[1]);
						_bodyUnit.bindWizardUnitToSkeleton(_Args[2], _wingUnit);
					}
					_WizardUnit = _wingUnit;
					break;
				case WizardKey.WizardUnit_Mount:		//坐骑
					if(_mountUnit && _mountUnit.wizardAction.actionID == int(_Args[1]))	//如果已经有坐骑了直接绑定上坐骑
					{
						_mountUnit.bindWizardUnitToSkeleton(_Args[2], _bodyUnit);
						if(_mountUnit.skeletonAnimator)
							_mountUnit.skeletonAnimator.start();
					}
					else
					{
						if(_mountUnit) 
						{
							index = _unitVec.indexOf(_mountUnit);
							_unitVec.splice(index,1);
							_mountUnit.removeWizardUnitFromSkeleton(_Args[2]);
							_mountUnit.removeEventListener("WizardLoadComplete", onMountWizardLoadComplete);
							_mountUnit.clearWizardUnit();
							_mountUnit = null;
						}
						_mountUnit = new WizardUnit();
						_mountUnit.owner = this;
						_mountUnit.addEventListener("WizardLoadComplete", onMountWizardLoadComplete);
						_mountUnit.wizardUnitInIt(_Args[1]);
						_mountUnit.bindWizardUnitToSkeleton(_Args[2], _bodyUnit);
					}
					_WizardUnit = _mountUnit;
					this.addChild(_mountUnit);
					break;
			}
			if(_WizardUnit)
				_unitVec.push(_WizardUnit);
		}
		
		/** 移除绑定部件 **/
		public function onRemoveWizardUnit(e:MyEvent):void
		{
			var _Args:Array=e.data as Array;
			var _Index:int=-1;
			switch(_Args[0])
			{
				case WizardKey.WizardUnit_LeftArms:		//左手武器
					if(!_leftArmsUnit) return;
					_bodyUnit.removeWizardUnitFromSkeleton(_Args[2])
					_Index = _unitVec.indexOf(_leftArmsUnit);
					_unitVec.splice(_Index, 1);
					_leftArmsUnit.parent.removeChild(_leftArmsUnit);
					break;
				case WizardKey.WizardUnit_RightArms:	//右手武器
					if(!_rightArmsUnit) return;
					_bodyUnit.removeWizardUnitFromSkeleton(_Args[2])
					_Index = _unitVec.indexOf(_rightArmsUnit);
					_unitVec.splice(_Index, 1);
					_rightArmsUnit.parent.removeChild(_rightArmsUnit);
					break;
				case WizardKey.WizardUnit_Wing:			//翅膀
					if(!_wingUnit) return;
					_bodyUnit.removeWizardUnitFromSkeleton(_Args[2])
					_Index = _unitVec.indexOf(_wingUnit);
					_unitVec.splice(_Index, 1);
					_wingUnit.parent.removeChild(_wingUnit);
					if(_wingUnit.skeletonAnimator)
						_wingUnit.skeletonAnimator.stop();
					break;
				case WizardKey.WizardUnit_Mount:		//坐骑
					if(!_mountUnit) return;
					_mountUnit.removeWizardUnitFromSkeleton(_Args[2]);
					_Index=_unitVec.indexOf(_mountUnit);
					_unitVec.splice(_Index,1);
					this.removeChild(_mountUnit);
					this.addChild(_bodyUnit);
					if(_mountUnit.skeletonAnimator)
						_mountUnit.skeletonAnimator.stop();
					break;
			}
		}
		/**非循环动作播放完毕以后*/
		public function onActionPlayOver(e:MyEvent):void
		{
			this.myWizardObject.actionPlayOver(String(e.data));
		}
		/**播放指定动作*/
		public function onPlayAction(e:MyEvent):void
		{
			var _Args:Array=e.data as Array;
			if(_Args[0] == ActionName.stand || _Args[0] == ActionName.run)
			{
				//设置坐骑
				if(_mountUnit && this.wizardObject.isRide)
				{
					_bodyUnit.playAction("ride"+_Args[0],_Args[1]);
					_mountUnit.playAction(_Args[0],_Args[1]);
					//设置名字条位置
					if(_mountUnit.skeleton)
					{
						var vec3D:Vector3D = _mountUnit.skeleton.jointVector3DFromName("ride");//获取骨骼点位置
						
						if(_wizardNameBar)
							_wizardNameBar.y = vec3D.y + _bodyUnit.maxY/2 + 20;
					}
				}
				else
				{
					_bodyUnit.playAction(_Args[0],_Args[1]);
					if(_wizardNameBar)
						_wizardNameBar.y = (_bodyUnit.maxY==0 ? 150 : _bodyUnit.maxY + 20);
				}
				//设置翅膀
				if(_wingUnit)
					_wingUnit.playAction(_Args[0],_Args[1]);
			}
			else
				_bodyUnit.playAction(_Args[0],_Args[1]);
			
		}
		/** 刷新黑影显示 **/
		private function refreshShadow():void
		{		
			var _TypeArgs:Array = [0,1,3,4];
			var _Index:int = _TypeArgs.indexOf(_WizardObject.type);
			if(_Index<0) return;
			var bitmapdata:BitmapData = ResourcePool.getInstance().getBtmdBySwf("MainUI", "yinying256");
			var textureMaterial:TextureMaterial = new TextureMaterial(new BitmapTexture(bitmapdata));
			textureMaterial.alphaBlending = true;
			var _Shadow:Sprite3D = new Sprite3D(textureMaterial, BitmapTexture(textureMaterial.texture).bitmapData.width, BitmapTexture(textureMaterial.texture).bitmapData.height);//bitmapdata.width, bitmapdata.height);
			this.addChild(_Shadow);
		}
		
		/**播放指定的特效*/
		public function onPlayEffect(e:MyEvent):void{
			var _EffectArgs:Array=e.data as Array;
			var _WizardEffect:WizardEffect=new WizardEffect();
			_WizardEffect.isDisPatch=true;
			_WizardEffect.addEventListener(WizardKey.Action_EffectOver,onEffectOver);
			_WizardEffect.effectInIt(_EffectArgs[0],_EffectArgs[1]);
			this.addChild(_WizardEffect);
			_effectVec.push(_WizardEffect);
			//_WizardEffect.rotationY=this.wizardObject.angle;
		}
		/**特效播放完毕后清除*/
		public function onEffectOver(e:MyEvent):void{
			var _WizardEffect:WizardEffect=e.target as WizardEffect;
			_WizardEffect.removeEventListener(WizardKey.Action_EffectOver,onEffectOver);
			//删除自身特效
			_effectVec.splice(_effectVec.indexOf(_WizardEffect), 1);
			
			this.removeChild(_WizardEffect);
			_WizardEffect.stop();
			_WizardEffect.clear();
			_WizardEffect=null;
		}
		/**刷新方向及位置信息*/
		public function refreshPosition():void{
			this.rotationY = _WizardObject.rotationY;
//			this.position=NodeUnit.twoToThree(new Point(_WizardObject.x,_WizardObject.y));
			//刷新Y坐标
//			if(isUpdateY)
//			{
//				var v3D:Vector3D = _bodyUnit.sceneTransform.transformVector(_bodyUnit.position);
//				var vec3D:Vector3D = MapMeshManage.getInstance().getVector3DFormPosition(v3D);//this.position);
//				this.y = vec3D.y;
				
//				this.y = MapMeshManage.getInstance().getPointHFomrPosition(new Point(v3D.x, -v3D.z));
//			}
		}
		/**精灵动态效果总刷新*/
		public function refreshActor3D():void{
			this.refreshPosition();
			this.refreshBindWizardUnit();
		}
		public function refreshBindWizardUnit():void{
			//_BodyUnit.refreshBindWizardUnit();
			for(var i:int=0;i<_unitVec.length;i++){
				_unitVec[i].refreshBindWizardUnit();
				_unitVec[i].refreshEffect();
			}
		}
		/**贴图是否混合*/
		public function get transparent():Boolean
		{
			return _Transparent;
		}
		/**贴图是否混合*/
		public function set transparent(value:Boolean):void
		{
			_Transparent = value;
			for(var i:int=0;i<_unitVec.length;i++)
			{
				_unitVec[i].transparent = _Transparent;
			}
		}
		/**
		 * 是否显示颜色边框
		 * @param value	: true: 显示 false: 不显示
		 */		
		public function set lineMethod(value:Boolean):void
		{
			_lineMethod = value;
			_bodyUnit.isShowlineMethod = _lineMethod;
		}
		public function get lineMethod():Boolean { return _lineMethod; }
		/** 更新显示线颜色 **/
		private function updateLineStype():void
		{
			switch(_WizardObject.type)
			{
				case 0:	//玩家
					_bodyUnit.setLineStyle(0xFF0000);
					_selectType = 2;
					_bodyUnit.setLineStyle(0x00CCFF);
					_selectType = 0;
					break;
				case 1:	//NPC
					_bodyUnit.setLineStyle(0x00FFFF);
					_selectType = 1;
					break;
				case 4:	//怪物
					_bodyUnit.setLineStyle(0xFF0000);
					_selectType = 2;
					break;
			}
		}
		private var _selectType:int = 0;	//设置选中类型(0:玩家 1:NPC 2:敌对者)
		/**
		 * 是否为选中(选中状态为脚下有光圈,人物包围着对应颜色的边, 如只需要线请使用lineMethod属性)
		 * @param value	: true:选中状态 false:非选中状态
		 */		
		public function set isSelect(value:Boolean):void
		{
			_isSelect = value;
			lineMethod = false;//_isSelect;	//显示/隐藏线
			//添加/移除光圈
			var wizardEffect:WizardEffect;
			switch(_selectType)
			{
				case 0:	//玩家
					if(!heroSelect)
					{
						heroSelect = new WizardEffect();
						heroSelect.effectInIt("ef_cj_select01", "effectall");	
					}
					wizardEffect = heroSelect;
					break;
				case 1:	//NPC
					if(!otherSelect)
					{
						otherSelect = new WizardEffect();
						otherSelect.effectInIt("ef_cj_select03", "effectall");	
					}
					wizardEffect = otherSelect;
					break;
				case 2:	//敌对者
					if(!monsterSelect)
					{
						monsterSelect = new WizardEffect();
						monsterSelect.effectInIt("ef_cj_select04", "effectall");	
					}
					wizardEffect = monsterSelect;
					break;
			}
			if(_isSelect)
			{
				this.addChild(wizardEffect);
				wizardEffect.play();
			}
			else
			{
				this.removeChild(wizardEffect);
				wizardEffect.stop();
			}
		}
		public function get isSelect():Boolean { return _isSelect; }
		
		/**
		 * 鼠标移入执行处理,为了统一处理怪物鼠标移入处理,如需要特殊处理额外的鼠标移入处理,请外部实现
		 * 此方法只是在HMap3D中精灵移入执行方法
		 */		
		public function mouseOver():void
		{
			this.lineMethod = true;
			//设置鼠标移入对应处理
		}
		/**
		 * 鼠标移出执行处理,为了统一处理怪物鼠标移入处理,如需要特殊处理额外的鼠标移入处理,请外部实现
		 * 此方法只是在HMap3D中精灵移入执行方法
		 */		
		public function mouseOut():void
		{
			this.lineMethod = false;
			//设置鼠标移出对应处理
		}
		
		/**贴图的透明度*/
		public function set alpha(value:Number):void
		{
			_Alpha = value;
			for(var i:int=0;i<_unitVec.length;i++){
				_unitVec[i].alpha=_Alpha;
			}
		}
		public function get alpha():Number  {  return _Alpha;  }
		/** 清除精灵部件 **/
		public function clearWizardActor3D():void
		{
			for(var i:int=0;i<_unitVec.length;i++)
			{
				_unitVec[i].clearWizardUnit();
			}
			_unitVec.length=0;
			if(_WizardObject)
				_WizardObject.dispose();
			_WizardObject = null;
			if(_wizardNameBar)
				_wizardNameBar.disposeWithChildren();
			_wizardNameBar = null;
			
			//删除自身特效
			var effect:WizardEffect;
			while(_effectVec.length)
			{
				effect = _effectVec[0];
				this.removeChild(effect);
				effect.clear();
				effect = null;
				_effectVec.splice(0, 1);
			}
			
//			_clickMesh.geometry.dispose();
//			_clickMesh.disposeAsset();
//			_clickMesh = null;
			
			_IsInIt=false;
		}
		

		public function set wizardObject(value:WizardObject):void
		{
			_WizardObject = value;
		}
		public function get wizardObject():WizardObject  {  return _WizardObject;  }
		public function get myWizardObject():WizardObject  {  return _WizardObject;  }

		public function set actionBoomTime(value:Number):void
		{
			_ActionBoomTime = value;
		}
		public function get actionBoomTime():Number  {  return _ActionBoomTime;  }
		/**精灵是否僵直*/
		public function set stiff(value:Boolean):void
		{
			_Stiff = value;
			if(!_isLoaderMeshComplete) return;
			if(this.bodyUnit.skeletonAnimator.activeAnimationName == null) return;
			if(_Stiff)
			{
				if(this.visible)
					this.visible = false;
				this.bodyUnit.skeletonAnimator.stop();
			}
			else
			{
				if(!this.visible)
					this.visible = true;
				this.bodyUnit.skeletonAnimator.start();
			}
		}
		public function get stiff():Boolean  {  return _Stiff;  }
		/**
		 * 设置描点显示与否
		 * @param value	: true:显示 false:不显示
		 */		
		public function set isShowShadow(value:Boolean):void
		{
			if(_IsShowShadow == value) return;
			_IsShowShadow = value;
			if(_Shadow)
				_Shadow.visible = _IsShowShadow;
		}
		public function get isShowShadow():Boolean { return _IsShowShadow; }
		/** 是否初始化 **/
		public function get isInIt():Boolean  {  return _IsInIt;  }
		/** 主体部件 **/
		public function get bodyUnit():WizardUnit  {  return _bodyUnit;  }
		/** 武器部件 **/
		public function get leftArmsUnit():WizardUnit  {  return _leftArmsUnit;  }
		/** 坐骑部件 **/
		public function get mountUnit():WizardUnit  {  return _mountUnit;  }
		/** 翅膀部件 **/
		public function get wingUnit():WizardUnit  {  return _wingUnit;  }
		/** 名字条 **/
		public function get wizardNameBar():WizardNameBar  {  return _wizardNameBar;  }

//		/**
//		 * 点击mesh
//		 * @return 
//		 */
//		public function get clickMesh():MeshExtend
//		{
//			return _clickMesh;
//		}
//		/** 添加武器拖尾光效 **/
//		public function addWeaponTaril():void
//		{
//			if(!_ArmsUnit) return;
//			var texture:BitmapTexture = Cast.bitmapTexture(ResourcePool.getInstance().getBitmapData("MainUI", "MainUI_WeaponTaril"))
//			_weaponTaril = new WeaponTaril();
//			_weaponTaril.init( _ArmsUnit, _ArmsUnit.skeleton, _ArmsUnit.skeleton, "magic2", "magic1", texture );
//			_weaponTaril.startTaril();
////			_ArmsUnit.initTaril(_ArmsUnit.skeleton, "magic2", "magic1", Cast.bitmapTexture(new BitmapData(128, 128, true, 0xAAFFFF00)));
////			_ArmsUnit.startTaril();
//		}
//		private var _weaponTaril:WeaponTaril;
//		/** 刷新拖尾 **/
//		public function refreshTaril():void
//		{
////			if(!_ArmsUnit) return;
//			if(!_weaponTaril) return;
//			_weaponTaril.onEnterFrame();
////			trace("<><><><><><><><><><><><><><><>", _ArmsUnit.position, _ArmsUnit.rotationX, _ArmsUnit.rotationY, _ArmsUnit.rotationZ);
////			_ArmsUnit.onEnterFrame();
//		}
		
	}
}