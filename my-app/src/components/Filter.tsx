import React from "react";
import { IFilter } from "../types";
import { FilterOption} from "./FilterOption";

interface IFilterProps {
    filter: IFilter;
    filterCallBack:  (name: string, checked:boolean) => void;
}
export function Filter({ filter,filterCallBack }: IFilterProps ) {
    return (
        <div>
            <h3>{filter.name}</h3>
            <div className="list-group">
            {filter.options.map((filteroption) => (
                <FilterOption key={filteroption.id} filteroption={filteroption} filterCallBack={filterCallBack} />
                    ))
            }
            </div>
        </div>
    );
}
