% Função Filtra Faixa em um intervalo
%
% Retorna um vetor com a quantidade de picos e outro com os valores dos
% picos para cada intervalo
%
% Exemplo: 
%
% [QtdePicosAsc, ValPicosAsc, QtdePicosDes, ValPicosDes ] =
% getPicos(Sinal,Intervalo,QtdeAmostras)
%

function [QtdePicosAsc, ValPicosAsc, QtdePicosDes, ValPicosDes ] = getPicos(Sinal,Intervalo,QtdeAmostras)

    AcmSup = 0;
    AcmInf = 0;
    k      = Intervalo;
    ct     = 0;
    idx    = 1;
    
    QtdePicosAsc (1)=0;
    QtdePicosDes (1)=0;
    
    ValPicosAsc = Sinal(1:QtdeAmostras);
    ValPicosDes = Sinal(1:QtdeAmostras);       

    for i = 2 : length(Sinal(1:QtdeAmostras))-1    
        ValPicosAsc(i,1) = NaN;%0;
        ValPicosDes(i,1) = NaN;%0;
        ct = ct+1;
        if Sinal(i) >= Sinal(i-1) && Sinal(i) > Sinal(i+1)
            ValPicosAsc(i,1) = Sinal(i);
            AcmSup = AcmSup + 1;
            QtdePicosAsc(idx) = AcmSup; 
        end;  

        if Sinal(i) <= Sinal(i-1) && Sinal(i) < Sinal(i+1)  
            ValPicosDes(i,1) = Sinal(i);
            AcmInf = AcmInf + 1;
            QtdePicosDes(idx) = AcmInf; 
        end;

        if ct > k
            ct = 1;
            AcmSup = 0;
            AcmInf = 0;
            idx = idx +1;
        end;    
     end; 
