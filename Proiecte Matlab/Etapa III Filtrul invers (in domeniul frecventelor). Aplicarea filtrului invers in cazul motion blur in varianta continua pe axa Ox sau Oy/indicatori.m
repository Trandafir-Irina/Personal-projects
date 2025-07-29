function [] = indicatori( poza_o, poza_p, poza_r )
    % calcul SNR si RMI pentru imagine perturbata / restaurata fata de orig.
    % toate imaginile sint tip gray-scale
	% I: poza_o - fisier cu imaginea clara, neperturbata
    %    poza_p - fisier cu imaginea perturbata
    %    poza_r - fisier cu imaginea restaurata
    % E: - 
    % Exemple de apel:
    % indicatori('Lenna_mono.bmp','Lenna_mono_MB_continuu_0,04_1.bmp','Lenna_mono_MB_continuu_0,04_1_I_0,02_1.bmp');
    % indicatori('Lenna_mono.bmp','Lenna_mono_MB_continuu_0,04_1.bmp','Lenna_mono_MB_continuu_0,04_1_I_0,08_1.bmp');
    % indicatori('Lenna_mono.bmp','Lenna_mono_MB_continuu_0,04_1.bmp','Lenna_mono_MB_continuu_0,04_1_I_0,04_1.bmp');
    
    a=SNR(poza_p,poza_o);
    b=SNR(poza_r,poza_o);
    c=RMI(poza_p,poza_o);
    d=RMI(poza_r,poza_o);
    
    disp(['SNR: P: ' num2str(a) ' - R: ' num2str(b)]);
    disp(['RMI: P: ' num2str(c) ' - R: ' num2str(d)]);
end

