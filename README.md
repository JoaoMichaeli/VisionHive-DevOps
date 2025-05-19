# VisionHive-Java

Este projeto representa a aplicação backend da VisionHive, empacotada com Maven, containerizada com Docker e implantada em uma VM no Azure.

---

## 🧪 Tecnologias utilizadas

- Java 17
- Maven
- Docker
- Azure Virtual Machine (Ubuntu 24.04 LTS)
- GitHub
- Swagger (para teste e documentação da API)

---

## 🔧 Etapas DevOps para implantação

### 1. Clonar o repositório
```bash
git clone https://github.com/JoaoMichaeli/VisionHive-Java.git
cd VisionHive-Java
```

### 2. Criar o Dockerfile (caso ainda não exista)
Adicionar um arquivo `Dockerfile` na raiz com o seguinte conteúdo:

```dockerfile
FROM maven:3.9.6-eclipse-temurin-17-alpine AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

FROM eclipse-temurin:17-jdk-alpine
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

### 3. Criar a imagem Docker
```bash
docker build -t joaomichaeli/visionhive-java:v1 .
```

### 4. Fazer login no Docker Hub e publicar a imagem
```bash
docker login
docker push joaomichaeli/visionhive-java:v1
```

### 5. Criar uma máquina virtual na Azure (Ubuntu 24.04)
- Configurar acesso SSH
- Abrir porta 8080 no grupo de segurança de rede

### 6. Conectar à VM via SSH
```bash
az ssh vm --resource-group VisionHive --vm-name VisionHiveSp1 --subscription <ID-DA-SUBSCRIPTION>
```

### 7. Instalar Docker na VM (caso necessário)
```bash
sudo apt update
sudo apt install docker.io -y
sudo usermod -aG docker $USER
newgrp docker
```

### 8. Puxar e rodar o container na VM
```bash
docker pull joaomichaeli/visionhive-java:v1
docker run -d -p 8080:8080 joaomichaeli/visionhive-java:v1
```

---

## 🌐 Acesso à aplicação

- Após subir o container, acesse via navegador:
```
http://<IP-PUBLICO-DA-VM>:8080/swagger-ui/index.html
```

---

## 📌 Observações

- O projeto ainda não possui interface web, apenas o Swagger disponível como ponto de teste e validação de endpoints.
- Certifique-se de expor a porta 8080 no firewall e no NSG da Azure.
