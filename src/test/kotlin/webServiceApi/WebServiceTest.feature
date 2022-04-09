Feature: Testando webService-restAssured-test do meu git usando Karate

  Background:
    * def baseUrl = 'http://localhost:8080'
    * def transactionUUID = generateUUID()
    * def creationDate =  generateCreationDate()
    * json requestPayload = read('listFull.json')



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
    And match jsonResponse[0].id == "d57c68b1-d6dc-458a-9016-2484486cb798"

  Scenario: Testing: Resposta GET contem um campo especifico
    Given url baseUrl
    When method GET
    Then status 200
    And match $ contains {id:"d57c68b1-d6dc-458a-9016-2484486cb798",text:"Teste de Contrato"}

  Scenario: Testing: Resposta GET validando campo obrigatorio usando marcadores
    Given url baseUrl
    When method GET
    Then status 200
    * def jsonResponse = response

    And match jsonResponse[0].id !=  { "id": "#null"}
    And match jsonResponse[0].text != { "text": "#null"}



  Scenario: Testing: Endpoint POST com o corpo da solicitacao

    # Substituir dados no payload
    * set requestPayload
      | path                       | value                |
      | text                       | transactionUUID      |

    * print requestPayload

    Given url baseUrl
    And request requestPayload
    When method POST
    Then status 200