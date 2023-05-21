*** Settings ***
Library  Browser
...        timeout=00:00:05
#...       run_on_failure=Take Screenshot    
#...        enable_presenter_mode=${true}        # HABILITA QUE PEGUE VALOR DE ELEMENTOS DURANTE A EXECUÇÃO
Library  FakerLibrary
Library  DateTime

*** Variables ***
${BROWSER}           chromium
${HEADLESS}          ${false}
${SITE_SERVE_REST}   https://front.serverest.dev/


*** Keywords ***
Abrir o navegador
    &{recordVideo}             Create Dictionary    dir=./videos
    New Browser    browser=${BROWSER}
    ...            headless=${HEADLESS}
    
    ${TRACE_NAME}  FakerLibrary.Uuid 4
    ${NOW}         Get Current Date  result_format=%d-%m-%Y_%H%M%S
    New Context    viewport={'width': 1200, 'height': 800}
    #...            tracing=${OUTPUT_DIR}/evidencies/traces/${NOW}/${TRACE_NAME}.zip
    #...            recordVideo=${recordVideo}

Ir para o site Serve Rest Front
    New Page       url=${SITE_SERVE_REST}
    ${title}       Get Title  ==  Front - ServeRest
    Log  ${title}

Preencher os dados do novo usuário e cadastrar
    # Record Selector
    # Click    css=.btn-link
    # Click    text="Cadastre-se"
    Click       css=a[data-testid='cadastrar']
    ${EMAIL}    FakerLibrary.Email
    Set Test Variable    ${EMAIL}
    Fill Text   css=input[data-testid='nome']       Mayara Fernandes
    Fill Text   css=input[data-testid='email']      ${EMAIL}
    Fill Text   css=input[data-testid='password']   123456
    Check Checkbox  css=input[data-testid='checkbox']
    # Click    css=button[data-testid='cadastrar']
    Click   xpath=//*[@id="root"]//button >> text="Cadastrar"

Conferir usuário cadastrado com sucesso
    Wait For Elements State    h1   visible
    Get Text    h1  ==  Bem Vindo Mayara Fernandes
    Get Element States    css=button[data-testid='logout']  validate  value & visible

Cadastrar novo usuário
    Abrir o navegador
    Ir para o site Serve Rest Front
    Preencher os dados do novo usuário e cadastrar
    Conferir usuário cadastrado com sucesso

Acessar a Lista de usuários
    Click        css=a[data-testid='listarUsuarios']

Conferir que o usuário aparece na listagem
    ${elemento}      Get Table Cell Element    css=table    "Nome"    "${EMAIL}"
    ${usuario_nome}  Get Text  ${elemento}  ==  Mayara Fernandes
    Highlight Elements    ${elemento}
    Take Screenshot       fullPage=${true}    

Criar Usuario via API
    ${EMAIL}    FakerLibrary.Email
    Set Suite Variable    ${EMAIL}
    
    ${resposta}    Http    url=https://serverest.dev/usuarios
    ...                    method=POST
    ...                    body={"nome": "Camila Marraccini", "email": "${EMAIL}", "password": "123456", "administrador": "true"}
    
    Should Be Equal As Integers    ${resposta["status"]}    201


Logar com o Usuario cadastrado via API
    ${resposta}        Http    url=https://serverest.dev/login     method=POST
    ...                body={"email": "${EMAIL}", "password": "123456"}
    
    Should Be Equal As Integers    ${resposta["status"]}    200

    LocalStorage Set Item    serverest/userEmail    ${EMAIL}
    LocalStorage Set Item    serverest/userToken    ${resposta["body"]["authorization"]}
    LocalStorage Set Item    serverest/userNome     Camila Marraccini

    Go To    url=https://serverest.dev/admin/home
    Take Screenshot

Cadastrar Usuario e Logar
    New Browser
    New Page    url=${SITE_SERVE_REST}
    Criar Usuario via API
    Logar com o Usuario cadastrado via API
    ${STORAGE_FILE}    Save Storage State
    Set Suite Variable    ${STORAGE_FILE}

Abrir o site logado
     New Context  viewport={'width': 1200, 'height': 800}
     ...        storageState=${STORAGE_FILE}
     New Page    url=https://serverest.dev/admin/home
     #Get Text     h1 == Bem Vindo Camila Marraccini
     Take Screenshot