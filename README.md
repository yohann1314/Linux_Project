# 📌 Gestion des Tâches Système (GTS)

## 📖 Introduction

Ce projet propose une série de scripts bash permettant de gérer efficacement un système Linux. Il inclut des fonctionnalités telles que la gestion des utilisateurs, la planification de tâches (cron), la surveillance système, la sauvegarde des fichiers et la journalisation des événements.

## 🚀 Installation

Cloner le dépôt :
```bash
git clone https://github.com/yohann1314/Linux_Project.git
cd Linux_Project/
```

Rendre les scripts exécutables :
```bash
chmod +x main.sh gts_utilisateurs.sh gts_cron.sh gts_surveillance.sh gts_sauvegarde.sh gts_journalisation.sh
```

Exécuter le script principal :
```bash
./main.sh
```

## 📜 Fonctionnalités

### 📌 1. Menu Principal (main.sh)

#### 📌 Fonctionnalité :
Le menu principal permet de naviguer facilement entre les différentes options du programme.

#### ⚙️ Implémentation :

- Utilisation d’une boucle while pour afficher le menu en continu.
- Lecture du choix utilisateur avec read.
- Utilisation d’un case pour exécuter les scripts correspondants en fonction du choix.

#### 📌 Exemple de code :

```bash
Copier
Modifier
while true; do
    echo "1. Gestion des utilisateurs"
    read -p "Choisissez une option : " choix
    case $choix in
        1) ./gts_utilisateurs.sh ;;
        2) exit 0 ;;
    esac
done
```

### 👤 2. Gestion des Utilisateurs (gts_utilisateurs.sh)

#### 📌 Fonctionnalité :
Ajout, suppression et gestion des utilisateurs Linux.

#### ⚙️ Implémentation :

- Utilisation de adduser pour ajouter un utilisateur.
- Utilisation de deluser pour supprimer un utilisateur.
- Utilisation de cat /etc/passwd pour lister les utilisateurs.
#### 📌 Exemple de code :
```bash
Copier
Modifier
read -p "Nom de l'utilisateur à ajouter : " user
sudo adduser "$user"
```

### ⏳ 3. Gestion des Tâches Planifiées (gts_cron.sh)

#### 📌 Fonctionnalité :
Automatisation des tâches grâce à cron.

#### ⚙️ Implémentation :

- Utilisation de crontab -l pour afficher les tâches existantes.
- Ajout d’une tâche avec echo "0 3 * * * script.sh" | crontab -.
- Suppression d’une tâche via crontab -e.

#### 📌 Exemple de code :
```bash
Copier
Modifier
echo "0 3 * * * /path/to/script.sh" | crontab -
```

### 📊 4. Surveillance du Système (gts_surveillance.sh)

Permet de surveiller les ressources système et l'état des processus.

#### 📌 Fonctionnalité :
Affichage des ressources système comme l’espace disque et les processus en cours.

#### ⚙️ Implémentation :

- Utilisation de df -h pour afficher l’espace disque.
- Utilisation de ps aux --sort=-%mem | head -6 pour lister les processus gourmands.

#### 📌 Exemple de code :
```bash
Copier
Modifier
df -h
ps aux --sort=-%mem | head -6
```

### 💾 5. Sauvegarde des Dossiers (gts_sauvegarde.sh)

Automatise la sauvegarde des fichiers et dossiers avec la possibilité de définir des tâches récurrentes.

#### 📌 Fonctionnalité :
Créer des archives .tar.gz pour sauvegarder des fichiers.

#### ⚙️ Implémentation :

- Utilisation de tar -czvf backup.tar.gz /chemin/du/dossier.

#### 📌 Exemple de code :
```bash
Copier
Modifier
tar -czvf backup.tar.gz /home/user/Documents
```

### 📝 6. Journalisation Système (gts_journalisation.sh)

Facilite la configuration et la gestion des logs système avec rsyslog.

#### 📌 Fonctionnalité :
Consulter les logs système et configurer rsyslog.

#### ⚙️ Implémentation :

- Utilisation de tail -n 20 /var/log/syslog pour afficher les logs récents.
- Configuration avancée via rsyslog.conf.
#### 📌 Exemple de code :
```bash
Copier
Modifier
tail -n 20 /var/log/syslog
```

## 🛠️ Prérequis

- Un système Linux (Ubuntu, Debian, CentOS...)

- Accès superutilisateur (sudo)

## 📌 Utilisation

Lancer le script principal :

```bash
./main.sh
```
Puis suivre les instructions du menu pour naviguer parmi les différentes options.

## 📢 Remarques

Si vous rencontrez des erreurs de permissions, assurez-vous que les scripts sont bien exécutables :

```bash
chmod +x *.sh
```
## 📧 Contact

Pour toute question ou amélioration, n’hésitez pas à ouvrir une issue ou à me contacter ! 🚀
