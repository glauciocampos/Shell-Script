#!/bin/bash
# Simple bash script to create users with keypair
# Author: Glaucio Campos
# My First commit script for github

# Array with key break for mass add users
user_input(){
 clear
 echo ""
 echo "Type a username to add:"
 echo "To break type: theend"
 while read USER_INPUT
  do
        [ "$USER_INPUT" == "theend" ] && break
        USER_ARRAY=("${USER_ARRAY[@]}" $USER_INPUT)
  echo
  echo "Usuarios a serem cadastrados: ${USER_ARRAY[@]}"
done

}

# Comandos de criacao
user_add(){
useradd $user
mkdir -p /home/$user/.ssh
touch /home/$user/.ssh/authorized_keys
}

# Adicionando chaves publicas para autenticacao sem senha
user_pubkeys(){
  ssh-keygen -t rsa -b 4096 -f /home/$user/.ssh/$user -C $user  -q -N ""
}

user_send_pubkey(){
  ssh-copy-id -i "$user".pub "$user"@"$remotehost"
}

# Setando permissoes para a pasta ssh dos usuarios
user_ssh_perm(){
  chown -R $user:$user /home/$user/.ssh
}

# Adicionando usuarios ao grupo sudoers
user_sudoers(){
  usermod -aG wheel $user
}

#Mostra os arquivos dos usuarios
show_user_keys(){
   echo "----------------- BEGIN OF PUBKEY FOR USER $user ---------------" >> keypair-gen.txt
   echo "" >> keypair-gen.txt
   cat /home/$user/.ssh/$user.pub >> keypair-gen.txt
   echo "" >> keypair-gen.txt
   echo "----------------- BEGIN OF PRIVKEY FOR USER $user ---------------" >> keypair-gen.txt
   echo >> keypair-gen.txt
   cat /home/$user/.ssh/$user >> $user
   echo "----------------- END OF $user ---------------" >> keypair-gen.txt
   echo 
   
}

# Start
#Chama cadastro de usuarios input
user_input

# Loop para criacao e config de cada usuario
for user in ${USER_ARRAY[@]}
do   

# Chama funcoes
user_add
user_sudoers
user_ssh_perm

#Fim do loop
done

user_pubkeys
show_user_keys

if [ $? -eq 0 ]
then
    echo "Operation succeed"
    sleep 2
    echo "Showing keypair info..."
    sleep 2
    clear
    cat keypair-gen.txt
else
    echo "There was a problem to add users"
fi