Class Data.Product Extends %Persistent
{

Property ProductCode As %String;

Property Name As %String;

Property Price As %Numeric;

Property ProductFamily As Data.ProductFamily;

Storage Default
{
<Data name="ProductDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ProductCode</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>Price</Value>
</Value>
<Value name="5">
<Value>ProductFamily</Value>
</Value>
</Data>
<DataLocation>^Data.ProductD</DataLocation>
<DefaultData>ProductDefaultData</DefaultData>
<IdLocation>^Data.ProductD</IdLocation>
<IndexLocation>^Data.ProductI</IndexLocation>
<StreamLocation>^Data.ProductS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
