Class BeI.API Extends %CSP.REST
{

Parameter CONTENTTYPE = "application/json";

XData UrlMap
{
<Routes>
    <Route Url="/filters" Method="GET" Call="Filters" Cors="false" />
    <Route Url="/products/:sort/:pageSize/:lastId/:searchTerm" Method="POST" Call="Products" Cors="false" />
    <Route Url="/products/:sort/:pageSize/:lastId" Method="POST" Call="Products" Cors="false" />
</Routes>
}

ClassMethod Filters() As %Status
{
    set resultObj = {}
    set resultObj.filters = []
    set start = $ZH 
    do resultObj.filters.%Push(##class(BeI.API).CategoryFilter())
    set resultObj.filters = ##class(BeI.API).AttributeFilters(resultObj.filters)
    set resultObj.time = $ZH - start
    write resultObj.%ToJSON()
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

ClassMethod Products(sort As %String, pageSize As %Integer, lastId As %String, searchTerm As %String = "") As %Status
{
    set result = []
    set filter = ##class(BeI.API).GetFilter()
    set count = 0
    set index = $ORDER(^INDEX("SORTORDER",$ZCONVERT(sort,"U"),lastId),1,value)
    while count < pageSize,index '= "" {
        ;w !,index
        if ##class(BeI.API).TestFilter(filter,value) {
            set oProd=##class(BeI.API).GetProductFromIndex(index)
            if (oProd.Name [ searchTerm) || (searchTerm = "") {
                do result.%Push(oProd.GetDynamicProduct())
                set count = count + 1
            }
        }
        set index = $ORDER(^INDEX("SORTORDER",$ZCONVERT(sort,"U"),index),1,value)
    }
    write result.%ToJSON()
    return $$$OK
}

ClassMethod GetFilter() As %String [ PublicList = %request ]
{
    set filter = ""
    set len = ##class(BeI.Agent).GetLastBitstringPosition()
    for i = 1:1:len {
        set $BIT(filter, i) = 1
    }
    if %request.Content {
        set filterObj = {}.%FromJSON(%request.Content)
        ;write filterObj.%ToJSON()
        set filterIter = filterObj.filters.%GetIterator()
        while filterIter.%GetNext(.key,.filtervalue) {
            set optionsIter = filtervalue.options.%GetIterator()
            while optionsIter.%GetNext(.optionsKey,.optionsValue){
                if optionsValue.checked = 0 {
                    set $BIT(filter,optionsValue.bitPosition) = 0
                }
            }
        }
    }
    ;write !,##class(BeI.Utils).ShowBitstring(filter),!
    return filter
}

ClassMethod TestFilter(filter As %String, value As %String) As %Boolean
{
    set match = 0
    set test = $bitlogic(filter&value)
    set match = (value = test)
    return match
}

ClassMethod GetProductFromIndex(index As %String) As BeI.Product
{
    set result = $$$NULLOREF
    set id = +$e(index,*-6,*)
    w !,index,*9,id,!
    if id '= "" { set result = ##class(BeI.Product).%OpenId(id) }
    return result
}

}
