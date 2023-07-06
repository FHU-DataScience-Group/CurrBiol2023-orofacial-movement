<Computing environment>
・OS: MacOS version13.4.1
・MATLAB (version:R2023a (9.14.0)).

MATLAB codes for prediction (Figure 1H).

run_me1_make_features.m
calculates feateres and generates features.mat
This code requires expert_data.mat generated by the codes in "preprocess" folder.
Requirement: Signal Processing Toolbox

run_me2_classification.m
classifies CP wv RW using features calculated using run_me1_make_features.m.
The features for the classification can be set at Line 4:
features='pc1';
You can choose features by set one of 'pc1', 'protraction', 'cumwhisk', 'protraction_cumwhisk'
Requirement: Statistics and Machine Learning Toolbox