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
            if (prod.BitString = "") || ($BITCOUNT(prod.BitString) '= ##class(BeI.Agent).GetLastBitstringPosition()) {
                do prod.SetBitstring()
            }
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

ClassMethod BuildIndices() As %Status
{
    &SQL(DECLARE prodlist CURSOR FOR SELECT id into:id FROM BeI.Product)
    &SQL(OPEN prodlist)
    while 'SQLCODE {
        &SQL(FETCH prodlist)
        if 'SQLCODE,id '="" {
            set prod = ##class(BeI.Product).%OpenId(id)
            set idIndex = prod.%Id()
            set priceIndex = ($j(prod.Price,0,2) * 10000000000) + prod.%Id()
            set nameIndex = prod.Name_$EXTRACT(100000000 + prod.%Id(),2,*)
        
            set ^INDEX("SORTORDER","ID",idIndex) = prod.BitString
            set ^INDEX("SORTORDER","PRICE",priceIndex) = prod.BitString
            set ^INDEX("SORTORDER","NAME",nameIndex) = prod.BitString
        }
    }
    &SQL(CLOSE prodlist)
    return $$$OK
}

}
