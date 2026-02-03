% Função Filtra Faixa em um intervalo
%
% Retorna um sinal com limite superior e inferior de acordo com o informado
%
% Exemplo: 
%
% ResSinal = FiltroFaixa(Sinal,Limites)
%

function ResSinal = FiltroFaixa(Sinal,Limites)
ResSinal  = Sinal;
    for i = 1 : length(ResSinal) 
    %Removendo picos maiores que 10
        ResSinal(i) = ResSinal(i,1);
        if ResSinal(i) > Limites         
            %disp(X(i,1));
            ResSinal(i,1) = Limites;
        end;
        if ResSinal(i) < -Limites         
            %disp(X(i,1));
            ResSinal(i,1) = -Limites;
        end;    
    end;