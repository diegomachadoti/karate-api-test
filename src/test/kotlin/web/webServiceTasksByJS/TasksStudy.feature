Feature: Teste de API usando o Karate

  # https://github.com/diegomachadoti/api-full-stack-be-fe
  Background:
    * def baseUrl = 'http://localhost:3333/tasks/'

  @getByall
  Scenario: Realizar GET na app
    Given url baseUrl
    When method GET
    Then status 200

  @getByItem
  Scenario: Realizar GET para itens
    Given url baseUrl + '1'
    When method GET
    Then status 200
    And match response != {title: '#null', status: '#null',created_at: '#null' }

  @getParamsExamples
  Scenario Outline: Realizar GET usando dados dinâmicos
    Given url baseUrl + '<task>'
    When method GET
    Then status 200
    And match response != {title: '#null', status: '#null',created_at: '#null' }
    Examples:
      | task  |
      | 1     |
      | 2     |
      | 3     |
      | 4     |
      | 6     |
      | 7     |
      | 9     |
      | 10    |
      | 233   |
      | 234   |
      | 267   |

  @getContractTestByJson
  Scenario: Realizar GET para validar o contrato usando JSON como validador passando por um registro
    * def peopleContract = read('tasksContract.json')
    Given url baseUrl + '/1'
    When method GET
    Then status 200
    And match response[0] == peopleContract
    * print peopleContract
    * print response

  @getContractTestByJson
  Scenario: Realizar GET para validar o contrato usando JSON como validador passando por todos os registros
    * def peopleContract = read('tasksContract.json')
    Given url baseUrl
    When method GET
    Then status 200
    * def responseSize = karate.sizeOf(response)
    * print 'Tamanho do response:', responseSize
    * print 'Response completo:', response
    * eval
      """
      for (var i = 0; i < responseSize.length; i++) {
        karate.match(validations[i].value, peopleContract);
      }
      """
    * print peopleContract
    * print response




  @postByCsvFile
  Scenario Outline: Realizar POST usando CSV como dados de teste
    Given url baseUrl
    And request { title: '#(title)', status: '#(status)'}
    When method POST
    Then status 201
    And match response == { insertId: '#number? _ >= 0'}
    Examples:
      | read('tasks.csv') |

  @postByRequestJson
  Scenario: Realizar POST com request usando JSON como request
    * def titleDesc = generateDescription()
    * json requestPayload = read('tasksRequests.json')

    * set requestPayload
      | path      | value           |
      | title     | titleDesc       |
      | status    | "em andamento"  |

    * print requestPayload
