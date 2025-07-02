#*** Variables *** ---> resources/variables.py
#*** Settings *** ---> resources/common.resource
#*** Test Cases *** ---> continuam no arquivo .robot
#*** Keywords *** ---> resources/common.resource


# Casos de Teste
*** Settings ***
Library        RequestsLibrary
Resource       ../../resources/common.resource
Variables      ../../resources/variables.py
Suite Setup    Create Token    ${url}

*** Test Cases ***
Create Booking
    # Header é opcional na criação
    ${headers}    Create Dictionary    Content-Type=${content_type}
    ${body}    Evaluate    json.loads(open('./fixtures/json/booking1.json').read())
    

    ${response}    POST    url=${url}/booking    json=${body}    headers=${headers}

    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}

    Status Should Be    200
    Should Be Equal    ${response_body}[booking][firstname]                ${firstname}
    Should Be Equal    ${response_body}[booking][bookingdates][checkin]    ${bookingdates}[checkin]


Get Booking
    Get Booking Id    ${url}    ${firstname}    ${lastname}

    ${response}    GET    url=${url}/booking/${booking_id}

    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}

    Should Be Equal    ${response_body}[firstname]                 ${firstname}
    Should Be Equal    ${response_body}[lastname]                  ${lastname}
    Should Be Equal    ${response_body}[totalprice]                ${totalprice}
    Should Be Equal    ${response_body}[depositpaid]               ${depositpaid}
    Should Be Equal    ${response_body}[bookingdates][checkin]     ${bookingdates}[checkin]
    Should Be Equal    ${response_body}[bookingdates][checkout]    ${bookingdates}[checkout]
    Should Be Equal    ${response_body}[additionalneeds]           ${additionalneeds}


Update Booking
    Get Booking Id    ${url}    ${firstname}    ${lastname}

    ${headers}    Create Dictionary    Content-Type=${content_type}    Cookie=token=${token}
    ${body}    Create Dictionary    firstname=${firstname}    lastname=${lastname}    totalprice=100    depositpaid=True    bookingdates=${bookingdates}    additionalneeds=${additionalneeds}

    ${response}    PUT    url=${url}/booking/${booking_id}    json=${body}    headers=${headers}

    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}

    Status Should Be    200
    Should Be Equal    ${response_body}[firstname]                 ${firstname}
    Should Be Equal    ${response_body}[lastname]                  ${lastname}
    Should Be Equal    ${response_body}[totalprice]                ${{int(100)}}
    Should Be Equal    ${response_body}[depositpaid]               ${{bool(True)}}
    Should Be Equal    ${response_body}[bookingdates][checkin]     ${bookingdates}[checkin]
    Should Be Equal    ${response_body}[bookingdates][checkout]    ${bookingdates}[checkout]
    Should Be Equal    ${response_body}[additionalneeds]           ${additionalneeds}


Partial Update Booking
    Get Booking Id    ${url}    ${firstname}    ${lastname}
    ${headers}    Create Dictionary    Content-Type=${content_type}    Cookie=token=${token}
    ${body}    Create Dictionary    additionalneeds=Dinner

    ${response}    PATCH    url=${url}/booking/${booking_id}    json=${body}    headers=${headers}

    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}

    Status Should Be    200
    Should Be Equal    ${response_body}[firstname]                 ${firstname}
    Should Be Equal    ${response_body}[lastname]                  ${lastname}
    Should Be Equal    ${response_body}[totalprice]                ${{int(100)}}
    Should Be Equal    ${response_body}[depositpaid]               ${{bool(True)}}
    Should Be Equal    ${response_body}[bookingdates][checkin]     ${bookingdates}[checkin]
    Should Be Equal    ${response_body}[bookingdates][checkout]    ${bookingdates}[checkout]
    Should Be Equal    ${response_body}[additionalneeds]           Dinner


Delete Booking
    Get Booking Id    ${url}    ${firstname}    ${lastname}
    ${headers}    Create Dictionary    Content-Type=${content_type}    Cookie=token=${token}

    ${response}    DELETE    url=${url}/booking/${booking_id}    headers=${headers}
    
    Status Should Be    201