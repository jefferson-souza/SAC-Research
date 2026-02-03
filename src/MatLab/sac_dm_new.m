function sacdm = sac_dm_new(data, N)
    M = length(data);
    size_sacdm =  floor(M/N);
    sacdm = zeros(1, size_sacdm);

    inicio = 1;
    fim = N;
    
    for k = 1:size_sacdm 
        % Encontrar picos na janela atual
        [pks, ~] = findpeaks(data(inicio:fim));
        %[~, peaks] = findpeaks(data(inicio:min(fim, M)));

        % Se houver picos, calcular a média das amplitudes absolutas 
        %if ~isempty(pks)            
        %    v = abs(data(locs)); % Ajuste de índice
        %    s = mean(v);
        %else
        %    s = 1; % Se não houver picos, assume-se 0
        %end
        v = length(pks);        
        % Normalização
        sacdm(k) = 1*v / N;

        % Atualizar os índices para a próxima janela
        inicio = fim;
        fim = fim + N;
    end
end