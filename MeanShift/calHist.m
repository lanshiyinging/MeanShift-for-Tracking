function [tHist, tb, td] = calHist(zc)

num = size(zc, 1);
tHist = zeros(16, 3);
tb = zeros(num, 3);
td = zeros(16, num, 3);
r = zc(:, 1);
g = zc(:, 2);
b = zc(:, 3);
for i = 1:num
	tHist[rem(r(i)%16)+1] = tHist[rem(r(i)%16)+1] + 1;
	tHist[rem(g(i)%16)+1] = tHist[rem(g(i)%16)+1] + 1;
	tHist[rem(b(i)%16)+1] = tHist[rem(b(i)%16)+1] + 1;
	tb(i, :) = [rem(r(i)%16)+1 rem(g(i)%16)+1 rem(b(i)%16)+1];
	td(tb(i,1), i, 1) = 1;
	td(tb(i,2), i, 2) = 1;
	td(tb(i,3), i, 3) = 1;
end