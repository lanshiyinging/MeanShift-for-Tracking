function [pos, pos_c, z] = getPos(region)


[h, w, ~] = size(region);
num = h*w;
x0 = w/2;
y0 = h/2;
pos = zeros(num, 2);
pos_c = zeros(num,3);
z = zeros(num, 1);
hh = x0^2+y0^2;
n=1;
for i = 1:h
    for j = 1:w
        pos(n,:) = [j-x0 i-y0];
        z(n) = ((i-y0)^2+(j-x0)^2)/ hh;
        pos_c(n,1) = region(i, j, 1);
		pos_c(n,2) = region(i, j, 2);
		pos_c(n,3) = region(i, j, 3);
        n = n + 1;
    end
end