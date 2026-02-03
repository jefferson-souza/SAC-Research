
close all;
clear all;
clc;

%%
%Configurações
tempsimul  = 500000; % DataSet Size
N          = 1000;   % Window Size

JanelaExibicao_sinal_puro = 500; % Window Size For Graphics Generation
JanelaExibicao_sac_am     = 500; % Window Size For Graphics Generation

set(0,'defaultAxesFontSize',15)


%% DataSet
filename  = 'D:\Serial\TesteDrone_New\data_T5_Healthy.csv';
filename2 = 'D:\Serial\TesteDrone_New\data_T5_1200_F1.csv';
filename4 = 'D:\Serial\TesteDrone_New\data_T5_1200_F2.csv';
filename6 = 'D:\Serial\TesteDrone_New\data_T5_1200_F3.csv';

delimiterIn = ';';
headerlinesIn = 1;

A = importdata(filename,delimiterIn,headerlinesIn);
%%Valores Heathy
X = A.data(:,1);
Y = A.data(:,2);
Z = A.data(:,3);

A = importdata(filename2,delimiterIn,headerlinesIn);
%%Valores Failure 1
X2 = A.data(:,1);
Y2 = A.data(:,2);
Z2 = A.data(:,3);

A = importdata(filename4,delimiterIn,headerlinesIn);
%%Valores Failure 2
X4 = A.data(:,1);
Y4 = A.data(:,2);
Z4 = A.data(:,3);

A = importdata(filename6,delimiterIn,headerlinesIn);
%%Valores Failure 3
X6 = A.data(:,1);
Y6 = A.data(:,2);
Z6 = A.data(:,3);

%% Clock Simulation 
 for i=1:(tempsimul + 1 )
     t(i)=(i-1)*0.00487;    
 end

figure(1);
graf(1) = subplot(3,2,[1 2]);         %%% Plotar Sinal Original
 plot(t(1:JanelaExibicao_sinal_puro),X(1:JanelaExibicao_sinal_puro ),'-b', ...
      t(1:JanelaExibicao_sinal_puro) ,X2(1:JanelaExibicao_sinal_puro),'-g', ...
      t(1:JanelaExibicao_sinal_puro) ,X4(1:JanelaExibicao_sinal_puro),'-r', ...
      t(1:JanelaExibicao_sinal_puro) ,X6(1:JanelaExibicao_sinal_puro),'-m' );
 title('Signal X-axis');
 legend('Healthy','Failure 1','Failure 2', 'Failure 3');
 ylabel('acceleration (m/s²)');
 xlabel('Time (sec)');
 axis tight;
 
graf(2) = subplot(3,2,[3 4]);         %%% Plotar Sinal Original
 plot(t(1:JanelaExibicao_sinal_puro) ,Y(1:JanelaExibicao_sinal_puro),'-b', ...
      t(1:JanelaExibicao_sinal_puro) ,Y2(1:JanelaExibicao_sinal_puro),'-g', ...
      t(1:JanelaExibicao_sinal_puro) ,Y4(1:JanelaExibicao_sinal_puro),'-r', ...
      t(1:JanelaExibicao_sinal_puro) ,Y6(1:JanelaExibicao_sinal_puro),'-m' );
 title('Signal Y-axis');
 ylabel('acceleration (m/s²)');
 xlabel('Time (sec)');
 legend('OK','Falha 1','Falha 2', 'Falha 3');
 axis tight;
  
 graf(3) = subplot(3,2,[5 6]);         %%% Plotar Sinal Original
 plot(t(1:JanelaExibicao_sinal_puro) ,Z(1:JanelaExibicao_sinal_puro),'-b', ...
      t(1:JanelaExibicao_sinal_puro) ,Z2(1:JanelaExibicao_sinal_puro),'-g', ...
      t(1:JanelaExibicao_sinal_puro) ,Z4(1:JanelaExibicao_sinal_puro),'-r', ...
      t(1:JanelaExibicao_sinal_puro) ,Z6(1:JanelaExibicao_sinal_puro),'-m' );
 title('Signal Z-axis');
 ylabel('acceleration (m/s²)');
 xlabel('Time (sec)');
 legend('OK','Falha 1','Falha 2', 'Falha 3');
 axis tight;  

 for i=1:(tempsimul + 1 )
     t(i)=(i-1)*1;    
 end 

%SAC-AM Calculator
sac_am_x  = sac_am(X,  N);
sac_am_x2 = sac_am(X2, N);
sac_am_x4 = sac_am(X4, N);
sac_am_x6 = sac_am(X6, N);

