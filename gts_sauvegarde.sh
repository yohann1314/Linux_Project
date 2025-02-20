#!/bin/bash

# Couleurs pour le menu
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Répertoire par défaut pour les sauvegardes
SAUVEGARDE_DIR="/backup"
[[ ! -d "$SAUVEGARDE_DIR" ]] && mkdir -p "$SAUVEGARDE_DIR"

# Fonction pour afficher le menu
menu_sauvegarde() {
    echo -e "${CYAN}=============================="
    echo "Menu de Gestion des Sauvegardes"
    echo -e "==============================${NC}"
    echo "1. Sauvegarde manuelle d'un dossier"
    echo "2. Configurer une sauvegarde automatique"
    echo "3. Lister les tâches de sauvegarde existantes"
    echo "4. Supprimer une tâche de sauvegarde"
    echo "5. Quitter"
    echo -n "Choisissez une option : "
}

# Fonction pour sauvegarder un dossier
sauvegarde_manuelle() {
    echo -n "Entrez le chemin du dossier à sauvegarder : "
    read -r dossier
    if [[ -d "$dossier" ]]; then
        timestamp=$(date +'%Y%m%d_%H%M%S')
        cp -r "$dossier" "$SAUVEGARDE_DIR/sauvegarde_$timestamp"
        echo -e "${GREEN}Sauvegarde terminée : ${SAUVEGARDE_DIR}/sauvegarde_$timestamp${NC}"
    else
        echo -e "${RED}Erreur : Le dossier spécifié n'existe pas.${NC}"
    fi
}

# Fonction pour configurer une sauvegarde automatique
configurer_sauvegarde_automatique() {
    echo -n "Entrez le chemin du dossier à sauvegarder : "
    read -r dossier
    if [[ -d "$dossier" ]]; then
        echo -n "Entrez la fréquence de la sauvegarde (ex : '0 2 * * *' pour tous les jours à 2h) : "
        read -r frequence
        job="$frequence cp -r $dossier $SAUVEGARDE_DIR/sauvegarde_\$(date +'\%Y\%m\%d_\%H\%M\%S')"
        (crontab -l; echo "$job") | crontab -
        echo -e "${GREEN}Sauvegarde automatique configurée.${NC}"
    else
        echo -e "${RED}Erreur : Le dossier spécifié n'existe pas.${NC}"
    fi
}

# Fonction pour lister les tâches cron
lister_taches_cron() {
    echo -e "${GREEN}=== Tâches de sauvegarde ===${NC}"
    crontab -l | grep 'cp -r' || echo "Aucune tâche de sauvegarde configurée."
}

# Fonction pour supprimer une tâche cron
supprimer_tache_cron() {
    echo -e "${GREEN}=== Tâches actuelles ===${NC}"
    crontab -l | grep 'cp -r'
    echo -n "Entrez la ligne exacte de la tâche à supprimer : "
    read -r ligne

    # Vérifier si la tâche existe dans le crontab
    if crontab -l | grep -qF "$ligne"; then
        # Supprimer la tâche
        (crontab -l | grep -vF "$ligne") | crontab -
        echo -e "${GREEN}Tâche supprimée avec succès.${NC}"
    else
        echo -e "${RED}Erreur : La tâche spécifiée n'existe pas.${NC}"
    fi
}


# Boucle principale pour le menu
while true; do
    menu_sauvegarde
    read -r choix
    case $choix in
        1)
            sauvegarde_manuelle ;;
        2)
            configurer_sauvegarde_automatique ;;
        3)
            lister_taches_cron ;;
        4)
            supprimer_tache_cron ;;
        5)
            echo -e "${GREEN}Retour au menu principal...${NC}"
            exit 0 ;;
        *)
            echo -e "${RED}Option invalide. Veuillez réessayer.${NC}" ;;
    esac
    echo ""
done
