import React from "react";
import { IProduct } from "../types";

interface IProductProps {
    product: IProduct;
}
export function Product({ product }: IProductProps ) {
    return (
        <div className="card col">
          <img src="logo512.png" className="card-img-top" alt="..."/>
          <div className="card-body">
            <h5 className="card-title">{product.name}</h5>
            <p className="card-text">The product id is: {product.id}</p>
          </div>
        </div>
    );
}
