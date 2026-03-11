Feature: Ejercicios Basicos

#  Background:
#    * url 'https://petstore.swagger.io/v2'

  Scenario: CP01 - Login exitoso
    Given url 'https://petstore.swagger.io/v2'
    And path 'user/login'
    And param username = 'nilo'
    And param password = '1234'
    When method get
    Then status 200

  Scenario: CP02 - Login fallido
    Given url 'https://petstore.swagger.io/v2'
    And path 'user/login'
    And param username = 'nilo'
    And param password = ''
    When method get
    Then status 200

  Scenario: CP03 - Crear un nuevo usuario
    Given url 'https://petstore.swagger.io/v2'
    And path 'user'
    And request
      """
      {
        "id": 12345,
        "username": "nilo",
        "firstName": "Nilo",
        "lastName": "Perez",
        "email": "nilo@gmail.com",
        "password": "1234",
        "phone": "1234567890",
        "userStatus": 1
        }
        """
    When method post
    Then status 200

  Scenario: CP04 - Crear registro order exitoso
    Given url 'https://petstore.swagger.io/v2'
    And path 'store/order'
    And request
      """
      {
        "id": 12345,
        "petId": 54321,
        "quantity": 1,
        "shipDate": "2024-06-01T12:00:00.000Z",
        "status": "placed",
        "complete": false
      }
      """
    When method post
    Then status 200

  Scenario: CP05 - Crear registro con variable
    * def bodyOrder =
      """
      {
        "id": 12345,
        "petId": 54321,
        "quantity": 1,
        "shipDate": "2024-06-01T12:00:00.000Z",
        "status": "placed",
        "complete": false
      }
      """
    Given url 'https://petstore.swagger.io/v2'
    And path 'store/order'
    * print bodyOrder
    And request bodyOrder
    When method post
    * print 'Mascota agregada: ', bodyOrder
    Then status 200

  Scenario: Prueba de assertions
    * def color = 'red'
    * def num = 5
    Then assert color + num == 'red 5'

  Scenario: CP06 - Actualizar informacion mascota
    Given url 'https://petstore.swagger.io/v2'
    And path 'pet'
    And request
          """
          {
            "id": 12345,
            "category": {
              "id": 1,
              "name": "Dogs"
            },
            "name": "Rex",
            "photoUrls": [
              "http://example.com/photo1.jpg"
            ],
            "tags": [
              {
                "id": 1,
                "name": "tag1"
              }
            ],
            "status": "available"
          }
          """
    When method put
    Then status 200
    And match response.category.name == 'Dogs'
    And match response.status == 'available'

  Scenario: CP07 - Agregar mascota
    Given url 'https://petstore.swagger.io/v2'
    And path 'pet'
    And request
          """
          {
            "id": 54321,
            "category": {
              "id": 2,
              "name": "Cats"
            },
            "name": "Whiskers",
            "photoUrls": [
              "http://example.com/photo2.jpg"
            ],
            "tags": [
              {
                "id": 2,
                "name": "tag2"
              }
            ],
            "status": "available"
          }
          """
    When method post
    Then status 200
    And match response.category.name == 'Cats'
    And match response.name == 'Whiskers'
    And match response.tags[0].name == 'tag2'
    And assert response.photoUrls[0] == 'http://example.com/photo2.jpg'
    And assert response.status == 'available'
    * print 'Mascota agregada: ', response

  Scenario:  CP08 - Buscar mascota por status
    Given url 'https://petstore.swagger.io/v2'
    And path 'pet/findByStatus'
    And param status = 'available'
    When method get
    Then status 200
    And match each response[*].id == '#number'
    And match each response[*].name == '#string'
    And match each response[*].status == 'available'

