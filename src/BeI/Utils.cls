Class BeI.Utils Extends %RegisteredObject
{

ClassMethod BuildFirstTestSet() As %Status
{
        set ok = $$$OK
        // populate categories
        s catTV = ##class(BeI.Utils).NewCategory("TV") 
        s catLaptop = ##class(BeI.Utils).NewCategory("Laptop") 
        s catTablet = ##class(BeI.Utils).NewCategory("Tablet") 
        // populate attributes
        s attrEnergyClass = ##class(BeI.Utils).NewAttribute("Energy class")
        s attrScreensize = ##class(BeI.Utils).NewAttribute("Screen size")
        s attrCPU = ##class(BeI.Utils).NewAttribute("CPU")
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
        // populate products
        d ##class(BeI.Product).Populate()
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

}
