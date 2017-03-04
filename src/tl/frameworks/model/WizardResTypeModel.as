/**
 * Created by gaord on 2017/3/4.
 */
package tl.frameworks.model
{
	import flash.utils.Dictionary;

	import org.robotlegs.mvcs.Actor;

	import tl.core.role.model.CsvResTypeVO;
	import tl.core.role.model.CsvRoleVO;

	public class WizardResTypeModel extends Actor
	{
		public function WizardResTypeModel()
		{
			super();
		}

		/** 模型 分分类的列表   [restype] = Array [CsvRoleVO ]  */
		public var modelByResType:Dictionary;

		public var resTypeCount:uint = 0;

		/** UI菜单用 */
		public var resTypeAsArray:Vector.<String>;

		/** 根据类型字符串 找类型id */
		public var resTypeByName:Dictionary;


		public function parseResTypes(csvModel:CsvDataModel):void
		{
			if (modelByResType == null)
			{
				resTypeCount   = csvModel.table_restype.size;
				modelByResType = new Dictionary();
				var keys:Array = csvModel.table_wizard.keys;
				var csvRoleVO:CsvRoleVO;
				for (var j:int = 0; j < keys.length; j++)
				{
					csvRoleVO = csvModel.table_wizard.get(keys[j]);
					if (modelByResType[csvRoleVO.ResType] == null)
						modelByResType[csvRoleVO.ResType] = [];
					var targetArr:Array = modelByResType[csvRoleVO.ResType];
					targetArr.push(csvRoleVO);
				}
				//
				keys = csvModel.table_restype.keys;
				resTypeByName=new Dictionary();
				resTypeAsArray= new <String>[];
				for (var i:int = 0; i < keys.length; i++)
				{
					var resTypeVO:CsvResTypeVO    = (csvModel.table_restype.get(keys[i]) as CsvResTypeVO);
					resTypeByName[resTypeVO.Name] = resTypeVO.Id;
					resTypeAsArray.push(resTypeVO.Name);
				}
			}
		}
	}
}
