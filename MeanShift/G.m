function [g] = G(x)
num = size(x, 1);
g = zeros(num, 1);
for i = 1:num
    if x(i) <= 1
        g(i) = -2/pi;
    else
        g(i) = 0;
    end
end
