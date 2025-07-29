function [] = zgomot_unimodal(nume_poza, tip, tip_zgomot, p)
% functie care genereaza zgomot unimodal pentru o poza
% nume_poza - numele pozei careia urmeaza sa ii fie adaugat zgomotul
% tip_zgomot - 0 pentru piper, orice alta valoare pentru sare
% p - probabilitatea in care trebuie sa se regaseasca un pixel pentru a fi
% alterat, ia valori intre 0 si 1

% Exemple de apel: zgomot_unimodal('Lena', 'png', 0, 0.1);

im = imread(nume_poza, tip);
figure
    imshow(im);
    title('Imaginea originala');
[m, n, ~] = size(im);

for i=1:m
    for j=1:n
        r = unifrnd(0,1,1);
        if r < p
            if tip_zgomot == 0
                im(i,j) = 0;
            else 
                im(i,j) = 255;
            end;
        end;
    end;
end;

figure
    imshow(im);
    title('Imaginea cu zgomot');
    
if tip_zgomot == 0
    imwrite(im, [nume_poza ' piper zg.' tip],tip);
else
    imwrite(im, [nume_poza ' sare zg.' tip],tip);
    
end

