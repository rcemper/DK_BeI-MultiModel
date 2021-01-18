import React from "react";
import { IProduct } from "../types";

interface IProductProps {
    product: IProduct;
}
export function Product({ product }: IProductProps ) {
    return (
      <div className="col">
      <div className="card mb-4 shadow-sm h-100">
        <div className="card-header">
          <h4 className="my-0 fw-normal">{product.category_name} {product.name}({product.id})</h4>
        </div>
        <div className="card-body">
          <h1 className="card-title pricing-card-title">${product.price}</h1>
          <img src="logo512.png" className="card-img-top img-thumbnail" alt="..."/>
          <ul className="list-unstyled mt-3 mb-4">
          {product.attributes?.map((attribute) => (
                  <li key={attribute.id}>{attribute.attribute} : {attribute.name}</li>
                ))}
          </ul>
        </div>
        <div className="card-footer">
          <button type="button" className="w-100 btn btn-lg btn-outline-primary">Buy</button>
        </div>
    </div>
    </div>
    );
}
