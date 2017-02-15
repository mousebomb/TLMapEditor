package HLib.MapBase
{
	import Modules.MainFace.MouseCursorManage;
	import Modules.Map.HMap3D;
	import Modules.Map.HMapSources;
	import Modules.Wizard.WizardKey;
	import Modules.Wizard.WizardObject;
	
	public class MouseStatus
	{
		/*
		public var mouseType:String;
		public var targetType:int;
		public var camp:int;
		public var mainCamp:int;
		public var mainGroup:int;
		*/
		
		public var mainActorObj:WizardObject;
		
		public function MouseStatus()
		{
			
		}
		
		public function overOutActor(actorObj:WizardObject, isOver:Boolean):void
		{
			if (actorObj.Creature_MasterUID)
			{
				actorObj = actorObj.masterObject;//HMapSources.getInstance().getWizardObject(actorObj.Creature_MasterUID);
			}
			
			if (actorObj == null)
			{
				return;
			}
			
			var curMapId:uint = uint(HMap3D.getInstance().mapData.mapId);
			if (WizardKey.isPick(actorObj.type))
			{
				setCursorType(MouseCursorManage.PICKUP_TYPE);
			}
			else if (WizardKey.isCollect(actorObj.type))
			{
				setCursorType(MouseCursorManage.GATHER_TYPE);
			}
			else if (actorObj != HMapSources.getInstance().mainWizardObject && (curMapId == 41040 || (curMapId >= 29300  && curMapId < 29400) || curMapId == 29101 || curMapId == 41101))
			{
				if (isOver)
				{
					setCursorType(MouseCursorManage.ATTACK_1_TYPE);
				}
				else
				{
					setCursorType(MouseCursorManage.ATTACK_2_TYPE);
				}
			}
			else if (actorObj.Creature_TmpGroup)
			{
				if (actorObj.Creature_TmpGroup == mainActorObj.Creature_TmpGroup)
				{
					if (isOver)
					{
						setCursorType(MouseCursorManage.CLICK_1_TYPE);
					}
					else
					{
						setCursorType(MouseCursorManage.CLICK_2_TYPE);
					}
				}
				else
				{
					if (isOver)
					{
						setCursorType(MouseCursorManage.ATTACK_1_TYPE);
					}
					else
					{
						setCursorType(MouseCursorManage.ATTACK_2_TYPE);
					}
				}
			}
			else if (actorObj.Player_Camp)
			{
				if (actorObj.Player_Camp != mainActorObj.Player_Camp)
				{
					if (isOver)
					{
						setCursorType(MouseCursorManage.ATTACK_1_TYPE);
					}
					else
					{
						setCursorType(MouseCursorManage.ATTACK_2_TYPE);
					}
				}
				else
				{
					if (isOver)
					{
						setCursorType(MouseCursorManage.CLICK_1_TYPE);
					}
					else
					{
						setCursorType(MouseCursorManage.CLICK_2_TYPE);
					}
				}
			}
			else if(actorObj.type == WizardKey.TYPE_0 || actorObj.Creature_MasterUID)
			{
				if(HMapSources.getInstance().mapData.type == 2)
				{
					if (isOver)
					{
						setCursorType(MouseCursorManage.ATTACK_1_TYPE);
					}
					else
					{
						setCursorType(MouseCursorManage.ATTACK_2_TYPE);
					}
				}
				else
				{
					if(mainActorObj.Player_PKModle > 0 && mainActorObj.Player_Camp != actorObj.Player_Camp)
					{
						if (isOver)
						{
							setCursorType(MouseCursorManage.ATTACK_1_TYPE);
						}
						else
						{
							setCursorType(MouseCursorManage.ATTACK_2_TYPE);
						}
					}
					else
					{
						if (isOver)
						{
							setCursorType(MouseCursorManage.CLICK_1_TYPE);
						}
						else
						{
							setCursorType(MouseCursorManage.CLICK_2_TYPE);
						}
					}
				}
			}
			else if(actorObj.type == WizardKey.TYPE_1)
			{
				if (isOver)
				{
					setCursorType(MouseCursorManage.CLICK_1_TYPE);
				}
				else
				{
					setCursorType(MouseCursorManage.CLICK_2_TYPE);
				}
			}
			else if(WizardKey.isMayAtt(actorObj.type) || actorObj.type == WizardKey.TYPE_25)
			{
				if (isOver)
				{
					setCursorType(MouseCursorManage.ATTACK_1_TYPE);
				}
				else
				{
					setCursorType(MouseCursorManage.ATTACK_2_TYPE);
				}
			}
			else
			{
				reset();
			}
		}
		
		public function reset():void
		{
			setCursorType(MouseCursorManage.NORMAL_TYPE);
		}
		
		private function setCursorType(type:String):void
		{
			MouseCursorManage.getInstance().setType(type);
		}
		
		/*
		public function refreshMouseCursorBy3DLayer():void
		{
		var mouseCursor:int=2;
		if(targetType == WizardKey.TYPE_0)
		{
		if(HMapSources.getInstance().mapData.type == 2)
		{
		if(HMapSources.getInstance().mainWizardObject.Player_PKModle > 0 && mainCamp > 0 && mainCamp != camp)
		{
		if(mouseType==MouseEvent3D.MOUSE_OVER || mouseType==MouseEvent3D.MOUSE_UP)
		{
		mouseCursor=1;
		}
		else if(mouseType==MouseEvent3D.MOUSE_DOWN)
		{
		mouseCursor=10;
		}	
		}
		}
		}
		else if(targetType==WizardKey.TYPE_1)
		{
		if(mouseType==MouseEvent3D.MOUSE_OVER || mouseType==MouseEvent3D.MOUSE_UP)
		{
		mouseCursor=3;
		}
		else if(mouseType==MouseEvent3D.MOUSE_DOWN)
		{
		mouseCursor=9;
		}
		}
		else if(targetType==WizardKey.TYPE_4 ||
		targetType==WizardKey.TYPE_5 ||
		targetType==WizardKey.TYPE_16 ||
		targetType==WizardKey.TYPE_23 ||
		targetType==WizardKey.TYPE_25
		)
		{
		if(mouseType==MouseEvent3D.MOUSE_OVER || mouseType==MouseEvent3D.MOUSE_UP)
		{
		mouseCursor=1;
		}
		else if(mouseType==MouseEvent3D.MOUSE_DOWN){
		mouseCursor=10;
		}
		}
		else if(targetType==WizardKey.TYPE_11 ||
		targetType==WizardKey.TYPE_31 ||
		targetType==WizardKey.TYPE_99
		)
		{
		if(mouseType==MouseEvent3D.MOUSE_OVER || mouseType==MouseEvent3D.MOUSE_UP)
		{
		mouseCursor=4;
		}
		else if(mouseType==MouseEvent3D.MOUSE_DOWN)
		{
		mouseCursor=5;
		}
		}
		else if(targetType==WizardKey.TYPE_29 || targetType==WizardKey.TYPE_40 )
		{
		if(mouseType==MouseEvent3D.MOUSE_OVER || mouseType==MouseEvent3D.MOUSE_UP)
		{
		mouseCursor=6;
		}
		else if(mouseType==MouseEvent3D.MOUSE_DOWN)
		{
		mouseCursor=6;
		}
		}
		
		MouseCursorManage.getInstance().showCursor(mouseCursor);
		}*/
	}
}