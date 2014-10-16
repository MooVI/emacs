ggplot() +geom_point(aes(wl,stdsl/meansl),size=1.2)+
scale_y_log10(breaks = trans_breaks("log10", function(x) 10^x), labels = trans_format("log10", math_format(10^.x)))+
theme_bw()+
xlab("$W$")+ylab("$\\sigma/\\xi$")+
scale_x_log10(labels = trans_format("log10", math_format(10^.x)))+
annotation_logticks()

ggplot() + geom_point(aes(wl,meansl),size=1.2) +theme_bw()+geom_smooth(aes(wl,meansl), method=lm)+xlab("$W$")+ylab("$\\xi$")+scale_y_log10(breaks = trans_breaks("log10", function(x) 10^x), labels = trans_format("log10", math_format(10^.x)))+ scale_x_log10(labels = trans_format("log10", math_format(10^.x)))+annotation_logticks()
    
