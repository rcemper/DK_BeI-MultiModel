Class BeI.Installer Extends %RegisteredObject
{

ClassMethod CreateRestAPI()
{
    /* unauthenticade */
    s x=$NAMESPACE
    zn "%SYS"
    set cspProperties("AutheEnabled") = 64
    
    set cspProperties("NameSpace") = "USER"
    set cspProperties("IsNameSpaceDefault") = 0
    set cspProperties("DispatchClass") = "BeI.API"
    
    set tSC = ##class(Security.Applications).Create("/BeI2", .cspProperties)

    zn x
}

}
