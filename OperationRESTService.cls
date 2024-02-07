Class Hospital.WS.OperationRESTService Extends (%CSP.REST, Ens.BusinessService)
{

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<Route Url="/operationreq" Method="POST" Call="CreateNewOperationRequest"/>
</Routes>
}

ClassMethod CreateNewOperationRequest() As %Status
{
	set %response.ContentType = "application/json"
	
	// request body (JSON string)
	set body = %request.Content
	
	// parse body
	set jsonObj = {}.%FromJSON(body)
	
	// create msg
	set msg = ##class(Hospital.OperateRequest).%New()
	set msg.PatientID = jsonObj.PatientID
	set msg.RequestedOperation = jsonObj.RequestedOperation
	set msg.LikelyOutcome = jsonObj.LikelyOutcome
	
	// instantiate business service
	set sc = ##class(Ens.Director).CreateBusinessService("Hospital.WS.OperationRESTService", .service)
	$$$ThrowOnError(sc)
	
	// send msg
	set sc = service.SendRequestAsync("Hospital.PermissionToOperateProces", msg)
	
	// return some response
	write {"success": "true"}.%ToJSON()
	
	quit $$$OK
}

}
