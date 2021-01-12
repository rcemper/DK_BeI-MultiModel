export const fetchAPI = async (endpoint:string, body:any) => {
    try {
        const response = await fetch(endpoint,body);
        const result=response.json();
        return result;
    } catch (error) {
        console.log('Fetch error: ', error);
    }
    return;
}