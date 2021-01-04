Class BeI.Attribute Extends %Persistent
{

Property Name As %String;

Method GetValues() As %Library.ArrayOfObjects
{
    k list
    s result=##class(%Library.ArrayOfObjects).%New()
    s attrId = ..%Id(),i=0
    &SQL(declare attrs cursor for select id into:Id from BeI.AttributeValue where Attribute = :attrId)
    &SQL(open attrs)
    while 'SQLCODE {
        &sql(fetch attrs)
        i 'SQLCODE,Id'="" {
            d result.SetAt(##class(BeI.AttributeValue).%OpenId(Id),i)
            s i = i + 1
        }
    }
    &SQL(close attrs)
    return result
}

Storage Default
{
<Data name="AttributeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
</Data>
<DataLocation>^BeI.AttributeD</DataLocation>
<DefaultData>AttributeDefaultData</DefaultData>
<IdLocation>^BeI.AttributeD</IdLocation>
<IndexLocation>^BeI.AttributeI</IndexLocation>
<StreamLocation>^BeI.AttributeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
