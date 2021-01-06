import React from "react";
import { IFilterOption } from "../types";

interface IFilterOptionProps {
    filteroption: IFilterOption;
}
export function FilterOption({ filteroption }: IFilterOptionProps) {
    return (
        <label className="list-group-item">
            <input className="form-check-input me-1" type="checkbox" name={filteroption.id.toString()} value="" />
            {filteroption.name}
        </label>
    );
}