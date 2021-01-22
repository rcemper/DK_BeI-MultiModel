export const getFilterOptionCount = (filterOptionId: number, array: any): number => {
    let result:number=0;
    array.forEach((element: { id: number; count: any; }) => {
        //console.log(element.id,typeof(element.id));
        //console.log(filterOptionId,typeof(filterOptionId));
        if (+element.id===filterOptionId) {
            //console.log("found",element.count)
            result=element.count;
        }
    });
    return result;
}