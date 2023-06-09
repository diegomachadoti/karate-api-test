Feature: Realizar testes de API no conexão TQI


  Background:
    * def urlBase = 'http://localhost:3333/tasks/'
    * url 'http://localhost:3333/tasks/'
    * def UUID = function(){return java.util.UUID.randomUUID()}

    # Essa função chama 'after-feature.feature' e executa todos os deletes dos registros inseridos
    #* configure afterFeature = function(){ karate.call('after-feature.feature'); }

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
    * url urlBase
    * path id
    * method GET
    * status 200
    * match response[0] == {"id":"#notnull","title":"#notnull","status":"#notnull","created_at":"#notnull"}
    Examples:
      | id    |
      | 1     |
      | 2     |
      | 3     |


# POST (teste com assert, teste realizando leitura de um CSV, teste utilizando arquivo JSON)
  Scenario: Realizar POST validando resultado
    * def title = "Teste POST - CREATE " + UUID()
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
      | path  | value                                       |
      | title | "Teste POST - CREATE by JSON " + UUID()     |
      | status| "em andamento"                              |

    * request requestJSON
    * method POST
    * status 201
    * match response.insertId == "#notnull"

# PUT (Criação e Atualização de um novo registro)
  Scenario: Realizar UPDATE validando a atualização do registro
    * def title = "Teste PUT - UPDATE " + UUID()
    * request {"title":"Teste PUT CREATE by UPDATE","status":"pendente"}
    * method POST
    * status 201
    * def id = response.insertId
    * url urlBase
    * path id
    * request {"title":"#(title)","status":"concluída"}
    * method PUT
    * status 204


# DELETE (Criação, exclusão e consulta após exclusão)
  Scenario: Realizar DELETE validando a exclusão do registro
    * request {"title":"Teste DELETE - CREATE by DELETE","status":"pendente"}
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
