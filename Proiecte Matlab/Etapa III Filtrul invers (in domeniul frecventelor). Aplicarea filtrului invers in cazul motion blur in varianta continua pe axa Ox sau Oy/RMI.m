function [ rez ] = RMI( poza1, poza2 )
    % indicatorul raport informatie mutuala intre poza1 si poza2
    % rmi=(entropie(poza1)+entropie(poza2)-entropie comuna)/entropie(poza1)
    % imagini cu aceleasi dimensiuni
    % I: poza 1 - numele fisierului cu prima imagine
    %    poza 2 - numele fisierului cu a doua imagine
    % E: rez - valoarea indicatorului
    % Exemplu de apel:
    %   rmi=RMI('car-mb3-frecv-mb3-fr-0.0001.png','car-gray.png');
    
    I1=imread(poza1);
    [m,n,p]=size(I1);
    I2=imread(poza2);
    [m1,n1,p1]=size(I2);
    if m~=m1 || n~=n1
        rez=0;
    else
        if p>1
            I1=rgb2gray(I1);
        end;
        A=double(I1);
        if p1>1
            I2=rgb2gray(I2);
        end;
        B=double(I2);
        
        % calcul probabilitati (histograme) A, B, comun A B
        [pa,pb,pab]=probabilitati(A,B);
        L=256;
        % calcul entropie A
        hA=0;
        for i=1:L
            if pa(i)
                hA=hA-pa(i)*log(pa(i));
            end
        end
        % calcul entropie B
        hB=0;
        for i=1:L
            if pb(i)
                hB=hB-pb(i)*log(pb(i));
            end
        end
        % calcul entropie comuna
        hAB=0;
        for i=1:L
            for j=1:L
                if pab(i,j)
                    hAB=hAB-pab(i,j)*log(pab(i,j));
                end
            end
        end
        % calcul valoare RMI
        rez=(hA+hB-hAB)/hA;
    end;
    
end

function [pa,pb,pab] = probabilitati(A,B)
    % probabilitati culori in A, B, comun A B (histograme)
    % imaginile au aceleasi dimensiuni
    % I: A - imagine (un plan)
    %    B - imagine (un plan)
    % E: pa - probabilitati A, pb - probabilitati B
    %    pab - probabilitati comune A B
    
    L=256;  % numar niveluri culoare
    [m,n]=size(A);
    pab=zeros(L,L);
    for i=1:m
        for j=1:n
            pab( A(i,j)+1, B(i,j)+1 ) = pab( A(i,j)+1 , B(i,j)+1 ) + 1;
        end;
    end;
    sumab=sum(sum(pab));
    pab=pab/sumab;
    
    pa=sum(pab,2);  % pa=histograma(A);
    pb=sum(pab,1);  % pb=histograma(B);
end

function p=histograma(I)
    % histograma unei imagini (un plan) - probabilitati culori
    % I: I - imagine (un plan)
    % E: p - vector histograma (probabilitati)
    
    [m,n]=size(I);
    L=256;
    p=zeros(L,1);
    for i=1:m
        for j=1:n
            p( I(i,j)+1 )=p( I(i,j)+1 ) + 1;
        end;
    end;
    ss=sum(p);
    p=p/ss;
end


