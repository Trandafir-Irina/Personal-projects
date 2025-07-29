function [hTFD]=motion_blur_caz_continuu(l,c,a,T)
    % calcularea perturbarii tip miscare continua pe directia x 
    % in domeniul de frecvente
    % I: l,c - dimensiuni matrice perturbare (nr. linii / nr. coloane)
    %    a - viteza constanta cu care se deplaseaza senzorul pe X
    %    T - intervalul de timp in care se deplaseaza senzorul la achizitia
    %    imaginii
    % E: hTFD - matricea perturbare (impuls) in domeniul de frecvente
    
    hTFD=zeros(l,c);
    for n=1:l
        for m=1:c
            hTFD(n,m)=(T*sin(pi*n*a))/(pi*n*a)*exp(-pi*1i*n*a);
        end;
    end;
    
end

