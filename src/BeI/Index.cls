Class BeI.Index Extends %Persistent
{

Property SortField As %String;

Property SortId As %String;

Property Bitstring As %String;

Index IdIndex On (SortField, SortId) [ IdKey ];

Storage Default
{
<Data name="IndexDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Bitstring</Value>
</Value>
</Data>
<DataLocation>^INDEX("SORTORDER")</DataLocation>
<DefaultData>IndexDefaultData</DefaultData>
<IdLocation>^BeI.IndexD</IdLocation>
<IndexLocation>^BeI.IndexI</IndexLocation>
<SQLMap name="Index">
<Data name="Bitstring">
<Delimiter>"|"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^INDEX("SORTORDER")</Global>
<Subscript name="2">
<Expression>{SortField}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SortId}</Expression>
</Subscript>
</SQLMap>
<StreamLocation>^BeI.IndexS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
