package tl.frameworks.service.bombloader
{

    /**
     * @author rhett
     */
    public class LoadQueueItemVO
    {
        public var url:String;

        public var type:int;

        public var priority:int;

        public var progressCb:Function;

        public var order:int;

        public var mark:*;

        private static var reqOrder:uint = 0;

        public function LoadQueueItemVO(url:String, type:int, priority:int, progCb:Function, mark:*)
        {
            this.url = url;
            this.type = type;
            this.priority = priority;
            this.progressCb = progCb;
            this.order = reqOrder++;
            this.mark = mark;
        }


        public function toString():String
        {
            return "bombloader.LoadQueueItemVO 优先级" + priority + ",URL=" + url;
        }
    }
}
