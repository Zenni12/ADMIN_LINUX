# Projet Helios Logistique TP Linux

Ce dossier contient les TP du serveur Helios.

## Fichiers

TP Finale.pdf et TP Finale.docx. Mise en production du portail.

TP 2.pdf. Comptes mots de passe et droits.

TP 3.pdf. Pare feu et SSH.

Dossier annexes. Fichiers de configuration du TP1.

## Ce qui est en place

### TP1

Les unités systemd du projet. Elles gèrent la collecte l archivage et la boîte de réception. Les fichiers sont dans annexes.

### TP2

Le compte se bloque après 5 échecs. Les mots de passe font 12 caractères minimum. Les groupes et les utilisateurs de test sont créés. Les dossiers projets sont protégés. Les règles sudo sont vérifiées avant installation.

### TP3

SSH tourne sur le port 2242. Seul le groupe ssh admins peut se connecter. La connexion root est refusée. Le pare feu bloque par défaut. Une adresse qui échoue 10 fois en 10 minutes est bloquée.

### Mise en production

Zabbix est installé et testé. Le portail est publié par un script. Un timer systemd lance le script. Le statut est SUCCESS.

## Points à revoir

La commande de publication change les droits de tous les fichiers. Il faut la limiter aux dossiers.

Le service de publication tourne en root. Un compte dédié est plus sûr.

Le timer d authentification n existe pas. Il faut le revérifier.

La config SSH n a pas été revérifiée après la correction.

## Avant de recharger

Testez chaque fichier avant de le recharger. Utilisez l outil prévu pour chaque service.
