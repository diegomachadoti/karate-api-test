Feature: Realizar testes WEB usando Karate

Background:
  * configure driver = { type: 'chrome' }

Scenario: Realizar Login no Git Hub com usuário inválido
    Given driver 'https://github.com/login'
    And input('#login_field', 'karateTest')
    And input('#password', 'karate')
    When submit().click("input[name=commit]")
    Then match html('.flash-error') contains 'Incorrect username or password.'
    And screenshot()

    
  Scenario: Realizar Consulta no google e acessar a página do resultado
    Given driver 'https://google.com'
    And input("[name=q][name=q]", 'karate dsl')
    When submit().click("input[name=btnI]")
    Then waitForUrl('https://github.com/karatelabs/karate')