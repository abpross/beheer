#!/bin/bash
#set -x
rm /home/apross/Desktop/7??2.xlsx
rm '/home/apross/Desktop/migratie voortgang.xlsx'
echo copy sheets
cd '/work/impulse_teksten/3. afdelingen/service/Helpdesk/USER/Update verzoeken (HF-PATCH-VERSIE)/' && tar -cpf - 7???.xlsx | ( cd /home/apross/Desktop/ && tar -xvpf - )
cd '/home/apross/Desktop/work/impulse_teksten/3. afdelingen/service/Systeembeheer/implementaties/linux6/' && tar -cpf - 'migratie voortgang.xlsx' | ( cd /home/apross/Desktop/ && tar -xvpf - )
