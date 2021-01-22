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
                set map(optionsValue."bit_position")=$lb(key,optionsKey)
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
            // end: building normal filter bitstring            
            if foundOne,foundOne '= countOptions { 
                //bijhouden welke filters getest moeten worden
                merge todo = foundOne
                set todo = todo + 1
            }
        }
        set tests = 0
        set fKey = $ORDER(todo(""))
        while fKey '= "" {
            set testBitstring = bitstring
            set oKey = $ORDER(todo(fKey,""),1,pos)
            while oKey '= "" {
                set $BIT(testBitstring,pos)=0
                set oKey = $ORDER(todo(fKey,oKey),1,pos)
            }
            set oKey = $ORDER(todo(fKey,""),1,pos)
            while oKey '= "" {
                set newBitstring = testBitstring
                set $BIT(newBitstring,pos)=1
                set tests(fKey,oKey)=newBitstring
                set oKey = $ORDER(todo(fKey,oKey),1,pos)
            }
            set fKey = $ORDER(todo(fKey))
        }
            
    }
    if (todo) || (searchTerm '= "") {
        set index = $ORDER(^INDEX("SORTORDER","ID",""),1,value)
        while index '= "" {
            set testName = $LIST(value,2), testBitstring = $LIST(value,1)
            if ##class(BeI.API).TestFilter(bitstring,testBitstring) {
                if (searchTerm = "") || (testName [ searchTerm)  {
                    for i=1:1:len {
                        set counts(i) = $GET(counts(i)) + $BIT(testBitstring,i)
                    }
               }
            }
            else {
                set fKey = $ORDER(tests(""))
                while fKey '= "" {
                    set oKey = $ORDER(tests(fKey,""),1,value)
                    while oKey '= "" {
                        if ##class(BeI.API).TestFilter(value,testBitstring) {
                            if (searchTerm = "") || (testName [ searchTerm)  {
                                set idx = filterObj.filters.%Get(fKey).options.%Get(oKey)."bit_position"
                                set counts(idx)=$GET(counts(idx)) + 1
                            }
                        }
                        set oKey = $ORDER(tests(fKey,oKey),1,value)
                    }
                    set fKey = $ORDER(tests(fKey))
                }
            }
            set index = $ORDER(^INDEX("SORTORDER","ID",index),1,value)
        }

        for i=1:1:len {
            set mapping = map(i)
            set xfilter = filterObj.filters.%Get($LIST(mapping,1))
            set xoption = xfilter.options.%Get($LIST(mapping,2))
            set filterCounts(xfilter.id)=xfilter.name
            set filterCounts(xfilter.id,xoption.id)=$LISTBUILD($GET(counts(i),0),xoption.name)
        }
    
        set counters.filters2 =[]
        set filterId = $ORDER(filterCounts(""),1,filterName)
        while filterId '= "" {
            set optionId = $ORDER(filterCounts(filterId,""),1,filterVal)
            while optionId '= "" {
                set option = {}
                set option.id = optionId
                set option.count=$LIST(filterVal,1)
                do counters.filters2.%Push(option)
                set optionId = $ORDER(filterCounts(filterId,optionId),1,filterVal)
            }
            set filterId = $ORDER(filterCounts(filterId),1,filterName)
        }
    }
    else {
        set counters.filters2 = xCounts
    }
    set counters.requestId = requestId
    set counters.searchTerm = searchTerm
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
