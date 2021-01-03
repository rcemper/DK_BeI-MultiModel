Class BeI.AttributeValue Extends %Persistent
{

Property Attribute As BeI.Attribute;

Property Name As %String;

Property Value As %String;

Property ProductCount As %Numeric;

Property BitStringPosition As %Numeric;

Storage Default
{
<Data name="AttributeValueDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Attribute</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>Value</Value>
</Value>
<Value name="5">
<Value>ProductCount</Value>
</Value>
<Value name="6">
<Value>BitStringPosition</Value>
</Value>
</Data>
<DataLocation>^BeI.AttributeValueD</DataLocation>
<DefaultData>AttributeValueDefaultData</DefaultData>
<IdLocation>^BeI.AttributeValueD</IdLocation>
<IndexLocation>^BeI.AttributeValueI</IndexLocation>
<StreamLocation>^BeI.AttributeValueS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
