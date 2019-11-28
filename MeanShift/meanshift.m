close all;
clear;

%%read dataset_path

dataset_path='Basketball/img/';
frameFile=dir('Basketball/img/*.jpg');
frameNum=length(frameFile);
first_frame = imread([dataset_path, frameFile(1).name]);
target_rect=[198 214 34 81];

for i = 2:frameNum
	last_frame = imread([dataset_path, frameFile(i).name]);
	cur_frame = imread([dataset_path, frameFile(i).name]);
	t_x=target_rect(1);
	t_y=target_rect(2);
	t_w=target_rect(3);
	t_h=target_rect(4);
	target_region=last_frame[t_y:t_y+t_h,t_x:t_x+t_w,:];
	[target_z, target_zc] = normalizeRegion(target_rect, target_region);
	[target_region_hist, target_b, target_delta] = cal_hist(target_zc);
	q = zeros(16, 3);
	t_k = K(z);
	t_C = 1 / sum(t_k);
	q(:,1) = t_C*target_delta(:,:,1)*t_k;
	

end



 




