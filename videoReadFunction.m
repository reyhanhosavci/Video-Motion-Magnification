function [frameCells] = videoReadFunction(videopath)

v = VideoReader(videopath);

for img = 1:v.NumberOfFrames;
    filename=strcat('frame',num2str(img),'.jpg');
    video = read(v, img);
    frameCells{img}=(video);
end
whos video
v.NumberOfFrames
v.FrameRate
end

