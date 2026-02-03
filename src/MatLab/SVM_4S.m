% TestandoSVM_R2024b.m
% Script compatível com MATLAB R2024b
% Treina um classificador SVM multiclasses (fitcecoc) para dados de vibração
% Autor: adaptado para R2024b

%clearvars; close all; clc;


%% ==================== 1) Dados de exemplo ====================
% Cada variável tem dimensão channels x nSamples (ex.: 3 x 12)
% normal = [...
%     0.1200, 0.1202, 0.1203, 0.1201, 0.1200, 0.1202, 0.1203, 0.1201, 0.1200, 0.1202, 0.1203, 0.1201;
%     %0.2900, 0.2910, 0.2923, 0.2920, 0.2915, 0.2910, 0.2923, 0.2920, 0.2915, 0.2910, 0.2923, 0.2920;
%     0.5222, 0.5322, 0.5242, 0.5221, 0.5222, 0.5322, 0.5242, 0.5221, 0.5242, 0.5221, 0.5242, 0.5221];
% 
% falha1 = [...
%     0.2200, 0.2202, 0.2203, 0.2201, 0.2200, 0.2202, 0.2203, 0.2201, 0.2200, 0.2202, 0.2203, 0.2201;
%     %0.5900, 0.5910, 0.5923, 0.5920, 0.5915, 0.5910, 0.5923, 0.5920, 0.5915, 0.5910, 0.5923, 0.5920;
%     0.1222, 0.1322, 0.1242, 0.1221, 0.1222, 0.5322, 0.1242, 0.1221, 0.1242, 0.1221, 0.1242, 0.1221];
% 
% falha2 = [...
%     0.3200, 0.3202, 0.3203, 0.3201, 0.3200, 0.3202, 0.3203, 0.3201, 0.3200, 0.3202, 0.3203, 0.3201;
%     %0.2900, 0.2910, 0.2923, 0.2920, 0.2915, 0.2910, 0.2923, 0.2920, 0.2915, 0.2910, 0.2923, 0.2920;
%     0.2222, 0.2322, 0.2242, 0.2221, 0.2222, 0.2322, 0.2242, 0.2221, 0.2242, 0.2221, 0.2242, 0.2221];
% 
% falha3 = [...
%     0.5200, 0.5202, 0.5203, 0.5201, 0.5200, 0.5202, 0.5203, 0.5201, 0.5200, 0.5202, 0.5203, 0.5201;
%     %0.2900, 0.2910, 0.2923, 0.2920, 0.2915, 0.2910, 0.2923, 0.2920, 0.2915, 0.2910, 0.2923, 0.2920;
%     0.2222, 0.2322, 0.2242, 0.2221, 0.2222, 0.2322, 0.2242, 0.2221, 0.2242, 0.2221, 0.2242, 0.2221];

