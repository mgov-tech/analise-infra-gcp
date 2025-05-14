# Instruções de Autenticação GCP

Para acessar os recursos do Google Cloud Platform da MOVVA, siga os passos abaixo:

## 1. Autenticação com Conta de Usuário

Execute o seguinte comando e siga as instruções para autenticar com sua conta Google:

```bash
gcloud auth login
```

Este comando abrirá seu navegador para fazer login. Após concluir o login, você será redirecionado de volta ao terminal.

## 2. Configuração do Projeto Padrão

Após autenticar, liste os projetos disponíveis:

```bash
gcloud projects list
```

Configure o projeto padrão que deseja utilizar:

```bash
gcloud config set project NOME_DO_PROJETO
```

## 3. Verificação de Acesso

Verifique se você tem acesso adequado executando:

```bash
gcloud services list
```

## 4. Autenticação para APIs

Para utilizar os serviços programaticamente, configure as credenciais de aplicação:

```bash
gcloud auth application-default login
```

## 5. Usando Service Accounts (Alternativa)

Caso precise utilizar uma service account:

1. Baixe a chave JSON da service account do Console GCP
2. Configure a variável de ambiente:

```bash
export GOOGLE_APPLICATION_CREDENTIALS=/caminho/para/arquivo-chave.json
```

3. Autentique usando a service account:

```bash
gcloud auth activate-service-account --key-file=/caminho/para/arquivo-chave.json
```
