#!/bin/bash

# Couleurs pour le menu
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Vérifier si l'utilisateur est root
if [ "$EUID" -ne 0 ]; then 
  echo "Ce script doit être exécuté en tant que superutilisateur (root)."
  exit 1
fi

# Menu interactifs
menu_crons() {
    echo -e "${CYAN}================================="
    echo "Menu de gestion des tâches cron :"
    echo "1. Afficher les tâches cron"
    echo "2. Ajouter une tâche cron"
    echo "3. Supprimer une tâche cron"
    echo "4. Quitter"
    echo -e "=================================${NC}"
    echo -n "Choisissez une option : "
}

# Afficher les tâches cron
function afficher_taches_cron() {
    if crontab -l 2>/dev/null | grep -q .; then 
        crontab -l
    else
        echo "Aucune tâche cron configurée."
    fi
    read -p "Appuyez sur Entrée pour continuer."
}

# Ajouter une tâche cron
function ajouter_tache_cron() {
    read -p "Entrez la commande à exécuter : " commande

    read -p "Entrez la fréquence (* * * * *, m h dom mon dow): " frequence

    read -p "Entrez le chemin absolu du fichier de sortie : " fichier_sortie

    if ! touch "$fichier_sortie" 2>/dev/null; then
        echo "Erreur : Impossible d'écrire dans le fichier spécifié ($fichier_sortie)."
        return 1
    fi
    
    (crontab -l 2>/dev/null; echo "$frequence $commande > $fichier_sortie 2>&1") | crontab -
    echo "Tâche cron ajoutée avec succès."
}


# Supprimer une tâche cron
function supprimer_tache_cron() {
    crontab -l 2>/dev/null | nl -w 2 -s ') '
    read -p "Entrez le numéro de la tâche à supprimer : " numero
    crontab -l 2>/dev/null | sed "${numero}d" | crontab -
    echo "Tâche cron supprimée avec succès."
}

# Menu principal
while true; do
    menu_crons;
    read -r choix;
    case $choix in
      1) afficher_taches_cron ;;
      2) ajouter_tache_cron ;;
      3) supprimer_tache_cron ;;
      4) break ;;
      *) echo "Option invalide." ;;
    esac
  echo ""
done
