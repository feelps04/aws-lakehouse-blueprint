Este repositório não é apenas um código de estudo. Ele é a "espinha dorsal" técnica do que aplico no meu SaaS (Sem Viagem), mas aqui eu o trouxe de forma genérica para que outros engenheiros possam usar como base.

Por que criei isso?
No dia a dia, percebi que muita gente sobe buckets no S3 sem pensar no custo ou em quem vai acessar o quê. Aqui, eu quis provar que dá para ter um fluxo de Big Data (Bronze/Silver/Gold) que seja barato (FinOps) e seguro (IAM) desde o primeiro dia.

O que você vai encontrar aqui:
Infra que se paga: Usei regras de ciclo de vida no S3. Se o dado é velho e ninguém usa, ele vai para o "arquivo morto" (Glacier) automaticamente. Menos custo, mais inteligência.

Dados que fazem sentido: Não adianta ter um mar de JSONs bagunçados. Eu uso PySpark para limpar a bagunça (Silver) e dbt para deixar tudo pronto para o BI (Gold).

Segurança de verdade: Nada de admin para tudo. O uploader só faz upload, o processador só processa. Simples e seguro.

Nota de bastidor: Se você quer ver como isso escala na vida real, dê uma olhada no diretório /infra. Ali o Terraform faz o trabalho pesado para que a gente possa focar no que importa: o dado.

🛠️ Visão Técnica

🛡️ Governança e Segurança Cross-Account
Este projeto foi desenhado seguindo o Well-Architected Framework da AWS. Em vez de uma conta única e caótica, a arquitetura está preparada para ambientes segregados:

Least Privilege (IAM): Nenhuma função ou usuário tem permissão FullAccess.

O Ingestor possui apenas s3:PutObject no bucket Bronze.

O Glue Job possui permissões de leitura no Bronze e escrita no Silver, sem acesso à camada Gold.

As políticas são anexadas via Managed Policies via Terraform para facilitar auditoria.

Pronto para Cross-Account: A estrutura de IAM utiliza roles que podem ser assumidas (AssumeRole) por identidades de outras contas (ex: conta de Analytics acessando a conta de Produção), garantindo que as chaves de acesso nunca saiam de seus respectivos perímetros.

O Diagrama de Arquitetura (O "Pulo do Gato")
Como você não vai postar o código real de cross-account (para manter o blueprint simples de rodar), o Diagrama é onde você prova que sabe fazer.

Dica de Arquiteto: Desenhe no Excalidraw (é grátis e tem um visual limpo) um fluxo assim:

Box 1 (Conta App): Mostre o seu SaaS (Sem Viagem) gerando os dados.

Seta: Mostre o dado sendo enviado para uma conta de Data Lake centralizada via Role Cross-Account.

Box 2 (Conta Data Lake): Mostre as camadas Bronze, Silver e Gold.

Box 3 (Conta Analytics/BI): Mostre o Athena ou QuickSight buscando os dados da Gold via permissões delegadas.

Por que fazer isso? Isso mostra que você sabe resolver o problema de "Como eu dou acesso ao time de BI sem deixar eles verem a conta de Produção?".

Arquitetura
Snippet de código
flowchart LR
    A[Gerador de Dados] -->|JSON| B[S3 Bronze]
    B -->|Glue Job| C[S3 Silver (Parquet)]
    C -->|dbt| D[S3 Gold]
    D --> E[Athena / BI]
Automação (CI/CD)
O projeto inclui um GitHub Action inteligente que valida toda a infraestrutura a cada Pull Request. Ele garante que o código Terraform está formatado e sintaticamente correto antes de qualquer alteração chegar na main.

Como rodar
Infra: cd infra/terraform && terraform apply

Dados: cd data-generator && python generate_and_upload.py

Processo: O script de limpeza está em jobs/pyspark/bronze_to_silver.py