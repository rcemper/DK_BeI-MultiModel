Class BeI.Attribute Extends %Persistent
{

Property Name As %String;

Method GetValues(ByRef list) As %Integer
{
    k list
    s result=0
    s attrId = ..%Id()
    &SQL(declare attrs cursor for select id into:Id from BeI.AttributeValue where Attribute = :attrId)
    &SQL(open attrs)
    while 'SQLCODE {
        &sql(fetch attrs)
        i 'SQLCODE,Id'="" {
            s list(result)=Id
            s result = result + 1
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
