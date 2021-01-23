import React from "react";

interface IPaginationProps {
    curPage: number;
    lastPage: number;
    paginationCallback: (clickedPage: number, curPage: number) => void
}
 // er moet nog een callback komen
export function Pagination({curPage, lastPage, paginationCallback}: IPaginationProps) {
    function linkClick(event: React.MouseEvent<HTMLButtonElement,MouseEvent>, clickedPage: number) {
        event.preventDefault();
        paginationCallback(clickedPage,curPage);
    }
    return (
        <nav aria-label="Page navigation example">
        <ul className="pagination mt-3">
            {(curPage>1) &&
            <li className="page-item">
            <button className="btn btn-outline-primary" onClick={(event) => linkClick(event,curPage-1)} >
                <span aria-hidden="true">&laquo;</span>
            </button>
            </li>
            }
            {(curPage>1) &&
            <li className="page-item">
                <button className="btn btn-outline-primary" onClick={(event) => linkClick(event,1)} >
                    <span aria-hidden="true">1</span>
                </button>
            </li>
            }
            {(curPage>2) &&
            <li className="page-item disabled">
                <button className="btn btn-outline-primary" >
                    <span aria-hidden="true">...</span>
                </button>
            </li>
            }
            {(curPage>2) &&
            <li className="page-item">
                <button className="btn btn-outline-primary" onClick={(event) => linkClick(event,curPage-1)} >
                    <span aria-hidden="true">{curPage-1}</span>
                </button>
            </li>
            }
            <li className="page-item active">
                <button className="btn btn-primary" >
                    <span aria-hidden="true">{curPage}</span>
                </button>
            </li>
            {(curPage<lastPage-1) &&
            <li className="page-item">
                <button className="btn btn-outline-primary" onClick={(event) => linkClick(event,curPage+1)} >
                    <span aria-hidden="true">{curPage+1}</span>
                </button>
            </li>
            }
            {(curPage<(lastPage-1)) &&
            <li className="page-item disabled">
                <button className="btn btn-outline-primary" >
                    <span aria-hidden="true">...</span>
                </button>
            </li>
            }
            {(curPage<lastPage) &&
            <li className="page-item">
                <button className="btn btn-outline-primary" onClick={(event) => linkClick(event,lastPage)} >
                    <span aria-hidden="true">{lastPage}</span>
                </button>
            </li>
            }
            {(curPage<lastPage) &&
            <li className="page-item">
                <button className="btn btn-outline-primary" onClick={(event) => linkClick(event,curPage+1)} >
                    <span aria-hidden="true">&raquo;</span>
                </button>
            </li>
            }
        </ul>
        </nav>
    )
}