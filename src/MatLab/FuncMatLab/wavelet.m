function [ out_wavelet ] = wavelet( sinal1, fs1 )
%WAVELET Summary of this function goes here

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Ts1 = 1/fs1;                    % período de amostragem
n = length(sinal1);                % tamanho do vetor
t = 0:Ts1:(n-1)*Ts1;          % intervalo de amostragem
t = t';                       % transpõe o vetor

%Realiza o janelamento do sinal utilizando a funçãod e Hamming
janela = hamming(n);
sinal1_janelado = janela.*sinal1;
envelopado = sinal1_janelado;
% sinal2_janelado = janela.*sinal2';
% sinal3_janelado = janela.*sinal3';

%%%%%%%%%%%%%%%%5 TRANSFORMADA DE FOURIER %%%%%%%%%%%%%%%%%%%
Y1 = abs(fft(sinal1_janelado))/n;           % FFT sinal normal
% Y2 = abs(fft(sinal2_janelado))/n;           % FFT sinal normal
% Y3 = abs(fft(sinal3_janelado))/n;           % FFT sinal normal

% Cria uma faixa de frequência para a FFT realizada, baseado na frequência
%de Nyquist 
w = linspace(0,fs1,n); 

%%%%%%%%%%%%%%%%%%%%%%%% ANÁLISE WAVELET %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sinal(:,1) = sinal1;
% sinal(:,2) = sinal2;
% sinal(:,3) = sinal3;

%sinal(:,4) = desacoplado_100g(1:40000,1);

for i = 1 %:3
format long
clear C
clear L

l_s = length(sinal(:,i));
[C,L] = wavedec(sinal(:,i),11,'db6');  %define o vetor com os coeficientes wavelets

%Determinando a aproximação e os subníveis
A11(i,:) = wrcoef('a',C,L,'db6',11);
D1(i,:) = wrcoef('d',C,L,'db6',1);
D2(i,:) = wrcoef('d',C,L,'db6',2);
D3(i,:) = wrcoef('d',C,L,'db6',3);
D4(i,:) = wrcoef('d',C,L,'db6',4);
D5(i,:) = wrcoef('d',C,L,'db6',5);
D6(i,:) = wrcoef('d',C,L,'db6',6);
D7(i,:) = wrcoef('d',C,L,'db6',7);
D8(i,:) = wrcoef('d',C,L,'db6',8);
D9(i,:) = wrcoef('d',C,L,'db6',9);
D10(i,:) = wrcoef('d',C,L,'db6',10);
D11(i,:) = wrcoef('d',C,L,'db6',11);

end

%Plota as figuras

% vetor = load('data_4kHz.mat');
% signal = vetor.ts.data(:,1)

%soma dos sinais
% vetor1 = load('../dataset/testes_2017_03_03/M1_H1_CW_current_03.mat'); %experimentos do dia 03/03 com 1.000.000
% vetor2 = load('../dataset/testes_2017_03_03/M1_H1_CW_current_04.mat'); %experimentos do dia 03/03 com 1.000.000
% vetor3 = load('../dataset/testes_2017_03_03/M1_H1_CW_current_05.mat'); %experimentos do dia 03/03 com 1.000.000
% vetor4 = load('../dataset/testes_2017_03_03/M1_H1_CW_current_06.mat'); %experimentos do dia 03/03 com 1.000.000
% signal = cat(1, vetor1.y1, vetor2.y1, vetor3.y1, vetor4.y1);

%% offset to ZERO and convert to current
%mean_data = mean(signal);

% for i = 1:length(signal)      
%      signal(i) =  signal(i) - mean_data;   %offset to ZERO => colunm 2
% end
% if mean_data < 0
%    for i = 1:length(signal)      
%      signal(i) =  signal(i) - mean_data;   %offset to ZERO => colunm 2
%     end 
% end

out_wavelet = D5;


end

