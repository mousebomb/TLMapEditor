/**
 * Created by gaord on 2016/12/14.
 */
package org.mousebomb.framework
{
	import tool.StageFrame;

	public class MediatorBase
	{

		public function MediatorBase()
		{
		}

		/**加入舞台*/
		public function onAdd():void
		{
trace(StageFrame.renderIdx,"MediatorBase/onAdd" ,this);
		}

		/**移除舞台，结束生命周期*/
		public function onRemove():void
		{
trace(StageFrame.renderIdx,"MediatorBase/onRemove" , this);
		}
	}
}
