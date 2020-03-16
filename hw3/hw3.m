clear all; close all; clc;
load('cam1_1.mat')
load('cam2_1.mat')
load('cam3_1.mat')
load('cam1_2.mat')
load('cam2_2.mat')
load('cam3_2.mat')
load('cam1_3.mat')
load('cam2_3.mat')
load('cam3_3.mat')
load('cam1_4.mat')
load('cam2_4.mat')
load('cam3_4.mat')

n11=size(vidFrames1_1,4);
n21=size(vidFrames2_1,4);
n31=size(vidFrames3_1,4);
n12=size(vidFrames1_2,4);
n22=size(vidFrames2_2,4);
n32=size(vidFrames3_2,4);
n13=size(vidFrames1_3,4);
n23=size(vidFrames2_3,4);
n33=size(vidFrames3_3,4);
n14=size(vidFrames1_4,4);
n24=size(vidFrames2_4,4);
n34=size(vidFrames3_4,4);

[x11,y11] = trackmotion(n11,vidFrames1_1,300,400,200,400);
[x21,y21] = trackmotion(n21,vidFrames2_1,200,350,100,350);
[x31,y31] = trackmotion(n31,vidFrames3_1,200,500,200,350);

[x12,y12] = trackmotion(n12,vidFrames1_2,300,400,200,400);
[x22,y22] = trackmotion(n22,vidFrames2_2,200,400,100,350);
[x32,y32] = trackmotion(n32,vidFrames3_2,250,500,200,320);

[x13,y13] = trackmotion(n13,vidFrames1_3,300,400,200,400);
[x23,y23] = trackmotion(n23,vidFrames2_3,200,450,150,350);
[x33,y33] = trackmotion(n33,vidFrames3_3,200,500,200,350);

[x14,y14] = trackmotion(n14,vidFrames1_4,300,400,200,400);
[x24,y24] = trackmotion(n24,vidFrames2_4,200,400,100,350);
[x34,y34] = trackmotion(n34,vidFrames3_4,250,500,150,300);



x21 = x21(10:end);
y21 = y21(10:end);

x22 = x22(20:end);
y22 = y22(20:end);

x13=x13(5:end);
y13=y13(5:end)
x23=x23(35:end);
y23=y23(35:end);

x24=x24(5:end);
y24=y24(5:end);

PCAplot(x11,x21,x31,y11,y21,y31,1,2);
title('Case1 with PCA');
PCAplot(x12,x22,x32,y12,y22,y32,3,4);
title('Case2 with PCA');
PCAplot(x13,x23,x33,y13,y23,y33,5,6);
title('Case3 with PCA');
PCAplot(x14,x24,x34,y14,y24,y34,7,8);
title('Case4 with PCA');

function [x,y] = trackmotion(n,m,a,b,c,d)
    x=[];y=[];
    for j = 1 : n
        x1 = double(rgb2gray(m(:,:,:,j)));
        x1(:,1:a)=0; x1(:,b:end)=0; 
        x1(1:c,:)=0; x1(d:end,:)=0;
        [V,I] = max(x1(:));
        [a1,b1] = find(x1 >= 11 * V /12);
        x(j) = mean(a1);
        y(j) = mean(b1);
    end     
end

function PCAplot(x1,x2,x3,y1,y2,y3,a,b)
    l = min([length(x1),length(x2),length(y3)]);
    A = [x1(1:l); y1(1:l); x2(1:l); y2(1:l); x3(1:l); y3(1:l)];
    [m,n] = size(A);
    mn = mean(A,2);
    A = A-repmat(mn,1,n);
    [u,s,v] = svd(A,'econ');
    figure(a)
    plot(diag(s)/sum(diag(s)),'ro')
    xlabel('Principal Component');
    ylabel('Energy Percentage');
    figure(b)
    plot(v*s)
    legend('comp1','comp2','comp3','comp4','comp5','comp6')
    xlabel('Time')
    ylabel('Position')
end

