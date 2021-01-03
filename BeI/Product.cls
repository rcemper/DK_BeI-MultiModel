Class BeI.Product Extends (%Persistent, %Populate)
{

Property Name As %String(POPSPEC = "Product()");

Property Price As %Numeric;

Property Category As BeI.Category;

Property BitString As %String;

Property Attributes As array Of BeI.AttributeValue;

Storage Default
{
<Data name="Attributes">
<Attribute>Attributes</Attribute>
<Structure>subnode</Structure>
<Subscript>"Attributes"</Subscript>
</Data>
<Data name="ProductDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Category</Value>
</Value>
<Value name="4">
<Value>BitString</Value>
</Value>
<Value name="5">
<Value>Price</Value>
</Value>
</Data>
<DataLocation>^BeI.ProductD</DataLocation>
<DefaultData>ProductDefaultData</DefaultData>
<IdLocation>^BeI.ProductD</IdLocation>
<IndexLocation>^BeI.ProductI</IndexLocation>
<StreamLocation>^BeI.ProductS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
