import cpp

// from Function f, FunctionCall call
// where 
//      call.getTarget()=f and  //查找函数调用
//      f.getName() = "memcpy"  //查找定义 
// select call 

from FunctionCall call
where call.getTarget().getName() = "memcpy"
select call
