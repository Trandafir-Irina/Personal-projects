function [ ] = to_gray( nrp,tip )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
k = 1;
    while k<=nrp
        p = imread([ num2str(k) '.' tip]);
        p = rgb2gray(p);
        imwrite(p, [ num2str(k) '.' tip], tip);
        k = k+1;
    end;
end

