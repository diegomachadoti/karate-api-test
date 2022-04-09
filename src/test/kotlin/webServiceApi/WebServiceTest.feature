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
    And match jsonResponse[0].id == "87aa36e3-cde3-481e-87ae-68e6acb2d893"

  Scenario: Testing: Resposta GET contem um campo especifico
    Given url baseUrl
    When method GET
    Then status 200
    # Substituir o assert abaixo com o id do primeiro registro inserido na carga inicial do Web Service utilizado de exemplo
    And match $ contains {id:"87aa36e3-cde3-481e-87ae-68e6acb2d893",text:"Testes E2E"}

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