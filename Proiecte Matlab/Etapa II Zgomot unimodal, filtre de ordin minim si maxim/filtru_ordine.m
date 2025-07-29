function [] = filtru_ordine(nume_poza, tip, minSauMax, d)
% filtru_ordine e o functie care aplica filtru de ordine minim sau maxim
% nume_poza - numele pozei ce va fi prelucrata
% tip - tipul pozei ce va fi prelucrata
% minSauMax - 0 pentru filtru de ordine minim, orice alta valoare pentru
% filtru de ordine maxim
% d - dimensiunea filtrului

% Exemplu de apel:
% filtru_ordine('Lena piper zg', 'png', 1, 3);

im = imread(nume_poza, tip);
[m,n,~] = size(im);

figure
    imshow(im);
    title('Imaginea de restaurat');

t = (d+1)/2;
l = m+d-1;
c = n+d-1;
ime = zeros(l,c);
f = zeros(l,c);
ime(t:m+t-1,t:n+t-1,:) = im(:,:);

for i=1:m
    for j=1:n
        subim = ime(i:i+d-1, j:j+d-1);
        elem = reshape(subim, [d*d 1]);
        if minSauMax == 0
            minEl = min(elem);
            f(i+t+1, j+t+1) = minEl;
        else
            maxEl = max(elem);
            f(i+t-1, j+t-1) = maxEl;
        end;
    end;
end;

im = uint8(f(t:m+t-1,t:n+t-1,:));

figure
    imshow(im);
    title('Imaginea restaurata');
    imwrite(im, [nume_poza ' restaurata.' tip], tip);

end