sac_am_y  = sac_am(Y,  N);
sac_am_y2 = sac_am(Y2, N);
sac_am_y4 = sac_am(Y4, N);
sac_am_y6 = sac_am(Y6, N);

sac_am_z  = sac_am(Z,  N);
sac_am_z2 = sac_am(Z2, N);
sac_am_z4 = sac_am(Z4, N);
sac_am_z6 = sac_am(Z6, N);


figure(2);
graf(1) = subplot(3,2,[1 2]);         %%% Plotar Sinal Original
 plot(t(1:JanelaExibicao_sac_am),sac_am_x(1:JanelaExibicao_sac_am ),'ob', ...
      t(1:JanelaExibicao_sac_am) ,sac_am_x2(1:JanelaExibicao_sac_am),'og', ...
      t(1:JanelaExibicao_sac_am) ,sac_am_x4(1:JanelaExibicao_sac_am),'or', ...
      t(1:JanelaExibicao_sac_am) , sac_am_x6(1:JanelaExibicao_sac_am),'om' );
 title('SAC AM Signal X-axis');
 legend('Healthy','Failure 1','Failure 2', 'Failure 3');
 ylabel('SAC-AM');
 xlabel('Time (sec)');
 axis tight;
 
graf(2) = subplot(3,2,[3 4]);         %%% Plotar Sinal Original
 plot(t(1:JanelaExibicao_sac_am),sac_am_y(1:JanelaExibicao_sac_am ),'ob', ...
      t(1:JanelaExibicao_sac_am) ,sac_am_y2(1:JanelaExibicao_sac_am),'og', ...
      t(1:JanelaExibicao_sac_am) ,sac_am_y4(1:JanelaExibicao_sac_am),'or', ...
      t(1:JanelaExibicao_sac_am) , sac_am_y6(1:JanelaExibicao_sac_am),'om' );
 title('SAC AM Signal Y-axis');
 legend('Healthy','Failure 1','Failure 2', 'Failure 3');
 ylabel('SAC-AM');
 xlabel('Time (sec)'); 
 axis tight;
  
 graf(3) = subplot(3,2,[5 6]);         %%% Plotar Sinal Original
 plot(t(1:JanelaExibicao_sac_am),sac_am_z(1:JanelaExibicao_sac_am ),'ob', ...
     t(1:JanelaExibicao_sac_am) ,sac_am_z2(1:JanelaExibicao_sac_am),'og', ...
     t(1:JanelaExibicao_sac_am) ,sac_am_z4(1:JanelaExibicao_sac_am),'or', ...
     t(1:JanelaExibicao_sac_am) , sac_am_z6(1:JanelaExibicao_sac_am),'om' );
 title('SAC AM Signal Z-axis');
 legend('Healthy','Failure 1','Failure 2', 'Failure 3');
 ylabel('SAC-AM');
 xlabel('Time (sec)');
 axis tight;

%% SAC-DM Calculator
sac_dm_x  = sac_dm_new(X,  N);
sac_dm_x2 = sac_dm_new(X2, N);
sac_dm_x4 = sac_dm_new(X4, N);
sac_dm_x6 = sac_dm_new(X6, N);

sac_dm_y  = sac_dm_new(Y,  N);
sac_dm_y2 = sac_dm_new(Y2, N);
sac_dm_y4 = sac_dm_new(Y4, N);
sac_dm_y6 = sac_dm_new(Y6, N);

sac_dm_z  = sac_dm_new(Z,  N);
sac_dm_z2 = sac_dm_new(Z2, N);
sac_dm_z4 = sac_dm_new(Z4, N);
sac_dm_z6 = sac_dm_new(Z6, N);

figure(3);
graf(1) = subplot(3,2,[1 2]);         %%% Plotar Sinal Original
 plot(t(1:JanelaExibicao_sac_am) , sac_dm_x (1:JanelaExibicao_sac_am ),'ob', ...
      t(1:JanelaExibicao_sac_am) , sac_dm_x2(1:JanelaExibicao_sac_am),'og', ...
      t(1:JanelaExibicao_sac_am) , sac_dm_x4(1:JanelaExibicao_sac_am),'or', ...
      t(1:JanelaExibicao_sac_am) , sac_dm_x6(1:JanelaExibicao_sac_am),'om' );
 title('SAC DM Signal X-axis');
 legend('Healthy','Failure 1','Failure 2', 'Failure 3');
 ylabel('SAC-DM');
 xlabel('Time (sec)');
 axis tight;
 
