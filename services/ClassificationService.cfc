<cfcomponent>
	<cfset init() />
	
	<cffunction name="init" access="private" returntype="void" output="false">
		<cfset variables.dsn = request.dsn />

	</cffunction>
	
	<cffunction name="getList" access="public" returntype="supermodel.ObjectList">
	
		<cfset var object = createObject('component', 'hr_staffing.model.classifications.Classification') />
		<cfset var query = '' />
		<cfset var list = createObject('component', 'supermodel.ObjectList') />
		<cfset var gateway = createObject('component', 'hr_staffing.model.classifications.ClassificationGateway') />	
		<cfset gateway.configure() />
		<cfset gateway.init(variables.dsn) />
		<cfset object.init(variables.dsn) />
		<cfset query = gateway.select(ordering='name') />
		

		<cfset list.init(
			object,
			query) />
	
		<cfreturn list />
	</cffunction>
	
	<cffunction name="getClassification" access="public" returntype="hr_staffing.model.classifications.Classification">
		<cfset var object = createObject('component', 'hr_staffing.model.classifications.Classification') />
		<cfset object.init(variables.dsn) />
		
		<cfreturn object />
	</cffunction>
</cfcomponent>