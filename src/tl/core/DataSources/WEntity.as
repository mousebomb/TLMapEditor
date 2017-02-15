package tl.core.DataSources
{
	import tl.Net.Socket.Order;

	public class WEntity extends Entity
	{
	
    public var WEntity_SceneId               : uint      ;     // 28  2 WEntity_SceneId                世界实体的场景ID
    public var WEntity_PosX                  : uint      ;     // 29  3 WEntity_PosX                   世界实体位置X
    public var WEntity_PosY                  : uint      ;     // 30  4 WEntity_PosY                   世界实体位置Y

		
		public function WEntity()
		{
		}
		public function RefreshWEntity(_Order:Order,_AttrList:Array):void{
			this.RefreshEntity(_Order,_AttrList);
			
        WEntity_SceneId               = DataArray[ 1]; // 28  2 世界实体的场景ID
        WEntity_PosX                  = DataArray[ 2]; // 29  3 世界实体位置X
        WEntity_PosY                  = DataArray[ 3]; // 30  4 世界实体位置Y

		}
	}
}