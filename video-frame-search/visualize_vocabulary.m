addpath('./provided_code/');
siftdir = './sift';
framesdir = './frames';
fnames = dir([siftdir '/*.mat']);

N = 30;

start = 1;
frame=60;
matrix=zeros(197520,128);
mvec=zeros(197520,1);

fprintf('\nAnalyzing images takes approximately 7 mins!\n\n')

for i=1:length(fnames)
    fname = [siftdir '/' fnames(i).name];
    load(fname, 'imname', 'descriptors', 'positions', 'scales', 'orients');
    numfeats = size(descriptors,1);
    if(numfeats<30)
        frame=frame+1;
        clear descriptors positions scales orients im
        continue;
    end
    
    endm=start+29;
    %fprintf('reading frame %d of %d\n', i+59, length(fnames)+59);
    index = randsample(1:size(descriptors,1), N);
    b = descriptors(index,:);
   
    matrix(start:endm,:)=b;
    mvec(start:endm,1)=frame;
    start=start+30;
    
    clear descriptors positions scales orients im
    frame=frame+1;
end

matrix1=matrix(1:197520,:);
mvec=mvec(1:197520,:);
[member,kmeans,rms]=kmeansML(1500,matrix1');
kmean=kmeans';
save('kMeans.mat','kmean') 
count = 0;

for i=1:600
    fname = [siftdir '/' fnames(i).name];
    load(fname, 'imname', 'descriptors', 'positions', 'scales', 'orients');
    
    comparedis=dist2(kmean(500,:), descriptors);
    [minValue,index]=min(comparedis);
    
    %fprintf('reading FRAME %d of %d\n', i+59, length(fnames)+59);
    
    if minValue < 0.30
        count = count + 1;
        imname = [framesdir '/' imname];
        im = imread(imname);
        im = getPatchFromSIFTParameters(positions(index,:), scales(index), orients(index), rgb2gray(im));
        subplot(5,5,count);
        imshow(im);
        
    end
    
    clear descriptors positions scales orients im
    if count == 25
        break
    end
 
end