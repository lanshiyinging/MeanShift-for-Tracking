function [pos, pos_c] = getPos(rect, region)

x = rect(1);
y = rect(2);
w = rect(3);
h = rect(4);

pos = zeros(w*h, 2);
pos_c = zeros(w*h,3);
n=1;
for i = x:x+w
    for j = y:y+h
        pos(n,:) = [i j];
        pos_c(n,1) = region(i, j, 1);
		pos_c(n,2) = region(i, j, 2);
		pos_c(n,3) = region(i, j, 3);
        n = n + 1;
    end
end