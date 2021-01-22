import {IFilter} from "../types"

export const filters: IFilter[] = [
    {
        "id" : 1,
        "name" : "screen size",
        "options" : [
          {
            "id" : 1,
            "name": "1-10 inch",
            "value": 1 ,
            "checked": false,
            "bit_position": 1,
            "product_count":10
          },
          {
            "id" : 2,
            "name": "11-20 inch",
            "value": 2,
            "checked": false,
            "bit_position": 2,
            "product_count":10
          },
          {
            "id" : 3,
            "name": "21-30 inch",
            "value": 3,
            "checked": false,
            "bit_position": 3,
            "product_count":10
          }
        ]
    },
    {
        "id" : 2,
        "name" : "energy efficiency",
        "options" : [
          {
            "id": 4,
            "name": "A++",
            "value" : 1,
            "checked": false,
            "bit_position": 4,
            "product_count":10
          },
          {
            "id": 5,
            "name": "A+",
            "value" : 2,
            "checked": false,
            "bit_position": 5,
            "product_count":10
          },
          {
            "id": 6,
            "name": "A",
            "value" : 3,
            "checked": false,
            "bit_position": 6,
            "product_count":10
          },
          {
            "id": 7,
            "name": "B",
            "value" : 4,
            "checked": false,
            "bit_position": 7,
            "product_count":10
          }
        ]
    }
];