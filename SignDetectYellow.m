function outputY = SignDetectYellow(Irgb, I)
% Generatie invert C.
load('Yellowrgb.mat');
IC = inv(covYellowrgb);
MeanVector = mYellowrgb;
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
MM = MDMap < 2.3;
Ylabel = bwlabel(MM);
Ylmax = max(max(Ylabel));
outputY = I;
% Filter the result
for i = 1:Ylmax
    [r,c] = find(Ylabel == i);
    if length(r) > 200
        outY = Ylabel == i;
        sum_v = sum(outY);
        sum_h = sum(outY');
        f_v = find(sum_v, 1, 'first');
        l_v = find(sum_v, 1, 'last');
        f_h = find(sum_h, 1, 'first');
        l_h = find(sum_h, 1, 'last');
        long = l_h - f_h;
        wide = l_v - f_v;   
        [w,l,p] = size(I);    
        if f_v > 50 && l_v < l-50 && f_h > 50 && l_h < w-50  
            if  wide < 1.5 * long || wide > 1.9 * long
                outputY(f_h-2:f_h, f_v:l_v, 1) = 1;
                outputY(f_h-2:f_h, f_v:l_v, 2) = 0;
                outputY(f_h-2:f_h, f_v:l_v, 3) = 0;
                outputY(l_h:l_h+2, f_v:l_v, 1) = 1;
                outputY(l_h:l_h+2, f_v:l_v, 2) = 0;
                outputY(l_h:l_h+2, f_v:l_v, 3) = 0;
                outputY(f_h:l_h, f_v-2:f_v, 1) = 1;
                outputY(f_h:l_h, f_v-2:f_v, 2) = 0;
                outputY(f_h:l_h, f_v-2:f_v, 3) = 0;
                outputY(f_h:l_h, l_v:l_v+2, 1) = 1;
                outputY(f_h:l_h, l_v:l_v+2, 2) = 0;
                outputY(f_h:l_h, l_v:l_v+2, 3) = 0;
            end 
        end
    end
end
return