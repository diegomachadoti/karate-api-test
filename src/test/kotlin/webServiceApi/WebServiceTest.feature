Feature: Testando webService-restAssured-test do meu git usando Karate

  Background:
    * def baseUrl = 'http://localhost:8080'
    * def textNew = generateDescription()
    * def creationDate =  generateCreationDate()
    * json requestPayload = read('webServiceExemplo.json')



  Scenario: Testing: Endpoint GET valido
    Given url baseUrl
    When method GET
    Then status 200


  Scenario: Testing: Endpoint GET invalido - 404
    Given url baseUrl + '/test'
    When method GET
    Then status 404

  Scenario: Testing: Resposta com quantidade de registros exatos de um endpoint GET
    Given url baseUrl
    When method GET
    Then status 200
    * print response
    * def jsonResponse = response
    #* replace jsonResponse.[ = ''
    #* replace jsonResponse.] = ''
    #* print jsonResponse
    * def len = jsonResponse.length
    * match len != 16

  Scenario: Testing: Valor exato do primeiro registro retornado no endpoint GET
    Given url baseUrl
    When method GET
    Then status 200
    * print response
    * def jsonResponse = response
    # Substituir o assert abaixo com o id do primeiro registro inserido na carga inicial do Web Service utilizado de exemplo
    And match jsonResponse[0].id == "8ce6e581-84c9-4c5e-a594-cf9edf24114a"

  Scenario: Testing: Resposta GET contem um campo especifico
    Given url baseUrl
    When method GET
    Then status 200
    # Substituir o assert abaixo com o id do primeiro registro inserido na carga inicial do Web Service utilizado de exemplo
    And match $ contains {id:"8ce6e581-84c9-4c5e-a594-cf9edf24114a",text:"Testes E2E"}

  Scenario: Testing: Resposta GET validando campo obrigatorio usando marcadores
    Given url baseUrl
    When method GET
    Then status 200
    * def jsonResponse = response

    And match jsonResponse[0].id !=  { "id": "#null"}
    And match jsonResponse[0].text != { "text": "#null"}



  Scenario: Testing: Endpoint POST lendo e substituindo dados de um arquivo json

    # Substituir dados no payload
    * set requestPayload
      | path                       | value        |
      | text                       | textNew      |

    * print requestPayload

    Given url baseUrl
    And request requestPayload
    When method POST
    Then status 200


  @new
  Scenario Outline: Testing: Realizando um GET e validar elementos através de parâmetros
    # Definindo a URL com o parâmetro id
    * def baseUrlNew = 'https://serverest.dev/usuarios?_id=<user>'

    Given url baseUrlNew
    When method GET
    Then status 200

    * def nomes = []
    * def emails = []
    * def usuarios = $response.usuarios

    * eval
      """
      for (var i = 0; i < usuarios.length; i++) {
        nomes.push(usuarios[i].nome);
        emails.push(usuarios[i].email);
      }
      """
    * match nomes == ['<nome>']
    * match emails == ['<email>']

    # Validar dados extraídos com a massa de dados
    Examples:
      | user              | qtda | nome               | email                 | pass        | adm   |
      | 0uxuPY0cbmQhpEz1  | 9    | Fulano da Silva    | fulano@qa.com         | teste       | true  |
      | 2MZ1ZTpWFbr7xY72  | 9    | Mack Boehm         | mackboehm@test.com    | Test;123    | true  |
      | 2c762uLsyOAL8dvd  | 9    | Fulano da Silva    | vxct@emailteste.com   | teste       | true  |

