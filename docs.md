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
$\frac{\atan2(y, x) * 180}{pi} + 224
```

# Disag data parsing

## ID
Implemented in disag utils.

| OurID  | DisagID | Disag NEU Schießzeiten (=New Time ID) |
|--------|---------|---------------------------------------|
| LG20   | 100_2   | 50_1                                  |
| LG40   | 100_4   | 50_2                                  |
| LP20   | 300_2   | 50_5                                  |
| LP40   | 300_4   | 50_6                                  |
| KK10   | 400_1   | -                                     |
| KK20   | 400_2   | -                                     |
| KK40   | 400_4   | -                                     |
| KK60   | 400_6   | -                                     |
| KK3x10 | 500_1   | -                                     |
| KK3x20 | 500_2   | -                                     |


# Target values
Represented by ResultType Enum.

| Discipline | 10 Diameter | Value Distance | Target Width | Mirror Width | Inner 10                              |
|------------|-------------|----------------|--------------|--------------|---------------------------------------|
| LG         | 0.5 mm      | 2.5 mm         | 45.5 mm      | 30.5 mm      | - (Exists ≥10.2 but not drawn by App) |
| LP         | 11.5 mm     | 8 mm           | 155.5 mm     | 59.5 mm      | 5 mm                                  |
| KK         | 10.4 mm     | 8 mm           | 154.4 mm     | 112.4 mm     | 5 mm                                  |
| KK PP      | 50 mm       | 25 mm          | 500 mm       | 200 mm       | 25 mm                                 |
| KK PD      | 100 mm      | 40 mm          | 500 mm       | 200 mm       | 50 mm                                 | 

Amount of numbers in mirror:
```math
\frac{Mirror Width}{Diameter Multiplier} : 2
```


Source: https://www.dsb.de/fileadmin/DSB.DE/PDF/PDF_2020/Zielscheiben_DSB_SpO_2014.pdf

# Flutter stuff

## Pixel to mm
Flutter works with logical pixels where 1cm == 39px

pixel to mm:
```math
pixels : \frac{38}{10}
```

mm to pixel:
```math
mm * \frac{38}{10}
```