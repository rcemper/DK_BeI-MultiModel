export const fetchAPI = async (request: Request) => {
    try {
        const response = await fetch(request);
        const result=response.json();
        return result;
    } catch (error) {
        console.log('Fetch error: ', error);
    }
    return;
}