close all;
clear all;
im = imread('1.jpg');
figure
imshow(im)
imgray = rgb2gray(im);
figure
imshow(imgray)
imbin = imbinarize(imgray);
figure
imshow(imbin) 
imgraynew = medfilt2(imgray);
figure
imshow(imgraynew)
im = edge(imgraynew, 'sobel');
figure
imshow(im) 
im=imdilate(im,strel('diamond',2));
figure
imshow(im) 
im2=imfill(im,'holes');
figure
imshow(im2) 
im=imopen(im,strel('rectangle',[2 2]));

%Below steps are to find location of number plate
Iprops=regionprops(im,'BoundingBox','Area', 'Image');
area = Iprops.Area;
count = numel(Iprops);
maxa= area;
boundingBox = Iprops.BoundingBox;
for i=1:count
   if maxa<Iprops(i).Area
       maxa=Iprops(i).Area;
       boundingBox=Iprops(i).BoundingBox;
   end
end    

im = imcrop(imbin, boundingBox);%crop the number plate area
figure
imshow(im)
im = bwareaopen(~im, 500); %remove some object if it width is too long or too small than 500
figure

imshow(im) ,

 [h, w] = size(im);%get width


Iprops=regionprops(im,'BoundingBox','Area', 'Image'); %read letter
count = numel(Iprops);
noPlate=[]; % Initializing the variable of number plate string.

for i=1:count
   ow = length(Iprops(i).Image(1,:));
   oh = length(Iprops(i).Image(:,1));
   if ow<(h/2) & oh>(h/3)
       letter=Letter_detection(Iprops(i).Image); % Reading the letter corresponding the binary image 'N'.
       noPlate=[noPlate letter] % Appending every subsequent character in noPlate variable.
   end
end