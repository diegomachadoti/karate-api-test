Feature: Testando webService Serverest

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

