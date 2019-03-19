
% FACE DETECTION:
clear ALL
clc
%Detect objects using Viola-Jones Algorithm

%To detect Face
FDetect = vision.CascadeObjectDetector;
FDetect.MergeThreshold =15;
%Read the input image
 I = imread('1.jpg');
%Returns Bounding Box values based on number of objects
BB = step(FDetect,I);

figure,
imshow(I);
hold on
k=1;
for i = 1:size(BB,1) % draw rectanlge in row wise
    rectangle('Position',BB(i,:),'LineWidth',2,'LineStyle','-','EdgeColor','g');
    %start from first row then second and ....
   
end
% title('Face Detection');
hold off;
for i= 1:size(BB,1)
    J= imcrop(I,BB(i,:));
    p2=strcat('C:\Users\Manuna Chhangte\Desktop\PD LAB\Demo\Demo\Cropped faces\', int2str(k),'.bmp');
    I2 = rgb2gray(J); 
    I2= imresize(I2, [112 92]);
    k=k+1;
    imwrite(I2,p2)
end
% Face Recognition


