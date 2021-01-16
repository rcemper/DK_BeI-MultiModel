Class BeI.Installer Extends %RegisteredObject
{

ClassMethod Install()
{
    s x=$NAMESPACE
    zn "%SYS"
    d ..CreateRole()
    d ..AddRole()
    d ..CreateRestAPI()
    zn x

    d ##class(BeI.Utils).BuildFirstTestSet(100)
}

ClassMethod CreateRestAPI()
{
    /* unauthenticade */

    s name="/BeI"
    if '##class(Security.Applications).Exists(name) {
        set cspProperties("AutheEnabled") = 64
        
        set cspProperties("NameSpace") = "USER"
        set cspProperties("IsNameSpaceDefault") = 0
        set cspProperties("DispatchClass") = "BeI.API"
        
        set tSC = ##class(Security.Applications).Create(name, .cspProperties)
    }
}

ClassMethod CreateRole()
{
    s name="BeI"
    if '##class(Security.Roles).Exists(name) {
        s description="Role for BeI application"
        s recources="%DB_USER:RW,%Service_Webgateway:U"
        set tSC = ##class(Security.Roles).Create(name,description,recources)
    }
}

ClassMethod AddRole()
{
    set tSC = ##class(Security.Users).AddRoles("UnknownUser","BeI",0)
}

}
