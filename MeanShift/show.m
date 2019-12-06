function []=show(frame, rect, g_rect)
imshow(frame);
hold on;
v1=rect(1);
v2=rect(2);
v3=rect(3);
v4=rect(4);
plot([v1, v1+v3],[v2,v2],[v1,v1],[v2,v2+v4],[v1+v3,v1+v3],[v2,v2+v4],[v1,v1+v3],[v2+v4,v2+v4],'LineWidth',2,'Color','r');

v1=g_rect(1);
v2=g_rect(2);
v3=g_rect(3);
v4=g_rect(4);
plot([v1, v1+v3],[v2,v2],[v1,v1],[v2,v2+v4],[v1+v3,v1+v3],[v2,v2+v4],[v1,v1+v3],[v2+v4,v2+v4],'LineWidth',2,'Color','g');

pause(0.05)


end

