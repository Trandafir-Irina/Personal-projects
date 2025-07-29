function [] = filtru_invers_caz_continuu(poza,a,T,eps)
    % Functie pentru aplicarea filtrului invers
    % I: poza - imaginea perturbata cu zgomot si efect de miscare
    %           presupusa a fi grascale (1 plan)
    %    a - viteza constanta cu care se deplaseaza senzorul
    %    T - intervalul de timp in care se deplaseaza senzorul
    %    eps - vecinatatea lui zero pentru filtrul invers
    % E: -
    % Exemple de apel:
    % filtru_invers_caz_continuu('Lenna_mono_MB_continuu_0.01_1.bmp',0.01,1,0.001)

    I=imread(poza);
    [m,n]=size(I);
    J = double(I);

    %trecere in domeniul de frecvente pentru aplicarea filtrului invers
    gTFD=fft2(double(J));
    hTFD=motion_blur_caz_continuu(m,n,a,T);
    
    %aplicare filtru invers
    citi=0;     %pe citi pixeli se face calculul
    fTFD=gTFD;
    for i=1:m
        for j=1:n
            if abs(hTFD(i,j))> eps
                fTFD(i,j)= gTFD(i,j) / hTFD(i,j);
                citi=citi+1;
            end;
        end;
    end;

    %revenire in domeniul spatial
    rez=uint8(real(ifft2(fTFD)));

    figure
        imshow(I);
        title('Imaginea initiala (perturbata)');

    figure
        imshow(rez);
        title(['Rezultatul aplicarii filtrului invers (pe ' num2str(100*citi/(m*n)) '% pixeli)']);
        
    [nume,ext]=strtok(poza,'.');
    [a,av] = strtok(num2str(a),'.');
    [T,Tv] = strtok(num2str(T),'.');
    av = av(~ismember(av, '.'));
    Tv = Tv(~ismember(Tv, '.'));
    if ~isempty(av)
        av = [',' av];
    end;
    if ~isempty(Tv)
        Tv = [',' Tv];
    end;
    fo=[nume '_I_' a av '_' T Tv ext];
    imwrite(rez,fo);
end



