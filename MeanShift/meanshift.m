close all;
clear;

%%read dataset_path

dataset_path='Basketball/img/';
frameFile=dir('Basketball/img/*.jpg');
frameNum=length(frameFile);
first_frame = imread([dataset_path, frameFile(1).name]);
target_rect=[198 214 34 81];
iteration = 20;
it = 0;
h = pow2(target_rect(3)/2) + pow2(target_rect(4)/2);

for i = 2:frameNum
	last_frame = imread([dataset_path, frameFile(i).name]);
	cur_frame = imread([dataset_path, frameFile(i).name]);
	t_x=target_rect(1);
	t_y=target_rect(2);
	t_w=target_rect(3);
	t_h=target_rect(4);
	target_region=last_frame(t_y:t_y+t_h, t_x:t_x+t_w, :);
	[target_pos, target_posc] = getPos(target_rect, target_region);
	[q, q_delta] = cal_hist(target_pos, target_posc);

    candi_rect = target_rect;
    while it < iteration
        c_x=candi_rect(1);
        c_y=candi_rect(2);
        c_w=candi_rect(3);
        c_h=candi_rect(4);
        y0 = [c_x c_y];
        y0_region = cur_frame(c_y:c_y+c_h, c_x:c_x+c_w, :);
        [y0_pos, y0_posc] = normalizeRegion(candi_rect, y0_region);
        [p_y0, py0_delta] = cal_hist((y0-y0_pos)/h, y0_posc);
        sim_y0 = p_y0' * q;
        num = c_w*c_h;
        w = zeros(num, 1);
        for j = 1:num
            w(j) = sqrt(q/p_y0)' * py0_delta(:,j);
        end
        y0_g = G((y0_z(1)-y0_z)/h);
        y1 = sum(y0_pos.*w.*y0_g) / (w'*y0_g);
        c_x = y1(1);
        c_y = y1(2);
        candi_rect(1) = y1(1);
        candi_rect(2) = y1(2);
        y1_region = cur_frame(c_y:c_y+c_h, c_x:c_x+c_w, :);
        [y1_pos, y1_posc] = normalizeRegion(candi_rect, y1_region);
        [p_y1, py1_delta] = cal_hist((y1-y1_pos)/h, y1_posc);
        sim_y1 = p_y1' * q;
        while sim_y1 < sim_y0
            y1 = (y0 + y1) / 2;
            c_x = y1(1);
            c_y = y1(2);
            candi_rect(1) = y1(1);
            candi_rect(2) = y1(2);
            y1_region = cur_frame(c_y:c_y+c_h, c_x:c_x+c_w, :);
            [y1_pos, y1_posc] = normalizeRegion(candi_rect, y1_region);
            [p_y1, py1_delta] = cal_hist((y1-y1_pos)/h, y1_posc);
            sim_y1 = p_y1' * q;
        end
        if (y1-y0) * (y1-y0)' > 0.5
            y0 = y1;
        end
        it = it+1;
    end
	

end



 




