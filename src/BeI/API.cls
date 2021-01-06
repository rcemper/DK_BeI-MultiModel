Class BeI.API Extends %CSP.REST
{

Parameter CONTENTTYPE = "application/json";

XData UrlMap
{
<Routes>
    <Route Url="/filters" Method="GET" Call="Filters" Cors="false" />
</Routes>
}

ClassMethod Filters() As %Status
{
    set resultObj = {}
    set resultObj.filters=[]
    set start=$ZH    
    d resultObj.filters.%Push(##class(BeI.API).CategoryFilter())
    set resultObj.time=$ZH - start
    w resultObj.%ToJSON()
    return $$$OK
}

ClassMethod CategoryFilter() As %DynamicObject
{
    set filter = {}
    set filter.name="Categories"
    set filter.options=[]
    s categories=##class(BeI.Category).GetAllCategories(),key=""
    s cat = categories.GetNext(.key)
    while key'="" {
        s catFilter={}
        s catFilter.name=cat.Name
        s catFilter.bitPosition=cat.BitStringPosition
        d filter.options.%Push(catFilter)
        s cat = categories.GetNext(.key)
    }
    return filter
}

}
