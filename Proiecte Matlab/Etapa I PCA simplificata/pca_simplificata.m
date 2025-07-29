function [rez, vect_compresie, medie, er]=pca_simplificata(nrp, tip, nrc)
    % Comprimarea unui set de imagini prin retinerea unui numar mic de
    % componente principale. Imaginile sint in nuante de gri (1 singur
    % plan) si au toate ACEEASI DIMENSIUNE si TEMATICA. Imaginile au
    % dimensiuni MICI
    % I: nrp - numarul de imagini,
    %    tip - tipul fisierelor imagine,
    %    nrc - numarul de componente pastrate (<<lin*col)
    % E: rez - cod de terminare a operatiei (0=succes, 1=imagini cu
    %    dimensiuni diferite, 2=imagini cu mai mult de un plan)
    %    er - eroarea (medie pe pixel)
    %    vect_compresie - vectorii de compresie, componentele principale
    %    medie - vectorul (imaginea) medie ((m*n)*1)
   
    % Exemplu de apel:
    %   [rez,~,~,er]=pca_simplificata(400,'png',250);
   
    % incarcare imagini cu verificarea dimensiunilor si numarului de plane
    k=0;
    rez=0;
    while k<nrp && ~rez
        k=k+1;
        fi=[num2str(k) '.' tip]; %num2str din numar in sir de caractere
        poza=imread(fi);
        [m,n,p]=size(poza); % p e nr de plane
        if p>1
            rez=2;                              %imagine RGB
        else
            if ~exist('imagini','var')         %daca e prima imagine exist cauta daca exista alocata variabila imagini
                imagini=uint8(zeros(m,n,nrp));  %aloca variabila
                m1=m;n1=n;      %pastreaza dim. prima imagine pt. comparatie
            end;
            if m~=m1 || n~=n1                   %alte dimensiuni (daca e diferita de prima)
                rez=1;
            else
                imagini(:,:,k)=poza;            %adauga imagine la masiv 3d
            end;
        end;
    end;
   
% daca au aparut erori la preluarea imaginilor stop
    if rez
        disp(['Imaginea ' num2str(k) 'nu corespunde: ']); % k are nr imaginii la care s-a oprit while-ul (la care s-a produs eroarea)
        if rez==1
            disp('Are dimensiuni diferite');
        else
            disp('Are mai mult de un plan');
        end;

    else
        % altfel se prelucreaza imaginile
        p=m*n; % de aici incolo p este m*n
        % liniarizarea imaginilor initiale, pe linii (lexicografic)
        im_lin=zeros(p,nrp);
        for k=1:nrp    
            im_lin(:,k)=reshape(imagini(:,:,k)',[1 m*n]); %functie pentru liniarizare, reshape merge pe coloane, [1, m*n] este tuplu
        end;
       
        % calcul medie si centrare date
        medie=mean(im_lin,2);   % 2 - media coloanelor
        for k=1:nrp
            im_lin(:,k)=im_lin(:,k)-medie;
        end;
        
        %varianta pentru calculul matricei de covarianta:%%%%%%%%%%%%
        ss = im_lin'*im_lin;
        ss = (1/(nrp-1))*ss;

        % determinarea componentelor principale si retinerea primelor nrc
        [V,L]=eig(ss);
        V=V(:, nrp : -1 : nrp-nrc+1); % toate liniile, de la coloana p mergand cu pasul -1 pana la p-nrc+1
        valp=diag(L); %matricea diagonala
        er=sum(valp(1:nrp-nrc));                %eroare absoluta suma valoriilor proprii care nu au fost pastrate
       
        A = (1/sqrt(nrp-1))*im_lin;
        vect_compresie = A*V;
        
        for k = 1:nrc
            if norm(vect_compresie(:,k))>1
                vect_compresie(:,k) = vect_compresie(:,k)/norm(vect_compresie(:,k));
            end;
        end;
        
        % reprezentarea folosind doar componentele retinute
        R=vect_compresie'*im_lin;
     
        % reconstructia imaginilor din reprezentarea cu componentele princ.
        im_noi_l=vect_compresie*R;
       
        % adaugare medie si revenire la forma matriceala
        im_noi=uint8(zeros(m,n,nrp));
        for k=1:nrp
            matrice=reshape( im_noi_l(:,k)+medie, [n m] );
            im_noi(:,:,k)=uint8(matrice');
            figure
                imshow( im_noi(:,:,k) );
                title(['Imaginea ' num2str(k) ' reconstruita']);
            fo=[num2str(k) '_r.' tip];
            imwrite(im_noi(:,:,k),fo,tip);
        end;
    end;
end