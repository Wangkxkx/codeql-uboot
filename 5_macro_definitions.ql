import cpp

from Macro m
///where m.getName().regexpMatch("ntoh(s|l|ll)") //正则表达式匹配
where m.getName() in ["ntohs","ntohl","ntohll"]
select m, "network functions m"