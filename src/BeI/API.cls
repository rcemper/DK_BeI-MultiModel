Class BeI.API Extends %CSP.REST
{

Parameter CONTENTTYPE = "application/json";

XData UrlMap
{
<Routes>
    <Route Url="/filters" Method="GET" Call="Filters" Cors="true" />
    <Route Url="/sorts" Method="GET" Call="Sorts" Cors="true" />
    <Route Url="/filters/:category" Method="GET" Call="Filters" Cors="true" />
    <Route Url="/products" Method="POST" Call="Products" Cors="true" />
    <Route Url="/counts" Method="POST" Call="Counts" Cors="true" />
</Routes>
}

ClassMethod Filters(category As %Integer = "") As %Status
{
    set resultObj = {}
    set resultObj.filters = []
    set start = $ZH 
    do resultObj.filters.%Push(##class(BeI.API).CategoryFilter())
    set resultObj.filters = ##class(BeI.API).AttributeFilters(resultObj.filters,category)
    set resultObj.time = $ZH - start
    write resultObj.%ToJSON()
    return $$$OK
}

ClassMethod Sorts() As %Status
{
    set sorts = ##class(BeI.SortOrder).GetAllSortOrdersDynamic()
    w sorts.%ToJSON()
    return $$$OK
}

ClassMethod CategoryFilter() As %DynamicObject
{
    set filter = {}
    set filter.name = "Categories"
    set filter.id = -1
    set filter.options = []
    set categories = ##class(BeI.Category).GetAllCategories(),key=""
    set cat = categories.GetNext(.key)
    set i=0
    while key '= "" {
        set i=i+1
        set catFilter = {}
        set catFilter.id = -1*i
        set catFilter.name = cat.Name
        set catFilter.value = cat.%Id()
        set catFilter."product_count" = cat.ProductCount()
        set catFilter."bit_position" = cat.BitStringPosition
        d catFilter.%Set("checked",1,"boolean")
        do filter.options.%Push(catFilter)
        set cat = categories.GetNext(.key)
    }
    return filter
}

ClassMethod AttributeFilters(filters As %DynamicArray, category As %Integer = "") As %DynamicArray
{
    if (category = "") {
        set attributes = ##class(BeI.Attribute).GetAttributes()
    } else {
        set oCategory = ##class(BeI.Category).%OpenId(category)
        if oCategory {
            set attributes = oCategory.Attributes
        }
    }
    set key = ""
    set attr = attributes.GetNext(.key)
    while key '= "" {
        set filter = {}
        set filter.name = attr.Name
        set filter.id = attr.%Id()
        set filter.options = []
        set values = attr.GetValues(),valKey = ""
        set val = values.GetNext(.valKey)
        while valKey '= "" {
            set option = {}
            set option.name = val.Name
            set option.id = val.%Id()
            set option.value = val.Value
            set option."product_count" = val.ProductCount
            set option."bit_position" = val.BitStringPosition
            d option.%Set("checked",0,"boolean")
            do filter.options.%Push(option)
            set val = values.GetNext(.valKey)
        }
        do filters.%Push(filter)
        set attr = attributes.GetNext(.key)
    }
    return filters
}

ClassMethod ProductsBackup() As %Status
{
    set start = $zh
    set result = {}
    set result.products = []
    set filter = ##class(BeI.API).GetFilter()
    set result.filter = ##class(BeI.Utils).ShowBitstring(filter.bitstring)
    set count = 0,hasNext = 0
    set index = $ORDER(^INDEX("SORTORDER",$ZCONVERT(filter.sort.field,"U"),filter.pageDirection.id),filter.sort.direction*filter.pageDirection.direction,value)
    while count < (filter.pageSize + 1),index '= "" {
        if ##class(BeI.API).TestFilter(filter.bitstring,value) {
            set oProd=##class(BeI.API).GetProductFromIndex(index)
            if oProd,($ZCONVERT(oProd.Name,"U") [ $ZCONVERT(filter.searchTerm,"U")) || (filter.searchTerm = "") {
                if count < filter.pageSize { 
                    if filter.pageDirection.direction > 0 {
                        do result.products.%Push(oProd.GetDynamicProduct(index))
                    }
                    else {
                        do result.products.%Set(filter.pageSize-count-1,oProd.GetDynamicProduct(index))
                    }
                }
                set count = count + 1
                if count > filter.pageSize { set hasNext = 1 }
            }
        }
        set index = $ORDER(^INDEX("SORTORDER",$ZCONVERT(filter.sort.field,"U"),index),filter.sort.direction*filter.pageDirection.direction,value)
    }
    do result.%Set("hasNext",hasNext,"boolean")
    set result.time = $zh - start
    write result.%ToJSON()
    return $$$OK
}

