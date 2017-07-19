function outputR = SignDetectRed(Irgb, outputG)
% Generatie invert C.
load('Redrgb.mat');
IC = inv(covRedrgb);
MeanVector = mRedrgb;
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
MM = MDMap < 3;
% Close the MDMap use the shape "octagon"
SER = strel('octagon',6);
FOR = imclose(MM, SER);
Rlabel = bwlabel(FOR);
Rlmax = max(max(Rlabel));
outputR = outputG;
% Filter the result
for i = 1:Rlmax
    [r,c] = find(Rlabel == i);
    if length(r) > 200
        outR = Rlabel == i;
        sum_v = sum(outR);
        sum_h = sum(outR');
        f_v = find(sum_v, 1, 'first');
        l_v = find(sum_v, 1, 'last');
        f_h = find(sum_h, 1, 'first');
        l_h = find(sum_h, 1, 'last');        
        outputR(f_h-2:f_h, f_v:l_v, 1) = 1;
        outputR(f_h-2:f_h, f_v:l_v, 2) = 0;
        outputR(f_h-2:f_h, f_v:l_v, 3) = 0;
        outputR(l_h:l_h+2, f_v:l_v, 1) = 1;
        outputR(l_h:l_h+2, f_v:l_v, 2) = 0;
        outputR(l_h:l_h+2, f_v:l_v, 3) = 0;
        outputR(f_h:l_h, f_v-2:f_v, 1) = 1;
        outputR(f_h:l_h, f_v-2:f_v, 2) = 0;
        outputR(f_h:l_h, f_v-2:f_v, 3) = 0;
        outputR(f_h:l_h, l_v:l_v+2, 1) = 1;
        outputR(f_h:l_h, l_v:l_v+2, 2) = 0;
        outputR(f_h:l_h, l_v:l_v+2, 3) = 0;
    end
end
return