# Annexes — TP2 — Gestion avancée des utilisateurs et des groupes

Fichiers de l'énoncé, extraits tels quels. Copiez-les sur la VM (`scp annexes/<fichier> sysops@192.168.56.10:/tmp/`, avec `-P 2242` à partir du TP3 où le port SSH change),
puis placez-les à l'emplacement indiqué. Si le fichier existe déjà et que la colonne « Action » dit « ajouter », 
**ne l'écrasez pas** : ajoutez-en le contenu à la fin.

| Fichier | Destination sur la VM | Action | Droits (`chmod`) |
|---|---|---|---|
| `50-helios.conf` | `/etc/security/pwquality.conf.d/50-helios.conf` | créer (écrase) | — |
| `skel-bashrc.ajout` | `/etc/skel/.bashrc` | ajouter à la fin | — |
| `helios-umask.sh` | `/etc/profile.d/helios-umask.sh` | créer (écrase) | 0644 |
| `helios-lastlog.c` | `/root/helios-lastlog.c` | créer (écrase) | — |
| `90-helios-ops` | `/etc/sudoers.d/90-helios-ops` | créer (écrase) | 0440 |

Vérifiez toujours un fichier de configuration avant de le recharger (`systemd-analyze verify`, `sshd -t`, `visudo -c`, `bash -n`, `nginx -t`… selon le cas).
