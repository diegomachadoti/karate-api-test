Feature: Realizar testes de API no conexão TQI


  Background:
    * url 'http://localhost:3333/tasks/'
    * def UUID = function(){return java.util.UUID.randomUUID()}

# GET (teste com assert, teste de contrato, teste parametrizado )
  Scenario: Realizar GET validando o resultado
    * method GET
    * status 200
    * match each response[*] == {"id":"#notnull","title":"#notnull","status":"#notnull","created_at":"#notnull"}

  Scenario: Realizar GET validando o contrato da API
    * def contract = read('contract.json')
    * method GET
    * status 200
    * match each response[*] == contract

  Scenario Outline: Realizar GET com consultas dinâmicas
    * url urlBase + id
    * method GET
    * status 200
    * match response[0] == {"id":"#notnull","title":"#notnull","status":"#notnull","created_at":"#notnull"}
    Examples:
      | id    |
      | 1     |
      | 2     |
      | 3     |


# POST (teste com assert, teste realizando leitura de um CSV)
  Scenario: Realizar POST validando resultado
    * def title = "Teste POST " + UUID()
    * request {"title":"#(title)","status":"pendente"}
    * method POST
    * status 201
    * match response.insertId == "#notnull"

  Scenario Outline: Realizar POST utilizando arquivo CSV
    * request {"title":"#(title)","status":"#(status)"}
    * method POST
    * status 201
    * match response.insertId == "#notnull"
    Examples:
      | read('file.csv') |

  Scenario: Realizar POST utilizando arquivo JSON
    * def requestJSON = read('payloads.json')
    * set requestJSON
      | path  | value                             |
      | title | "Teste create JSON 1" + UUID()    |
      | status| "em andamento"                    |

    * request requestJSON
    * method POST
    * status 201
    * match response.insertId == "#notnull"

# PUT
  Scenario: Realizar UPDATE validando a atualização do registro
    * def title = "Teste UPDATE " + UUID()
    * request {"title":"Teste CREATE by UPDATE","status":"pendente"}
    * method POST
    * status 201
    * def id = response.insertId
    * url urlBase + id
    * request {"title":"#(title)","status":"concluída"}
    * method PUT
    * status 204


# DELETE
  Scenario: Realizar DELETE validando a exclusão do registro
    * request {"title":"Teste DELETE","status":"pendente"}
    * method POST
    * status 201
    * def id = response.insertId

    * url urlBase
    * path id
    * method DELETE
    * status 204

    * url urlBase
    * path id
    * method GET
    * status 404
    * match response == {"message":"Não existe uma tarefa na base com esse {id}!!"}
