# Rotinas de Manutenção
__________________
### Subir Exames COVID-19 / Servidor Local

- Entrar no site do GAL https://gal.saude.sc.gov.br/login/


- **Login:ve.fpolis13   Senha:...** (usuário e senha mudam uma vez por mês -> verificar com a GERVE - Larissa)
- Na aba a esqueda selecionar Biologia Medica > Relatorios > Relatórios Epidemiológicos Por Exame
- Dar 2 clicks Relatórios Epidemiológicos Por Exame e nos campos selecionar : **Requisição**,**Paciente**,**Data de Nascimento**,**Data da Liberação**

- Campo da Data > **Sempre um dia Antes**, **Obs:Segunda feira selecionar sext,sab,dom**
- Período > **Por data de liberação**
- Selecionar o exame : **COVID-19 BIOLOGIA MOLECULAR / RTPCR EM TEMPO REAL**
- Gerar o Relatorio, extrair o **gal-relatorio-epidemiologia-exame.RAR**, renomear **data.csv** para **resultado_gal.csv**
- Abrir o **WinSPC** jogar  **resultado_gal** dentro do diretorio **ss/R/vinculacao_bases/gal_celk/**
- Entrar no RStudio > **http://172.17.50.8:8787/**, selecionar o projeto **vinculação_bases** que fica no canto superior direito, e rodar o script **vinculação_gal_celk.R**
- Ao finalizar o script voltar no **WinSPC** no mesmo diretorio, e copiar o arquivo **base_importacao_gal_celk2_c_fone_latin1** mover para sua desktop.
- Abrir o site do celk >  **https://florianopolis.celk.com.br/** entrar com suas credenciais, no canto superior direito apertar no icone de **lupa** digitar o codigo **1001** selecionar a opção **importação de exames covid-19**, escolher o arquivo que você moveu para a desktop **base_importacao_gal_celk2_c_fone_latin1** clicar em importar aquivos, uma mensagem aparecerá se subiu os exames corretamente.
_______________________________

### Atualizar o Cenário / Servidor Local
- Rodar apenas com a rotina **Subir exames** concluída.

- Entrar no RStudio > **http://172.17.49.10:8787/**, selecionar o projeto **cenario_covid_florianopolis** rodar o script **05-cenarios.R**
- Depois de finalizado olhar se foi atualizada a planilha **https://docs.google.com/spreadsheets/d/1Ya0urjD781uutQwRu95Pbc9JXsilb6qmnDHU8Kg7nq8/edit#gid=868562419**
_______________________________

### Envio de dados sobre a COVID-19 / Servidor Remoto

- Abrir o **WinSPC** entrar no diretório **fmsf/relatorios/coronavirus/data/tr_lacen** copiar o arquivo **tr_lacen** com a data mais recente para sua desktop.

- Entrar no site **https://www.sc.gov.br/servicos/detalhe/envio-de-dados-sobre-a-covid-19** com suas credenciais selecionar a opção em vermelho **SOLICITAR**, selecionar **Enviar arquivos com os dados do paciente**, clicar na seta vermelha e selecionar o arquivo **tr_lacen** que você moveu para a desktop, em seguida clicar em **ENVIAR DADOS**.
_______________________________