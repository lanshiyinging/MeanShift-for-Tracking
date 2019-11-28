function [z, zc]=normalizeRegion(rect, region)
x=rect(1);
y=rect(2);
w=rect(3);
h=rect(4);
num = w*h;
z = zeros(num, 1);
zc = zeros(num, 3);
n = 1;
for i = x:x+w
	for j = y:y+h
		z(n) = power((pow2(i-x)+pow2(j-y))/(pow2(x)+pow2(y)),0.5);
		zc(n,1) = region(i, j, 1);
		zc(n,2) = region(i, j, 2);
		zc(n,3) = region(i, j, 3);
		n = n+1;
	end
end

