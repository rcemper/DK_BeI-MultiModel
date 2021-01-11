import React, { ChangeEvent, FormEvent, useState } from 'react';

export function Search({searchCallback}: { searchCallback: (searchTerms: string) => void }) {
    const [state,updateState] = useState({searchTerm:""});
    
    function preventDefaultAndCallBack(event: FormEvent) {
        event.preventDefault();
        searchCallback(state.searchTerm);
    }
    
    return (
        <form className="d-flex flex-row-reverse" onSubmit={preventDefaultAndCallBack}>
        <input 
            className="form-control me-2" 
            type="search" 
            role={'search'}
            placeholder="Search" 
            aria-label="Search" 
            onChange={(event:ChangeEvent<HTMLInputElement>) => {
                updateState({searchTerm:event.target.value})
                searchCallback(event.target.value)
                }} />
        <button className="btn btn-outline-success" onClick={preventDefaultAndCallBack} type="submit">Search</button>
    </form>
    );
}
