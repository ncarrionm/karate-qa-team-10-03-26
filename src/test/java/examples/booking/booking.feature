Feature: Flujo booking

  Scenario: CP08- Actualizar booking
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
#    And request {"firstname": "Jim","lastname": "Smith","totalprice": 111,"depositpaid": true,"bookingdates": {"checkin": "2024-01-01","checkout": "2024-01-10"},"additionalneeds": "Lunch"}
    
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


  Scenario: Update booking with call
    * def responseToken = call read('cllasspath:examples/booking/auth.feature@token')
    * print 'Token obtenido: ', responseToken
    * def tokenAuth = responseToken.token

    Given url 'https://restful-booker.herokuapp.com'
    And header Content-Type = 'application/json'
    And header Acept = 'application/json'
    And header Cookie = 'token=' + tokenAuth
    And path 'booking/1'
    And request {"firstname": "Jim","lastname": "Smith","totalprice": 111,"depositpaid": true,"bookingdates": {"checkin": "2024-01-01","checkout": "2024-01-10"},"additionalneeds": "Lunch"}
    When method put
    Then status 200


