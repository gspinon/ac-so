#!/bin/bash

cabecalho() {
    DIA=$(date +%d)
    MES=$(date +%B)
    ANO=$(date +%Y)
    HORA=$(date +%H)
    MIN=$(date +%M)
    SEM=3

    echo "###############################################################"
    printf "# %-60s#\n" "IBMEC"
    printf "# %-60s#\n" "Sistemas Operacionais                    Semestre $SEM de $ANO"
    printf "# %-60s#\n" "Codigo: IBM8940                          Turma: 8001"
    printf "# %-60s#\n" "Professor: Luiz Fernando T. de Farias"
    echo "#-------------------------------------------------------------#"
    printf "# %-60s#\n" "Equipe Desenvolvedora:"
    printf "#   %-58s#\n" "Aluno: Guilherme da Silva Pinon"
    printf "#   %-58s#\n" "Aluno: Henrique Fernandes Novaes Cals"
    echo "#-------------------------------------------------------------#"
    printf "# %-60s#\n" "Rio de Janeiro, $DIA de $MES de $ANO"
    printf "# %-60s#\n" "Hora do Sistema: $HORA Horas e $MIN Minutos"
    echo "###############################################################"
}

buscar_arquivo() {
    echo ""
    read -p "Digite o nome do arquivo a buscar: " ARQUIVO
    read -p "Digite o diretorio onde buscar: " LOCAL
    echo ""
    find "$LOCAL" -name "$ARQUIVO"
    echo ""
    read -p "Pressione Enter para continuar..."
}

ver_conteudo() {
    echo ""
    read -p "Digite o caminho do arquivo: " ARQUIVO
    echo ""
    cat "$ARQUIVO"
    echo ""
    read -p "Pressione Enter para continuar..."
}

