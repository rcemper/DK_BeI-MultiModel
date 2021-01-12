Class BeI.SortOrder Extends %Persistent
{

Property Name As %String;

Property Direction As %Numeric;

Property Field As %String;

Method GetDynamicSortOrder() As %DynamicObject
{
    set result = {}
    set result.name = ..Name
    set result.id = ..Field_"_"_..Direction
    set result.direction = ..Direction
    set result.field = ..Field
    return result
}

ClassMethod GetAllSortOrders() As %ArrayOfObjects
{
        set result = ##class(%ArrayOfObjects).%New(),i = 0
        &SQL(DECLARE orders CURSOR FOR SELECT id INTO :id FROM BeI.SortOrder)
        &SQL(OPEN orders)
        while 'SQLCODE {
            &SQL(FETCH orders)
            if 'SQLCODE,id '= "" {
                do result.SetAt(##class(BeI.SortOrder).%OpenId(id),i)
                set i = i + 1
            }
        }
        &SQL(CLOSE orders)
        return result
}

ClassMethod GetAllSortOrdersDynamic() As %DynamicArray
{
    set result = []
    set orders = ##class(BeI.SortOrder).GetAllSortOrders(),key = ""
    set order = orders.GetNext(.key)
    while key'="" {
        do result.%Push(order.GetDynamicSortOrder())
        set order = orders.GetNext(.key)
    }
    return result
}

Storage Default
{
<Data name="SortOrderDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Direction</Value>
</Value>
<Value name="4">
<Value>Field</Value>
</Value>
</Data>
<DataLocation>^BeI.SortOrderD</DataLocation>
<DefaultData>SortOrderDefaultData</DefaultData>
<IdLocation>^BeI.SortOrderD</IdLocation>
<IndexLocation>^BeI.SortOrderI</IndexLocation>
<StreamLocation>^BeI.SortOrderS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
