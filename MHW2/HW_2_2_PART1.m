
load("MHW2\face_databases\Yale_32x32.mat")


% 
% [nSmp,nFea] = size(fea);
% for i = 1:nSmp
%      fea(i,:) = fea(i,:) ./ max(1e-12,norm(fea(i,:)));
% end
% ===========================================
% Scale the features (pixel values) to [0,1]
% ===========================================
% maxValue = max(max(fea));
% fea = fea/maxValue;

faceW = 32; 
faceH = 32; 
neutral = []; smile = [];
numPerLine_face = 11; 
ShowLine_face =15; 

 




numFaces=165;
faces=transpose(fea)
meanFace = mean(faces, 2);
faces = faces - repmat(meanFace, 1,numFaces);


% meanFace = mean(faces, 2);
% faces = faces - repmat(meanFace, 1, numFaces);

[u,d,v] = svd(faces, 0);
eigVals = diag(d);
eigVecs = u;

h = 32; w = 32;

figure; imshow(reshape(meanFace,faceH,faceW)); title('Mean Face');
figure;
title('First Eigenface');subplot(1, 3, 1); imagesc(reshape(u(:, 1),h, w)); colormap(gray);
title('Second Eigenface'); subplot(1, 3, 2); imagesc(reshape(u(:, 2), h, w)); colormap(gray);
title('Third Eigenface'); subplot(1, 3, 3); imagesc(reshape(u(:, 3), h, w)); colormap(gray);
for i = 1:numFaces
energy(i) = sum(eigVals(1:i));
end
propEnergy = energy./energy(end);

percentMark = min(find(propEnergy > 0.9));
eigenVecs = u(:, 1:percentMark);
smileFaces=zeros(1024,165)
neutralFaces=zeros(1024,165)
neutral=[1,2,4,5,6,7,8,9,10,11]
for i=0:14
    for j=1:10
    neutralFaces(:,i*11+neutral(j)) = faces(:,i*11+neutral(j));
    end
    smileFaces(:,i*11+3) = faces(:,i*11+3);
end
neutralWeights = eigenVecs' * neutralFaces;
smileWeights = eigenVecs' * smileFaces;

for i = 1:165
weightDiff = repmat(smileWeights(:, i), 1, 165) - neutralWeights;
[val, ind] = min(sum(abs(weightDiff), 1));
bestMatch(i) = ind;
val(i)=val
end



for i = 1:165
test_smile=smileWeights(:,i);
distance_smile1=repmat(test_smile,1,(165-1));
distance_smile2=[smileWeights(:,1:i-1) smileWeights(:,i+1:end)];
distance_smile=distance_smile1-distance_smile2;
distance_smile_val(i)=sum(vecnorm(distance_smile))/(165-1);
end

%%
for i = 1:165
test_smile=smileWeights(:,i);
distance_neutral1=repmat(test_smile,1,(165));
distance_neutral2=[neutralWeights];
distance_neutral=distance_neutral1-distance_neutral2;
distance_neutral_val(i)=sum(vecnorm(distance_neutral))/(165);
end

%%
for i = 1:165
   decision(i)=distance_neutral_val(i)>= distance_smile_val(i)
end
sum(decision)/165