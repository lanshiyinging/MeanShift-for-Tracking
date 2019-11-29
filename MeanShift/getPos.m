function [pos, pos_c, z] = getPos(rect, region)

x = rect(1);
y = rect(2);
w = rect(3);
h = rect(4);
x0 = w/2;
y0 = h/2;
pos = zeros(w*h, 2);
pos_c = zeros(w*h,3);
z = zeros(w*h, 1);
hh = pow2(x0) + pow2(y0);
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