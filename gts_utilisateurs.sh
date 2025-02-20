#!/bin/bash

# Couleurs pour le menu
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Menu interactif
menu_utilisateurs() {
    echo -e "${CYAN}================================="
    echo "Menu de gestion des utilisateurs"
    echo -e "=================================${NC}"
    echo "1. Créer un utilisateur"
    echo "2. Supprimer un utilisateur"
    echo "3. Créer un groupe"
    echo "4. Lister les utilisateurs"
    echo "5. Ajouter un utilisateur à un groupe"
    echo "6. Définir un quota utilisateur"
    echo "7. Configurer sudo"
    echo "4. Quitter"
    echo -n "Choisissez une option : "
}

create_user() {
    echo "Entrez le nom d'utilisateur :"
    read username
    echo "Entrez le mot de passe :"
    read -s password
    if id "$username" &>/dev/null; then
        echo "L'utilisateur $username existe déjà."
    else
        useradd -m "$username"
        echo "Utilisateur $username créé avec succès."
    fi
}

delete_user() {
    echo "Entrez le nom d'utilisateur à supprimer :"
    read username
    if id "$username" &>/dev/null; then
        userdel -r "$username"
        echo "Utilisateur $username supprimé avec succès."
    else
        echo "L'utilisateur $username n'existe pas."
    fi
}

create_group() {
    echo "Entrez le nom du groupe :"
    read groupname
    if getent group "$groupname" &>/dev/null; then
        echo "Le groupe $groupname existe déjà."
    else
        groupadd "$groupname"
        echo "Groupe $groupname créé avec succès."
    fi
}

list_users() {
    echo "Liste des utilisateurs :"
    cut -d: -f1 /etc/passwd
}

affect_user_to_group() {
    list_users
    echo "Entrez le nom d'utilisateur :"
    read username
    if id "$username" &>/dev/null; then
        echo "Entrez le nom du groupe :"
        read groupname
        if getent group "$groupname" &>/dev/null; then
            usermod -aG "$groupname" "$username"
            echo "Utilisateur $username ajouté au groupe $groupname."
        else
            echo "Le groupe $groupname n'existe pas."
        fi
    else
        echo "L'utilisateur $username n'existe pas."
    fi
}

set_user_quota() {
    echo "Entrez le nom d'utilisateur :"
    read username
    if id "$username" &>/dev/null; then
        echo "Entrez la limite de quota (en blocs) :"
        read quota
        echo "Vérification et activation des quotas sur le système de fichiers..."
        mount -o remount,usrquota / && quotacheck -cum / && quotaon -vu /
        setquota -u "$username" "$quota" "$quota" 0 0 /
        echo "Quota de $quota blocs défini pour l'utilisateur $username."
    else
        echo "L'utilisateur $username n'existe pas."
    fi
    # Afficher le quota de l'utilisateur
    quota -s "$username"
}

configure_sudo() {
    echo "Entrez le nom d'utilisateur :"
    read username
    if id "$username" &>/dev/null; then
        echo "$username ALL=(ALL) NOPASSWD: /usr/sbin/service" >> /etc/sudoers
        echo "L'utilisateur $username peut maintenant redémarrer les services sans mot de passe."
    else
        echo "L'utilisateur $username n'existe pas."
    fi
}

# Exécution du menu de surveillance
while true; do
    menu_utilisateurs
    read -r choix
    case $choix in
        1)
            create_user ;;
        2)
            delete_user ;;
        3)
            create_group ;;
        4)
            list_users ;;
        5)
            affect_user_to_group ;;
        6)
            set_user_quota ;;
        7)
            configure_sudo ;;
        8)
            echo -e "${GREEN}Retour au menu principal...${NC}"
            exit 0 ;;
        *)
            echo -e "${RED}Option invalide. Veuillez réessayer.${NC}" ;;
    esac
    echo ""
done
