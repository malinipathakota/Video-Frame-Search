addpath('./provided_code/');
load('twoFrameData.mat'); 
imageindices = selectRegion(im1, positions1); 
results = []; 

for i = 1:size(imageindices)
    eucdist = dist2(descriptors1(imageindices(i),:),descriptors2(:,:));
    [~,x] = find(eucdist < 0.20);
    results = [results x];
end

figure
imshow(im2); 
displaySIFTPatches(positions2(results,:),scales2(results),orients2(results),im2); 