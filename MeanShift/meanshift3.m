close all;
clear;

%%read dataset_path
g_rect=load('Box/groundtruth_rect.txt');
dataset_path='Box/img/';
frameFile=dir('Box/img/*.jpg');
frameNum=length(frameFile);
target_rect = zeros(frameNum, 4);
target_rect(1,:)=g_rect(1, :);
iteration = 20;


first_frame = imread([dataset_path, frameFile(1).name]);
rect = target_rect(1, :);

target_region = imcrop(first_frame, rect);
[row, col, ~] = size(target_region);
num = row*col;
[target_pos, target_posc, target_z] = getPos(target_region);
[q, q_delta] = calHist(target_z, target_posc);

%{
last_frame = imread([dataset_path, frameFile(i-1).name]);
cur_frame = imread([dataset_path, frameFile(i).name]);
t_x = target_rect(i-1, 1);
t_y = target_rect(i-1, 2);
target_region=last_frame(t_y:t_y+t_h, t_x:t_x+t_w, :);
[target_pos, target_posc, target_z] = getPos(target_rect(i-1, :), target_region);
[q, q_delta] = calHist(target_z, target_posc);
%}

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

showResult(target_rect, dataset_path);