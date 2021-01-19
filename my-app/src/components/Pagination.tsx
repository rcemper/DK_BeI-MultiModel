import React from "react";

interface IPaginationProps {
    curPage: number;
    nextExists: boolean;
    paginationCallback: (clickedPage: number, curPage: number) => void
}
 // er moet nog een callback komen
export function Pagination({curPage, nextExists, paginationCallback}: IPaginationProps) {
    function linkClick(event: React.MouseEvent<HTMLAnchorElement,MouseEvent>, clickedPage: number) {
        event.preventDefault();
        paginationCallback(clickedPage,curPage);
    }
    return (
        <nav aria-label="Page navigation example">
        <ul className="pagination">
            {(curPage>1) &&
            <li className="page-item">
            <a className="page-link" href="#" aria-label="Previous" onClick={(event) => linkClick(event,curPage-1)}>
                <span aria-hidden="true">&laquo;</span>
            </a>
            </li>
            }
            {(curPage>1) &&
            <li className="page-item"><a className="page-link" href="#" onClick={(event) => linkClick(event,1)}>1</a></li>
            }
            {(curPage>2) &&
            <li className="page-item disabled"><a className="page-link" href="#">...</a></li>
            }
            {(curPage>2) &&
            <li className="page-item"><a className="page-link" href="#" onClick={(event) => linkClick(event,curPage-1)}>{curPage-1}</a></li>
            }
            <li className="page-item active"><a className="page-link" href="#" onClick={(event) => event.preventDefault()}>{curPage}</a></li>
            {(nextExists) &&
            <li className="page-item"><a className="page-link" href="#" onClick={(event) => linkClick(event,curPage+1)}>{curPage+1}</a></li>
            }
            {(nextExists) &&
            <li className="page-item disabled"><a className="page-link" href="#">...</a></li>
            }
            {(nextExists) &&
            <li className="page-item">
            <a className="page-link" href="#" aria-label="Next" onClick={(event) => linkClick(event,curPage+1)}>
                <span aria-hidden="true">&raquo;</span>
            </a>
            </li>
            }
        </ul>
        </nav>
    )
}