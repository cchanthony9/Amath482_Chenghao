clear all; close all; clc;
%part 1
load handel
v = y'/2; L = 9;
v = v(1:(length(v) - 1)); n = length(v); t = (1:n)/Fs;
k = (2*pi/L)*[0:(n/2-1) -n/2:-1]; ks = fftshift(k);

%Gussian window a = 0.1 translation  0.1
[music3,ts] = gussian(0.1,0.1);
figure(1)
plotfigure(ts,music3);
title ('a=0.1 dt=0.1')

%Gussian window a = 10 translation  0.1
[music3,ts] = gussian(10,0.1);
figure(2)
plotfigure(ts,music3);
title('a=10 dt=0.1')

%Gussian window a = 50 translation  0.1
[music3,ts] = gussian(50,0.1);
figure(3)
plotfigure(ts,music3);
title('a=50 dt=0.1')

%Gussian window a = 10 translation 0.5
[music3,ts] = gussian(10,0.5);
figure(4)
plotfigure(ts,music3);
title('a=10 dt=0.5')

%Gussian window a = 10 translation  1
[music3,ts] = gussian(10,1);
figure(5)
plotfigure(ts,music3);
title('a=10 dt=1')

%Mexican hat a = 0.1, dt = 0.1
a=0.1;
ts=0:0.1:9;
music3 = [];
for j=1:length(ts)
    g=(2/(sqrt(3*a)*(pi)^(1/4)))*(1-((t-ts(j))/a).^2).*exp(-(t-ts(j)).^2/(2*a^2)); 
    music1=g.*v; 
    music2=fft(music1); 
    music3(j,:) = abs(fftshift(music2)); 
end
figure(6)
plotfigure(ts,music3);
title('mexican hat a=0.1 dt=0.1')

%step function a = 0.1, dt = 0.1
a=0.1;
ts=0:0.1:9;
music3 = [];
for j=1:length(ts)
    g=(abs(t-ts(j))<a);
    music1=g.*v; 
    music2=fft(music1); 
    music3(j,:) = abs(fftshift(music2)); 
end
figure(7)
plotfigure(ts,music3);
title('step function a=0.1 dt=0.1') clear all; close all; clc;


%part 2
clear all;close all; clc;

y= audioread('music1.wav');
Fs=length(y)/16; 
y=y'/2; L=16;
n=length(y); t=(1:length(y))/Fs;
k=(2*pi/L)*[0:(n/2-1) -n/2:-1]; ks=fftshift(k);
a = 10;
ts = 0:0.1:16;
music3 = [];
ff = [];
for j = 1 : length(ts)
    g = exp(-a*(t-ts(j)).^2); 
    music1 = g.*y;
    music2 = fft(music1);
    music3(j,:) = abs(fftshift(music2));
    [M, I] = max(abs(music2));
    ff = [ff; abs(k(I))/(2*pi)];
end
figure(1)
plot(ts, ff)
xlabel('Time')
ylabel('Frequency')
title('center frequency')

figure(2)
pcolor(ts, ks/(2*pi) ,music3.'), shading interp
set(gca,'Ylim', [100 500],'Fontsize', [12])
xlabel('Time')
ylabel('Frequency')
colormap(hot)
title('spectrogram')

y= audioread('music2.wav');
Fs=length(y)/14; 
y=y'/2; L=14;
n=length(y); t=(1:length(y))/Fs;
k=(2*pi/L)*[0:(n/2-1) -n/2:-1]; ks=fftshift(k);
a = 10;
ts = 0:0.1:14;
music3 = [];
ff = [];
for j = 1 : length(ts)
    g = exp(-a*(t-ts(j)).^2); 
    music1 = g.*y;
    music2 = fft(music1);
    music3(j,:) = abs(fftshift(music2));
    [M, I] = max(abs(music2));
    ff = [ff; abs(k(I))/(2*pi)];
end
figure(3)
plot(ts, ff)
xlabel('Time')
ylabel('Frequency')
title('center frequency')

figure(4)
pcolor(ts,ks/(2*pi),music3.'), shading interp
set(gca,'Ylim', [600 1200],'Fontsize', [12])
xlabel('Time')
ylabel('Frequency')
colormap(hot)
title('spectrogram')


function [music3,ts] = gussian(a,dt)
    load handel
    v = y'/2; L = 9;
    v = v(1:(length(v) - 1));
    n = length(v); t = (1:n)/Fs;
    k = (2*pi/L)*[0:(n/2-1) -n/2:-1]; ks = fftshift(k);
    music3 = [];
    ts = 0:dt:9;
    for j = 1:length(ts)
    g = exp(-a*(t-ts(j)).^2); 
    music1 = v.*g; 
    music2 = fft(music1); 
    music3(j,:) = abs(fftshift(music2)); 
    end
end

function plotfigure(ts, music3)
    load handel
    v = y'/2; L = 9;
    v = v(1:(length(v) - 1));
    n = length(v); t = (1:n)/Fs;
    k = (2*pi/L)*[0:(n/2-1) -n/2:-1]; ks = fftshift(k);
    pcolor(ts,ks,music3.'), shading interp 
    xlabel('Time')
    ylabel('Frequency')
    colormap(hot)
end





