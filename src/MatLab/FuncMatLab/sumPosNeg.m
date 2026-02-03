% Função que retorna a quantos valores são positivos e quantos valores são
% negativos
%
% Retorna dos vetores com a media dos picos
%
% Exemplo: 
%
% [pos, neg] = sumPosNeg(C)
%
function [pos, neg] = sumPosNeg(VetIn)
    pos = 0;
    neg = 0;
    for i = 1 : length(VetIn')  
        if (VetIn(i) >= 0)                    
                    pos = pos +1;
        else                    
                    neg = neg +1;
        end
    end