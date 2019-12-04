function [r_bp] = calBackProject(hist1, region)

[row, col, ~] = size(region);

r_bp = zeros(row, col);
minS = 65;
r_hsv = rgb2hsv(region);
h = uint8(180*r_hsv(:,:,1));
s = uint8(255*r_hsv(:,:,2));
mask = zeros(row, col);

for r = 1:row
    for c = 1:col
        if s(r,c) > minS
            mask(r, c) = 1;
        end
    end
end

for r = 1:row
    for c = 1:col
        index = h(r,c)+1;
        r_bp(r, c) = hist1(index)*255;
    end
end

r_bp = r_bp.*mask;

%{
[row, col, ~] = size(region);

r_bp = zeros(row, col);
r_hsv = uint8(255*rgb2hsv(region));
h_b = 4;
s_b = 2;

for r = 1:row
    for c = 1:col
        index = bitshift(r_hsv(r,c,1), -(8-h_b))*2^h_b + bitshift(r_hsv(r,c,2),-(8-s_b)) + 1;
        r_bp(r, c) = hist1(index);
    end
end
%}