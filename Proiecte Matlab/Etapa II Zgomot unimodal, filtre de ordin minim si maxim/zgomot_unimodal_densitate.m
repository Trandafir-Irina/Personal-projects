function [] = zgomot_unimodal_densitate(nume_poza, tip, tip_zgomot, d)
% functie care genereaza zgomot unimodal pentru o poza
% nume_poza - numele pozei careia urmeaza sa ii fie adaugat zgomotul
% tip_zgomot - 0 pentru piper, orice alta valoare pentru sare
% densitate - nr de pixeli alterati in medie, ia valori intre 0 si 1

% Exemple de apel: zgomot_unimodal_densitate('Lena', 'png', 0, 0.1);

im = imread(nume_poza, tip);
figure
    imshow(im);
    title('Imaginea originala');
[m, n, ~] = size(im);
ind_pixeli = randperm(m*n, fix(d*m*n));

for i=1:d*m*n
    [l,c] = ind2sub([m,n],ind_pixeli(i));
    if tip_zgomot == 0
        im(l,c) = 0;
    else 
        im(l,c) = 255;
    end;
end;

figure
    imshow(im);
    title('Imaginea cu zgomot');
    
if tip_zgomot == 0
    imwrite(im, [nume_poza ' densitate piper zg.' tip],tip);
else
    imwrite(im, [nume_poza ' densitate sare zg.' tip],tip);
    
end

