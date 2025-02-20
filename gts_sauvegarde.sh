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
    echo "3. Lister les sauvegardes existantes"
    echo "4. Supprimer une tâche de sauvegarde"
    echo "5. Quitter"
    echo -n "Choisissez une option : "
}

# Fonction pour sauvegarder un dossier (manuelle)
sauvegarde_manuelle() {
    echo -n "Entrez le chemin du dossier à sauvegarder : "
    read -r dossier
    if [[ -d "$dossier" ]]; then
        timestamp=$(date +'%Y%m%d_%H%M%S')
        sauvegarde_dir="$SAUVEGARDE_DIR/sauvegarde_$timestamp"
        cp -r "$dossier" "$sauvegarde_dir"
        
        # Enregistrer la sauvegarde manuelle dans un fichier log
        echo "Sauvegarde manuelle de $dossier effectuée à $timestamp" >> "$SAUVEGARDE_DIR/sauvegardes_log.txt"
        
        echo -e "${GREEN}Sauvegarde terminée : $sauvegarde_dir${NC}"
    else
        echo -e "${RED}Erreur : Le dossier spécifié n'existe pas.${NC}"
    fi
}

# Fonction pour configurer une sauvegarde automatique (via cron)
configurer_sauvegarde_automatique() {
    echo -n "Entrez le chemin du dossier à sauvegarder : "
    read -r dossier
    if [[ -d "$dossier" ]]; then
        echo -n "Entrez la fréquence de la sauvegarde (ex : '0 2 * * *' pour tous les jours à 2h) : "
        read -r frequence
        job="$frequence cp -r $dossier $SAUVEGARDE_DIR/sauvegarde_\$(date +'\%Y\%m\%d_\%H\%M\%S')"
        (crontab -l; echo "$job") | crontab -
        
        # Enregistrer la tâche cron de sauvegarde automatique dans un fichier log
        echo "Tâche de sauvegarde automatique configurée pour $dossier à $frequence" >> "$SAUVEGARDE_DIR/sauvegardes_log.txt"
        
        echo -e "${GREEN}Sauvegarde automatique configurée.${NC}"
    else
        echo -e "${RED}Erreur : Le dossier spécifié n'existe pas.${NC}"
    fi
}

# Fonction pour lister les sauvegardes (manuelles et automatiques)
lister_sauvegardes() {
    echo -e "${GREEN}=== Sauvegardes existantes ===${NC}"

    # Lister les sauvegardes (tâches cron)
    if [[ -f "$SAUVEGARDE_DIR/sauvegardes_log.txt" ]]; then
        cat "$SAUVEGARDE_DIR/sauvegardes_log.txt"
    else
        echo "Aucune sauvegarde manuelle effectuée."
    fi
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
            lister_sauvegardes ;;
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
