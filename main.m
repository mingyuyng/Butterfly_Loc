%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Goal:  Given a piece of light and temperature observation, find the
%          location estimation
%   Data:  .mat file that contains (see example.mat):
%          1.  time_light: array of time stemps for light observations
%          2.  light:  light observations in lux
%          3.  time_temp: array of time stemps for temperature observations
%          4.  temp: temperature observations in C
%   
%   Notes: - Time stemps are in datetime format
%          - Currently, only light intensity part is realized
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath(genpath('./utils'));
fprintf('Add path done !!\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load('example_Mexico_HOMO.mat');
time_unit = 15;    % Target sampling rate, default: 15 seconds
GMT = 6;           % Time zone for time stemps

% Data pre-processing
data_cell = data_preprocessing(light, time_light, time_unit);

% Generate the inputs for Neural Networks
% -- We need to choose the locations to test. Here the test locations are
% generated in a square grid manner
% -- This block is related to the neural nets. So if our method is changed one
% day, I will update this test_generation function

center_long = -100;   % Center of longitude queries 
center_lat = 20;      % Center of latitude queries 
resolution = 0.5;     % Queries's resolution
range = 20;           % Coverage range

filename = './Testdata/Mexico_HOBO';      % Save path
test_generation(data_cell, center_long, center_lat, resolution, range, GMT, filename)

