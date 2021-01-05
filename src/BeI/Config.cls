Class BeI.Config Extends %Persistent
{

Property LastBitStringPosition As %Numeric;

Storage Default
{
<Data name="ConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LastBitStringPosition</Value>
</Value>
</Data>
<DataLocation>^BeI.ConfigD</DataLocation>
<DefaultData>ConfigDefaultData</DefaultData>
<IdLocation>^BeI.ConfigD</IdLocation>
<IndexLocation>^BeI.ConfigI</IndexLocation>
<StreamLocation>^BeI.ConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
