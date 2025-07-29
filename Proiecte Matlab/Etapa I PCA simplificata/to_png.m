function [] = to_png(nrp, nri, nrs)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    k = 0;
    while k<nrp
        k = k+1;
        poza = imread([num2str(nri) '.pgm']);
        nri = nri+1;
        imwrite(poza, [num2str(nrs) '.png'],'png');
        nrs = nrs+1;
    end;
end

