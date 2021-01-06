import React from "react";
import { IFilter } from "../types";
import { FilterOption} from "./FilterOption";

interface IFilterProps {
    filter: IFilter;
}
export function Filter({ filter }: IFilterProps ) {
    return (
        <div>
            <h3>{filter.name}</h3>
            <div className="list-group">
            {filter.options.map((filteroption) => (
                <FilterOption key={filteroption.id} filteroption={filteroption} />
                    ))
            }
            </div>
        </div>
    );
}