graf(2) = subplot(3,2,[3 4]);         %%% Plotar Sinal Original
 plot(t(1:JanelaExibicao_sac_am) , sac_dm_y (1:JanelaExibicao_sac_am ),'ob', ...
      t(1:JanelaExibicao_sac_am) , sac_dm_y2(1:JanelaExibicao_sac_am),'og', ...
      t(1:JanelaExibicao_sac_am) , sac_dm_y4(1:JanelaExibicao_sac_am),'or', ...
      t(1:JanelaExibicao_sac_am) , sac_dm_y6(1:JanelaExibicao_sac_am),'om' );
 title('SAC DM Signal Y-axis');
 legend('Healthy','Failure 1','Failure 2', 'Failure 3');
 ylabel('SAC-DM');
 xlabel('Time (sec)'); 
 axis tight;
  
 graf(3) = subplot(3,2,[5 6]);         %%% Plotar Sinal Original
 plot(t(1:JanelaExibicao_sac_am) , sac_dm_z (1:JanelaExibicao_sac_am ),'ob', ...
      t(1:JanelaExibicao_sac_am) , sac_dm_z2(1:JanelaExibicao_sac_am),'og', ...
      t(1:JanelaExibicao_sac_am) , sac_dm_z4(1:JanelaExibicao_sac_am),'or', ...
      t(1:JanelaExibicao_sac_am) , sac_dm_z6(1:JanelaExibicao_sac_am),'om' );
 title('SAC DM Signal Z-axis');
 legend('Healthy','Failure 1','Failure 2', 'Failure 3');
 ylabel('SAC-DM');
 xlabel('Time (sec)'); 
 axis tight;


figure(4);
graf(1) = subplot(3,2,[1 2]); 
    hold on
    graf(1)
    histogram(sac_dm_x(1:JanelaExibicao_sac_am),13,'EdgeColor','w','FaceColor','b')
    histogram(sac_dm_x2(1:JanelaExibicao_sac_am),13,'EdgeColor','w','FaceColor','g')
    histogram(sac_dm_x4(1:JanelaExibicao_sac_am),13,'EdgeColor','w','FaceColor','r')
    histogram(sac_dm_x6(1:JanelaExibicao_sac_am),13,'EdgeColor','w','FaceColor','m')
    legend('Healthy','Failure 1','Failure 2', 'Failure 3');
    title('Histogram of Maximum Density (SAC-DM) for X axios');
    axis tight;
    ylabel('Occurrences')
    xlabel('Density of Maximum (SAC-DM)')
    hold off


graf(2) = subplot(3,2,[3 4]);
    hold on
    graf(1)
    histogram(sac_dm_y(1:JanelaExibicao_sac_am),13,'EdgeColor','w','FaceColor','b')
    histogram(sac_dm_y2(1:JanelaExibicao_sac_am),13,'EdgeColor','w','FaceColor','g')
    histogram(sac_dm_y4(1:JanelaExibicao_sac_am),13,'EdgeColor','w','FaceColor','r')
    histogram(sac_dm_y6(1:JanelaExibicao_sac_am),13,'EdgeColor','w','FaceColor','m')
    legend('Healthy','Failure 1','Failure 2', 'Failure 3');
    title('Histogram of Maximum Density (SAC-DM) for Y axios');
    axis tight;
    ylabel('Occurrences')
    xlabel('Density of Maximum (SAC-DM)')
    hold off

graf(3) = subplot(3,2,[5 6]);
    hold on
    graf(1)
    histogram(sac_dm_z(1:JanelaExibicao_sac_am),13,'EdgeColor','w','FaceColor','b')
    histogram(sac_dm_z2(1:JanelaExibicao_sac_am),13,'EdgeColor','w','FaceColor','g')
    histogram(sac_dm_z4(1:JanelaExibicao_sac_am),13,'EdgeColor','w','FaceColor','r')
    histogram(sac_dm_z6(1:JanelaExibicao_sac_am),13,'EdgeColor','w','FaceColor','m')
    legend('Healthy','Failure 1','Failure 2', 'Failure 3');
    title('Histogram of Maximum Density (SAC-DM) for Z axios');
    axis tight;
    ylabel('Occurrences')
    xlabel('Density of Maximum (SAC-DM)')
    hold off


