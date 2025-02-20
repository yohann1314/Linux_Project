#!/bin/bash

# Couleurs pour le menu
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Menu interactif
menu_surveillance() {
    echo -e "${CYAN}============================"
    echo "Menu de Surveillance Système"
    echo -e "============================${NC}"
    echo "1. Surveiller l'espace disque"
    echo "2. Lister les processus actifs"
    echo "3. Surveiller l'utilisation de la mémoire"
    echo "4. Quitter"
    echo -n "Choisissez une option : "
}

# Fonction pour surveiller l'espace disque
surveillance_espace_disque() {
    echo -e "${GREEN}=== Espace disque ===${NC}"
    df -h | awk 'NR==1 || $5+0 > 80 {print $0}' # Affiche les partitions avec >80% d'utilisation
}

# Fonction pour lister les processus actifs
lister_processus_actifs() {
    echo -e "${GREEN}=== Processus Actifs ===${NC}"
    ps aux --sort=-%mem | head -n 10 # Top 10 processus utilisant le plus de mémoire
}

# Fonction pour surveiller l'utilisation de la mémoire
surveillance_memoire() {
    echo -e "${GREEN}=== Utilisation Mémoire ===${NC}"
    free -h
}

# Exécution du menu de surveillance
while true; do
    menu_surveillance
    read -r choix
    case $choix in
        1)
            surveillance_espace_disque ;;
        2)
            lister_processus_actifs ;;
        3)
            surveillance_memoire ;;
        4)
            echo -e "${GREEN}Retour au menu principal...${NC}"
            exit 0 ;;
        *)
            echo -e "${RED}Option invalide. Veuillez réessayer.${NC}" ;;
    esac
    echo ""
done
