clear all; close all; clc;
load Testdata

L=15; % spatial domain
n=64; % Fourier modes
x2=linspace(-L,L,n+1); x=x2(1:n); y=x; z=x;
k=(2*pi/(2*L))*[0:(n/2-1) -n/2:-1]; ks=fftshift(k);
[X,Y,Z]=meshgrid(x,y,z);
[Kx,Ky,Kz]=meshgrid(ks,ks,ks);

%plot the original spectrum
Un(:,:,:)=reshape(Undata(20,:),n,n,n);
figure(1) 
isosurface(X,Y,Z,abs(Un),0.4)
axis([-20 20 -20 20 -20 20]), grid on, drawnow
xlabel('X');
ylabel('Y');
zlabel('Z');
title('Noisy spectrum');

%average the spectrum
Uave = zeros(n,n,n);
for j=1:20
Un(:,:,:)=reshape(Undata(j,:),n,n,n);
Utn(:,:,:) = fftn(Un(:,:,:));
Uave = Uave + Utn(:,:,:);
end
Uave = abs(fftshift(Uave)) / 20;
figure(2) 
isosurface(X,Y,Z,Uave./max(Uave),0.8)
axis([-5 5 -5 5 -5 5]), grid on, drawnow
xlabel('kx');
ylabel('ky');
zlabel('kz');
title('Averaged Spectrum in frequency domain');

%find the center frequency
[M,I] = max(Uave(:));
[kx, ky, kz] = ind2sub([64,64,64], I);
K_center = [Kx(kx,ky,kz), Ky(kx,ky,kz), Kz(kx,ky,kz)];

%filter the spectrum and plot the position
filter = exp(-1*((Kx - K_center(1)).^2 + (Ky - K_center(2)).^2 + (Kz - K_center(3)).^2));
loc = zeros(20,3);
for i= 1:20
Un(:,:,:)=reshape(Undata(i,:),n,n,n);
Utn(:,:,:) = fftn(Un(:,:,:));
Uf(:,:,:) = fftshift(Utn(:,:,:)).* filter;
Unf(:,:,:) = ifftn(Uf(:,:,:));

[C,D] = max(Unf(:));
[Dx, Dy, Dz] = ind2sub([64,64,64], D);
loc(i,:) = [X(Dx,Dy,Dz), Y(Dx,Dy,Dz), Z(Dx,Dy,Dz)];
end 

figure(3)
plot3(loc(:,1), loc(:,2), loc(:,3), 'k->', 'Linewidth', 3);
axis([-20 20 -20 20 -20 20]);
xlabel('X');
ylabel('Y');
zlabel('Z');
title('Marble position');
grid on

loc_20 = loc(20,:);
