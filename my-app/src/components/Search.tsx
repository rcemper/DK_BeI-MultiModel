import React, { ChangeEvent } from 'react';

export function Search({searchCallback}: { searchCallback: (searchTerms: string) => void }) {
    return (
        <form className="d-flex">
        <input 
            className="form-control me-2" 
            type="search" 
            role={'search'}
            placeholder="Search" 
            aria-label="Search" 
            onChange={(event:ChangeEvent<HTMLInputElement>) => searchCallback(event.target.value)} />
        <button className="btn btn-outline-success" type="submit">Search</button>
    </form>
    );
}
