%% This code evaluates the test set.

% ** Important.  This script requires that:
% 1)'centroid_labels' be established in the workspace
% AND
% 2)'centroids' be established in the workspace
% AND
% 3)'test' be established in the workspace

load('classifierdata.mat');

% IMPORTANT!!:
% You should save 1) and 2) in a file named 'classifierdata.mat' as part of
% your submission.

predictions = zeros(200,1);
outliers = zeros(200,1);


% loop through the test set, figure out the predicted number
for i = 1:200

testing_vector=test(i,:);

% Extract the centroid that is closest to the test image
[prediction_index, vec_distance]= assign_vector_to_centroid(testing_vector,centroids);

predictions(i) = centroid_labels(prediction_index);

end

%% DESIGN AND IMPLEMENT A STRATEGY TO SET THE outliers VECTOR
% outliers(i) should be set to 1 if the i^th entry is an outlier
% otherwise, outliers(i) should be 0


    
% FILL IN
distance = zeros(200,1);
for i = 1:200
    testing_vector=test(i,:);
    [prediction_index, vec_distance]= assign_vector_to_centroid(testing_vector,centroids);
    predictions(i)= centroid_labels(prediction_index);
    distance(i)= vec_distance; 
end 

median_distance = median(distance);
sorted_distance = sort(distance, 'ascend');
quartile_3 = median(sorted_distance(101:200));
quartile_1 = median(sorted_distance(1:100));
interquartile_range = quartile_3 - quartile_1;
upper_bound = quartile_3 + (1.5*interquartile_range);

for i = 1:200
   
    if(distance(i) <= upper_bound)
        outliers(i) = 0;
    else
        outliers(i) = 1; 
    end
end

%% MAKE A STEM PLOT OF THE OUTLIER FLAG
figure;
stem(outliers,'filled','LineWidth',1.5);

%% The following plots the correct and incorrect predictions
% Make sure you understand how this plot is constructed
figure;
plot(correctlabels,'o');
hold on;
plot(predictions,'x');
title('Predictions');

%% The following line provides the number of instances where and entry in correctlabel is
% equatl to the corresponding entry in prediction
% However, remember that some of these are outliers
sum(outliers)
sum(correctlabels==predictions)

function [index, vec_distance] = assign_vector_to_centroid(data,centroids)
differences = centroids(:,1:784) - data(1:784);
distances = sqrt(sum((differences.^2),2)); 
[vec_distance,index] = min(distances);
end