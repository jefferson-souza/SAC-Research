# Repositório — Análise de Vibração em Drones (SAC-DM / SAC-AM)

## Descrição
Este repositório contém os dados, código e ferramentas utilizados no estudo de análise de sinais de vibração e classificação de falhas em motores BLDC de um quadricóptero. A estrutura organiza conjuntos de dados, firmware da placa ESP32, servidor UDP para recepção dos pacotes de dados e scripts/funções MATLAB para pré‑processamento, extração de features e avaliação dos classificadores.

## Estrutura de pastas
- `dataSets/`  
  Contém os dados brutos e processados utilizados na pesquisa (arquivos de aceleração triaxial, metadados e splits de treino/teste). Organização por cenário (Healthy, Failure1, Failure2, Failure3). Inclui um README interno com formato dos arquivos e convenções de nomenclatura.

- `src/esp32/`  
  Código-fonte e instruções para o firmware executado no ESP32 (aquisição do ADXL345, formatação e envio via UDP). Contém scripts de build/flash e arquivo de configuração com parâmetros de aquisição (taxa de amostragem, escala do acelerômetro, pinos).

- `src/UDP_Server/`  
  Implementação em Python do servidor UDP responsável por receber e armazenar os pacotes enviados pelo ESP3.

- `src/MatLab/`  
  Scripts e funções MATLAB utilizadas para pré‑processamento (filtragem, segmentação, normalização), extração de features (SAC-DM, SAC-AM), treinamento e avaliação dos classificadores (MLP e SVM) e geração de figuras e tabelas do artigo.

## Como usar (resumo rápido)
1. ESP32: ajuste parâmetros em `src/esp32/config` e faça o flash do firmware conforme instruções do README interno; inicie a aquisição e transmissão via UDP.  
2. Servidor UDP: instale dependências (`pip install -r src/UDP_Server/requirements.txt`), inicie o servidor para receber e salvar os pacotes em formato compatível com `src/MatLab`.  
3. MATLAB: abra a pasta `src/MatLab`, ajuste os caminhos de entrada (apontando para `dataSets/`) e execute os scripts principais para pré‑processamento, extração de features e avaliação. Consulte os scripts para parâmetros de validação cruzada e geração de relatórios.

## Dependências e requisitos
- ESP32 toolchain (esptool / PlatformIO / Arduino IDE) conforme preferir.  
- Python 3.8+ e bibliotecas listadas.  
- MATLAB (versão compatível com Signal Processing Toolbox; ver comentários nos scripts para versões mínimas).

## Agradecimentos / Apoio
Esta pesquisa foi apoiada pela Universidade Federal da Paraíba (UFPB) e pelo LASER — Laboratório de Engenharia de Sistemas e Robótica.  

## Licença e crédito
licença `LICENSE CC BY INCLUDED`

