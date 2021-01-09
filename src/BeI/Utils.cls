Class BeI.Utils Extends %RegisteredObject
{

ClassMethod ResetDB() As %Status
{
    kill ^BeI.AttributeValueD
    kill ^BeI.AttributeValueI
    kill ^BeI.AttributeD
    kill ^BeI.AttributeI
    kill ^BeI.CategoryD
    kill ^BeI.CategoryI
    kill ^BeI.ProductD
    kill ^BeI.ProductI
    kill ^BeILastBitstringPosition
    kill ^INDEX
    return $$$OK
}

ClassMethod BuildFirstTestSet(size As %Integer = 100) As %Status
{
        set ok = $$$OK
        write "Resetting DB",!
        set start = $zh
        do ##class(BeI.Utils).ResetDB()
        write "DB reset done in: ",$zh-start,!
        write "Populating categories",!
        set start = $zh
        // populate categories
        set catTV = ##class(BeI.Utils).NewCategory("TV") 
        set catLaptop = ##class(BeI.Utils).NewCategory("Laptop") 
        set catTablet = ##class(BeI.Utils).NewCategory("Tablet") 
        write "Categories populated in: ",$zh-start,!
        write "Populating Attributes",!
        set start = $zh
        // populate attributes
        set attrEnergyClass = ##class(BeI.Utils).NewAttribute("Energy class")
        set attrScreensize = ##class(BeI.Utils).NewAttribute("Screen size")
        set attrCPU = ##class(BeI.Utils).NewAttribute("CPU")
        write "Attributes populated in: ",$zh-start,!
        write "Adding Attributes to categories",!
        set start = $zh
        // add attributes to categories 
        do catTV.Attributes.SetAt(attrEnergyClass,0)
        do catTV.Attributes.SetAt(attrScreensize,1)
        do catTV.%Save()
        do catLaptop.Attributes.SetAt(attrEnergyClass,0)
        do catLaptop.Attributes.SetAt(attrScreensize,1)
        do catLaptop.Attributes.SetAt(attrCPU,2)
        do catLaptop.%Save()        
        do catTablet.Attributes.SetAt(attrEnergyClass,0)
        do catTablet.Attributes.SetAt(attrScreensize,1)
        do catTablet.Attributes.SetAt(attrCPU,2)
        do catTablet.%Save()
        write "Attributes linked to categories in: ",$zh-start,!
        write "Populating attribute values",!
        set start = $zh
        // Populate attribute values
        set x = ##class(BeI.AttributeValue).%New()
        set x.Attribute = attrEnergyClass
        set x.Name = "A++"
        set x.Value = 1
        do x.%Save()
        set x = ##class(BeI.AttributeValue).%New()
        set x.Attribute = attrEnergyClass
        set x.Name = "A+"
        set x.Value = 2
        do x.%Save()
        set x = ##class(BeI.AttributeValue).%New()
        set x.Attribute = attrEnergyClass
        set x.Name = "A"
        set x.Value = 3
        do x.%Save()
        set x = ##class(BeI.AttributeValue).%New()
        set x.Attribute = attrEnergyClass
        set x.Name = "B"
        set x.Value = 4
        do x.%Save()
        set x = ##class(BeI.AttributeValue).%New()
        set x.Attribute = attrScreensize
        set x.Name = "8 inch"
        set x.Value = 1
        do x.%Save()
        set x = ##class(BeI.AttributeValue).%New()
        set x.Attribute = attrScreensize
        set x.Name = "10 inch"
        set x.Value = 2
        do x.%Save()
        set x = ##class(BeI.AttributeValue).%New()
        set x.Attribute = attrScreensize
        set x.Name = "12 inch"
        set x.Value = 3
        do x.%Save()
        set x = ##class(BeI.AttributeValue).%New()
        set x.Attribute = attrScreensize
        set x.Name = "14 inch"
        set x.Value = 4
        do x.%Save()
        set x = ##class(BeI.AttributeValue).%New()
        set x.Attribute = attrScreensize
        set x.Name = "15 inch"
        set x.Value = 5
        do x.%Save()
        set x = ##class(BeI.AttributeValue).%New()
        set x.Attribute = attrScreensize
        set x.Name = "17 inch"
        set x.Value = 6
        do x.%Save()
        set x = ##class(BeI.AttributeValue).%New()
        set x.Attribute = attrScreensize
        set x.Name = "28 inch"
        set x.Value = 7
        do x.%Save()
        set x = ##class(BeI.AttributeValue).%New()
        set x.Attribute = attrScreensize
        set x.Name = "32 inch"
        set x.Value = 8
        do x.%Save()
        set x = ##class(BeI.AttributeValue).%New()
        set x.Attribute = attrScreensize
        set x.Name = "34 inch"
        set x.Value = 9
        do x.%Save()
        set x = ##class(BeI.AttributeValue).%New()
        set x.Attribute = attrScreensize
        set x.Name = "55 inch"
        set x.Value = 10
        do x.%Save()
        set x = ##class(BeI.AttributeValue).%New()
        set x.Attribute = attrCPU
        set x.Name = "Intel I3"
        set x.Value = 1
        do x.%Save()
        set x = ##class(BeI.AttributeValue).%New()
        set x.Attribute = attrCPU
        set x.Name = "Intel I5"
        set x.Value = 2
        do x.%Save()
        set x = ##class(BeI.AttributeValue).%New()
        set x.Attribute = attrCPU
        set x.Name = "Intel I7"
        set x.Value = 3
        do x.%Save()
        set x = ##class(BeI.AttributeValue).%New()
        set x.Attribute = attrCPU
        set x.Name = "AMD Ryzen"
        set x.Value = 4
        do x.%Save()
        set x = ##class(BeI.AttributeValue).%New()
        set x.Attribute = attrCPU
        set x.Name = "Snapdragon"
        set x.Value = 5
        do x.%Save()
        write "Attribute values populated in: ",$zh-start,!
        write "Populating products",!
        set start = $zh
        // populate products
        do ##class(BeI.Product).Populate(size)
        for i=1:1:size {
            set oref = ##class(BeI.Product).%OpenId(i)
            if oref {
                set oref.Attributes = oref.PopulateAttributes()
                do oref.%Save(0)
            }
        }
        write "products populated in: ",$zh-start,!
        write "running Agent",!
        set start = $zh
        // Run the agent
        do ##class(BeI.Agent).Run()
        write "Agent ran for: ",$zh-start,!
        // return overal status
        return ok
}

ClassMethod NewCategory(Name As %String) As BeI.Category
{
   
    set cat = ##class(BeI.Category).%New()
    set cat.Name = Name
    do cat.%Save()
    return cat
}

ClassMethod NewAttribute(Name As %String) As BeI.Attribute
{
    set attr = ##class(BeI.Attribute).%New()
    set attr.Name = Name
    do attr.%Save()
    return attr
}

ClassMethod ShowBitstring(bs) As %String
{
    set result = ""
    for i=1:1:$BITCOUNT(bs) { set result = result_$bit(bs, i) }
    return result
}

}
