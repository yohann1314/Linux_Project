📌 Gestion des Tâches Système (GTS)

📖 Introduction

Ce projet propose une série de scripts bash permettant de gérer efficacement un système Linux. Il inclut des fonctionnalités telles que la gestion des utilisateurs, la planification de tâches (cron), la surveillance système, la sauvegarde des fichiers et la journalisation des événements.

🚀 Installation

Cloner le dépôt (si applicable) :
```bash
git clone https://github.com/votre-repo.git
cd votre-repo
```

Rendre les scripts exécutables :
```bash
chmod +x main.sh gts_utilisateurs.sh gts_cron.sh gts_surveillance.sh gts_sauvegarde.sh gts_journalisation.sh
```

Exécuter le script principal :
```bash
./main.sh
```

📜 Fonctionnalités

📌 1. Menu Principal (main.sh)

Ce script est l'entrée principale du projet. Il affiche un menu interactif permettant d'accéder aux différentes fonctionnalités.

Vérifie que tous les scripts nécessaires sont exécutables.

Propose les options suivantes :

Gestion des utilisateurs et groupes

Automatisation des tâches (cron)

Surveillance système

Sauvegarde des fichiers

Configuration de la journalisation

Quitter

👤 2. Gestion des Utilisateurs (gts_utilisateurs.sh)

Permet de gérer les utilisateurs et groupes sous Linux avec un menu interactif.

✅ Fonctionnalités :

Créer et supprimer des utilisateurs

Créer des groupes

Lister les utilisateurs

Ajouter un utilisateur à un groupe

Définir un quota utilisateur

Configurer l'accès sudo

⏳ 3. Gestion des Tâches Planifiées (gts_cron.sh)

Ce script facilite la gestion des tâches automatisées via cron.

✅ Fonctionnalités :

Afficher les tâches cron existantes

Ajouter une nouvelle tâche cron

Supprimer une tâche cron spécifique

📊 4. Surveillance du Système (gts_surveillance.sh)

Permet de surveiller les ressources système et l'état des processus.

✅ Fonctionnalités :

Afficher l’espace disque utilisé

Lister les processus actifs

Surveiller l’utilisation de la mémoire

💾 5. Sauvegarde des Dossiers (gts_sauvegarde.sh)

Automatise la sauvegarde des fichiers et dossiers avec la possibilité de définir des tâches récurrentes.

✅ Fonctionnalités :

Sauvegarde manuelle d’un dossier

Planification d’une sauvegarde automatique via cron

Affichage et suppression des tâches de sauvegarde

📝 6. Journalisation Système (gts_journalisation.sh)

Facilite la configuration et la gestion des logs système avec rsyslog.

✅ Fonctionnalités :

Vérifier et installer rsyslog

Configurer la journalisation centralisée

Mettre en place une rotation des journaux

Activer la journalisation avancée pour certains services critiques (SSH, Apache, MySQL)

🛠️ Prérequis

Un système Linux (Ubuntu, Debian, CentOS...)

Accès superutilisateur (sudo)

bash, cron, rsyslog installés

📌 Utilisation

Lancer le script principal :

```bash
./main.sh
```
Puis suivre les instructions du menu pour naviguer parmi les différentes options.

📢 Remarques

Si vous rencontrez des erreurs de permissions, assurez-vous que les scripts sont bien exécutables :

```bash
chmod +x *.sh
```
📧 Contact

Pour toute question ou amélioration, n’hésitez pas à ouvrir une issue ou à me contacter ! 🚀
