clear all;
close all;
clc;
%% Loading Student Answer Sheet Image
sample = imread('./Images/2/filled.jpg');
figure(1),imshow(sample);title('Sample image');
%% ROI extraction
rollNumber = sample(1062:1564,195:500);
paperCode = sample(1060:1564,545:755);
figure(2),imshow(rollNumber);
figure(3),imshow(paperCode);
blackCenters = [];
radiiBlack = [];
for i = 1:50:50*6
    patch = rollNumber(1:end,i:i+49);
    [blackcenters, radiiblack] = imfindcircles(patch,[19 23],'ObjectPolarity','dark', 'Sensitivity',.982);
    figure,imshow(rollNumber(1:end,i:i+49));
    hDetectAll = viscircles(blackcenters,radiiblack,'EdgeColor','black');
    blackcenters(1:end,2) = blackcenters(1:end,2) + i -1;
    blackCenters = [blackCenters; blackcenters ];
    radiiBlack = [radiiBlack; radiiblack];
    radius = 21;
    circ_mask = fspecial('disk',radius);
    convSample = mat2gray(conv2(patch, circ_mask,'same'));
    figure,imshow(convSample);
    [bluecenters, radii] = imfindcircles(convSample,[19 23],'ObjectPolarity','dark', 'Sensitivity',.982);
    hDetectFilled = viscircles(bluecenters,radii,'EdgeColor','blue');
    temp = bluecenters(1,2);
    if(temp<45)        
       disp('0')
    elseif(temp<90)
       disp('1')
    elseif (temp<135)
       disp('2')
    elseif(temp<185)
       disp('3')
    else
        disp('no match' )
    end

end
pause(2)
close(4:15);
figure(2);

hBlack = viscircles(blackCenters,radiiBlack,'EdgeColor','black');