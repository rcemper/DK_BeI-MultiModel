Class BeI.API Extends %CSP.REST
{

XData UrlMap
{
<Routes>
    <Route Url="/filters" Method="GET" Call="Filters" Cors="false" />
</Routes>
}

ClassMethod Filters(CategoryId As %Integer) As %Status
{
    set resultObj = {}
    set start=$ZH

    set resultObj.Time=$ZH - start
    w resultObj.%ToJSON()
    return $$$OK
}

}