figure(6);
graf(1) = subplot(3,2,[1 2]); 
    hold on
    graf(1)
    histogram(sac_am_x(1:JanelaExibicao_sac_am),13,'EdgeColor','w','FaceColor','b')
    histogram(sac_am_x2(1:JanelaExibicao_sac_am),13,'EdgeColor','w','FaceColor','g')
    histogram(sac_am_x4(1:JanelaExibicao_sac_am),13,'EdgeColor','w','FaceColor','r')
    histogram(sac_am_x6(1:JanelaExibicao_sac_am),13,'EdgeColor','w','FaceColor','m')
    legend('Healthy','Failure 1','Failure 2', 'Failure 3');
    title('Histogram of Maximum Density (SAC-AM) for X axios');
    axis tight;
    ylabel('Occurrences')
    xlabel('Density of Maximum (SAC-AM)')
    hold off


graf(2) = subplot(3,2,[3 4]);
    hold on
    graf(1)
    histogram(sac_am_y(1:JanelaExibicao_sac_am),13,'EdgeColor','w','FaceColor','b')
    histogram(sac_am_y2(1:JanelaExibicao_sac_am),13,'EdgeColor','w','FaceColor','g')
    histogram(sac_am_y4(1:JanelaExibicao_sac_am),13,'EdgeColor','w','FaceColor','r')
    histogram(sac_am_y6(1:JanelaExibicao_sac_am),13,'EdgeColor','w','FaceColor','m')
    legend('Healthy','Failure 1','Failure 2', 'Failure 3');
    title('Histogram of Maximum Density (SAC-AM) for Y axios');
    axis tight;
    ylabel('Occurrences')
    xlabel('Density of Maximum (SAC-AM)')
    hold off

graf(3) = subplot(3,2,[5 6]);
    hold on
    graf(1)
    histogram(sac_am_z(1:JanelaExibicao_sac_am),13,'EdgeColor','w','FaceColor','b')
    histogram(sac_am_z2(1:JanelaExibicao_sac_am),13,'EdgeColor','w','FaceColor','g')
    histogram(sac_am_z4(1:JanelaExibicao_sac_am),13,'EdgeColor','w','FaceColor','r')
    histogram(sac_am_z6(1:JanelaExibicao_sac_am),13,'EdgeColor','w','FaceColor','m')
    legend('Healthy','Failure 1','Failure 2', 'Failure 3');
    title('Histogram of Maximum Density (SAC-AM) for Z axios');
    axis tight;
    ylabel('Occurrences')
    xlabel('Density of Maximum (SAC-AM)')
    hold off    

All_Normal = [sac_am_x(1:JanelaExibicao_sac_am) ; sac_am_y(1:JanelaExibicao_sac_am) ; sac_am_z(1:JanelaExibicao_sac_am); ...
              sac_dm_x(1:JanelaExibicao_sac_am) ; sac_dm_y(1:JanelaExibicao_sac_am) ; sac_dm_z(1:JanelaExibicao_sac_am)];

All_falha1 = [sac_am_x2(1:JanelaExibicao_sac_am); sac_am_y2(1:JanelaExibicao_sac_am); sac_am_z2(1:JanelaExibicao_sac_am); ...
              sac_dm_x2(1:JanelaExibicao_sac_am); sac_dm_y2(1:JanelaExibicao_sac_am); sac_dm_z2(1:JanelaExibicao_sac_am)];

All_falha2 = [sac_am_x4(1:JanelaExibicao_sac_am); sac_am_y4(1:JanelaExibicao_sac_am); sac_am_z4(1:JanelaExibicao_sac_am); ...
              sac_dm_x4(1:JanelaExibicao_sac_am); sac_dm_y4(1:JanelaExibicao_sac_am); sac_dm_z4(1:JanelaExibicao_sac_am)];

All_falha3 = [sac_am_x6(1:JanelaExibicao_sac_am); sac_am_y6(1:JanelaExibicao_sac_am); sac_am_z6(1:JanelaExibicao_sac_am); ...
              sac_dm_x6(1:JanelaExibicao_sac_am); sac_dm_y6(1:JanelaExibicao_sac_am); sac_dm_z6(1:JanelaExibicao_sac_am)];


normal = All_Normal;
falha1 = All_falha1;
falha2 = All_falha2;
falha3 = All_falha3;

%disp(MPL_ACU(normal([4 6] , :) , falha1([4 6] , :) , falha2([4 6] , :) , falha3([4 6] , :)) ); %% XZ-axis
%disp(SVM_4S(normal([1 3] , :) , falha1([1 3] , :) , falha2([1 3] , :) , falha3([1 3] , :)) );
%return;

%% 1-3 SAC-AM | 4-6 SAC-DM
%% MPL Simulations
%% SAC-AM
disp(MPL_ACU(normal([1] , :) , falha1([1] , :) , falha2([1] , :) , falha3([1] , :)) );                 %% X-axis
disp(MPL_ACU(normal([2] , :) , falha1([2] , :) , falha2([2] , :) , falha3([2] , :)) );                 %% Y-axis
disp(MPL_ACU(normal([3] , :) , falha1([3] , :) , falha2([3] , :) , falha3([3] , :)) );                 %% Z-axis
        