ClassMethod GetFilter() As %DynamicObject [ PublicList = %request ]
{
    set filter = {},bitstring = ""
    set filter.searchTerm = ""
    set filter.pageSize = 5
    set filter.curPage = 1
    set filter.lastId = ""
    set filter.requestId = ""
    set filter.sort = {"field": "id","direction":1 }
    set len = ##class(BeI.Agent).GetLastBitstringPosition()
    for i = 1:1:len {
        set $BIT(bitstring, i) = 1
    }
    if %request.Content {
        set filterObj = {}.%FromJSON(%request.Content)
        if filterObj.searchTerm '= "" { set filter.searchTerm = $ZCONVERT(filterObj.searchTerm,"U") }
        if filterObj.pageSize '= "" { set filter.pageSize = filterObj.pageSize }
        if filterObj.pageDirection '= "" { set filter.pageDirection = filterObj.pageDirection }
        if filterObj.sort '= "" { set filter.sort = filterObj.sort }
        if filterObj.curPage '= "" { set filter.curPage = filterObj.curPage }
        if filterObj.requestId '= "" { set filter.requestId = filterObj.requestId }
        set filterIter = filterObj.filters.%GetIterator()
        while filterIter.%GetNext(.key,.filtervalue) {
            set optionsIter = filtervalue.options.%GetIterator()
            s foundOne=0
            while 'foundOne && optionsIter.%GetNext(.optionsKey,.optionsValue){
                if optionsValue.checked {
                    s foundOne=1
                }
            }
            if foundOne {
                set optionsIter = filtervalue.options.%GetIterator()
                while optionsIter.%GetNext(.optionsKey,.optionsValue){
                    if optionsValue.checked = 0 {
                        set $BIT(bitstring,optionsValue."bit_position") = 0
                    }
                }
            }
        }
    }
    set filter.bitstring = bitstring
    return filter
}

