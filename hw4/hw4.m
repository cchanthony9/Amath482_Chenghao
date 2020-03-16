clear; close all; clc

%% test 1
[ariana0] = loading("ariana");
[pink0] = loading("pink");
[chopin0] = loading("chopin");
ariana0 = ariana0';
pink0 = pink0';
chopin0 = chopin0';

[U,S,V,threshold1,threshold2,w,sortpop,sortrock,sortclassic,a] = dc_trainer(ariana0,pink0,chopin0,20);

a
threshold1
threshold2

% classify
[pval] = classify("pink4.mp3",U,w)

[pval] = classify("ariana3.mp3",U,w)

[pval] = classify("chopin4.mp3",U,w)

%% test 2
[alice0] = loading("alice");
[pearl0] = loading("pearl");
[soundgarden0] = loading("soundgarden");
alice0 = alice0';
pearl0 = pearl0';
soundgarden0 = soundgarden0';

[U,S,V,threshold1,threshold2,w,sortpop,sortrock,sortclassic,a] = dc_trainer(alice0,pearl0,soundgarden0,20);
a
threshold1 
threshold2

% classify
[pval] = classify("alice3.mp3",U,w)

[pval] = classify("pearl3.mp3",U,w)

[pval] = classify("soundgarden3.mp3",U,w)
%% test 3

[pop0] = loading("pop");
[rock0] = loading("rock");
[classic0] = loading("classic");
pop0 = pop0';
rock0 = rock0';
classic0 = classic0';

[U,S,V,threshold1,threshold2,w,sortpop,sortrock,sortclassic,a] = dc_trainer(pop0,rock0,classic0,20);
a
threshold1 
threshold2

% classify
[pval] = classify("pop3.mp3",U,w)

[pval] = classify("rock3.mp3",U,w)

[pval] = classify("classic4.mp3",U,w)
%% function

function [pval] = classify(songname,U,w)
    song0= [];
    [song,Fs] = audioread(songname);
    song = song'/2;
    song = song(1,:) + song(2,:);
    for j = 20 : 5 : 120
        song1 = song(Fs*j :Fs*(j+5));
        song1_spec = abs(spectrogram(song1));
        song1_spec = reshape(song1_spec, [1,32769*8]);
        song0 = [song0; song1_spec];
    end
    TestMat = U'*song0';  % PCA projection
    pval = w'*TestMat; % LDA projection
end

function [song0] = loading(name)
    song0 = [];
    for i = 1 : 2
        [song,Fs] = audioread(strcat(name,num2str(i),".mp3"));
        song = song'/2;
        song = song(1,:) + song(2,:);
        for j = 20 : 5 : 120
            song1 = song(Fs*j :Fs*(j+5));
            song1_spec = abs(spectrogram(song1));
            song1_spec = reshape(song1_spec, [1,32769*8]);
            song0 = [song0; song1_spec];
        end
    end
end

