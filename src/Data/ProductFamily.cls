Class Data.ProductFamily Extends %Persistent
{

Property Name As %String;

Storage Default
{
<Data name="ProductFamilyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
</Data>
<DataLocation>^Data.ProductFamilyD</DataLocation>
<DefaultData>ProductFamilyDefaultData</DefaultData>
<IdLocation>^Data.ProductFamilyD</IdLocation>
<IndexLocation>^Data.ProductFamilyI</IndexLocation>
<StreamLocation>^Data.ProductFamilyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
