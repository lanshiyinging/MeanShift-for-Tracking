function [thist] = calHist2(region)

minS = 65;
r_hsv = rgb2hsv(region);
h = uint8(180*r_hsv(:,:,1));
s = uint8(255*r_hsv(:,:,2));
[row, col,~] = size(region);
mask = zeros(row, col);

for r = 1:row
    for c = 1:col
        if s(r,c) > minS
            mask(r, c) = 1;
        end
    end
end

mask = uint8(mask);
h = h.*mask;

thist = zeros(181, 1);

for i = 1 : 181
	thist(i) = sum(sum(h(:,:) == i-1));
end

thist = thist/sqrt(sum(thist.^2));



%{
r_hsv = uint8(255*rgb2hsv(region));
h_b = 4;
s_b = 2;
thist = zeros(h_b*s_b, 1);

for i = 1 : 2^h_b
	for j = 1 : 2^s_b
        index = (i-1)*2^h_b + j;
		thist(index) = sum(sum(bitshift(r_hsv(:,:,1),-(8-h_b))==i-1 & bitshift(r_hsv(:,:,2),-(8-s_b))==j-1));
	end
end
thist = thist/sum(thist);
%}
%thist = uint8(255*thist);
