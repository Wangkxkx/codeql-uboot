import cpp

class NetworkByteSwap extends Expr{
  NetworkByteSwap(){
    exists(MacroInvocation mic|
      mic.getMacroName().regexpMatch("ntoh(s|l|ll)") and
      this = mic.getExpr() //这个是什么呀？
      )
  }
}

from NetworkByteSwap n
select n,"Network Byte swap"