ClassMethod TestFilter(filter As %String, value As %String, debug = 0) As %Boolean
{
    set match = 0
    ;i debug { w ##class(BeI.Utils).ShowBitstring(value),!,##class(BeI.Utils).ShowBitstring(filter),! }
    set test = $bitlogic(filter&value)
    ;i debug { w ##class(BeI.Utils).ShowBitstring(test),! }
    set match = '$BITCOUNT($bitlogic(test^value),1)
    return match
}

ClassMethod GetProductFromIndex(index As %String) As BeI.Product
{
    set result = $$$NULLOREF
    set id = +$e(index,*-7,*)
    if id '= "" { set result = ##class(BeI.Product).%OpenId(id).GetDynamicProduct(index) }
    return result
}

ClassMethod Counts() As %Status
{
    set result = $$$OK
    set bitstring = ""
    set searchTerm = ""
    set requestId = 0
    set counters = {}
    set xCounts = []
    set start = $zh
    set len = ##class(BeI.Agent).GetLastBitstringPosition()
    for i = 1:1:len {
        set $BIT(bitstring, i) = 1
    }
    set todo = 0
    s todo2 =0
    if %request.Content {
        set filterObj = {}.%FromJSON(%request.Content)
        set requestId = filterObj.requestId
        set searchTerm = $ZCONVERT(filterObj.searchTerm,"U")
        set filterIter = filterObj.filters.%GetIterator()
        while filterIter.%GetNext(.key,.filtervalue) {
            set optionsIter = filtervalue.options.%GetIterator()
            set positions = "" , pos = 1, optionKeys = ""
            k foundOne
            s foundOne=0,countOptions=0
            while optionsIter.%GetNext(.optionsKey,.optionsValue){
                set map(optionsValue."bit_position")=$lb(key,optionsValue.id)
                set xopt = {}
                set xopt.id = optionsValue.id
                set xopt.count=optionsValue."product_count"
                d xCounts.%Push(xopt)
                if optionsValue.checked {
                    s foundOne=foundOne + 1
                }
                s countOptions = countOptions + 1
                set foundOne(key,optionsKey) = optionsValue."bit_position"
            }
            // building the normal filter bitstring
            set optionsIter = filtervalue.options.%GetIterator()
            while optionsIter.%GetNext(.optionsKey,.optionsValue) {               
                if foundOne {
                    if optionsValue.checked = 0 {
                        set $BIT(bitstring,optionsValue."bit_position") = 0
                    }
                }
            }
            if foundOne,foundOne '= countOptions { 
                //bijhouden of filters getest moeten worden
                set todo = todo + 1
            }
            merge todo2 = foundOne
            set todo2 = todo2 + 1
        }

        set tests2 = 0
        set fKey = $ORDER(todo2(""))
        while fKey '= "" {
            set testBitstring = bitstring
            set oKey = $ORDER(todo2(fKey,""),1,pos)
            while oKey '= "" {
                set $BIT(testBitstring,pos)=1
                set oKey = $ORDER(todo2(fKey,oKey),1,pos)
            }
            set tests2(fKey)=testBitstring
            set fKey = $ORDER(todo2(fKey))
        }
            
    }
    if todo || (searchTerm '= ""){
        set index = $ORDER(^INDEX("SORTORDER","ID",""),1,value)
        while index '= "" {
            set fKey = $ORDER(tests2(""))
            while fKey '= "" {     
                set testName = $LIST(value,2), testBitstring = $LIST(value,1)
                if ##class(BeI.API).TestFilter(bitstring,testBitstring) {
                    if (searchTerm = "") || (testName [ searchTerm)  {
                        set oKey = $ORDER(todo2(fKey,""),1,pos)
                        while oKey '= "" {
                            set counts(pos) = $GET(counts(pos)) + $BIT(testBitstring,pos)
                            set oKey = $ORDER(todo2(fKey,oKey),1,pos)
                        }
                    }
                }
                set fKey = $ORDER(tests2(fKey))
            }      
            set index = $ORDER(^INDEX("SORTORDER","ID",index),1,value)
        }
    
        set counters.filters2 =[]
        s i=$ORDER(counts(""),1,count)
        while i'="" {
            set option = {}
            set option.id = $LIST(map(i),2)
            set option.count=count
            do counters.filters2.%Push(option)

            s i=$ORDER(counts(i),1,count)
        }
    }
    else {
        set counters.filters2 = xCounts
    }
    set counters.requestId = requestId
    set counters.time = $zh - start
    write counters.%ToJSON()
    return result
}

ClassMethod Products() As %Status
{
    set start = $zh
    set result = {}
    set result.products = []
    set filter = ##class(BeI.API).GetFilter()
    set result.filter = ##class(BeI.Utils).ShowBitstring(filter.bitstring)
    set count = 0
    set sortField=$ZCONVERT(filter.sort.field,"U")
    set index = $ORDER(^INDEX("SORTORDER",sortField,""),1,value)
    while index '= "" {
        set testName = $LIST(value,2), testBitstring = $LIST(value,1),bitcount = $BITCOUNT(testBitstring)
        if ##class(BeI.API).TestFilter(filter.bitstring,testBitstring) {
            if (filter.searchTerm = "") || (testName [ filter.searchTerm)  {
                if count > (filter.pageSize * (filter.curPage-1)),count<=(filter.pageSize * (filter.curPage)) {
                    set oProd=##class(BeI.API).GetProductFromIndex(index) 
                    do result.products.%Push(oProd)
                } 
                set count = count + 1
           }
        }
        set index = $ORDER(^INDEX("SORTORDER",sortField,index),1,value)
    }
    set result.totalCount = count
    set result.requestId = filter.requestId
    set result.time = $zh - start
    write result.%ToJSON()
    return $$$OK
}

}
