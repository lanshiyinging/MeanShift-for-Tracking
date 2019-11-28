function [k] = K(z)

num = size(z, 1);
k = zeros(num, 1);
for i = 1:num
	if z(i) <= 1
		k(i) = (1-pow2(z(i))) / pi;
	else
		k(i) = 0;
	end
end