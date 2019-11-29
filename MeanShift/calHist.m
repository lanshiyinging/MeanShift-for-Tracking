function [tHist, delta] = calHist(z, zc)

num = size(zc, 1);
tb = zeros(num, 1);
delta = zeros(16*16*16, num);
r = zc(:, 1);
g = zc(:, 2);
b = zc(:, 3);

for i = 1:num
	tb(i) = floor(r(i)/16)+1+(floor(g(i)/16))*16+(floor(b(i)/16))*256;
    delta(tb(i), i) = 1;
end

k = K(z);
C = 1 / sum(k);
tHist = C*delta*k;
