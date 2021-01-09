Class BeI.API Extends %CSP.REST
{

Parameter CONTENTTYPE = "application/json";

XData UrlMap
{
<Routes>
    <Route Url="/filters" Method="GET" Call="Filters" Cors="false" />
    <Route Url="/products/:sort/:pageSize/:lastId/:searchTerm" Method="POST" Call="Products" Cors="false" />
    <Route Url="/products/:sort/:pageSize/:lastId" Method="POST" Call="Products" Cors="false" />    
    <Route Url="/products/:sort/:pageSize" Method="POST" Call="Products" Cors="false" />
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
    set attributes = ##class(BeI.Attribute).GetAttributes(),key = ""
    set attr = attributes.GetNext(.key)
    while key '= "" {
        set filter = {}
        set filter.name = attr.Name
        set filter.options = []
        set values = attr.GetValues(),valKey = ""
        set val = values.GetNext(.valKey)
        while valKey '= "" {
            set option = {}
            set option.name = val.Name
            set option.value = val.Value
            set option.bitPosition = val.BitStringPosition
            do filter.options.%Push(option)
            set val = values.GetNext(.valKey)
        }
        do filters.%Push(filter)
        set attr = attributes.GetNext(.key)
    }
    return filters
}

ClassMethod Products(sort As %String, pageSize As %Integer, lastId As %String = "", searchTerm As %String = "") As %Status
{
    set start = $zh
    set result = {}
    set result.products = []
    set filter = ##class(BeI.API).GetFilter()
    set result.filter = ##class(BeI.Utils).ShowBitstring(filter)
    set count = 0,lastIndex = ""
    set index = $ORDER(^INDEX("SORTORDER",$ZCONVERT(sort,"U"),lastId),1,value)
    while count < pageSize,index '= "" {
        if ##class(BeI.API).TestFilter(filter,value) {
            set oProd=##class(BeI.API).GetProductFromIndex(index)
            if oProd,(oProd.Name [ searchTerm) || (searchTerm = "") {
                do result.products.%Push(oProd.GetDynamicProduct())
                set count = count + 1,lastIndex = index
            }
        }
        set index = $ORDER(^INDEX("SORTORDER",$ZCONVERT(sort,"U"),index),1,value)
    }
    set result.lastId = lastIndex
    set result.time = $zh - start
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
    return filter
}

ClassMethod TestFilter(filter As %String, value As %String, debug = 0) As %Boolean
{
    set match = 0
    ;i debug { w ##class(BeI.Utils).ShowBitstring(value),!,##class(BeI.Utils).ShowBitstring(filter),! }
    set test = $bitlogic(filter&value)
    ;i debug { w ##class(BeI.Utils).ShowBitstring(test),! }
    set match = (value = test)
    return match
}

ClassMethod GetProductFromIndex(index As %String) As BeI.Product
{
    set result = $$$NULLOREF
    set id = +$e(index,*-7,*)
    if id '= "" { set result = ##class(BeI.Product).%OpenId(id) }
    return result
}

}
