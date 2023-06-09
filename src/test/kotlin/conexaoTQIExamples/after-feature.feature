@ignore
Feature: Teste para deletar todas os dados gerados no arquivo tests.feature

  Background:
    * def urlBase = 'http://localhost:3333/tasks/'

  Scenario: Realizar GET todos registros inseridos e deletar
    * url urlBase
    * method GET
    * status 200
    * def responseSize = karate.sizeOf(response)
    * print responseSize
    * def lastThreeIds = karate.filter(response, function(item, index){ return index >= responseSize - 7 })
    * print lastThreeIds
    * def lastThreeIdsList = karate.map(lastThreeIds, function(item){ return item.id })
    * print lastThreeIdsList[0]
    * match each response[*] == {"id":"#notnull","title":"#notnull","status":"#notnull","created_at":"#notnull"}

    * path lastThreeIdsList[0]
    * method DELETE

    * path lastThreeIdsList[1]
    * method DELETE

    * path lastThreeIdsList[2]
    * method DELETE

    * path lastThreeIdsList[3]
    * method DELETE

    * path lastThreeIdsList[4]
    * method DELETE

    * path lastThreeIdsList[5]
    * method DELETE

    * path lastThreeIdsList[6]
    * method DELETE


