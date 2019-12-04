function []=showResult(target_rect, dataset_path)

frame_file_path=[dataset_path, '*.jpg'];
frameFile=dir(frame_file_path);
frameNum=length(frameFile);

%%groundtruth_rect=load('Basketball/groundtruth_rect.txt');

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
    pause(0.05)
end

