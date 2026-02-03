Este repositório não é apenas um código de estudo. Ele é a "espinha dorsal" técnica do que aplico no meu SaaS (Sem Viagem), mas aqui eu o trouxe de forma genérica para que outros engenheiros possam usar como base.

Por que criei isso?
No dia a dia, percebi que muita gente sobe buckets no S3 sem pensar no custo ou em quem vai acessar o quê. Aqui, eu quis provar que dá para ter um fluxo de Big Data (Bronze/Silver/Gold) que seja barato (FinOps) e seguro (IAM) desde o primeiro dia.

O que você vai encontrar aqui:
Infra que se paga: Usei regras de ciclo de vida no S3. Se o dado é velho e ninguém usa, ele vai para o "arquivo morto" (Glacier) automaticamente. Menos custo, mais inteligência.

Dados que fazem sentido: Não adianta ter um mar de JSONs bagunçados. Eu uso PySpark para limpar a bagunça (Silver) e dbt para deixar tudo pronto para o BI (Gold).

Segurança de verdade: Nada de admin para tudo. O uploader só faz upload, o processador só processa. Simples e seguro.

Nota de bastidor: Se você quer ver como isso escala na vida real, dê uma olhada no diretório /infra. Ali o Terraform faz o trabalho pesado para que a gente possa focar no que importa: o dado.

🛠️ Visão Técnica
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