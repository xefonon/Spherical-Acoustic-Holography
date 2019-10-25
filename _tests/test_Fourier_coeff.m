% test calcul coefficients de Fourier

clear; clc; 
close all

%% initialisation
% matlabhome = 'H:\Mes documents\5A\Projet_5A\19_10_spherical_NAH\';
matlabhome = 'D:\Users\e152210\19_10_spherical_NAH\';
simu_path = [matlabhome 'simulation\'];
plot_path = [matlabhome 'plot\'];
sph_func_path = [matlabhome 'spherical_functions\'];
data_path = [matlabhome 'data\'];

addpath(plot_path);
addpath(sph_func_path);
addpath(simu_path);
addpath(data_path);

%% param�tres
sim_method = 'GN';
a = 15e-2;
% fr�quence de travail [Hz]
f = 1000;
% Maximum order (Bessel, Hankel, SH)
Nmax = 6;

%%% Autres param�tres
% d�bit de la source [m^3/s]
Q = 1e-3;
% masse volumique du milieu
rho = 1;
% c�l�rit� du milieu 
c = 340;

% position source
xs = 0;
ys = 0;
zs = 0.5;




%% chargemet des positions des micros
Nmic = 36;
filename =  '3Dcam36Officiel.txt';
fID = fopen([data_path filename],'r');
sizeA = [Nmic 3];
mic_loc_tmp = fscanf(fID,'%f');
fclose(fID);

Rm = transpose(reshape(mic_loc_tmp,[3 Nmic]));  
dointerp = 1;



%% Calcul de la pression simul�e

pp_simu = struct('MaxOrder',Nmax,...
               'freq',f,...
               'SphereRadius',a,...
               'c',c,...
               'rho',rho,...
               'Q',Q,...
               'method',sim_method,...
               'doplot',0);
Rs = [xs ys zs];            
[P] = generateSimu(Rm,Rs,pp_simu);    

%% calcul des harmoniques sph�riques

[az,elev,r] = cart2sph(Rm(:,1),Rm(:,2),Rm(:,3));

idx_SH = 1;

for n = 0 : Nmax    
    for m = -n : n
        for imic = 1 : Nmic
            Ymn(imic,idx_SH) = getSphericalHarmonics(elev(imic),az(imic),n,m);
        end
        idx_SH = idx_SH+1;
    end    
end

%% Calcul des coefficients de Fourier

[Pmn,cond] = SphericalFourierCoeff(Ymn,P);

