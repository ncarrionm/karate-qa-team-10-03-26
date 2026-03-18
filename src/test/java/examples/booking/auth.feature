Feature: Flujo Auth

  @token
  Scenario: CP01 - Login exitoso
    Given url 'https://restful-booker.herokuapp.com'
    And path 'auth'
    And header Content-Type = 'application/json'
    And request {"username": "admin","password": "password123"}
    When method post
    Then status 200
    * def token = response.token
    * print 'Token obtenido: ', token

  Scenario: CP02 - Contraseña incorrecta
    Given url 'https://restful-booker.herokuapp.com'
    And path 'auth'
    And header Content-Type = 'application/json'
    And request {"username": "admin","password": "wrongpassword"}
    When method post
    Then status 200
    And match response.error == 'Bad credentials'

  Scenario Outline: CP03 - <nombre> - TOKEN
    Given url 'https://restful-booker.herokuapp.com'
    And path 'auth'
    And header Content-Type = 'application/json'
    And request {"username": "<username>","password": "<password>"}
    When method post
    Then status 200
    And match response.token != null

    Examples:
      | username | password      | nombre          |
      | admin    | password123   | Token ok        |
      | user1    | user1password | Bad credentials |
      | user2    | user2password | Bad credentials |


  Scenario: CP04 - Booking - GetBookingIds
    Given url 'https://restful-booker.herokuapp.com'
    And path 'booking'
    And params checkin = '2014-03-13', checkout = '2026-05-21'
    When method get
    Then status 200
    And match response[0].bookingid != null


  Scenario: CP05-GetBooking-ID
    * def id = 1
    Given url 'https://restful-booker.herokuapp.com'
    And path 'booking/'+id
    When method get
    Then status 200
    And match response.firstname == 'Jim'
    And match response.lastname == 'Jones'
    And match response.bookingdates.checkin == '2013-02-23'
    And match response.bookingdates.checkout == '2026-10-23'
    And match response.additionalneeds == 'Breakfast'

  Scenario: CP06-Actualizar booking por id
    * def id = 1
    #* def token = d4a9105b4029296
    Given url 'https://restful-booker.herokuapp.com'
    And path 'booking/'+id
    And header Content-Type = 'application/json'
    And header Cookie = 'token=b16c4be68b1786d'
    #And header Authorization = 'Basic ' + d4a9105b4029296
    And request {"firstname": "Jim","lastname": "Smith","totalprice": 111,"depositpaid": true,"bookingdates": {"checkin": "2024-01-01","checkout": "2024-01-10"},"additionalneeds": "Lunch"}
    When method put
    Then status 200
    And match response.firstname == 'Jim'
    And match response.lastname == 'Smith'


  Scenario: CP07- Crear booking
    Given url 'https://restful-booker.herokuapp.com'
    And path 'booking'
    And header Content-Type = 'application/json'
    And request read('bodyBooking.json')
    When method post
    Then status 200
    And match response.booking.firstname == 'Alice'

  Scenario: CP08- Actualizar booking
    Given url 'https://restful-booker.herokuapp.com'
    And path 'auth'
    And header Content-Type = 'application/json'
    And request {"username": "admin","password": "password123"}
    When method post
    Then status 200
    * def tokenAuth = response.token

    * def id = 1
    #* def token = d4a9105b4029296
    Given url 'https://restful-booker.herokuapp.com'
    And path 'booking/'+id
    And header Content-Type = 'application/json'
    #And header Cookie = 'token=b16c4be68b1786d'
    And header Authorization = 'Basic ' + tokenAuth
    And request {"firstname": "Jim","lastname": "Smith","totalprice": 111,"depositpaid": true,"bookingdates": {"checkin": "2024-01-01","checkout": "2024-01-10"},"additionalneeds": "Lunch"}
    When method put
    Then status 200
    And match response.firstname == 'Jim'
    And match response.lastname == 'Smith'


  @token-parameter
  Scenario: CP09 - Login exitoso
    Given url 'https://restful-booker.herokuapp.com'
    And path 'auth'
    And header Content-Type = 'application/json'
    And request {"username": "admin","password": "password123"}
    When method post
    Then status 200
    * def token = response.token
    * print 'Token obtenido: ', token


