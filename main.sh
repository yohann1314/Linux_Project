#!/bin/bash

# Couleurs pour rendre le menu plus attrayant
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Vérifier si les scripts nécessaires sont exécutables
check_scripts() {
    for script in gts_utilisateurs.sh gts_cron.sh gts_surveillance.sh gts_sauvegarde.sh gts_journalisation.sh; do
        if [[ ! -x $script ]]; then
            echo -e "${RED}Erreur : ${script} n'est pas exécutable ou introuvable.${NC}"
            exit 1
        fi
    done
}

# Afficher le menu principal
menu_principal() {
    echo -e "${CYAN}========================="
    echo "     Menu Principal  :) "
    echo -e "=========================${NC}"
    echo -e "${RED}1.${NC} Gestion des utilisateurs et des groupes"
    echo -e "${RED}2.${NC} Automatisation des tâches (cron)"
    echo -e "${RED}3.${NC} Surveillance du système"
    echo -e "${RED}4.${NC} Sauvegarde des dossiers"
    echo -e "${RED}5.${NC} Configuration de la journalisation système"
    echo -e "${RED}6.${NC} Quitter"
    echo -n "Choisissez une option : "
}

# Appeler les scripts selon le choix
execute_option() {
    case $1 in
        1)
            ./gts_utilisateurs.sh ;;
        2)
            ./gts_cron.sh ;;
        3)
            ./gts_surveillance.sh ;;
        4)
            ./gts_sauvegarde.sh ;;
        5)
            ./gts_journalisation.sh ;;
        6)
            echo -e "${GREEN}Merci d'avoir utilisé l'application. À bientôt !${NC}"
            exit 0 ;;
        *)
            echo -e "${RED}Option invalide. Veuillez réessayer.${NC}" ;;
    esac
}

# Exécution du script principal
check_scripts
while true; do
    menu_principal
    read -r choix
    execute_option "$choix"
    echo ""
done
