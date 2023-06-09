*** Settings ***
Resource  ../resources/serve-rest-front.resource
Suite Setup    Cadastrar Usuario e Logar
Suite Teardown  Close Browser    ALL


*** Test Cases ***
Login com sucesso Serve Rest Front
    [Tags]    login_serve_rest
    Abrir o navegador
    Ir para o site Serve Rest Front
    Preencher os dados do novo usuário e cadastrar
    Conferir usuário cadastrado com sucesso

Desafio: Conferir se o novo usuário é mostrado na listagem de usuários
    [Tags]    conferindo_listagem
    Cadastrar novo usuário
    Acessar a Lista de usuários
    Conferir que o usuário aparece na listagem

Exemplo Utilizando Requisição HTTP
    [Tags]    http
    Abrir o navegador
    Ir para o site Serve Rest Front
    Criar Usuario via API
    Logar com o Usuario cadastrado via API

Exemplo Usando Storage State
    #Cadastrar Usuario e Logar
    Abrir o site logado