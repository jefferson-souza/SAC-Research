function sacam = sac_am(data, N)
    M = length(data);
    size_sacam =  floor(M/N);
    sacam = zeros(1, size_sacam);

    inicio = 1;
    fim = N;
    %disp("tamanho: " + size_sacam);
    
    for k = 1:size_sacam 
        % Encontrar picos na janela atual
        [pks, pos] = findpeaks(data(inicio:fim));
        %[~, peaks] = findpeaks(data(inicio:min(fim, M)));

        % Se houver picos, calcular a média das amplitudes absolutas 
        %if ~isempty(pks)            
        %    v = abs(data(locs)); % Ajuste de índice
        %    s = mean(v);
        %else
        %    s = 1; % Se não houver picos, assume-se 0
        %end
        
        %v = abs(data(pos));
        %s = mean(v);
        
        v = abs(pks);
        s = sum(v);

        % Normalização
        sacam(k) = (1*s / N)/100;

        % Atualizar os índices para a próxima janela
        inicio = fim;
        fim = fim + N;
    end
end