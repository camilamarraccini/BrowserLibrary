*** Settings ***
Resource  ../resources/serve-rest-front.resource
Suite Setup    Cadastrar Usuario e Logar


*** Test Cases ***
Login com sucesso Serve Rest Front
    Abrir o navegador
    Ir para o site Serve Rest Front
    Preencher os dados do novo usuário e cadastrar
    Conferir usuário cadastrado com sucesso

Desafio: Conferir se o novo usuário é mostrado na listagem de usuários
    Cadastrar novo usuário
    Acessar a Lista de usuários
    Conferir que o usuário aparece na listagem

Exemplo Utilizando Requisição HTTP
    Abrir o navegador
    Ir para o site Serve Rest Front
    Criar Usuario via API
    Logar com o Usuario cadastrado via API

Exemplo Usando Storage State
    #Cadastrar Usuario e Logar
    Abrir o site logado