function [val] = SNR(restaurata,originala)
    % estimare grad de similaritate intre doua imagini utilizind SNR
    % poate fi folosita pentru calcularea SNR in urma filtrarii unei
    % imagini
    % I: restaurata - fisierul cu imaginea restaurata, 
    %    originala - fisierul cu imaginea originala (clara, neperturbata) 
    %    ambele fisiere sint monocrome (gray-scale)
    % E: val - indicatorul SNR
    
    I=imread(restaurata);
    f=double(I(:,:,1));
    [m,n]=size(f);
    J=imread(originala);
    g=double(J(:,:,1));
    s1=0;
    s2=0;
    for i=1:m
        for j=1:n
            s1=s1+f(i,j)^2;
            s2=s2+(f(i,j)-g(i,j))^2;
        end;
    end;
    val=10*log10(s1/s2);
end

