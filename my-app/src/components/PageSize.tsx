import React,{ ChangeEvent } from "react";

interface PageSizeProps {
    pageSizes: number[];
    pageSizeCallBack: (size:number) => void;
}

export function PageSize({ pageSizes,pageSizeCallBack }: PageSizeProps ) {
    return (
        <form className="d-flex flex-row-reverse">
            <select name="sort_order" onChange={(event:ChangeEvent<HTMLSelectElement>) => pageSizeCallBack(+(event.target.value))}>
            {pageSizes.map(function(name, index){
                    return <option key={name} value={name}>{name}</option>;
                  }
            )}
            </select>
        </form>
    );
}
