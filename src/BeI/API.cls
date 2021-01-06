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
    s resultObj.filters=##class(BeI.API).AttributeFilters(resultObj.filters)
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
        s catFilter.value=cat.%Id()
        s catFilter.bitPosition=cat.BitStringPosition
        d filter.options.%Push(catFilter)
        s cat = categories.GetNext(.key)
    }
    return filter
}

ClassMethod AttributeFilters(filters As %DynamicArray) As %DynamicArray
{
    s attributes = ##class(BeI.Attribute).GetAttributes(),key=""
    s attr = attributes.GetNext(.key)
    while key'="" {
        s filter={}
        s filter.name=attr.Name
        s filter.options=[]
        s values=attr.GetValues(),valKey=""
        s val=values.GetNext(.valKey)
        while valKey'="" {
            s option={}
            s option.name=val.Name
            s option.value=val.Value
            s option.bitPosition=val.BitStringPosition
            d filter.options.%Push(option)
            s val=values.GetNext(.valKey)
        }
        d filters.%Push(filter)
        s attr = attributes.GetNext(.key)
    }
    return filters
}

}
