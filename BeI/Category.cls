Class BeI.Category Extends %Persistent
{

Property Name As %String;

Property Attributes As array Of BeI.Attribute;

Storage Default
{
<Data name="Attribute">
<Attribute>Attribute</Attribute>
<Structure>subnode</Structure>
<Subscript>"Attribute"</Subscript>
</Data>
<Data name="Attributes">
<Attribute>Attributes</Attribute>
<Structure>subnode</Structure>
<Subscript>"Attributes"</Subscript>
</Data>
<Data name="CategoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
</Data>
<DataLocation>^BeI.CategoryD</DataLocation>
<DefaultData>CategoryDefaultData</DefaultData>
<IdLocation>^BeI.CategoryD</IdLocation>
<IndexLocation>^BeI.CategoryI</IndexLocation>
<StreamLocation>^BeI.CategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
