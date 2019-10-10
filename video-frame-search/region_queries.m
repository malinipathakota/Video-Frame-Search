addpath('./provided_code/');
siftdir = './sift';
framesdir = './frames';

chosenImage = 1200;
fprintf('Chosen Frame: friends_000000%d.jpeg\n', chosenImage+59);

fname = [siftdir '/' fnames(chosenImage).name];
load(fname, 'imname', 'descriptors', 'positions', 'scales', 'orients');
    
imname = [framesdir '/' imname];
im1 = imread(imname);
 

reg_dis=selectRegion(im1, positions);
selectdescip=descriptors(reg_dis,:);

r_distance=dist2(kmean, selectdescip);
[minvec,minindex]=min(r_distance,[],1);
r_n = histc(minindex,edges);
    
clear descriptors positions scales orients im;

r_vec=zeros(length(histogram_matrix),1);
for i=1:length(histogram_matrix)
    r_a=histogram_matrix(i,:);
    r_sim=(sum(r_n .* r_a))/(sqrt(sum(r_n.^2))*sqrt(sum(r_a.^2)));
    r_vec(i,1)=r_sim;
end

newsv=sort(r_vec,'descend');
[sortedValues,sortIndex] = sort(r_vec,'descend');  
ii=1;
TF=isnan(newsv(ii));
while (TF==1)
    ii=ii+1;
    TF=isnan(newsv(ii));
end
maxIndex = sortIndex(ii:ii+5);

figure;
for j=2:6
    i=maxIndex(j);
    
    fprintf('Frame: %d\n', i);
    
    fname = [siftdir '/' fnames(i).name];
    load(fname, 'imname', 'descriptors', 'positions', 'scales', 'orients');
    
    imname = [framesdir '/' imname];
    im = imread(imname);
 
    subplot(5,1,j-1);
    imshow(im);

    clear descriptors positions scales orients im 
end   
   
