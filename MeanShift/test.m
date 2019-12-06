close all;
clear;

g_rect=load('Bird2/groundtruth_rect.txt');
dataset_path='Bird2/img/';
frameFile=dir('Bird2/img/*.jpg');

frameNum=length(frameFile);
target_rect = zeros(frameNum, 4);
target_rect(1,:)=g_rect(1, :);
iteration = 20;


first_frame = imread([dataset_path, frameFile(1).name]);
ff_hsv = rgb2hsv(first_frame);
rect = target_rect(1, :);
region = imcrop(first_frame, rect);

%target_hist = calHist2(region);

minS = 80;
r_hsv = rgb2hsv(region);
h = uint8(180*r_hsv(:,:,1));
s = uint8(255*r_hsv(:,:,2));
[row, col,~] = size(region);
mask = zeros(row, col);

for r = 1:row
    for c = 1:col
        if s(r,c) < minS
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


r_bp = zeros(row, col);
h = uint8(180*r_hsv(:,:,1));
for r = 1:row
    for c = 1:col
        index = h(r,c)+1;
        r_bp(r, c) = thist(index)*255;
    end
end
r_bp = uint8(r_bp);
r_bp = r_bp.*mask;
figure(2)
imshow(r_bp)
hold on



