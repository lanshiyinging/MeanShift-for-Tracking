close all;
clear;

%%read dataset_path
base_path = 'Bird2';
groundtruth_path = [base_path, '/groundtruth_rect.txt'];
dataset_path = [base_path, '/img/'];
frameFile_path = [dataset_path, '*.jpg'];
g_rect=load(groundtruth_path);

frameFile=dir(frameFile_path);
frameNum=length(frameFile);
target_rect = zeros(frameNum, 4);
target_rect(1,:)=g_rect(1, :);
iteration = 20;


first_frame = imread([dataset_path, frameFile(1).name]);
%{
figure(1);
imshow(first_frame);
[target_region, rect] = imcrop(first_frame);
%}
rect = target_rect(1, :);
target_region = imcrop(first_frame, rect);

[row, col, ~] = size(target_region);
rect(3) = col-1;
rect(4) = row-1;
num = row*col;
[target_pos, target_posc, target_z] = getPos(target_region);
[q, q_delta] = calHist(target_z, target_posc);

for i = 2:frameNum
    cur_frame = imread([dataset_path, frameFile(i).name]);
    y = [1, 1];
    it = 0;
    
    while(it < iteration && y(1)^2+y(2)^2>0.5)
        
        region = imcrop(cur_frame, rect);
        [pos, posc, z] = getPos(region);
        [p, p_delta] = calHist(z, posc);
        sim = p' * q;
        w = zeros(num, 1);
        w1 = zeros(4096, 1);
        for m = 1:4096
            if p(m) ~= 0
                w1(m) = q(m) / p(m);
            else
                w1(m) = 0;
            end
        end
        for j = 1:num
            w(j) = w1' * p_delta(:,j);
        end
        g = G(z);
        
        y = sum(pos.*w.*g) / (w'*g);
        rect(1) = rect(1)+y(1);
        rect(2) = rect(2)+y(2);
        %q = p;
        
        it = it+1;
    end
	target_rect(i, :) = rect;
    %show(cur_frame, rect, g_rect(i, :));
end

showResult(target_rect, base_path);

 




