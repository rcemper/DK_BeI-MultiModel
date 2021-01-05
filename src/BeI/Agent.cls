Class BeI.Agent Extends %RegisteredObject
{

ClassMethod GetLastBitstringPosition() As %Numeric
{
    return $g(^BeILastBitstringPosition,0)
}

ClassMethod GetNextBitStringPosition() As %Numeric
{
    s next = 1
    lock +^BeILastBitstringPosition
    s next= ##class(BeI.Agent).GetLastBitstringPosition()+1
    s ^BeILastBitstringPosition=next
    lock -^BeILastBitstringPosition
    return next
}

ClassMethod Run() As %Status
{
    set ok = $$$OK
    d ##class(BeI.Agent).AddCategories()
    return ok
}

ClassMethod AddCategories() As %Status
{
    set ok = $$$OK
    s cat=##class(BeI.Category).CategoriesWithoutPosition()
    for i = 0:1:cat.Count()-1 {
        s currentCat=cat.GetAt(i)
        s currentCat.BitStringPosition=##class(BeI.Agent).GetNextBitStringPosition()
        d currentCat.%Save(0)
    }
    return ok
}

}
