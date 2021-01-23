Class BeI.Agent Extends %RegisteredObject
{

ClassMethod GetLastBitstringPosition() As %Numeric
{
    return $g(^BeILastBitstringPosition,0)
}

ClassMethod GetNextBitStringPosition() As %Numeric
{
    set next = 1
    lock +^BeILastBitstringPosition
    set next = ##class(BeI.Agent).GetLastBitstringPosition() + 1
    set ^BeILastBitstringPosition = next
    lock -^BeILastBitstringPosition
    return next
}

ClassMethod Run() As %Status
{
    set ok = $$$OK
    write *9,"Agent: Categories",!
    set start = $zh
    do ##class(BeI.Agent).AddCategories()
    write *9,"Agent: Categories finished in: ",$zh-start,!
    write *9,"Agent: Attribute values",!
    set start = $zh
    do ##class(BeI.Agent).AddAttributeValues()
    write *9,"Agent: Attribute values finished in: ",$zh-start,!
    write *9,"Agent: Products",!
    set start = $zh
    do ##class(BeI.Agent).AddProducts(.attrValueCount)
    write *9,"Agent: Products finished in: ",$zh-start,!
    write *9,"Agent: ProductsFilter",!
    set start = $zh
    do ##class(BeI.Agent).AddProducFilterBitstrings()
    write *9,"Agent: ProductsFilter finished in: ",$zh-start,!
    write *9,"Agent: Counts",!
    set start = $zh
    do ##class(BeI.Agent).AddCountsToAttributeValues(.attrValueCount)
    write *9,"Agent: Counts finished in: ",$zh-start,!
    write *9,"Agent: Indices",!
    set start = $zh
    do ##class(BeI.Agent).BuildIndices()
    write *9,"Agent: Indices finished in: ",$zh-start,!
    return ok
}

ClassMethod AddCategories() As %Status
{
    set ok = $$$OK
    set cat = ##class(BeI.Category).CategoriesWithoutPosition()
    for i = 0:1:cat.Count()-1 {
        set currentCat = cat.GetAt(i)
        set currentCat.BitStringPosition = ##class(BeI.Agent).GetNextBitStringPosition()
        do currentCat.%Save(0)
    }
    return ok
}

ClassMethod AddAttributeValues() As %Status
{
    set attrValues = ##class(BeI.AttributeValue).AttributeValuesWithoutPosition()
    for i = 0:1:attrValues.Count()-1 {
        set currentAttrVal = attrValues.GetAt(i)
        set currentAttrVal.BitStringPosition = ##class(BeI.Agent).GetNextBitStringPosition()
        do currentAttrVal.%Save(0)
    }
    return $$$OK
}

ClassMethod AddProducts(ByRef AttrValueCount) As %Status
{
    set ok = $$$OK
    kill AttrValueCount
    &SQL(DECLARE products CURSOR FOR SELECT id into:id FROM BeI.Product)
    &SQL(OPEN products)
    while 'SQLCODE {
        &SQL(FETCH products)
        i 'SQLCODE,id '= "" {
            s prod = ##class(BeI.Product).%OpenId(id)
            do prod.SetBitstring()
            set attr = prod.Attributes.GetNext(.attrKey)
            while attrKey '= "" { 
                set AttrValueCount(attr.%Id()) = $g(AttrValueCount(attr.%Id())) + 1
                set attr = prod.Attributes.GetNext(.attrKey)
            }
        }
    }
    &SQL(CLOSE products)
    return ok
}

ClassMethod AddProducFilterBitstrings() As %Status
{
    &SQL(DECLARE bproducts CURSOR FOR SELECT id into:id FROM BeI.Product)
    &SQL(OPEN bproducts)
    while 'SQLCODE {
        &SQL(FETCH bproducts)
        i 'SQLCODE,id '= "" {
            s prod = ##class(BeI.Product).%OpenId(id)
            do prod.SetFilterBitstring()
            if id = 5290 { w ##class(BeI.Utils).ShowBitstring(prod.FilterBitString),!}
        }
    }
    &SQL(CLOSE bproducts)
    return $$$OK
}

ClassMethod AddCountsToAttributeValues(ByRef AttrValueCount)
{
    set id = $o(AttrValueCount(""),1,value)
    while id '= "" {
        set obj = ##class(BeI.AttributeValue).%OpenId(id)
        if obj {
            set obj.ProductCount = value
            do obj.%Save(0)
        }
        set id = $o(AttrValueCount(id),1,value)
    }
}

ClassMethod BuildIndices() As %Status [ PublicList = (prod, idx) ]
{
  
    s sorts = ##class(BeI.SortOrder).GetAllSortOrders()
    &SQL(DECLARE prodlist CURSOR FOR SELECT id into:id FROM BeI.Product)
    &SQL(OPEN prodlist)
    while 'SQLCODE {
        &SQL(FETCH prodlist)
        if 'SQLCODE,id '="" {
            set prod = ##class(BeI.Product).%OpenId(id), key = ""
            set order = sorts.GetNext(.key)
            while key'="" {
                set indir = ("idx="_order.IndexRule)
                set @indir
                set ^INDEX("SORTORDER",$zcvt(order.Field,"U"),idx) = $lb(prod.BitString,$ZCONVERT(prod.Name,"U"),prod.FilterBitString)
                set order = sorts.GetNext(.key)
            }
        }
    }
    &SQL(CLOSE prodlist)
    return $$$OK
}

}
