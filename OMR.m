% Optical Mark Recognition
% Tools for performing OMR on scanned forms
% Last Modified: 21 May 2013, Farrukh I. Khan
% =============================================
% Change log:
% -Version 0.0.1 - 20 May 2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
close all;
clc;
%% Loading Master and Student Answer Sheet Image
master = rgb2gray(imread('./Images/1/MasterSheet.jpg'));
figure(1),imshow(master);h1 = title('Master Sheet');
student = rgb2gray(imread('./Images/1/StudentSheet.jpg'));
figure(2),imshow(student);h2 =title('Student Sheet');

%% Extracting ROI
mpatch = master(735:2030,530:690);
spatch = student(735:2030,530:690);
figure(3),imshow(mpatch);title('Master Patch');
figure(4),imshow(spatch);title('Student Patch');

%% Morphological Operation
close (3:4)
radius = 11;
circ_mask = fspecial('disk',radius);
mconv = mat2gray(conv2(mpatch, circ_mask,'same'));
sconv = mat2gray(conv2(spatch, circ_mask,'same'));

figure(6),imshow(mconv);title('Convolved Master Patch');
figure(7),imshow(sconv);title('Convolved Student Patch');

BWm = im2bw(mconv,.5);
BWs = im2bw(sconv,.5);
pause(5);
close (6:7)
figure(8),imshow(BWm);title('Segmented Master Patch');
figure(9),imshow(BWs);title('Segmented Student Patch');
correct = ~(~BWm & ~BWs);
pause(5);
close(8:9)
figure(10),imshow(correct);title('Correct Answers Patch');

correct = im2uint8(correct);

%% Finding Circles
% In this step we will find all circles (black) and mark those are filled
% by student (blue)
close(10)
[blackcenters, radii] = imfindcircles(mpatch,[10 12],'ObjectPolarity','dark', 'Sensitivity',.98);
blackcenters(1:end,1) = blackcenters(1:end,1)+529;
blackcenters(1:end,2) = blackcenters(1:end,2)+734;
blackcenters = sortrows(blackcenters,2);
figure(1);
hDetectAll = viscircles(blackcenters,radii,'EdgeColor','black');

[bluecenters, radii] = imfindcircles(sconv,[10 12],'ObjectPolarity','dark', 'Sensitivity',.98);
bluecenters(1:end,1) = bluecenters(1:end,1)+529;
bluecenters(1:end,2) = bluecenters(1:end,2)+734;
bluecenters = sortrows(bluecenters,2);
figure(2);
hDetectFilled = viscircles(bluecenters,radii,'EdgeColor','blue');

pause(5)

%% Finding Correct and Incorrect Marks
% In this step we will mark the correct (green) and incorrect (red);
delete(hDetectAll);
delete(hDetectFilled);
% delete(h1);delete(h2);
h1 = title('Correct Answers');
[greencenters, radii] = imfindcircles(correct,[10 12],'ObjectPolarity','dark', 'Sensitivity',.99);
greencenters(1:end,1) = greencenters(1:end,1)+529;
greencenters(1:end,2) = greencenters(1:end,2)+734;
greencenters = sortrows(greencenters,2);figure(2);
hDetectCorrect = viscircles(greencenters,radii,'EdgeColor','green');

%% Finding the Incomplete and Wrongly marked


