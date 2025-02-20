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
    sudo touch "$SAUVEGARDE_DIR"
    echo -n "Entrez le chemin du dossier à sauvegarder : "
    read -r dossier
    if [[ -d "$dossier" ]]; then
        timestamp=$(date +'%Y%m%d_%H%M%S')
        sauvegarde_dir="$SAUVEGARDE_DIR/sauvegarde_$timestamp"
        cp -r "$dossier" "$sauvegarde_dir"
        
        # Enregistrer la sauvegarde manuelle dans un fichier log
        touch "$SAUVEGARDE_DIR/sauvegardes_log.txt"
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
    echo -e "${GREEN}=== Tâches Cron actuelles ===${NC}"

    # Afficher toutes les tâches cron existantes
    taches=$(crontab -l)
    
    if [[ -z "$taches" ]]; then
        echo -e "${RED}Aucune tâche Cron trouvée.${NC}"
        return
    fi
    
    # Affichage des tâches actuelles avec un index
    echo -e "${CYAN}Tâches Cron actuelles :${NC}"
    echo "$taches" | nl -s ') ' -w 2
    
    # Demander à l'utilisateur de saisir le numéro de la tâche à supprimer
    echo -n "Entrez le numéro de la tâche à supprimer : "
    read -r numero

    # Vérifier si le numéro est valide
    if [[ "$numero" =~ ^[0-9]+$ ]]; then
        # Obtenir la tâche sélectionnée en utilisant 'nl' pour l'indexation
        ligne_a_supprimer=$(echo "$taches" | sed -n "${numero}p")

        # Vérifier si la tâche existe réellement
        if [[ -n "$ligne_a_supprimer" ]]; then
            # Demander une confirmation avant suppression
            echo -n "Êtes-vous sûr de vouloir supprimer la tâche suivante :\n$ligne_a_supprimer\n(y/n) : "
            read -r confirmation
            
            if [[ "$confirmation" =~ ^[Yy]$ ]]; then
                # Supprimer la tâche
                (crontab -l | grep -vF "$ligne_a_supprimer") | crontab -
                echo -e "${GREEN}Tâche supprimée avec succès.${NC}"
            else
                echo -e "${YELLOW}Suppression annulée.${NC}"
            fi
        else
            echo -e "${RED}Erreur : La tâche spécifiée n'existe pas.${NC}"
        fi
    else
        echo -e "${RED}Erreur : Numéro invalide.${NC}"
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
