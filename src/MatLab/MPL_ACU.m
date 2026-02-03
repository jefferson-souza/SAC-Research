
function MPLACU = MPL_ACU(normal, falha1, falha2, falha3)
    rng(1); %  reprodutibilidade
    X = [normal, falha1, falha2, falha3]; % Concatenar os dados
    num_amostras = size(X, 2);
    
    % Rótulos das classes (One-Hot Encoding)
    Y = [repmat([1; 0; 0; 0], 1, size(normal, 2)), ...
         repmat([0; 1; 0; 0], 1, size(falha1, 2)), ...
         repmat([0; 0; 1; 0], 1, size(falha2, 2)), ...
         repmat([0; 0; 0; 1], 1, size(falha3, 2)) 
         ];
    
    %% 3. Criar Rede Neural Feedforward Backpropagation
    hidden_layer_sizes = [20, 10]; % 2 camadas ocultas com 10 e 5 neurônios
    net = feedforwardnet(hidden_layer_sizes, 'trainlm'); % Algoritmo Levenberg-Marquardt
    
    % Configuração das funções de ativação
    net.layers{1}.transferFcn = 'logsig'; % Função sigmoide
    net.layers{2}.transferFcn = 'logsig';
    net.layers{3}.transferFcn = 'softmax'; % Softmax para classificação com probabilidade
    
    % Configuração do treinamento
    net.trainParam.epochs = 500;
    net.trainParam.goal = 1e-4;
    net.trainParam.min_grad = 1e-6;
    net.trainParam.showWindow = true;
    net.divideParam.trainRatio = 0.5; % 70% treino
    net.divideParam.valRatio = 0.25; % 15% validação
    net.divideParam.testRatio = 0.25; % 15% teste
    
    %% 4. Treinar a Rede Neural
    [net, tr] = train(net, X, Y);
    
    %% 5. Testar a Rede Neural
    Y_pred = net(X);
    
    %% 6. Obter Rótulos Preditos e Probabilidades de Classificação
    [~, predicted_labels] = max(Y_pred, [], 1); % Rótulo da classe predita
    [~, true_labels] = max(Y, [], 1); % Rótulo real
    
    %% 7. Gerar Matriz de Confusão
    conf_matrix = confusionmat(true_labels, predicted_labels);
    
    %% 8. Exibir Matriz de Confusão
    figure;
    confusionchart(conf_matrix, {'Healthy', 'Failure 1', 'Failure 2', 'Failure 3'});
    title('Confusion Matrix Perceptron with SAC-AM(XYZ) + SAC-DM(X) Filter');
    xlabel('Predict Class');
    ylabel('True Class');
    
    %% 9. Calcular Acurácia
    MPLACU = sum(diag(conf_matrix)) / sum(conf_matrix(:));
    disp(['Acurácia da Rede Neural SAC_DM: ', num2str(MPLACU)]);
    
    %% 10. Exibir Probabilidades de Classificação para Amostras de Teste
    disp('Probabilidades de Classificação para as Amostras:');
    %disp(Y_pred);
    
    save('rede_treinada_sac_dm.mat', 'net');
    
    disp('Rede Neural treinada e salva com sucesso!');


end