% Função que retorna a média dos picos acendentes e descendentes
%
% Retorna dos vetores com a media dos picos
%
% Exemplo: 
%
% [MediaAsc, MediaDes] = getMedias(QtdePicosAsc, ValPicosAsc, QtdePicosDes, ValPicosDes, Intervalo)
%

function [MediaAsc, MediaDes] = getMedias(QtdePicosAsc, ValPicosAsc, QtdePicosDes, ValPicosDes, Intervalo)
    idx = 1;
    MediaAsc = QtdePicosAsc;
    MediaDes = QtdePicosAsc;    
    for i = 1 : length(QtdePicosAsc)        
        MediaAsc(i) = round(sum(ValPicosAsc(idx:i*Intervalo))/QtdePicosAsc(i)); 
        MediaDes(i) = round(sum(ValPicosDes(idx:i*Intervalo))/QtdePicosDes(i));
        idx = i * Intervalo;
    end