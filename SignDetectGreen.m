function outputG = SignDetectGreen(Irgb, outputY)
% Generatie invert C.
load('Greenrgb.mat');
IC = inv(covGreenrgb);
MeanVector = mGreenrgb;
% Get the number of rows and coloums of the image.
[r,c,p] = size(Irgb);
% Calculate the metrix of image with each pixel - the mean of each color
% row.
imc(:,:,1) = Irgb(:,:,1) - MeanVector(1);
imc(:,:,2) = Irgb(:,:,2) - MeanVector(2);
imc(:,:,3) = Irgb(:,:,3) - MeanVector(3);
% Use the loop to calculate the Map.
for i = 1:r
    for j = 1:c
        Pix = [imc(i,j,1) imc(i,j,2) imc(i,j,3)];
        Map(i,j) = Pix * IC * Pix';
    end
end
% Calculate the Mahalanobis Distance Map.
MDMap = sqrt(Map);
% Use the threshold to generate the Thresholded Mahalanobis Distance Map.
MM = MDMap < 10;
% Close the MDMap use the shape "square"
SEG = strel('square',2);
FOG = imclose(MM, SEG);
Glabel = bwlabel(FOG);
Glmax = max(max(Glabel));
outputG = outputY;
% Filter the result
for i = 1:Glmax
    [r,c] = find(Glabel == i);
    if length(r) > 100
        outG = Glabel == i;
        sum_v = sum(outG);
        sum_h = sum(outG');
        f_v = find(sum_v, 1, 'first');
        l_v = find(sum_v, 1, 'last');
        f_h = find(sum_h, 1, 'first');
        l_h = find(sum_h, 1, 'last');        
        long = l_h - f_h;
        wide = l_v - f_v;        
        if long < wide  
        outputG(f_h-2:f_h, f_v:l_v, 1) = 1;
        outputG(f_h-2:f_h, f_v:l_v, 2) = 0;
        outputG(f_h-2:f_h, f_v:l_v, 3) = 0;
        outputG(l_h:l_h+2, f_v:l_v, 1) = 1;
        outputG(l_h:l_h+2, f_v:l_v, 2) = 0;
        outputG(l_h:l_h+2, f_v:l_v, 3) = 0;
        outputG(f_h:l_h, f_v-2:f_v, 1) = 1;
        outputG(f_h:l_h, f_v-2:f_v, 2) = 0;
        outputG(f_h:l_h, f_v-2:f_v, 3) = 0;
        outputG(f_h:l_h, l_v:l_v+2, 1) = 1;
        outputG(f_h:l_h, l_v:l_v+2, 2) = 0;
        outputG(f_h:l_h, l_v:l_v+2, 3) = 0;   
        end
    end
end
return