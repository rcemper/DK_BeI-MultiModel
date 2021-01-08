import { IProduct } from "../types";

export const doesProductNameContain = (product: IProduct, name: string): boolean => {
    return product.name.toLowerCase().includes(name.toLowerCase())
}