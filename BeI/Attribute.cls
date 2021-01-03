Class BeI.Attribute Extends %Persistent
{

Property Name As %String;

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
