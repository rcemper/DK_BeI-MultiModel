import React from "react";
import { IProduct } from "../types";
import { doesProductNameContain } from "../utils";

interface IProductProps {
    product: IProduct;
}
export function Product({ product }: IProductProps ) {
    return (
        <div className="card col gx-5">
          <img src="logo512.png" className="card-img-top" alt="..."/>
          <div className="card-body">
            <h5 className="card-title">{product.name}</h5>
            <p className="card-text">The product id is: {product.id}</p>
            <ul>
              {product.attributes?.map((attribute) => (
                <li key={attribute.id}>{attribute.attribute} : {attribute.name}</li>
              ))}
            </ul>
          </div>
        </div>
    );
}
