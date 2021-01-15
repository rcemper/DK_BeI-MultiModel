import { IAttribute } from "./attribute"

export interface IProduct {
    id: number;
    name: string;
    category_id : number;
    category_name: string;
    price: number;
    attributes?: Array<IAttribute>;
    sort_id: string;
  }