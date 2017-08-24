%{
%   Description: Main interface
%
%   author:  Romain Martinez
%   email:   martinez.staps@gmail.com
%   website: github.com/romainmartinez
%}

clear variables; clc; close all

bmch.main;

% TODO: put in main script:
% add case if doesn't exist
load('./cache/cache.mat')

load(sprintf('%s/conf/conf.mat', folder))