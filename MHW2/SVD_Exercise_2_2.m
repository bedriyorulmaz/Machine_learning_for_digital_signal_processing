close all;
clear all;
%% Read the Training Images
sizeimages = 36;
dirname = [pwd,filesep,'gender_classification/training/men'];
img_count = 0;

% Read the men face images
files_struct = dir(dirname);
train_men_faces = zeros(sizeimages^2,length(files_struct)-2);
for i = 3:length(files_struct)
    filename = files_struct(i).name;
    full_pathname = [dirname, '/', filename];
    img = imread(full_pathname);
    img_count = img_count + 1;
    train_men_faces(:,img_count) = uint8(img(:));
end

sizeimages = 36;
dirname = [pwd,filesep,'gender_classification/training/women'];
img_count = 0;

% Read the women face images
files_struct = dir(dirname);
train_women_faces = zeros(sizeimages^2,length(files_struct)-2);
for i = 3:length(files_struct)
    filename = files_struct(i).name;
    full_pathname = [dirname, '/', filename];
    img = imread(full_pathname);
    img_count = img_count + 1;
    train_women_faces(:,img_count) = uint8(img(:));
end

%% Read the test men and women images and combine them.
sizeimages = 36;
dirname = [pwd,filesep,'gender_classification/testing/women'];
img_count = 0;

% Read the test women face images
files_struct = dir(dirname);
test_women_faces = zeros(sizeimages^2,length(files_struct)-2);
for i = 3:length(files_struct)
    filename = files_struct(i).name;
    full_pathname = [dirname, '/', filename];
    img = imread(full_pathname);
    img_count = img_count + 1;
    test_women_faces(:,img_count) = uint8(img(:));
end

dirname = [pwd,filesep,'gender_classification/testing/men'];
img_count = 0;

% Read the test men face images
files_struct = dir(dirname);
test_men_faces = zeros(sizeimages^2,length(files_struct)-2);
for i = 3:length(files_struct)
    filename = files_struct(i).name;
    full_pathname = [dirname, '/', filename];
    img = imread(full_pathname);
    img_count = img_count + 1;
    test_men_faces(:,img_count) = uint8(img(:));
end

train_faces = [train_men_faces train_women_faces];
test_faces = [test_men_faces test_women_faces];
%% Apply Singular Value Decomposition
[trainEigVec s1 v1] = svd(train_faces);

%% Reduce Eigenvectors
energy = zeros(1,1296);
% The cumulative energy content for the m'th eigenvector is the sum of the energy content across eigenvalues 1:m
for i = 1:1296
    energy(i) = sum(trainEigVec(1:i));
end

propEnergy = energy./energy(end);
% Determine the number of principal components required to model 90% of data variance
percentMark = min(find(propEnergy > 0.9));
% Pick those principal components
trainEigenVec = trainEigVec(:, 1:percentMark);
%% this place takes some time :)
train_weigths = trainEigenVec' * train_faces;
train_men_weights = trainEigenVec' * train_men_faces;
train_women_weigths = trainEigenVec' * train_women_faces;

train_index = zeros(1,5000);
for i= 1:5000
    train_distance_men = min(vecnorm(repmat(train_weigths(:,i),1,2500) - train_men_weights)); 
    train_distance_women = min(vecnorm(repmat(train_weigths(:,i),1,2500) - train_women_weigths));
    %1 shows smile faces, 0 shows neutral faces.
    train_index(i) = (train_distance_men >= train_distance_women);
end
%% Train index shows that 0 is men faces index and 1 is women faces index.
plot(1:2500,train_index(1:2500));
hold on
plot(2501:5000,train_index(2501:5000));
legend('men faces index','women faces index')
ylim([-0.2 1.4])

%As a result, we have separated the men and women faces.
%%
test_index = zeros(1,400);
test_weigths = trainEigenVec' * test_faces;

for i = 1:400
    test_distance_men = min(vecnorm(repmat(test_weigths(:,i),1,2500) - train_men_weights));
    test_distance_women = min(vecnorm(repmat(test_weigths(:,i),1,2500) - train_women_weigths));
    test_index(i) = (test_distance_men >= test_distance_women);
end

predicted_men = test_faces(:,find(~test_index));
predicted_women = test_faces(:,find(test_index));

miscalculated_men = test_faces(:,find(test_index(1:200)));
miscalculated_women = test_faces(:,find(~test_index(201:400)));


