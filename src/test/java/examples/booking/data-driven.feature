Feature: Casos dinamicos

  Background:
    * def responseToken = call read('classpath:examples/booking/auth.feature@token-parameter') {user: 'admin', password: 'password123'}
    * print 'Token obtenido en Background: ', responseToken.token
    Given url 'https://restful-booker.herokuapp.com'


  Scenario: CP01 - Booking - PartialUpdateBooking
    * def id = 1

    And path 'booking/'+id
    And headers {'Content-Type': 'application/json','Accept': 'application/json','Cookie': #(responseToken.token)}
    And request {"firstname": "James","lastname": "Brown"}
    When method patch
    Then status 200


  Scenario Outline: CP03 - Data driven json
    And path 'booking'
    And request read('bodyBooking.json')

    When method post
    Then status 200

    Examples:
      | read(data.csv) |


    #Tarea subir a la ruta
  Scenario: CP04- Actualizar booking
    Given url 'https://restful-booker.herokuapp.com'
    And path 'auth'
    And header Content-Type = 'application/json'
    And request {"username": "admin","password": "password123"}
    When method post
    Then status 200
    * def tokenAuth = response.token

    * def id = 1
    Given url 'https://restful-booker.herokuapp.com'
    And path 'booking/'+id
    And header Content-Type = 'application/json'
    And header Cookie = 'token=' + tokenAuth

    And request
            """
            {
                "firstname": "Jim",
                "lastname": "Smith",
                "totalprice": 111,
                "depositpaid": true,
                "bookingdates": {
                "checkin": "2024-01-01",
                "checkout": "2024-01-10"
                },
                "additionalneeds": "Lunch"
            }
            """
    When method put
    Then status 200
    And match response.firstname == 'Jim'
    And match response.lastname == 'Smith'


  Scenario Outline: CP05- Actualizar booking con Examples
    Given url 'https://restful-booker.herokuapp.com'
    And path 'auth'
    And header Content-Type = 'application/json'
    And request {"username": "admin","password": "password123"}
    When method post
    Then status 200
    * def tokenAuth = response.token

    * def id = 1
    Given url 'https://restful-booker.herokuapp.com'
    And path 'booking/'+id
    And header Content-Type = 'application/json'
    And header Cookie = 'token=' + tokenAuth
    And request
            """
            {
                "firstname": "#(firstname)",
                "lastname": "#(lastname)",
                "totalprice": 111,
                "depositpaid": true,
                "bookingdates": {
                "checkin": "2024-01-01",
                "checkout": "2024-01-10"
                },
                "additionalneeds": "Lunch"
            }
            """
    When method put
    Then status 200
    And match response.firstname == '#(firstname)'

    Examples:
      | firstname | lastname |
      | Nilo      | Carrion  |
      | Juan      | Yaranga  |
      | Rolan     | Espino   |

  Scenario Outline: CP06 - Data driven json 2
    Given url 'https://restful-booker.herokuapp.com'
    And path 'auth'
    And header Content-Type = 'application/json'
    And request {"username": "admin","password": "password123"}
    When method post
    Then status 200
    * def tokenAuth = response.token

    * def id = 1
    Given url 'https://restful-booker.herokuapp.com'
    And path 'booking/'+id
    And header Content-Type = 'application/json'
    And header Cookie = 'token=' + tokenAuth

    And request read('data-driven.json')
    When method put
    Then status 200

    Examples:
      | firstname | lastname |
      | Nilo      | Carrion  |
      | Juan      | Yaranga  |
      | Rolan     | Espino   |
