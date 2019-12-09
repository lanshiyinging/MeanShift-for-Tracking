function []=showResult(target_rect, base_path)

dataset_path = [base_path, '/img/'];
frame_file_path=[base_path, '/img/*.jpg'];
groundtruth_path = [base_path, '/groundtruth_rect.txt'];
g_rect=load(groundtruth_path);
frameFile=dir(frame_file_path);
frameNum=length(frameFile);

%%groundtruth_rect=load('Basketball/groundtruth_rect.txt');
[row, col, ~] = size([dataset_path, frameFile(1).name]);
figure;
set(gcf, 'Position', [100, 100, col, row]);
result_video = VideoWriter([base_path,'_result.avi']);
result_video.FrameRate = 10;
open(result_video);

for l=1:frameNum
    img_path=[dataset_path,frameFile(l).name];
    I=imread(img_path);
    imshow(I);
    hold on;
    rect=target_rect(l,:);
    v1=rect(1);
    v2=rect(2);
    v3=rect(3);
    v4=rect(4);
    plot([v1, v1+v3],[v2,v2],[v1,v1],[v2,v2+v4],[v1+v3,v1+v3],[v2,v2+v4],[v1,v1+v3],[v2+v4,v2+v4],'LineWidth',2,'Color','r');
    %{
    v1=g_rect(l,1);
    v2=g_rect(l,2);
    v3=g_rect(l,3);
    v4=g_rect(l,4);
    plot([v1, v1+v3],[v2,v2],[v1,v1],[v2,v2+v4],[v1+v3,v1+v3],[v2,v2+v4],[v1,v1+v3],[v2+v4,v2+v4],'LineWidth',2,'Color','g');
    %}
    frame = getframe(gcf);
    result = frame2im(frame);
    writeVideo(result_video, result);
    pause(0.05)
end
close(result_video);