%% ==================== 2) Escolha a função de extração de features ====================
% Opção A (DEFAULT): seu formato atual - cada coluna é uma amostra com valores
%                     diretos por canal. Use extract_time_features_scalar.
% Opção B: cada amostra é uma janela temporal por canal (channels x Npoints).
%          Nesse caso, comente a opção A e use extract_time_features_vector.
function SVM4S = SVM_4S(normal, falha1, falha2, falha3)
    rng(1); %  reprodutibilidade


    disp("======================================================");
    disp(normal);
    size(normal)
    disp("======================================================");

    useVectorWindows = false; % true se suas amostras forem vetores temporais por canal
    
    if ~useVectorWindows
        % Cada coluna = amostra; cada linha = canal com um único valor
        Xn = extract_time_features_scalar(normal);   % nSamples x nFeatures
        Xf1 = extract_time_features_scalar(falha1);
        Xf2 = extract_time_features_scalar(falha2);
        Xf3 = extract_time_features_scalar(falha3);
    else
        % Exemplo de como construir cell arrays quando cada amostra tem vetor temporal:
        % Supondo que você transformou suas matrizes channels x nSamples em cell array
        % onde cada célula é channels x Npoints (janela temporal).
        % Aqui deixo um exemplo genérico (substitua pelos seus dados reais).
        % normalCell = {normal(:,1:Npoints), normal(:,Npoints+1:2*Npoints), ...};
        error('Ative useVectorWindows=true e construa as cell arrays de amostras temporais antes de usar.');
        % Xn = extract_time_features_vector(normalCell);
        % ...
    end
    
    %% ==================== 3) Montar dataset e rótulos ====================
    X = [Xn; Xf1; Xf2; Xf3];   % nTotalSamples x nFeatures
    yNum = [ones(size(Xn,1),1);
            2*ones(size(Xf1,1),1);
            3*ones(size(Xf2,1),1);
            4*ones(size(Xf3,1),1)];
    
    % Converter para categorical com nomes para facilitar interpretação
    classNames = {'Healthy','Failure 1','Failure 2','Failure 3'};
    y = categorical(yNum, [1 2 3 4], classNames);
    
    %% ==================== 4) Padronização (z-score) ====================
    mu = mean(X,1);
    sigma = std(X,0,1);
    sigma(sigma==0) = 1; % evita divisão por zero para features constantes
    Xz = (X - mu) ./ sigma;
    
    %% ==================== 5) Treinamento com fitcecoc (SVMs RBF) ====================
    % Template SVM (RBF kernel)
    t = templateSVM('KernelFunction','rbf', 'Standardize', false, 'Verbose', 0);
    
    % Treinar modelo ECOC (one-vs-one por padrão)
    MdlECOC = fitcecoc(Xz, y, 'Learners', t, 'Coding', 'onevsone', 'ClassNames', classNames);
    
    fprintf('Treinamento concluído: fitcecoc com SVM (RBF).\n');
    
    %% ==================== 6) Validação cruzada K-fold e avaliação ====================
    K = 5;
    CVMdl = crossval(MdlECOC, 'KFold', K);
    loss = kfoldLoss(CVMdl);
    acc = (1 - loss) * 100;
    fprintf('Validação Cruzada (%d-fold) - Loss: %.4f | Acurácia média: %.2f%%\n', K, loss, acc);
    
    % Predições via kfoldPredict
    predCV = kfoldPredict(CVMdl);
    
    % Matriz de confusão com nomes (garantindo compatibilidade)
    cats = categories(y); % armazena categorias para evitar indexação direta de função
    
    predCV = kfoldPredict(CVMdl);
    
    % converter predCV para categorical usando as mesmas categorias de y
    if ~iscategorical(predCV)
        predCV = categorical(predCV);       % cria categorias automaticamente
    end
    % garantir mesma ordem/categorias
    predCV = categorical(predCV, categories(y));
    
    
    confMat = confusionmat(y, predCV, 'Order', cats);
    confTable = array2table(confMat, 'VariableNames', cats, 'RowNames', cats);
    disp('Matriz de confusão (val. cruzada):');
    disp(confTable);
    
    figure;
    confusionchart(confMat, {'Healthy', 'Failure 1', 'Failure 2', 'Failure 3'});
    title('Confusion Matrix SVM with SAC-AM Filter (X axios)');
    xlabel('Predict Class');
    ylabel('True Class');
    
    % Acurácia por classe
    diagVals = diag(confMat);
    samplesPerClass = sum(confMat,2);
    accPerClass = (diagVals ./ samplesPerClass) * 100;
    for i = 1:numel(accPerClass)
        fprintf('Classe %s: %.2f%% (%d/%d)\n', cats{i}, accPerClass(i), diagVals(i), samplesPerClass(i));
    end
    
    %% ==================== 7) Avaliação no conjunto (referência) ====================
    yhat_train = predict(MdlECOC, Xz);
    acc_train = sum(yhat_train == y) / numel(y) * 100;
    fprintf('Acurácia no conjunto (treino): %.2f%%\n', acc_train);
    
    SVM4S = acc_train; 
    %% ==================== 8) Prever nova amostra: exemplo ====================
    % Exemplo de nova amostra (coluna 3x1 com valores por canal)
    % newSample = [0.130; 0.295; 0.525];
    % Para usar:
    % feats_new = extract_time_features_scalar(newSample');  % retorna 1xNfeatures
    % feats_new_z = (feats_new - mu) ./ sigma;
    % label_new = predict(MdlECOC, feats_new_z);
    % fprintf('Nova amostra classificada como: %s\n', string(label_new));
    
    %% ==================== 9) Otimização de hiperparâmetros (opcional) ====================
    doOptimize = false; % coloque true para ativar (pode demorar)
    if doOptimize
        fprintf('Iniciando otimização de hiperparâmetros (fitcecoc + SVM)...\n');
        % Otimizar BoxConstraint e KernelScale. Note: OptimizeHyperparameters aceita
        % 'Learners' ou passar templateSVM em 'Learners' e otimizar via fitcecoc.
        tOpt = templateSVM('KernelFunction','rbf', 'Standardize', false);
        optVars = {'BoxConstraint','KernelScale'};
        % Recomendo limitar MaxObjectiveEvaluations para controlar tempo
        MdlOpt = fitcecoc(Xz, y, 'Learners', tOpt, ...
            'OptimizeHyperparameters', optVars, ...
            'HyperparameterOptimizationOptions', struct('MaxObjectiveEvaluations', 30, 'Verbose', 1));
        CVMdlOpt = crossval(MdlOpt, 'KFold', K);
        lossOpt = kfoldLoss(CVMdlOpt);
        fprintf('Otimização finalizada. Loss (k-fold): %.4f | Acurácia: %.2f%%\n', lossOpt, (1-lossOpt)*100);
        MdlECOC = MdlOpt; % opcional: substituir modelo final
    end
    
    %% ==================== 10) Salvar modelo e normalização ====================
    saveModel = true;
    if saveModel
        save('svm_vibration_model_R2024b.mat', 'MdlECOC', 'mu', 'sigma', 'classNames');
        fprintf('Modelo e parâmetros salvos em svm_vibration_model_R2024b.mat\n');
    end
    
    % Fim do script principal

    SvmPipelineFlowchart('c:\');    


% ---------- 4) Visualizações ----------
    % Preparar PCA (usar Xz)
    [coeff, score, ~, ~, explained] = pca(Xz);

    % 4.1 PCA scatter com vetores de suporte
    figure('Name','PCA projection with Support Vectors','NumberTitle','off');
    gscatter(score(:,1), score(:,2), y, lines(numel(cats)), '.', 12); hold on;
    xlabel(sprintf('PC1 (%.1f%%)', explained(1))); ylabel(sprintf('PC2 (%.1f%%)', explained(2)));
    title('PCA: 1st vs 2nd component');
    % Extrair vetores de suporte de todos binary learners (se possível)
    svAll = [];
    if isprop(MdlECOC,'BinaryLearners')
        for k = 1:numel(MdlECOC.BinaryLearners)
            try
                sv = MdlECOC.BinaryLearners{k}.SupportVectors; % NxD
                % garantir dimensão compatível
                if size(sv,2) == size(Xz,2)
                    svAll = [svAll; sv];
                end
            catch
                % se não for possível, ignora
            end
        end
    end
    if ~isempty(svAll)
        svAll = unique(svAll, 'rows', 'stable');
        % projetar SVs nas PCs (usar mu e coeff; Xz = (X-mu)/sigma ; sv já está no espaço padronizado)
        svScore = svAll * coeff; % svAll está padronizado como Xz
        plot(svScore(:,1), svScore(:,2), 'ko', 'MarkerSize',8, 'LineWidth',1.2);
        legend([cellstr(cats); {'Support Vectors'}], 'Location', 'bestoutside');
    else
        legend(cellstr(cats), 'Location', 'bestoutside');
    end
    hold off; 

