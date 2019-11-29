function [z]=normalizeRegion(rect)
x=rect(1);
y=rect(2);
w=rect(3);
h=rect(4);
num = w*h;
z = zeros(num, 1);
n = 1;
for i = x:x+w
	for j = y:y+h
		z(n) = power((pow2(i-x)+pow2(j-y))/(pow2(x)+pow2(y)),0.5);
		n = n+1;
	end
end

