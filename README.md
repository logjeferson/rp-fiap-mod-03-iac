# Infrastructure as Code (IaC) - AWS Platform

> 🎓 **Projeto Acadêmico - FIAP**
> Este repositório é um projeto de estudos desenvolvido para o curso de **Pós-graduação em DevOps e Arquitetura Cloud da FIAP**. O ambiente arquitetado possui fins estritamente educacionais e aborda a resolução de um cenário técnico específico proposto em sala de aula.

Este repositório contém o código Terraform responsável pelo provisionamento e gerenciamento da infraestrutura base na nuvem AWS. Ele sustenta o ecossistema de microsserviços do projeto, implementando práticas de escalabilidade, segurança e automação ponta a ponta exigidas no desafio acadêmico.

## 🏗️ Arquitetura Base

A infraestrutura foi desenhada para suportar aplicações conteinerizadas de alta disponibilidade, dependências de mensageria e bancos de dados relacionais e NoSQL:

*   **Computação:** Amazon EKS (Elastic Kubernetes Service) para orquestração dos microsserviços.
*   **Containers:** Amazon ECR (Elastic Container Registry) para armazenamento seguro das imagens Docker.
*   **Mensageria & Assincronismo:** Amazon SQS gerido via boto3 pelos workers.
*   **Bancos de Dados:** 
    *   PostgreSQL (RDS) gerenciado com pool de conexões (psycopg2).
    *   Amazon DynamoDB para persistência NoSQL.

## 🌿 Ambientes e Estratégia de Branches

O provisionamento simula o modelo GitFlow de mercado, garantindo isolamento estrito entre as fases do ciclo de vida do software. A infraestrutura é segregada nos seguintes ambientes:

*   **DEV (Development):** Foco em testes iniciais e integração contínua das features branches.
*   **SIT (System Integration Testing):** Validação de comunicação entre os microsserviços e dependências externas.
*   **UAT (User Acceptance Testing):** Ambiente homologável, espelho fiel da produção.
*   **PRD (Production):** Simulação de cargas de trabalho reais com alta disponibilidade.

## 🔐 Segurança e Autenticação

A arquitetura do projeto prioriza o conceito de "Zero-Touch" para gestão de credenciais e acessos:

*   **OIDC Identity Federation:** As esteiras de CI/CD não utilizam chaves estáticas (Access Keys de longa duração). A federação OIDC garante tokens efêmeros e seguros durante a comunicação entre o GitHub Actions e a AWS.
*   **Segregação de Acesso:** Permissões de IAM granulares aplicadas por serviço (ex: SQS e DynamoDB) utilizando roles no nível do pod do EKS (IRSA).

## 🚀 Integração e Entrega Contínua (CI/CD)

Os fluxos de aplicação hospedados no GitHub Actions interagem com esta infraestrutura seguindo um pipeline rigoroso de validação e segurança:

1.  **Qualidade de Código (SAST):** Análise estática através do SonarCloud.
2.  **Análise de Vulnerabilidades (SCA):** Scans de sistema de arquivos e imagens Docker utilizando o Trivy.
3.  **Testes Unitários:** Execução de suítes de testes (`pytest`) com `unittest.mock` para isolamento de dependências (Boto3, psycopg2, Auth).
4.  **Versionamento de Imagem:** Tagging imutável utilizando o hash do commit (`${{ github.sha }}`).

## 📦 Microsserviços Suportados

A malha do EKS provisionada por este repositório atende o deploy dos seguintes serviços do ecossistema estudado:

*   `analytics-service` (Python/Flask, SQS, DynamoDB)
*   `flag-service` (Python/Flask, PostgreSQL, Auth Middleware)
*   `targeting-service` (Python/Flask, PostgreSQL/JSON rules, Auth Middleware)
*   `auth-service` (Go/Python - Validação de tokens e acessos)

## 🛠️ Como Executar (Uso Local)

Certifique-se de ter o [Terraform](https://www.terraform.io/) e o [AWS CLI](https://aws.amazon.com/cli/) instalados e devidamente autenticados via OIDC ou sua conta de laboratório AWS.

```bash
# 1. Inicializar os módulos e backend
terraform init

# 2. Selecionar o workspace correspondente ao ambiente (ex: dev, sit, uat, prd)
terraform workspace select dev

# 3. Validar o plano de execução
terraform plan -var-file="envs/dev.tfvars" -out=tfplan

# 4. Aplicar as mudanças na AWS
terraform apply tfplan
