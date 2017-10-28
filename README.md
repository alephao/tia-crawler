Tia Crawler ![Version](https://img.shields.io/badge/version-0.0.3-orange.svg)
----
Gem para acessar os dados do TIA Mackenzista

## Como instalar
```
gem install tia-crawler
```

## Como usar
```
tia-crawler horarios
```

## Exemplo de Resposta
```
[
   {
      "name": "MAQUINAS ELETRICAS",
      "timetable": {
          "seg":[
             "07:30"
          ],
          "ter":[
             "08:15"
          ],
          "qua":[
             "09:05"
          ],
          "qui":[
             "09:50"
          ],
          "sex":[ ],
          "sab":[ ]
      }
   },
   {
      "name": "MICROPROCESSADORES II",
      "timetable": {
          "seg":[
             "18:30"
          ],
          "ter":[
             "19:15"
          ],
          "qua":[ ],
          "qui":[ ],
          "sex":[ ],
          "sab":[ ]
      }

   },
   {
      "name": "CIRCUITOS ELETROMAGNETICOS II",
      "timetable": {
          "seg":[
             "18:30"
          ],
          "ter":[
             "19:15"
          ],
          "qua":[
             "20:05"
          ],
          "qui":[
             "20:50"
          ],
          "sex":[ ],
          "sab":[ ]
      }
   }
]
```
