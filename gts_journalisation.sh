#!/bin/bash

# Couleurs pour le menu
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

menu_journalisation() {
    echo -e "${CYAN}============================"
    echo "Menu de Journalisation"
    echo -e "============================${NC}"
    echo "1) Vérification et installation de rsyslog"
    echo "2) Configuration de la journalisation centralisée"
    echo "3) Mise en place de la rotation des journaux"
    echo "4) Activation de la journalisation avancée pour les services critiques"
    echo "5) Redémarrage du service rsyslog"
    echo "6) Vérification de la configuration des journaux"
    echo "7) Quitter"
}

install_rsyslog() {
    if ! dpkg -l | grep -q rsyslog; then
        echo "rsyslog non installé. Installation en cours..."
        sudo apt update && sudo apt install -y rsyslog
    else
        echo "rsyslog est déjà installé."
    fi
}

configure_central_logging() {
    echo "*.*    /var/log/syslog-central.log" | sudo tee -a /etc/rsyslog.conf > /dev/null
    echo "Configuration de la journalisation centralisée appliquée."
}

setup_log_rotation() {
    cat <<EOF | sudo tee /etc/logrotate.d/syslog-central
/var/log/syslog-central.log {
    size 100M
    rotate 5
    compress
    missingok
    notifempty
}
EOF
    echo "Rotation des journaux configurée."
}

configure_advanced_logging() {
    sudo mkdir -p /var/log/custom-logs
    echo "auth,authpriv.*  /var/log/custom-logs/ssh.log" | sudo tee -a /etc/rsyslog.d/ssh.conf > /dev/null
    echo "apache.*  /var/log/custom-logs/apache.log" | sudo tee -a /etc/rsyslog.d/apache.conf > /dev/null
    echo "mysql.*  /var/log/custom-logs/mysql.log" | sudo tee -a /etc/rsyslog.d/mysql.conf > /dev/null
    echo "Journalisation avancée activée pour SSH, Apache et MySQL."
}

restart_rsyslog() {
    sudo systemctl restart rsyslog
    echo "Service rsyslog redémarré."
}

check_logs() {
    sudo ls -l /var/log/syslog-central.log /var/log/custom-logs/
}

while true; do
    menu_journalisation
    read -p "Choisissez une option : " choice
    case $choice in
        1) install_rsyslog ;;
        2) configure_central_logging ;;
        3) setup_log_rotation ;;
        4) configure_advanced_logging ;;
        5) restart_rsyslog ;;
        6) check_logs ;;
        7) echo "Sortie..."; exit 0 ;;
        *) echo "Option invalide, veuillez réessayer." ;;
    esac
done
