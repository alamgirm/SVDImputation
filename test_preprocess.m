%test preprocess
clc;
clear all;
load('md_pat/adult_test.mat');

[numData, numCols, txtData, txtCols] = pre_process_data(inAllData);


