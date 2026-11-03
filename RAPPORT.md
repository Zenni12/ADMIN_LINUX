# TP2 : gestion avancée des utilisateurs, groupes, permissions et ACL

Auteur : David
Serveur : srv-core (Rocky Linux 9)

## 1. Comptes, groupes et politique d'authentification

- Politique réglée avant création des comptes : PASS_MAX_DAYS 90, PASS_MIN_DAYS 1, PASS_WARN_AGE 14, UMASK 027 (voir configs/login.defs.diff).
- Qualité des mots de passe : pam_pwquality avec minlen 12 (voir configs/50-helios.conf).
- Verrouillage : pam_faillock activé via authselect (profil sssd with-faillock), deny 5, unlock_time 600, fail_interval 900 (voir configs/faillock.conf).
- Preuves : chage -l julien, refus de « helios » comme mot de passe, faillock --user nadia avant et après --reset.

## 2. Bits spéciaux et umask

### Tableau umask prédit / observé

| Cas | umask | Dossier prédit / observé | Fichier prédit / observé |
|---|---|---|---|
| Défaut (UMASK 027) | 0027 | 750 / drwxr-x--- | 640 / rw-r----- |
| umask 002 | 0002 | 775 / drwxrwxr-x | 664 / rw-rw-r-- |
| umask 077 | 0077 | 700 / drwx------ | 600 / rw------- |

Calcul : mode de base 777 pour un dossier et 666 pour un fichier, puis retrait du umask.

### Setgid, sticky, faux setuid

- Héritage setgid : les fichiers de tarek dans transport/ ont le groupe transport, dans temoin/ le groupe telemetry.
- Sticky bit : tarek ne peut pas supprimer le fichier de nadia dans depot/ (rc 1), nadia supprime le sien (rc 0).
- Faux setuid : le script setuid s'exécute avec l'identité de l'appelant (uid 5101, nadia).

### Inventaire setuid

Trois binaires justifiés :
- /usr/bin/passwd (setuid root) : modifie /etc/shadow, réservé à root.
- /usr/bin/su (setuid root) : change d'identité et vérifie les mots de passe.
- /usr/bin/write (setgid tty) : écrit sur les terminaux, le groupe tty y a accès.

### helios-lastlog

Binaire setgid telemetry : tail direct refusé à julien (rc 1), helios-lastlog réussit (rc 0). Voir configs/helios-lastlog.c.

## 3. ACL POSIX

- Accès lecture seule de audit-ext sur transport/ (setfacl -R -m u:audit-ext:rX).
- ACL par défaut : un fichier créé après pose des ACL par défaut est lisible par audit-ext. Avant : refus.
- Effet de chmod g-w sur un fichier porteur d'ACL : il ne retire pas de droits à tarek. Il modifie le masque (mask), qui est le bit de groupe affiché par ls -l. Le masque limite les droits effectifs des entrées nommées (tarek, transport) : tarek est refusé en écriture (rc 1), puis rétabli avec setfacl -m m::rwx (rc 0).
- cp -a préserve les ACL, cp -r ne les préserve pas.
- Sauvegarde : getfacl -R, setfacl -b, setfacl --restore, et archive tar --acls --xattrs.

## 4. Délégation sudo

- Règle 90-helios-ops : julien peut redémarrer helios-collect.service et lire le journal, mais pas redémarrer sshd (refus constaté).
- Traçage : sudoreplay -l user julien liste les trois commandes de julien.
- Correction 91-nadia-edition : nadia n'a que sudoedit sur transport/*, avec !sudoedit_checkdir.

**Démonstration de l'évasion sudo (sudo vim, :!/usr/bin/id) : non réalisée.** Raison : [à compléter].

## 5. Audit croisé (bonus)

Non réalisé. [ou compléter avec les constats]

## 6. Problèmes rencontrés

- gcc absent de la VM : installé avec dnf install -y gcc.
- vim absent de la VM : installé avec dnf install -y vim-enhanced.
- authselect : le profil n'était pas appliqué au départ, corrigé avec authselect select sssd with-faillock --force.
