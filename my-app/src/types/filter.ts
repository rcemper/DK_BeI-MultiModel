
import { IFilterOption } from "./filteroption"

export interface IFilter {
    id: number;
    name: string;
    options: Array<IFilterOption>;
}