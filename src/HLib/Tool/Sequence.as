package HLib.Tool
{
	import flash.display.Sprite;
	public class Sequence extends Sprite
	{
		private var n:Number = 100;
		private var A:Array = new Array(n);
		public function Sequence()
		{    
			for (var i:int=0; i < n; i++) {   
				A[i] = i; //给数组赋值
			}
			for (var j:int=0; j < n; j++) {   
				var ran:int = int(Math.random()*n);
				var temp:int = A[j];
				A[j] = A[ran];
				A[ran] = temp;
				trace(A[j]);//随机生成一个数组
			}    
			selectionSort();//顺序排序算法
			//insertionSort();//直接插入排序 
			//bubbleSort();//冒泡排序 
			//shellSort();//希尔算法 
			//mergeSort();//归并排序
			//quickSort();//快速排序
		}   
		
		//顺序排序算法
		private function sortshuxu():void{
			
			var arr:Array = new Array(20,96,1,21,36,26);
			var temp:int;
			for(var i:int=0;i<arr.length-1;i++){
				temp = arr[i];
				for(var j:int=i+1;j<arr.length;j++){     
					if(arr[i]>arr[j]){      
						temp = arr[i];
						arr[i] = arr[j];
						arr[j] = temp;
					}
				}    
			}
			
			for(var k:int=0;k<arr.length;k++){    
				trace(arr[k]);
			}
		}
		
		//直接选择排序
		private function selectionSort():void{
			
			for (var k:int= 0; k< n; k++) {
				var temp1:int = A[k];
				for (var j:int = k; j > 0 && temp1 < A[j - 1]; j--) {
					A[j] = A[j - 1];
					A[j - 1] = temp1;
				}
			}   
			for(var h:int=0;h<n;h++){
				
				trace(A[h]);
			}
			
		}
		
		//直接插入排序
		private function insertionSort():void{
			
			for (var i:int=0;i<n-1;i++) {
				var s:Number = i;
				for (var j:int=s+1;j<n;j++) {
					if (A[j] < A[s]) {
						s = j;
					}
				}
				var temp:int = A[i];
				A[i] = A[s];
				A[s] = temp;
			}
			
			for(var h:int=0;h<n;h++){    
				trace(A[h]+"-----直接插入排序");
			}
		}
		
		//冒泡排序
		private function bubbleSort():void{
			
			for (var i:int=0;i<n;i++){
				for (var j:int=i;j<n;j++) {
					if (A[i]>A[j]){
						var temp:int = A[i];
						A[i] = A[j];
						A[j] = temp;
					}
				}
			}
			
			for(var h:int=0;h<n;h++){    
				trace(A[h]+"-----冒泡排序");
			}
			
		}
		
		//希尔排序
		private function shellSort():void{
			var increment:int = 6;
			while (increment > 1) {
				increment = int(increment / 3 + 1);
				Shellpass(increment);
			}
			function Shellpass(c:int){
				for (var i:int=c;i<n;i++) {
					if (A[i] < A[i - c]) {
						var temp:int = A[i];
						var j:int=i-c;
						do {
							A[j + c] = A[j];
							j = j - c;
						} while (j > 0 && temp < A[j]);
						A[j + c] = temp;
					}
				}
			}
			
			for(var h:int=0;h<n;h++){    
				trace(A[h]+"-----希尔排序");
			}
		}
		
		//快速排序
		private function quickSort():void{
			
			function QuickSort(A, low, hig) {
				var i:int = low, j = hig;
				var mid = A[int((low + hig) / 2)];
				do {
					while (A[i] < mid) {
						i++;
					}
					while (A[j] > mid) {
						j--;
					}
					if (i <= j) {
						var temp = A[i];
						A[i] = A[j];
						A[j] = temp;
						i++;
						j--;
					}
				} while (i <= j);
				if (low < j) {
					arguments.callee(A,low,j);
				}
				if (i < hig) {
					arguments.callee(A,i,hig);
				}
			}
			QuickSort(A,0,n - 1);
			
			for(var h:int=0;h<n;h++){    
				trace(A[h]+"-----快速排序");
			}
		}
		
		//归并排序
		private function mergeSort():void{
			
			var B:Array = new Array(A.length);
			for (var k:int=1;k<n;k*=2) {
				MergePass(k);
			}
			function MergePass(len:int) {
				for (var i:int=0;i+2*len<n;i=i+2*len) {
					MergeA(i,i + len - 1,i + 2 * len - 1);
				}
				if (i + len < n) {
					MergeA(i,i + len - 1,n - 1);
				}
			}
			function MergeA(low, m, hig) {
				var i:int = low;
				var j:int = m + 1;
				var z:int = 0;
				while (i <= m && j <= hig) {
					B[z++] = (A[i] <= A[j]) ? A[i++] : A[j++];
				}
				while (i <= m) {
					B[z++] = A[i++];
				}
				while (j <= hig) {
					B[z++] = A[j++];
				}
				for (z = 0, i = low; i <= hig; z++, i++) {
					A[i] = B[z];
				}
			}
			
			for(var h:int=0;h<n;h++){    
				trace(A[h]+"-----归并排序");
			}
		}
	}

}