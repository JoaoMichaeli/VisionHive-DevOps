# VisionHive-DevOps

Este projeto demonstra a criação completa de uma aplicação Java Spring Boot hospedada no **Azure App Service**, conectada a um **PostgreSQL Single Server**. Inclui a criação do App Service, banco de dados, configuração de connection string e variáveis de ambiente, tudo via Azure CLI.

---

## 1. Criar Resource Group
```bash
az group create --name rg-visionhive --location brazilsouth
```

## 2. Criar App Service Plan
- Plano gratuito para Linux, preparado para Java 17.
```bash
az appservice plan create --name plan-visionhive --resource-group rg-visionhive --sku F1 --is-linux
```

## 3. Criar Web App
- Isso cria o App Service já preparado para receber o .jar ou deploy via Git.
- --deployment-local-git habilita deploy via git push.
```bash
az webapp create --resource-group rg-visionhive --plan plan-visionhive --name visionhive-app --runtime "JAVA:17-java17" --deployment-local-git
```

## 4. Criar PostgreSQL Flexible Server
- --public-network-access Enabled → acesso público (bom para testes)
```bash
az postgres flexible-server create \
  --name visionhive-db \
  --resource-group rg-visionhive \
  --location brazilsouth \
  --admin-user visionadmin \
  --admin-password 'Vision123!' \
  --sku-name Standard_B1ms \
  --tier Burstable \
  --storage-size 32 \
  --version 15 \
  --public-access all
```

## 5. Configurar firewall para permitir acesso do App Service
- Aqui estou liberando para todos (facilita a Sprint).
- Se quiser, pode restringir para o IP do App Service.
```bash
az postgres flexible-server firewall-rule create \
  --resource-group rg-visionhive \
  --name visionhive-db \
  --rule-name AllowAppService \
  --start-ip-address 0.0.0.0 \
  --end-ip-address 255.255.255.255
```

## 6. Configurar Connection String no App Service
### Pegue a string do Flexible Server:
```bash
az postgres flexible-server show-connection-string \
  --server-name visionhive-db \
  --database-name postgres \
  --admin-user visionadmin \
  --admin-password 'Vision123!'
```

### Configure no App Service:
```bash
az webapp config connection-string set \
  --resource-group rg-visionhive \
  --name visionhive-app \
  --connection-string-type PostgreSQL \
  --settings 'DefaultConnection=jdbc:postgresql://visionhive-db.postgres.database.azure.com:5432/postgres?user=visionadmin&password=Vision123\!&sslmode=require'
```

### Verificar a connection string:
```bash
az webapp config connection-string list \
  --resource-group rg-visionhive \
  --name visionhive-app
```

## 7. Configurar variáveis de ambiente (App Settings) para Spring Boot
```bash
az webapp config appsettings set \
  --resource-group rg-visionhive \
  --name visionhive-app \
  --settings SPRING_DATASOURCE_URL='jdbc:postgresql://visionhive-db.postgres.database.azure.com:5432/postgres' \
             SPRING_DATASOURCE_USERNAME='visionadmin' \
             SPRING_DATASOURCE_PASSWORD='Vision123!' \
             SPRING_JPA_HIBERNATE_DDL_AUTO='update'
```

## 8. Deploy do .jar no App Service
```bash
az webapp deploy \
  --resource-group rg-visionhive \
  --name visionhive-app \
  --type jar \
  --src-path build/libs/VisionHive-0.0.1-SNAPSHOT.jar
```
