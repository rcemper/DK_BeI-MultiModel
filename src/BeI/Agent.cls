Class BeI.Agent Extends %RegisteredObject
{

ClassMethod GetLastBitstringPosition() As %Numeric
{
    return $g(^BeILastBitstringPosition,0)
}

ClassMethod GetNextBitStringPosition() As %Numeric
{
    s next = 1
    lock +^BeILastBitstringPosition
    s next= ##class(BeI.Agent).GetLastBitstringPosition()+1
    s ^BeILastBitstringPosition=next
    lock -^BeILastBitstringPosition
    return next
}

ClassMethod Run() As %Status
{
    set ok = $$$OK
    w *9,"Agent: Categories",!
    s start=$zh
    d ##class(BeI.Agent).AddCategories()
    w *9,"Agent: Categories finished in: ",$zh-start,!
    w *9,"Agent: Attribute values",!
    s start=$zh
    d ##class(BeI.Agent).AddAttributeValues()
    w *9,"Agent: Attribute values finished in: ",$zh-start,!
    w *9,"Agent: Products",!
    s start=$zh
    d ##class(BeI.Agent).AddProducts(.attrValueCount)
    w *9,"Agent: Products finished in: ",$zh-start,!
    w *9,"Agent: Counts",!
    s start=$zh
    d ##class(BeI.Agent).AddCountsToAttributeValues(.attrValueCount)
    w *9,"Agent: Counts finished in: ",$zh-start,!
    w *9,"Agent: Indices",!
    s start=$zh
    d ##class(BeI.Agent).BuildIndices()
    w *9,"Agent: Indices finished in: ",$zh-start,!
    return ok
}

ClassMethod AddCategories() As %Status
{
    set ok = $$$OK
    s cat=##class(BeI.Category).CategoriesWithoutPosition()
    for i = 0:1:cat.Count()-1 {
        s currentCat=cat.GetAt(i)
        s currentCat.BitStringPosition=##class(BeI.Agent).GetNextBitStringPosition()
        d currentCat.%Save(0)
    }
    return ok
}

ClassMethod AddAttributeValues() As %Status
{
    s attrValues = ##class(BeI.AttributeValue).AttributeValuesWithoutPosition()
    for i = 0:1:attrValues.Count()-1 {
        s currentAttrVal=attrValues.GetAt(i)
        s currentAttrVal.BitStringPosition=##class(BeI.Agent).GetNextBitStringPosition()
        d currentAttrVal.%Save(0)
    }
    return $$$OK
}

ClassMethod AddProducts(ByRef AttrValueCount) As %Status
{
    set ok = $$$OK
    k AttrValueCount
    s products = ##class(BeI.Product).GetAllProducts(),key=""
    s prod = products.GetNext(.key)
    while key'="" {
        d prod.SetBitstring()
        s attr = prod.Attributes.GetNext(.attrKey)
        while attrKey'="" { 
            s AttrValueCount(attr.%Id())=$g(AttrValueCount(attr.%Id()))+1
            s attr = prod.Attributes.GetNext(.attrKey)
        }
        s prod = products.GetNext(.key)
    }
    return ok
}

ClassMethod AddCountsToAttributeValues(ByRef AttrValueCount)
{
    s id=$o(AttrValueCount(""),1,value)
    while id'="" {
        s obj=##class(BeI.AttributeValue).%OpenId(id)
        i obj {
            s obj.ProductCount=value
            d obj.%Save(0)
        }
        s id=$o(AttrValueCount(id),1,value)
    }
}

ClassMethod BuildIndices() As %Status
{
  
    s products = ##class(BeI.Product).GetAllProducts(),key=""
    s prod = products.GetNext(.key)
    while key'="" {
        s idIndex=prod.%Id()
        s priceIndex=(prod.Price*10000000)+prod.%Id()
        s nameIndex = prod.Name_$EXTRACT(10000000+prod.%Id(),2,*)
        
        s ^INDEX("SORTORDER","ID",idIndex)=prod.BitString
        s ^INDEX("SORTORDER","PRICE",priceIndex)=prod.BitString
        s ^INDEX("SORTORDER","NAME",nameIndex)=prod.BitString

        s prod = products.GetNext(.key)
    }
    return $$$OK
}

}
