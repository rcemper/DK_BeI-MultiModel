import React,{ ChangeEvent } from "react";
import { ISortOrder } from "../types";

interface ISortOrderProps {
    sortOrders: ISortOrder[];
    sortOrderCallBack:  (id:string) => void;
}
export function SortOrder({ sortOrders,sortOrderCallBack }: ISortOrderProps ) {
    return (
        <form className="d-flex flex-row-reverse">
            <select name="sort_order" onChange={(event:ChangeEvent<HTMLSelectElement>) => sortOrderCallBack(event.target.value)}>
            {sortOrders.map(
            (sortOrder) => (
                <option key={sortOrder.id} value={sortOrder.id}>{sortOrder.name}</option>
            )
            )}
            </select>
        </form>
    );
}