function [U,S,V,threshold1, threshold2,w,sortpop,sortrock,sortclassic,a] = dc_trainer(pop0,rock0,classic0,feature)
    np = size(pop0,2); nr = size(rock0,2); nc = size(classic0,2);
    
    [U,S,V] = svd([pop0 rock0 classic0],'econ');
    
    SV = S*V'; % projection onto principal components
    U = U(:,1:feature);
    pops = SV(1:feature,1:np);
    rocks = SV(1:feature,np+1:np+nr);
    classics = SV(1:feature, np+nr+1:np+nr+nc);
    
    mp = mean(pops,2);
    mr = mean(rocks,2);
    mc = mean(classics,2);
    m = (mp+mr+mc)/3;
    
    Sw = 0; % within class variances
    for k=1:np
        Sw = Sw + (pops(:,k)-mp)*(pops(:,k)-mp)';
    end
    for k=1:nr
        Sw = Sw + (rocks(:,k)-mr)*(rocks(:,k)-mr)';
    end
    for k=1:nc
        Sw = Sw + (classics(:,k)-mc)*(classics(:,k)-mc)';
    end
    
    Sb = ((mp-m)*(mp-m)' + (mr-m)*(mr-m)'+ (mc-m)*(mc-m)')/3;   % between class 
    
    [V2,D] = eig(Sb,Sw); % linear discriminant analysis
    [~,ind] = max(abs(diag(D)));
    w = V2(:,ind); w = w/norm(w,2);
    
    vpop = w'*pops; 
    vrock = w'*rocks;
    vclassic = w'*classics;
    sortpop = sort(vpop);
    sortrock = sort(vrock);
    sortclassic = sort(vclassic);
    
    if mean(vpop) <= mean(vrock) 
        if mean(vrock) <= mean(vclassic)    % pop < threshold1 < rock < threshold2 < classic
            t1 = length(sortpop);
            t2 = 1;
            while sortpop(t1)>sortrock(t2)
                t1 = t1-1;
                t2 = t2+1;
            end
            threshold1 = (sortpop(t1)+sortrock(t2))/2;
            t3 = length(sortrock);
            t4 = 1;
            while sortrock(t3)>sortclassic(t4)
                t3 = t3-1;
                t4 = t4+1;
            end
            threshold2 = (sortrock(t3)+sortclassic(t4))/2;
            a = 1;
        else
            if mean(vclassic) > mean(vpop)  % pop < threshold1 < classic < threshold2 < rock
                t1 = length(sortpop);
                t2 = 1;
                while sortpop(t1)>sortclassic(t2)
                    t1 = t1-1;
                    t2 = t2+1;
                end
                threshold1 = (sortpop(t1)+sortclassic(t2))/2;
                t3 = length(sortclassic);
                t4 = 1;
                while sortclassic(t3)>sortrock(t4)
                    t3 = t3-1;
                    t4 = t4+1;
                end
                threshold2 = (sortclassic(t3)+sortrock(t4))/2;
                a = 2;
            else    % classic < threshold1 < pop < threshold2 < rock
                t1 = length(sortclassic);
                t2 = 1;
                while sortclassic(t1)>sortpop(t2)
                    t1 = t1-1;
                    t2 = t2+1;
                end
                threshold1 = (sortclassic(t1)+sortpop(t2))/2;
                t3 = length(sortpop);
                t4 = 1;
                while sortpop(t3)>sortrock(t4)
                    t3 = t3-1;
                    t4 = t4+1;
                end
                threshold2 = (sortpop(t3)+sortrock(t4))/2;
                a = 3;
            end
        end
    else
        if mean(vpop) <= mean(vclassic)    % rock < threshold1 < pop < threshold2 < classic
            t1 = length(sortrock);
            t2 = 1;
            while sortrock(t1)>sortpop(t2)
                t1 = t1-1;
                t2 = t2+1;
            end
            threshold1 = (sortrock(t1)+sortpop(t2))/2;
            t3 = length(sortpop);
            t4 = 1;
            while sortpop(t3)>sortclassic(t4)
                t3 = t3-1;
                t4 = t4+1;
            end
            threshold2 = (sortpop(t3)+sortclassic(t4))/2;
            a = 4;
        else
            if mean(vclassic) > mean(vrock)  % rock < threshold1 < classic < threshold2 < pop
                t1 = length(sortrock);
                t2 = 1;
                while sortrock(t1)>sortclassic(t2)
                    t1 = t1-1;
                    t2 = t2+1;
                end
                threshold1 = (sortrock(t1)+sortclassic(t2))/2;
                t3 = length(sortclassic);
                t4 = 1;
                while sortclassic(t3)>sortpop(t4)
                    t3 = t3-1;
                    t4 = t4+1;
                end
                threshold2 = (sortclassic(t3)+sortpop(t4))/2;
                a = 5
            else    % classic < threshold1 < rock < threshold2 < pop
                t1 = length(sortclassic);
                t2 = 1;
                while sortclassic(t1)>sortrock(t2)
                    t1 = t1-1;
                    t2 = t2+1;
                end
                threshold1 = (sortclassic(t1)+sortrock(t2))/2;
                t3 = length(sortrock);
                t4 = 1;
                while sortrock(t3)>sortpop(t4)
                    t3 = t3-1;
                    t4 = t4+1;
                end
                threshold2 = (sortrock(t3)+sortpop(t4))/2;
                a = 6
            end
        end
    end
end
  
