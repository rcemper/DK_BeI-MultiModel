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
        write "Populating categories - Attributes - attributevalues",!
        set start = $zh
        // populate categories - Attributes - attributevalues
        do ##class(BeI.Utils).PopulateFromFile()
        write "categories - Attributes - attributevalues populated in: ",$zh-start,!
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

ClassMethod PopulateFromFile(filename As %String = "/shared/testData.txt") As %Status
{
    Set stream=##class(%Stream.FileCharacter).%New()
    Set sc=stream.LinkToFile(filename)
    While 'stream.AtEnd {
        set line = stream.ReadLine()
        set line = $tr(line,$c(13),"")
        if line '= "" {
            set content=$LISTFROMSTRING(line,"-")
            set type=$LIST(content,1)
            if type = "cat" {
                set cat($LIST(content,2)) = ##class(BeI.Utils).NewCategory($LIST(content,3))
            } elseif type = "attr" {
                set attr($LIST(content,2)) = ##class(BeI.Utils).NewAttribute($LIST(content,3))
            } elseif type = "lnk" {
                do cat($LIST(content,2)).Attributes.SetAt(attr($LIST(content,3)),cat($LIST(content,2)).Attributes.Count())
                do cat($LIST(content,2)).%Save()
            } elseif type = "attrval" {
                set x = ##class(BeI.AttributeValue).%New()
                set x.Attribute = attr($LIST(content,2))
                set x.Name = $LIST(content,3)
                set x.Value = $LIST(content,4)
                do x.%Save()
            }
        }
    }    
    return $$$OK
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
