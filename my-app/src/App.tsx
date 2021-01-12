import React, { useState, useEffect } from 'react';
import './App.css';
import { Header } from "./components/Header";
import { Product } from "./components/Product";
import { Filter } from "./components/Filter";
import { SortOrder } from "./components/SortOrder";
//import {products, filters} from "./mocks";
import { IFilter, IProduct, ISortOrder } from './types';
import {/*doesProductNameContain,*/changeFilterOptionChecked,fetchAPI} from "./utils";
import { Helmet } from 'react-helmet-async';

function App() {
  const [state,updateState] = useState({searchTerm:"", filters: Array<IFilter>(), selectedSortOrder:{field:"",direction:1} });
  const [productState,updateProductState] = useState({products: Array<IProduct>()});
  const [sortOrders,updateSortOrders] = useState({sortOrders: Array<ISortOrder>()});
  function onSearch(searchTerm : string) {
    /*
    const newProducts: IProduct[] = products.filter((product) =>
              doesProductNameContain(product,searchTerm))
    */
    const newSearchTerm=searchTerm;
    updateState(prevState => {
      return {...prevState, searchTerm: newSearchTerm}});
  }

  function filterCallBack(name:string, checked: boolean) {
    const newFilters: IFilter[]= state.filters;
    changeFilterOptionChecked(newFilters,name,checked);
    updateState(prevState => {
      return {...prevState, filters: newFilters}});
  }

  function sortOrderCallBack(id:string) {
    updateState(prevState => {
      return {...prevState, selectedSortOrder:
        {
          field:id.split("_")[0],
          direction:Number(id.split("_")[1])
        }
      }
    });
  }

  useEffect(() => {
    if (state.filters.length && state.selectedSortOrder.field!=="") { 
      console.log("state changed");
      let payload = {
        "filters":state.filters,
        "sort": state.selectedSortOrder,
        "pageSize": 10,
        "lastId": "",
        "searchTerm": state.searchTerm
      };
      console.log(payload);

      fetch("http://localhost:9092/BeI/products", {
        method: 'POST', // *GET, POST, PUT, DELETE, etc.
        mode: 'cors', // no-cors, *cors, same-origin
        cache: 'no-cache', // *default, no-cache, reload, force-cache, only-if-cached
        credentials: 'same-origin', // include, *same-origin, omit
        headers: {
          'Content-Type': 'application/json'
          // 'Content-Type': 'application/x-www-form-urlencoded',
        },
        redirect: 'follow', 
        referrerPolicy: 'no-referrer',
        body: JSON.stringify(payload)}
      ).then(res => res.json())
      .then(
        (result) => {
          console.log(result);
          updateProductState({...state,products: result.products})
        },
        // Note: it's important to handle errors here
        // instead of a catch() block so that we don't swallow
        // exceptions from actual bugs in components.
        (error) => {
    
        }
      );
    }
  }, [state])

  useEffect(() => {
    // code to run on component mount
    console.log("requesting startup data: ");
    let newFilters: IFilter[]=Array<IFilter>();
    let newSortOrders: ISortOrder[]=Array<ISortOrder>();
    const fetchFilters = async() => {
      const filterResult=await fetchAPI("http://localhost:9092/BeI/filters",{});
      newFilters=filterResult.filters;
      const sortOrderResult = await fetchAPI("http://localhost:9092/BeI/sorts",{});
      newSortOrders=sortOrderResult

      console.log("Startup data received: ");
      updateSortOrders(prevState => {
        return {...prevState, sortOrders:newSortOrders}});
      updateState(prevState => {
        return {...prevState, filters: newFilters, selectedSortOrder: newSortOrders[0] }});

    };

    fetchFilters();
  }, [])

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
  <Header searchCallback={onSearch}/>
  <div className="container--xxl .mt-2 px-4">
    <div className="row">
      <div className="col-sm-3 px-4">
        {state.filters.map(
            (filter) => (
              <Filter key={filter.id} filter={filter} filterCallBack={filterCallBack} />
            )
          )}        
      </div>
      <div className="col-sm-9">
        <div>
          <SortOrder key="1" sortOrders={sortOrders.sortOrders} sortOrderCallBack={sortOrderCallBack} />
        </div>
        <div className="row row-cols-3 px-4 text-center">
          {productState.products ? productState.products.map(
            (product) => (
              <Product key={product.id} product={product} />
            )
          ) : <div>No products</div>
        }
        </div>
      </div>
    </div>
  </div>
  </div>
);
}

export default App;