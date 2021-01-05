Class BeI.Utils Extends %RegisteredObject
{

ClassMethod ResetDB() As %Status
{
    k ^BeI.AttributeValueD
    k ^BeI.AttributeValueI
    k ^BeI.AttributeD
    k ^BeI.AttributeI
    k ^BeI.CategoryD
    k ^BeI.CategoryI
    k ^BeI.ProductD
    k ^BeI.ProductI
    return $$$OK
}

ClassMethod BuildFirstTestSet(size As %Integer = 100) As %Status
{
        set ok = $$$OK
        w "Resetting DB",!
        s start=$zh
        d ##class(BeI.Utils).ResetDB()
        w "DB reset done in: ",$zh-start,!
        w "Populating categories",!
        s start=$zh
        // populate categories
        s catTV = ##class(BeI.Utils).NewCategory("TV") 
        s catLaptop = ##class(BeI.Utils).NewCategory("Laptop") 
        s catTablet = ##class(BeI.Utils).NewCategory("Tablet") 
        w "Categories populated in: ",$zh-start,!
        w "Populating Attributes",!
        s start=$zh
        // populate attributes
        s attrEnergyClass = ##class(BeI.Utils).NewAttribute("Energy class")
        s attrScreensize = ##class(BeI.Utils).NewAttribute("Screen size")
        s attrCPU = ##class(BeI.Utils).NewAttribute("CPU")
        w "Attributes populated in: ",$zh-start,!
        w "Adding Attributes to categories",!
        s start=$zh
        // add attributes to categories 
        d catTV.Attributes.SetAt(attrEnergyClass,0)
        d catTV.Attributes.SetAt(attrScreensize,1)
        d catTV.%Save()
        d catLaptop.Attributes.SetAt(attrEnergyClass,0)
        d catLaptop.Attributes.SetAt(attrScreensize,1)
        d catLaptop.Attributes.SetAt(attrCPU,2)
        d catLaptop.%Save()        
        d catTablet.Attributes.SetAt(attrEnergyClass,0)
        d catTablet.Attributes.SetAt(attrScreensize,1)
        d catTablet.Attributes.SetAt(attrCPU,2)
        d catTablet.%Save()
        w "Attributes linked to categories in: ",$zh-start,!
        w "Populating attribute values",!
        s start=$zh
        // Populate attribute values
        s x = ##class(BeI.AttributeValue).%New()
        s x.Attribute = attrEnergyClass
        s x.Name = "A++"
        s x.Value = 1
        d x.%Save()
        s x = ##class(BeI.AttributeValue).%New()
        s x.Attribute = attrEnergyClass
        s x.Name = "A+"
        s x.Value = 2
        d x.%Save()
        s x = ##class(BeI.AttributeValue).%New()
        s x.Attribute = attrEnergyClass
        s x.Name = "A"
        s x.Value = 3
        d x.%Save()
        s x = ##class(BeI.AttributeValue).%New()
        s x.Attribute = attrEnergyClass
        s x.Name = "B"
        s x.Value = 4
        d x.%Save()
        s x = ##class(BeI.AttributeValue).%New()
        s x.Attribute = attrScreensize
        s x.Name = "8 inch"
        s x.Value = 1
        d x.%Save()
        s x = ##class(BeI.AttributeValue).%New()
        s x.Attribute = attrScreensize
        s x.Name = "10 inch"
        s x.Value = 2
        d x.%Save()
        s x = ##class(BeI.AttributeValue).%New()
        s x.Attribute = attrScreensize
        s x.Name = "12 inch"
        s x.Value = 3
        d x.%Save()
        s x = ##class(BeI.AttributeValue).%New()
        s x.Attribute = attrScreensize
        s x.Name = "14 inch"
        s x.Value = 4
        d x.%Save()
        s x = ##class(BeI.AttributeValue).%New()
        s x.Attribute = attrScreensize
        s x.Name = "15 inch"
        s x.Value = 5
        d x.%Save()
        s x = ##class(BeI.AttributeValue).%New()
        s x.Attribute = attrScreensize
        s x.Name = "17 inch"
        s x.Value = 6
        d x.%Save()
        s x = ##class(BeI.AttributeValue).%New()
        s x.Attribute = attrScreensize
        s x.Name = "28 inch"
        s x.Value = 7
        d x.%Save()
        s x = ##class(BeI.AttributeValue).%New()
        s x.Attribute = attrScreensize
        s x.Name = "32 inch"
        s x.Value = 8
        d x.%Save()
        s x = ##class(BeI.AttributeValue).%New()
        s x.Attribute = attrScreensize
        s x.Name = "34 inch"
        s x.Value = 9
        d x.%Save()
        s x = ##class(BeI.AttributeValue).%New()
        s x.Attribute = attrScreensize
        s x.Name = "55 inch"
        s x.Value = 10
        d x.%Save()
        s x = ##class(BeI.AttributeValue).%New()
        s x.Attribute = attrCPU
        s x.Name = "Intel I3"
        s x.Value = 1
        d x.%Save()
        s x = ##class(BeI.AttributeValue).%New()
        s x.Attribute = attrCPU
        s x.Name = "Intel I5"
        s x.Value = 2
        d x.%Save()
        s x = ##class(BeI.AttributeValue).%New()
        s x.Attribute = attrCPU
        s x.Name = "Intel I7"
        s x.Value = 3
        d x.%Save()
        s x = ##class(BeI.AttributeValue).%New()
        s x.Attribute = attrCPU
        s x.Name = "AMD Ryzen"
        s x.Value = 4
        d x.%Save()
        s x = ##class(BeI.AttributeValue).%New()
        s x.Attribute = attrCPU
        s x.Name = "Snapdragon"
        s x.Value = 5
        d x.%Save()
        w "Attribute values populated in: ",$zh-start,!
        w "Populating products",!
        s start=$zh
        // populate products
        d ##class(BeI.Product).Populate(size)
        for i=1:1:100 {
            s oref=##class(BeI.Product).%OpenId(i)
            i oref {
                s oref.Attributes=oref.PopulateAttributes()
                d oref.%Save(0)
            }
        }
        w "products populated in: ",$zh-start,!
        w "running Agent",!
        s start=$zh
        // Run the agent
        d ##class(BeI.Agent).Run()
        w "Agent ran for: ",$zh-start,!
        // return overal status
        return ok
}

ClassMethod NewCategory(Name As %String) As BeI.Category
{
   
    s cat=##class(BeI.Category).%New()
    s cat.Name=Name
    d cat.%Save()
    return cat
}

ClassMethod NewAttribute(Name As %String) As BeI.Attribute
{
    s attr = ##class(BeI.Attribute).%New()
    s attr.Name = Name
    d attr.%Save()
    return attr
}

ClassMethod ShowBitstring(bs) As %String
{
    s result=""
    for i=1:1:$BITCOUNT(bs) { s result=result_$bit(bs, i) }
    return result
}

}
