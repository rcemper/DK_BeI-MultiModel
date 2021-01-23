import React, { useState, useEffect } from 'react';
import './App.css';
import { Header } from "./components/Header";
import { Product } from "./components/Product";
import { Filter } from "./components/Filter";
import { SortOrder } from "./components/SortOrder";
import { Pagination } from "./components/Pagination";
import { PageSize} from "./components/PageSize";

//import {products, filters} from "./mocks";
import { IFilter, IProduct, ISortOrder } from './types';
import {/*doesProductNameContain,*/changeFilterOptionChecked,fetchAPI} from "./utils";
import { Helmet } from 'react-helmet-async';

function App() {
  const [state,updateState] = useState({searchTerm:"", filters: Array<IFilter>(), selectedSortOrder:{field:"",direction:1}, pageDirection:{id:"",direction:1}, pageSize: 9 });
  const [productState,updateProductState] = useState({products: Array<IProduct>(), curPage:1,nextExists: false,resultCount: 0, filterWithCounts: Array<IFilter>() });
  const [requestState,updateRequestState] = useState({productRequestID:0,countRequestID:0});
  const [sortOrders,updateSortOrders] = useState({sortOrders: Array<ISortOrder>()});
  const pageSizes = [15,30,60];
  function onSearch(searchTerm : string) {
    /*
    const newProducts: IProduct[] = products.filter((product) =>
              doesProductNameContain(product,searchTerm))
    */
    const newSearchTerm=searchTerm;
    updateState(prevState => {
      return {...prevState, searchTerm: newSearchTerm}});
  }
  function topFunction() {
    document.body.scrollTop = 0; // For Safari
    document.documentElement.scrollTop = 0; // For Chrome, Firefox, IE and Opera
  }
  

  function filterCallBack(name:string, checked: boolean) {
    const newFilters: IFilter[]= state.filters;
    changeFilterOptionChecked(newFilters,name,checked);
    updateState(prevState => {
      return {...prevState, filters: newFilters, pageDirection:  {id:"",direction: prevState.pageDirection.direction} }});
    updateProductState(prevState => { 
      return {...prevState, curPage:1}});
  }

  function paginationCallback (clickedPage: number, curPage: number) {
    let lastID="";
    let direction=1;
    if (clickedPage===1) {
      // defaukt
    } else if (curPage<clickedPage) {
      lastID=productState.products[productState.products.length-1].sort_index
    } else {
      lastID=productState.products[0].sort_index
      direction=-1
    }
    updateProductState(prevState => {
      return {...prevState, curPage: clickedPage}})
    updateState(prevState => {
      return {...prevState, pageDirection: {id: lastID,direction:direction}}});
    //topFunction();
  }

  function sortOrderCallBack(id:string) {
    updateState(prevState => {
      return {...prevState, selectedSortOrder:
        {
          field:id.split("_")[0],
          direction:Number(id.split("_")[1])
        },pageDirection:  {id:"",direction: prevState.pageDirection.direction}
      }
    });
    updateProductState(prevState => { 
      return {...prevState, curPage:1}});
  }

  function pageSizeCallBack(size:number) {
    updateState(prevState => {
      return {...prevState, pageSize: size,pageDirection:  {id:"",direction: prevState.pageDirection.direction}
      }
    });
    updateProductState(prevState => { 
      return {...prevState, curPage:1}});
  }

  useEffect(() => {
    if (state.filters.length && state.selectedSortOrder?.field!=="") { 
      console.log("state changed");
      //updateRequestState(prevState => { 
      //  return {...prevState, productRequestID: prevState.productRequestID+1}});
      let payload = {
        "filters":state.filters,
        "sort": state.selectedSortOrder,
        "pageSize": state.pageSize,
        "pageDirection": state.pageDirection,
        "searchTerm": state.searchTerm,
        "curPage": productState.curPage,
        "requestId": requestState.productRequestID
      };
      console.log(payload);
      const fetchProducts = async() => {
        const productResult=await fetchAPI(new Request("http://localhost:9092/BeI/products",{
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
          body: JSON.stringify(payload)}));
        console.log(productResult);
        if (productResult.requestId===requestState.productRequestID) {
          updateProductState(prevState => {
            return {...prevState,products: productResult.products, lastID: productResult.lastId, nextExists: productResult.hasNext, resultCount: productResult.totalCount}})
        }
      }
      payload.requestId=requestState.countRequestID
      fetchProducts();
      const fetchCounts = async() => {
        const countResult=await fetchAPI(new Request("http://localhost:9092/BeI/counts",{
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
          body: JSON.stringify(payload)}));
        console.log(countResult);
        if (countResult.requestId===requestState.productRequestID) {
          updateProductState(prevState => {
            return {...prevState,filterWithCounts:countResult.filters2}})
          }
      }
      fetchCounts();

    }
  }, [state])

  useEffect(() => {
    // code to run on component mount
    console.log("requesting startup data: ");
    let newFilters: IFilter[]=Array<IFilter>();
    let newSortOrders: ISortOrder[]=Array<ISortOrder>();
    const fetchFilters = async() => {
      const filterResult=await fetchAPI(new Request("http://localhost:9092/BeI/filters"));
      newFilters=filterResult.filters;
      const sortOrderResult = await fetchAPI(new Request("http://localhost:9092/BeI/sorts"));
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
  <div className="container--xxl px-4">
    <div className="d-flex justify-content-between bg-white align-items-center"> 
      <span className="font-weight-bold text-uppercase">Product list</span>
      <span className="font-weight-bold text-uppercase">{productState.resultCount} results</span>
      <div>
        <div className="text d-flex">Items per page
        <PageSize pageSizes={pageSizes} pageSizeCallBack={pageSizeCallBack}/>
        </div>
        <div className="d-flex">
        <SortOrder key="1" sortOrders={sortOrders.sortOrders} sortOrderCallBack={sortOrderCallBack} />
        </div>
      </div>
    </div>
    <div className="row">
      <div id="firstAccordion" className="col-sm-3 px-4 accordion">
        {state.filters.map(
            (filter) => (
              <Filter key={filter.id} 
                      filter={filter} 
                      filterCallBack={filterCallBack} 
                      isFirst={filter.id===state.filters[0].id} 
                      filterCounts={productState.filterWithCounts} />
            )
          )}        
      </div>
      <div className="col-sm-9">
        <div>
          
          
        </div>
        <div className="row row-cols-3 px-4 text-center">
          {productState.products?.length>0 ? productState.products.map(
            (product) => (
              <Product key={product.id} product={product} />
            )
          ) : <div>No products found.</div>  
        }
        {productState.products?.length>0 ?
        <Pagination curPage={productState.curPage} lastPage={Math.floor(productState.resultCount/state.pageSize)} paginationCallback={paginationCallback}/>
        : ""}
        </div>
      </div>
    </div>
  </div>
  </div>
);
}

export default App;