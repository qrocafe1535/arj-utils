
funcao1 () {
    echo "teste1"
    sleep 3
}

funcao2 () {
    echo "teste2"
    sleep 5
}

execute () {
    funcao1
    funcao2
}

teste () {
gum spin  --title="Exportando BH1..." sleep 3 && \
gum spin --title="Exportando BH2..." sleep 5
}

teste