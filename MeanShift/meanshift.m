close all;
clear;

%%read dataset_path

dataset_path='Basketball/img/';
frameFile=dir('Basketball/img/*.jpg');
frameNum=length(frameFile);
target_rect=[198 214 34 81];
iteration = 20;
it = 0;
h = pow2(target_rect(3)/2) + pow2(target_rect(4)/2);

first_frame = imread([dataset_path, frameFile(1).name]);
t_x=target_rect(1);
t_y=target_rect(2);
t_w=target_rect(3);
t_h=target_rect(4);
num = t_w*t_h;


for i = 2:frameNum
    last_frame = imread([dataset_path, frameFile(i-1).name])
	cur_frame = imread([dataset_path, frameFile(i).name]);
    target_region=last_frame(t_y:t_y+t_h, t_x:t_x+t_w, :);
    [target_pos, target_posc] = getPos(target_rect, target_region);
    [q, q_delta] = cal_hist(target_pos, target_posc);

    y0 = [t_x t_y];
    y0_rect = [y0 t_w t_h];
    y0_region = cur_frame(y0(2):y0(2)+t_h, y0(1):y0(1)+t_w, :);
    [y0_pos, y0_posc] = normalizeRegion(y0_rect, y0_region);
    [p_y0, py0_delta] = cal_hist((y0-y0_pos)/h, y0_posc);
    sim_y0 = p_y0' * q;
    
    while it < iteration
        w = zeros(num, 1);
        for j = 1:num
            w(j) = sqrt(q/p_y0)' * py0_delta(:,j);
        end
        y0_g = G((y0_z(1)-y0_z)/h);
        y1 = sum(y0_pos.*w.*y0_g) / (w'*y0_g);
        y1_rect = [y1 t_w t_h];
        y1_region = cur_frame(y1(2):y1(2)+t_h, y1(1):y1(1)+c_w, :);
        [y1_pos, y1_posc] = normalizeRegion(y1_rect, y1_region);
        [p_y1, py1_delta] = cal_hist((y1-y1_pos)/h, y1_posc);
        sim_y1 = p_y1' * q;

        while sim_y1 < sim_y0
            y1 = (y0 + y1) / 2;
            y1_rect = [y1 t_w t_h];
            y1_region = cur_frame(y1(2):y1(2)+t_h, y1(1):y1(1)+c_w, :);
            [y1_pos, y1_posc] = normalizeRegion(y1_rect, y1_region);
            [p_y1, py1_delta] = cal_hist((y1-y1_pos)/h, y1_posc);
            sim_y1 = p_y1' * q;
        end

        if (y1-y0) * (y1-y0)' < 0.5
            target_rect = [target_rect; y1_rect];
            t_x = y1(1);
            t_y = y1(2);
            break;
        else
            y0 = y1;
            sim_y0 = sim_y1;
        end
        it = it+1;
    end
	

end



 




