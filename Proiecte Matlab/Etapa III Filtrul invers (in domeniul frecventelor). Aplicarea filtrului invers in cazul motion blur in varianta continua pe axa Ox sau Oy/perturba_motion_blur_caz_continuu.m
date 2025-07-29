function [rez] = perturba_motion_blur_caz_continuu(poza,a, T)
    % Perturba o imagine prin inducerea efectului de miscare in caz 
    % continuu. Imaginea rezultata e salvata intr-un fisier cu numele compus
    % din numele fisierului original si parametrii perturbarii
    % I: poza - numele fisierului care contine imaginea de prelucrat
    %           (se foloseste un plan, format gray-scale)
    %    a - viteza constanta cu care se deplaseaza senzorul pe X
    %    T - intervalul de timp in care se deplaseaza senzorul
    % E: rez - imaginea rezultata (un plan, gray-scale)

    % Exemple de apel 
    % perturba_motion_blur_caz_continuu('Lenna_mono.bmp',0.01,1); 
    % perturba_motion_blur_caz_continuu('Lenna_mono.bmp',0.1,1); 

    J=imread(poza);
	[l,c]=size(J);
    f=double(J);

    % calculul TFD a imaginii 
    fTFD=fft2(f);

    % construirea filtrului
    hTFD=motion_blur_caz_continuu(l,c,a,T);

    % aplicarea perturbarii, in domeniul frecventelor
    gTFD=zeros(l,c);
    for x=1:l
        for y=1:c
            gTFD(x,y)=fTFD(x,y)*hTFD(x,y);
        end;
    end;
    % gTFD=fTFD.*hTFD;

    % calculul imaginii perturbate
    rez=uint8(abs(ifft2(gTFD)));

    % afisarea si salvarea imaginii perturbate
    figure
        imshow(J);
        title('Imaginea initiala');
    figure
        imshow(rez);
        title(['Imaginea peturbata MB continuu pe directia x' ' cu a=' num2str(a) ' si cu T=' num2str(T)]);
        
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
    fo=[nume '_MB_continuu_' a av '_' T Tv ext];
    imwrite(rez,fo);
end
