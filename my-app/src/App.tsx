import React, { useState } from 'react';
import logo from './logo.svg';
import './App.css';
import { Helmet } from "react-helmet";
import { Header } from "./components/Header";
import { Product } from "./components/Product";
import { Filter } from "./components/Filter";
import {products, filters} from "./mocks";

function App() {
  const [state,updateState] = useState({products:products, searchTerm:"", filters: filters});
return (
<div className="App">
  <Helmet>
    <meta charSet="utf-8" />
    <title>React app</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta1/dist/css/bootstrap.min.css" rel="stylesheet"
      integrity="sha384-giJF6kkoqNQ00vy+HMDP7azOuL0xtbfIcaT9wjKHr8RbDVddVHyTfAAsrekwKmP1" crossOrigin="anonymous">
    </link>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta1/dist/js/bootstrap.bundle.min.js"
      integrity="sha384-ygbV9kiqUc6oa4msXn9868pTtWMgiQaeYH7/t7LECLbyPA2x65Kgf80OJFdroafW" crossOrigin="anonymous">
    </script>
  </Helmet>
  <Header/>
  <div className="container--xxl .mt-2">
    <div className="row">
      <div className="col-sm-3 border">
        {state.filters.map(
            (filter) => (
              <Filter key={filter.id} filter={filter} />
            )
          )}        
      </div>
      <div className="col-sm-9 border">
        <div className="row row-cols-4 gap-3">
          {state.products.map(
            (product) => (
              <Product key={product.id} product={product} />
            )
          )}
        </div>
      </div>
    </div>
  </div>
  </div>
);
}

export default App;