import React from "react";
import { IFilter } from "../types";
import { FilterOption} from "./FilterOption";

interface IFilterProps {
    filter: IFilter;
    filterCallBack:  (name: string, checked:boolean) => void;
    isFirst: boolean;
}
export function Filter({ filter,filterCallBack,isFirst }: IFilterProps ) {
    return (
        <div className="accordion-item">
            <h3 id={"header_"+filter.id.toString()} className="accordion-header">
                <button className={"accordion-button "+(!isFirst ? "collapsed" : "")} type="button" data-bs-toggle="collapse" data-bs-target={"#body_"+filter.id.toString()} aria-expanded={isFirst ? "true" : "false"} aria-controls={"body_"+filter.id.toString()}>
                    {filter.name}
                </button>
            </h3>
            <div id={"body_"+filter.id.toString()} className={"accordion-collapse collapse "+(isFirst ? "show" : "")}>
                <div className="list-group accordion-body" data-bs-parent="#firstAccordion" aria-labelledby={"header_"+filter.id.toString()}>
                {filter.options.map((filteroption) => (
                    <FilterOption key={filteroption.id} filteroption={filteroption} filterCallBack={filterCallBack} />
                        ))
                }
                </div>
            </div>
        </div>
    );
}
