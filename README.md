# Template: Lambda + CloudWatch (IaC)

**Descripción**
Esta plantilla estandarizada de Infraestructura como Código (IaC), desarrollada en **Terraform**, permite el aprovisionamiento automatizado y gobernado de arquitecturas Serverless compuestas por funciones **AWS Lambda** impulsadas por eventos programados de **Amazon CloudWatch Events / EventBridge**.

> **Propósito del Repositorio:** Este repositorio contiene un **ejemplo de los archivos base y la plantilla de Terraform** utilizados para el aprovisionamiento de la función Lambda. Los manifiestos están diseñados para ser consumidos y parametrizados de forma dinámica por el motor de *Scaffolding* de Backstage.

**Componentes Provisionados**
* **AWS Lambda Function:** Código base ejecutable e integración de runtime.
* **CloudWatch Event Rule & Target:** Programación tipo Cron/Rate para la activación periódica.
* **IAM Roles & Policies:** Políticas de menor privilegio e inyección de permisos de ejecución y logueo (CloudWatch Logs).