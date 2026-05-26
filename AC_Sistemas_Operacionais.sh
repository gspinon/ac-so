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

listar_diretorio() {
    
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

info_sistema() {
    echo ""
    echo "--- Usuario atual ---"
    whoami
    echo ""
    echo "--- Diretorio atual ---"
    pwd
    echo ""
    echo "--- Espaco em disco ---"
    df -h
    echo ""
    read -p "Pressione Enter para continuar..."
}

while true; do
    clear
    cabecalho
    echo ""
    echo "Menu de Escolhas:"
    echo "   1) Gerenciar diretorios e arquivos"
    echo "   2) Buscar um arquivo"
    echo "   3) Ver conteudo de um arquivo"
    echo "   4) Informacoes do sistema"
    echo "   5) Finalizar o programa"
    echo ""
    read -p "Selecione uma opcao: " OPCAO

    case $OPCAO in
        1) listar_diretorio ;;
        2) buscar_arquivo ;;
        3) ver_conteudo ;;
        4) info_sistema ;;
        5) echo ""; echo "Encerrando o programa. Ate logo!"; echo ""; exit 0 ;;
        *) echo ""; echo "Opcao invalida!"; read -p "Pressione Enter para continuar..." ;;
    esac
done
