close all;
clear;

%%read dataset_path
g_rect=load('Bird2/groundtruth_rect.txt');
dataset_path='Bird2/img/';
frameFile=dir('Bird2/img/*.jpg');
frameNum=length(frameFile);
target_rect = zeros(frameNum, 4);
target_rect(1,:)=g_rect(1, :);
iteration = 20;


first_frame = imread([dataset_path, frameFile(1).name]);
rect = target_rect(1, :);
region = imcrop(first_frame, rect);
target_hist = calHist2(region);

x0 = ceil(rect(3)/2);
y0 = ceil(rect(4)/2);
for i = 2:frameNum
    cur_frame = imread([dataset_path, frameFile(i).name]);
    cur_bp = calBackProject(target_hist, cur_frame);
    figure(1)
    imshow(cur_bp)
    y = [1, 1];
    it = 0;

    while(it < iteration && y(1)^2+y(2)^2>0.5)
        
        r_bp = cur_bp(rect(2):rect(2)+rect(4), rect(1):rect(1)+rect(3));
        
        [row, col] = size(r_bp);

        x_ = zeros(1,col);
        y_ = zeros(1,row);
        for r = 1:row
            y_(r) = r-y0;
        end
        for c = 1:col
            x_(c) = c-x0;
        end
        M00 = sum(sum(r_bp));
        M10 = x_*sum(r_bp, 1)';
        M01 = sum(r_bp'*y_');
        y(1) = round(M10/M00);
        y(2) = round(M01/M00);

        
        %{
        z = zeros(row*col, 2);
        n = 1;
        for r = 1:row
            for c = 1:col
                z(n, 1) = (c-x0)*r_bp(r, c)/255;
                z(n, 2) = (r-y0)*r_bp(r, c)/255;
                n = n+1;
            end
        end
        y = round(sum(z)/(row*col));
        %}
        
        rect(1) = rect(1)+y(1);
        rect(2) = rect(2)+y(2);
        it = it+1;
    end
    %region = imcrop(cur_frame, rect);
    %target_hist = calHist2(region);
	target_rect(i, :) = rect;
    show(cur_frame, rect, g_rect(i, :));
end