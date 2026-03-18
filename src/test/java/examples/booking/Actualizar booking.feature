Feature: Actualizar booking

  Background:
    * url 'https://restful-booker.herokuapp.com'
    * header Content-Type = 'application/json'
    * header Accept = 'application/json'
    * header Cookie = 'token=d4a9105b4029296'

  Scenario: Actualizar un booking existente
    Given path 'booking', 1

    And request
    """
    {
      "firstname": "James",
      "lastname": "Brown",
      "totalprice": 111,
      "depositpaid": true,
      "bookingdates": {
        "checkin": "2018-01-01",
        "checkout": "2019-01-01"
      },
      "additionalneeds": "Breakfast"
    }
    """

    When method PUT
    Then status 200

    And match response.firstname == 'James'
    And match response.lastname == 'Brown'
    And match response.totalprice == 111