disp(MPL_ACU(normal([1 2] , :) , falha1([1 2] , :) , falha2([1 2] , :) , falha3([1 2] , :)) );         %% XY-axis
disp(MPL_ACU(normal([2 3] , :) , falha1([2 3] , :) , falha2([2 3] , :) , falha3([2 3] , :)) );         %% YZ-axis
disp(MPL_ACU(normal([1 3] , :) , falha1([1 3] , :) , falha2([1 3] , :) , falha3([1 3] , :)) );         %% XZ-axis

disp(MPL_ACU(normal([1 2 3] , :) , falha1([1 2 3] , :) , falha2([1 2 3] , :) , falha3([1 2 3] , :)) ); %% XYZ-axis

%% SAC-DM
disp(MPL_ACU(normal([4] , :) , falha1([4] , :) , falha2([4] , :) , falha3([4] , :)) );                 %% X-axis
disp(MPL_ACU(normal([5] , :) , falha1([5] , :) , falha2([5] , :) , falha3([5] , :)) );                 %% Y-axis
disp(MPL_ACU(normal([6] , :) , falha1([6] , :) , falha2([6] , :) , falha3([6] , :)) );                 %% Z-axis
        
disp(MPL_ACU(normal([4 5] , :) , falha1([4 5] , :) , falha2([4 5] , :) , falha3([4 5] , :)) );         %% XY-axis
disp(MPL_ACU(normal([5 6] , :) , falha1([5 6] , :) , falha2([5 6] , :) , falha3([5 6] , :)) );         %% YZ-axis
disp(MPL_ACU(normal([4 6] , :) , falha1([4 6] , :) , falha2([4 6] , :) , falha3([4 6] , :)) );         %% XZ-axis

disp(MPL_ACU(normal([4 5 6] , :) , falha1([4 5 6] , :) , falha2([4 5 6] , :) , falha3([4 5 6] , :)) ); %% XYZ-axis


%% SVM Simulations
disp(SVM_4S(normal([1] , :) , falha1([1] , :) , falha2([1] , :) , falha3([1] , :)) );                 %% X-axis
disp(SVM_4S(normal([2] , :) , falha1([2] , :) , falha2([2] , :) , falha3([2] , :)) );                 %% Y-axis
disp(SVM_4S(normal([3] , :) , falha1([3] , :) , falha2([3] , :) , falha3([3] , :)) );                 %% Z-axis
        
disp(SVM_4S(normal([1 2] , :) , falha1([1 2] , :) , falha2([1 2] , :) , falha3([1 2] , :)) );         %% XY-axis
disp(SVM_4S(normal([2 3] , :) , falha1([2 3] , :) , falha2([2 3] , :) , falha3([2 3] , :)) );         %% YZ-axis
disp(SVM_4S(normal([1 3] , :) , falha1([1 3] , :) , falha2([1 3] , :) , falha3([1 3] , :)) );         %% XZ-axis

disp(SVM_4S(normal([1 2 3] , :) , falha1([1 2 3] , :) , falha2([1 2 3] , :) , falha3([1 2 3] , :)) ); %% XYZ-axis

%% SAC-DM
disp(SVM_4S(normal([4] , :) , falha1([4] , :) , falha2([4] , :) , falha3([4] , :)) );                 %% X-axis
disp(SVM_4S(normal([5] , :) , falha1([5] , :) , falha2([5] , :) , falha3([5] , :)) );                 %% Y-axis
disp(SVM_4S(normal([6] , :) , falha1([6] , :) , falha2([6] , :) , falha3([6] , :)) );                 %% Z-axis
        
disp(SVM_4S(normal([4 5] , :) , falha1([4 5] , :) , falha2([4 5] , :) , falha3([4 5] , :)) );         %% XY-axis
disp(SVM_4S(normal([5 6] , :) , falha1([5 6] , :) , falha2([5 6] , :) , falha3([5 6] , :)) );         %% YZ-axis
disp(SVM_4S(normal([4 6] , :) , falha1([4 6] , :) , falha2([4 6] , :) , falha3([4 6] , :)) );         %% XZ-axis

disp(SVM_4S(normal([4 5 6] , :) , falha1([4 5 6] , :) , falha2([4 5 6] , :) , falha3([4 5 6] , :)) ); %% XYZ-axis