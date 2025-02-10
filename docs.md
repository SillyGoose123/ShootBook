# Shoots API 
body type: multipart/form-data

## Endpoints
    Token:
        url: https://shotsapp.disag.de/api/token
        method: POST
        props:
            - email 
            - password
            - device_name

    Preview/Qr-Code Data:
        url: https://shotsapp.disag.de/api/results/preview
        method: POST
        auth: bearer token  ur
        props:
             data: qr code link

    Store Qr Code in Disag Store:
        url: https://shotsapp.disag.de/api/results
        method: POST
        auth: bearer token
        props:
             data: qr code link

    Get all your Results:
        url: https://shotsapp.disag.de/api/results
        method: GET
        auth: bearer token

# Math

## Divider
```math
$\frac{\sqrt{x²+y²} * 20}{20}
```

## Direction
```math
$\frac{\atan2 (y, x) * 180}{pi} + 224
```

# Disag data parsing

## ID
| OurID | DisagID | Disag NEU Schießzeiten |
|-------|---------|------------------------|
| LG20  | 100_2   | 50_1                   |
| LG40  | 100_4   | 50_2                   |
| LP20  | 300_2   | 50_5                   |
| LP40  | 300_4   | 50_6                   |    