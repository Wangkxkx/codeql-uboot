import cpp

from MacroInvocation inv 
where 
    inv.getMacroName() in  ["ntohs","ntohl","ntohll"]
select inv.getExpr()