gerenciar_usuarios_grupos() {
    while true; do
        clear
        echo ""
        echo "--- Gerenciamento de Usuarios e Grupos ---"
        echo "   1) Ver informacoes de um usuario (id)"
        echo "   2) Listar todos os usuarios (/etc/passwd)"
        echo "   3) Listar todos os grupos (/etc/group)"
        echo "   4) Criar novo usuario (useradd)"
        echo "   5) Alterar usuario existente (usermod)"
        echo "   6) Remover usuario (userdel)"
        echo "   7) Definir/alterar senha de usuario (passwd)"
        echo "   8) Criar novo grupo (groupadd)"
        echo "   9) Remover grupo (groupdel)"
        echo "  10) Adicionar usuario a um grupo (gpasswd -a)"
        echo "  11) Remover usuario de um grupo (gpasswd -d)"
        echo "  12) Voltar ao menu principal"
        echo ""
        read -p "Selecione uma opcao: " SUB

        case $SUB in
            1)
                read -p "Digite o login do usuario (vazio = atual): " USUARIO
                echo ""
                if [ -z "$USUARIO" ]; then
                    id
                else
                    id "$USUARIO"
                fi
                echo ""
                read -p "Pressione Enter para continuar..."
                ;;
            2)
                echo ""
                echo "Login : Senha : UID : GID : Comentarios : Home : Shell"
                echo "--------------------------------------------------------"
                cat /etc/passwd
                echo ""
                read -p "Pressione Enter para continuar..."
                ;;
            3)
                echo ""
                echo "Nome-Grupo : Senha : GID : Membros"
                echo "----------------------------------"
                cat /etc/group
                echo ""
                read -p "Pressione Enter para continuar..."
                ;;
            4)
                read -p "Login do novo usuario: " LOGIN
                read -p "Comentario (nome completo): " COMENTARIO
                read -p "Diretorio home (vazio = /home/$LOGIN): " HOME_DIR
                read -p "UID (vazio = automatico): " UID_NOVO
                read -p "Grupos suplementares (separados por virgula, vazio = nenhum): " GRUPOS
                read -p "Shell (vazio = /bin/bash): " SHELL_NOVO

                CMD="sudo useradd -m"
                [ -n "$COMENTARIO" ] && CMD="$CMD -c \"$COMENTARIO\""
                [ -n "$HOME_DIR" ] && CMD="$CMD -d $HOME_DIR"
                [ -n "$UID_NOVO" ] && CMD="$CMD -u $UID_NOVO"
                [ -n "$GRUPOS" ] && CMD="$CMD -G $GRUPOS"
                [ -n "$SHELL_NOVO" ] && CMD="$CMD -s $SHELL_NOVO"
                CMD="$CMD $LOGIN"

                echo ""
                echo "Executando: $CMD"
                eval $CMD && echo "Usuario '$LOGIN' criado com sucesso."
                echo ""
                read -p "Pressione Enter para continuar..."
                ;;
            5)
                read -p "Login do usuario a alterar: " LOGIN
                echo "Opcoes: 1)Novo login  2)Novo home  3)Novo UID  4)Novo GID"
                echo "        5)Substituir grupos (-G)  6)Adicionar grupos (-aG)  7)Novo shell  8)Novo comentario"
                read -p "Escolha a opcao: " OPC
                case $OPC in
                    1) read -p "Novo login: " V; sudo usermod -l "$V" "$LOGIN" ;;
                    2) read -p "Novo home: " V; sudo usermod -m -d "$V" "$LOGIN" ;;
                    3) read -p "Novo UID: " V; sudo usermod -u "$V" "$LOGIN" ;;
                    4) read -p "Novo GID: " V; sudo usermod -g "$V" "$LOGIN" ;;
                    5) read -p "Grupos (separados por virgula): " V; sudo usermod -G "$V" "$LOGIN" ;;
                    6) read -p "Grupos a adicionar (separados por virgula): " V; sudo usermod -aG "$V" "$LOGIN" ;;
                    7) read -p "Novo shell: " V; sudo usermod -s "$V" "$LOGIN" ;;
                    8) read -p "Novo comentario: " V; sudo usermod -c "$V" "$LOGIN" ;;
                    *) echo "Opcao invalida." ;;
                esac
                echo ""
                read -p "Pressione Enter para continuar..."
                ;;
            6)
                read -p "Login do usuario a remover: " LOGIN
                read -p "Remover tambem o diretorio home? (s/N): " RM
                if [ "$RM" = "s" ] || [ "$RM" = "S" ]; then
                    sudo userdel -r "$LOGIN"
                else
                    sudo userdel "$LOGIN"
                fi
                echo ""
                read -p "Pressione Enter para continuar..."
                ;;
            7)
                read -p "Login do usuario: " LOGIN
                echo "Opcoes: 1)Definir senha  2)Bloquear (-l)  3)Desbloquear (-u)"
                echo "        4)Forcar expiracao (-e)  5)Validade maxima (-x)  6)Periodo minimo (-n)  7)Aviso (-w)"
                read -p "Escolha a opcao: " OPC
                case $OPC in
                    1) sudo passwd "$LOGIN" ;;
                    2) sudo passwd -l "$LOGIN" ;;
                    3) sudo passwd -u "$LOGIN" ;;
                    4) sudo passwd -e "$LOGIN" ;;
                    5) read -p "Dias: " D; sudo passwd -x "$D" "$LOGIN" ;;
                    6) read -p "Dias: " D; sudo passwd -n "$D" "$LOGIN" ;;
                    7) read -p "Dias: " D; sudo passwd -w "$D" "$LOGIN" ;;
                    *) echo "Opcao invalida." ;;
                esac
                echo ""
                read -p "Pressione Enter para continuar..."
                ;;
            8)
                read -p "Nome do novo grupo: " GRUPO
                read -p "GID (vazio = automatico): " GID_NOVO
                if [ -n "$GID_NOVO" ]; then
                    sudo groupadd -g "$GID_NOVO" "$GRUPO"
                else
                    sudo groupadd "$GRUPO"
                fi
                echo "Grupo '$GRUPO' criado."
                echo ""
                read -p "Pressione Enter para continuar..."
                ;;
            9)
                read -p "Nome do grupo a remover: " GRUPO
                sudo groupdel "$GRUPO"
                echo ""
                read -p "Pressione Enter para continuar..."
                ;;
            10)
                read -p "Login do usuario: " LOGIN
                read -p "Nome do grupo: " GRUPO
                sudo gpasswd -a "$LOGIN" "$GRUPO"
                echo ""
                read -p "Pressione Enter para continuar..."
                ;;
            11)
                read -p "Login do usuario: " LOGIN
                read -p "Nome do grupo: " GRUPO
                sudo gpasswd -d "$LOGIN" "$GRUPO"
                echo ""
                read -p "Pressione Enter para continuar..."
                ;;
            12) break ;;
            *) echo "Opcao invalida!"; read -p "Pressione Enter para continuar..." ;;
        esac
    done
}

info_sistema() {
    clear
    echo ""
    echo "--- Usuario atual ---"
    echo ""
    whoami
    echo ""
    echo "--- Diretorio atual ---"
    echo ""
    pwd
    echo ""
    echo "--- Espaco em disco ---"
    echo ""
    df -h
    echo ""
    echo "--- Processos Atuais ---"
    echo ""
    ps aux
    echo ""
    read -p "Pressione Enter para continuar..."
    
}

while true; do
    clear
    cabecalho
    echo ""
    echo "Menu de Escolhas:"
    echo "   1) Gerenciar usuarios e grupos"
    echo "   2) Buscar um arquivo"
    echo "   3) Ver conteudo de um arquivo"
    echo "   4) Informacoes do sistema"
    echo "   5) Finalizar o programa"
    echo ""
    read -p "Selecione uma opcao: " OPCAO

    case $OPCAO in
        1) gerenciar_usuarios_grupos ;;
        2) buscar_arquivo ;;
        3) ver_conteudo ;;
        4) info_sistema ;;
        5) echo ""; echo "Encerrando o programa. Ate logo!"; echo ""; exit 0 ;;
        *) echo ""; echo "Opcao invalida!"; read -p "Pressione Enter para continuar..." ;;
    esac
done
