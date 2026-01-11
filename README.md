# Projet DevOps

**Auteur :** Bentaleb Badr Eddine

## Description

Ce projet démontre une implémentation complète d'un pipeline DevOps utilisant Git, GitHub, GitHub Actions, Jenkins, Docker, et l'intégration Slack.

## Structure du projet

```
Projet-DevOps-BentalebBadrEddine/
├── src/
│   ├── main/java/com/devops/
│   │   └── App.java
│   └── test/java/com/devops/
│       └── AppTest.java
├── .github/workflows/
│   └── ci.yml
├── Dockerfile
├── docker-compose.yml
├── Jenkinsfile
├── pom.xml
└── README.md
```

## Technologies utilisées

- **Java 17** / **Maven**
- **Git** & **GitHub**
- **GitHub Actions**
- **Jenkins**
- **Docker** & **Docker Compose**
- **Slack** (pour les notifications)

## Prérequis

- Java 17 ou supérieur
- Maven 3.6+
- Docker et Docker Compose
- Jenkins (déployé via Docker)
- Compte GitHub
- Webhook Slack (optionnel)

## Installation et exécution locale

### Build avec Maven

```bash
mvn clean compile
mvn test
mvn package
```

### Exécution

```bash
java -cp target/projet-devops-1.0.0.jar com.devops.App
```

Ou directement :

```bash
mvn exec:java -Dexec.mainClass="com.devops.App"
```

### Build avec Docker

```bash
docker build -t projet-devops:latest .
docker run projet-devops:latest
```

### Docker Compose

```bash
docker-compose up --build
```

## Pipeline Jenkins

Le pipeline Jenkins est défini dans le fichier `Jenkinsfile` et comprend les étapes suivantes :

1. **Checkout** : Récupération du code depuis GitHub
2. **Build** : Compilation et tests avec Maven
3. **Archive** : Archivage des artefacts
4. **Deploy** : Déploiement de l'application
5. **Notify Slack** : Envoi de notifications vers Slack

## GitHub Actions

Le workflow GitHub Actions (`.github/workflows/ci.yml`) est déclenché sur :
- Push vers les branches `main` et `dev`
- Pull Requests

Il exécute les tests et le build avec Maven.

## Licence

MIT License