% 4.2 Fronteira de decisão sobre as 2 primeiras PCs (usar predict do MdlECOC)
    figure('Name','Decision boundary on first 2 PCs','NumberTitle','off');
    % Usar apenas as duas primeiras PCs como features para a grade (o modelo foi treinado em todas as features,
    % mas predizer em 2D é uma aproximação: iremos usar o modelo original aplicando reconstrução parcial)
    % Para consistência: calcular predição do modelo treinado em todas as features onde as outras PCs ficam em 0.
    % Construímos um grid em PC space e projetamos de volta ao feature space aproximado:
    pc1 = linspace(min(score(:,1))-1, max(score(:,1))+1, 200);
    pc2 = linspace(min(score(:,2))-1, max(score(:,2))+1, 200);
    [g1,g2] = meshgrid(pc1, pc2);
    gridPC = [g1(:), g2(:)];
    % Reconstruir aproximação no espaço das features padronizadas:
    % Xz_approx = gridPC * coeff(:,1:2)'  (since score = Xz * coeff)
    Xz_approx = gridPC * coeff(:,1:2)'; % size: Ngrid x nFeatures
    % Predizer usando o modelo (aceita features com mesma dimensão)
    try
        gridPred = predict(MdlECOC, Xz_approx);
        % converter para indices
        [~, ~, gridIdx] = unique(gridPred, 'stable');
        % plot regions
        cmap = lines(numel(cats));
        h = pcolor(g1, g2, reshape(gridIdx, size(g1)));
        set(h,'EdgeColor','none','FaceAlpha',0.25);
        colormap(cmap);
        hold on;
        % plot pontos originais em PC space
        gscatter(score(:,1), score(:,2), y, lines(numel(cats)), '.', 12);
        % plot support vectors projected to PC space (if exist)
        if ~isempty(svAll)
            plot(svScore(:,1), svScore(:,2), 'ko', 'MarkerSize',8, 'LineWidth',1.2);
        end
        xlabel('PC1'); ylabel('PC2');
        title('Decision regions (approx.) on first 2 PCs');
        legend([cellstr(cats); {'Support Vectors'}], 'Location','bestoutside');
        hold off;
    catch ME
        warning('Não foi possível predizer grid em 2D com o modelo treinado: ');
        close; % fechar figura vazia
    end

    % 4.3 Kernel heatmap (RBF) - usar KernelScale se disponível
    % calcular sigma (KernelScale) tentando extrair do primeiro binary learner
    sigmaVal = [];
    if isprop(MdlECOC,'BinaryLearners') && ~isempty(MdlECOC.BinaryLearners)
        try
            % compactSVM possui KernelParameters.Scale
            sigmaVal = MdlECOC.BinaryLearners{1}.KernelParameters.Scale;
        catch
            sigmaVal = [];
        end
    end
    if isempty(sigmaVal)
        sigmaVal = 1; % fallback
    end
    % Distância euclidiana ao quadrado
    D2 = pdist2(Xz, Xz, 'euclidean').^2;
    Kmat = exp(-D2 / (2 * sigmaVal^2));
    % ordenar por classe para visualizar blocos
    [~, idxSort] = sort(double(y));
    Ksorted = Kmat(idxSort, idxSort);
    figure('Name','Kernel matrix (RBF) heatmap','NumberTitle','off');
    imagesc(Ksorted); colorbar; axis square;
    title('Kernel RBF matrix (samples ordered by class)');
    xlabel('Samples (ordered)'); ylabel('Samples (ordered)');    

    
    %% ==================== Funções auxiliares (devem ficar após script principal) ====================
    function feats = extract_time_features_scalar(mat)
    % RECEBE: mat (channels x nSamples)
    % RETORNA: feats -> nSamples x (5*channels)
    % Nota: para uma única medida por canal, std/skew/kurt ficam zero.
        [nCh, nS] = size(mat);
        feats = zeros(nS, 5*nCh);
        for s = 1:nS
            f = zeros(1,5*nCh);
            idx = 1;
            for ch = 1:nCh
                x = mat(ch,s); % único valor do canal na amostra s
                meanv = x;
                stdv  = 0;
                rmsv  = abs(x);
                skewv = 0;
                kurtv = 0;
                f(idx:idx+4) = [meanv, stdv, rmsv, skewv, kurtv];
                idx = idx + 5;
            end
            feats(s,:) = f;
        end
    end
    
    function feats = extract_time_features_vector(matcell)
    % RECEBE: matcell: cell array (nSamples x 1), cada célula = channels x Npoints
    % RETORNA: feats nSamples x (nFeatures_per_channel * channels)
    % Exemplos de features por canal: mean,std,rms,skewness,kurtosis,peak-to-peak,crest
        nSamples = numel(matcell);
        if nSamples == 0
            feats = [];
            return;
        end
        [nCh, ~] = size(matcell{1});
        nFeatPerCh = 7;
        feats = zeros(nSamples, nFeatPerCh * nCh);
        for s = 1:nSamples
            data = matcell{s}; % channels x Npoints
            fv = zeros(1, nFeatPerCh * nCh);
            idx = 1;
            for ch = 1:nCh
                x = data(ch, :);
                fv(idx:idx+6) = [ mean(x), std(x), rms(x), skewness(x), kurtosis(x), (max(x)-min(x)), max(abs(x))/rms(x) ];
                idx = idx + nFeatPerCh;
            end
            feats(s,:) = fv;
        end
    end

    function SvmPipelineFlowchart(outfile)
    if nargin<1, outfile = 'svm_pipeline_flowchart.png'; end
    
    nodes = { 'Input (Healthy, Failure 1, Failure 2, Failure 3)'
              'Feature Extraction'
              'Z-score Normalization'
              'fitcecoc (templateSVM RBF)'
              'Binary learners (pairwise SVMs)'
              'K-fold Cross-validation'
              'Metrics & Confusion Matrix'
              'Visualizations (PCA, boundary, kernel)'
              'Save model (MdlECOC, mu, sigma)' };
    
    % Arcos direcionados em índices (origem -> destino)
    edges = [1 2;
             2 3;
             3 4;
             4 5;
             5 6;
             6 7;
             6 8;
             7 9;
             8 9];
    
    % criar grafo direcionado (somente com listas de arestas)
    G = digraph(edges(:,1), edges(:,2));
    
    % plotar com layout em camadas e depois substituir os rótulos
    figure('Color','w','Units','normalized','Position',[0.2 0.2 0.6 0.6]);
    p = plot(G,'Layout','layered','Direction','right','MarkerSize',7,'LineWidth',1.2);
    p.NodeFontSize = 10;
    p.EdgeAlpha = 0.6;
    p.EdgeColor = [0.2 0.2 0.8];
    
    % substituir os rótulos dos nós
    p.NodeLabel = nodes;
    
    axis off;
    title('Pipeline SVM / ECOC');
    
    drawnow;
    %saveas(gcf, outfile);
    fprintf('Fluxograma salvo em: %s\n', outfile);
    end

end
