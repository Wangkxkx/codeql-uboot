/**
 * @kind path-problem
 */

import cpp
import semmle.code.cpp.dataflow.TaintTracking
import DataFlow::PathGraph


//memcpy函数的第3个参数是待复制数据块的长度，因为ntohs是进制转换的函数，因此通过ntohs输入的数据很有可能是用户可控的参数值，通过这条路径传递给memcpy，就能转化为用户可控的内存操作，造成缓存区溢出

class NetworkByteSwap extends Expr
{
     NetworkByteSwap(){
        exists(MacroInvocation mic |
        mic.getMacroName().regexpMatch("ntoh(s|l|ll)") and
        mic.getExpr() = this
       )
     }
}

class Config extends TaintTracking::Configuration 
{
     Config(){
       this = "NetworkToMemFuncLength"
     }

    //污点的源头 此处的source点是调用ntoh*的表达式
     override predicate isSource(DataFlow::Node source) {
       source.asExpr() instanceof NetworkByteSwap
       
     }
     //污点的去处 此处的sink点时memcpy中的第二个参数（从0开始算
     override predicate isSink(DataFlow::Node sink) {
       exists(FunctionCall call |
        call.getTarget().getName() = "memcpy" and
        sink.asExpr() = call.getArgument(2) 
        and 
        not call.getArgument(1).isConstant()
        )
     }
}

from Config cfg, DataFlow::PathNode source,DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink, source, sink, "Network byte swap flows to memcpy at " + sink.getNode().getFunction().getName()


