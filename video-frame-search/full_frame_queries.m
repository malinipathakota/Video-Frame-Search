addpath('./provided_code/');
siftdir = './sift';
framesdir = './frames';
fnames = dir([siftdir '/*.mat']);

fprintf('\nAnalyzing images takes approximately 7 mins!\n\n')

originalImage = 335;
fprintf('Chosen Frame: friends_000000%d.jpeg\n', originalImage+59);

edges=1:1500;
histogram_matrix=zeros(length(fnames),1500);

for i=1:length(fnames)
    
    %fprintf('reading frame %d of %d\n', i, length(fnames));
    
    fname = [siftdir '/' fnames(i).name];
    load(fname, 'imname', 'descriptors', 'positions', 'scales', 'orients');
    numfeats = size(descriptors,1);
    distance=dist2(kmean, descriptors);
    [minvec,minindex]=min(distance,[],1);
    n = histc(minindex,edges);
    
    histogram_matrix(i,:)=n;
    
    clear descriptors positions scales orients im
    
end

find_hist=histogram_matrix(originalImage,:);
sim_vec=zeros(length(histogram_matrix),1);
for i=1:length(histogram_matrix)
    a=histogram_matrix(i,:);
    sim=(sum(find_hist .* a))/(sqrt(sum(find_hist.^2))*sqrt(sum(a.^2)));
    sim_vec(i,1)=sim;
end

newsv=sort(sim_vec,'descend');
[sortedValues,sortIndex] = sort(sim_vec,'descend');  
ii=1;
TF=isnan(newsv(ii));
while (TF==1)
    ii=ii+1;
    TF=isnan(newsv(ii));
end
maxIndex = sortIndex(ii:ii+6);

for j=2:6
    i=maxIndex(j);
    
    fprintf('Similar Frame %d of %d\n', i+59, length(fnames));
    
    fname = [siftdir '/' fnames(i).name];
    load(fname, 'imname', 'descriptors', 'positions', 'scales', 'orients');
    
    imname = [framesdir '/' imname];
    im = imread(imname);
 
    subplot(5,1,j-1);
    imshow(im);
  
    clear descriptors positions scales orients im 
end   