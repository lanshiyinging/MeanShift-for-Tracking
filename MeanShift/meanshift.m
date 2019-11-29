close all;
clear;

%%read dataset_path

dataset_path='Basketball/img/';
frameFile=dir('Basketball/img/*.jpg');
frameNum=length(frameFile);
target_rect = zeros(frameNum, 4);
target_rect(1,:)=[198 214 34 81];
iteration = 20;

h = pow2(target_rect(3)/2) + pow2(target_rect(4)/2);

first_frame = imread([dataset_path, frameFile(1).name]);
t_x=target_rect(1,1);
t_y=target_rect(1,2);
t_w=target_rect(1,3);
t_h=target_rect(1,4);
num = t_w*t_h;

target_region=first_frame(t_y:t_y+t_h, t_x:t_x+t_w, :);
[target_pos, target_posc, target_z] = getPos(target_rect(1, :), target_region);
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
    t_x = target_rect(i-1, 1) + t_w/2;
    t_y = target_rect(i-1, 2) + t_h/2;
    y0 = [t_x t_y];
    y0 = ceil(y0);
    y0_rect = [y0 t_w t_h];
    y0_region = cur_frame(y0(2):y0(2)+t_h, y0(1):y0(1)+t_w, :);
    [y0_pos, y0_posc, y0_z] = getPos(y0_rect, y0_region);
    [p_y0, py0_delta] = calHist(y0_z, y0_posc);
    sim_y0 = p_y0' * q;
    
    it = 0;
    while it < iteration
        w = zeros(num, 1);
        w1 = zeros(4096, 1);
        for m = 1:4096
            if p_y0(m) ~= 0
                w1(m) = q(m) / p_y0(m);
            else
                w1(m) = 0;
            end
        end
        for j = 1:num
            w(j) = w1' * py0_delta(:,j);
        end
        y0_g = G(y0_z);
        
        y1 = sum(y0_pos.*w.*y0_g) / (w'*y0_g);
        y1 = y0 + y1;
        y1 = ceil(y1);
        y1_rect = [y1 t_w t_h];
        y1_region = cur_frame(y1(2):y1(2)+t_h, y1(1):y1(1)+t_w, :);
        [y1_pos, y1_posc, y1_z] = getPos(y1_rect, y1_region);
        [p_y1, py1_delta] = calHist(y1_z, y1_posc);
        sim_y1 = p_y1' * q;
        
        while sim_y1 < sim_y0
            y1 = (y0 + y1) / 2;
            y1 = ceil(y1);
            y1_rect = [y1 t_w t_h];
            y1_region = cur_frame(y1(2):y1(2)+t_h, y1(1):y1(1)+t_w, :);
            [y1_pos, y1_posc, y1_z] = getPos(y1_rect, y1_region);
            [p_y1, py1_delta] = calHist(y1_z, y1_posc);
            sim_y1 = p_y1' * q;
        end
        
        if (y1-y0) * (y1-y0)' < 0.5
            target_rect(i, :) = y1_rect;
            q = p_y1;
            break;
        else
            y0 = y1;
            y0_z = y1_z;
            y0_pos = y1_pos;
            sim_y0 = sim_y1;
            p_y0 = p_y1;
            py0_delta = py1_delta;
        end
        it = it+1;
    end
	

end

showResult(target_rect);

 




