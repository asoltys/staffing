<cfcomponent>	

<!--------------------------------------------------------------------------------------------- init

	Description:	
	
---------------------------------------------------------------------------------------------------->

	<cffunction name="init" access="public" returntype="void" output="false">
		<cfargument name="object" type="any" required="yes" />
		<cfargument name="gateway" type="any" required="yes" />
		<cfargument name="transactionLog" type="hr_staffing.model.transactions.TransactionLog" required="yes" />
		
		<cfset variables.object = arguments.object />
		<cfset variables.gateway = arguments.gateway />
		<cfset variables.transactionLog = arguments.transactionLog />
	</cffunction>
	
	<cffunction name="getList" access="remote" returntype="supermodel.ObjectList" output="true">
		<cfargument name="parameters" type="struct" default="#StructNew()#" />
		
		<cfset var query = variables.gateway.select() />
		<cfset var list = createObject('component', 'supermodel.ObjectList') />

		<cfset list.init(
			variables.object,
			query) />
	
		<cfreturn list />
	</cffunction>
	
	<cffunction name="getTransactions" access="remote" returntype="query" output="false">
		<cfargument name="position" type="hr_staffing.model.positions.Position" required="yes" />
		
		<cfset arguments.position.configure() />
		<cfset arguments.position.init(variables.dsn) />
		
		<cfreturn arguments.position.transactions />
	</cffunction>
	
	<cffunction name="savePositionActivity" access="remote" returntype="void" output="false">
		<cfargument name="processActivity" type="hr_staffing.model.positions.processactivity" required="yes" />
			
		<cfset arguments.processActivity.configure() />
		<cfset arguments.processActivity.init(variables.dsn) />
		<cfset arguments.processActivity.save() />

	</cffunction>
	
	<cffunction name="updateTransactionLog" access="remote" returntype="void" output="false">
		<cfargument name="transaction" type="hr_staffing.model.transactions.Transaction" required="yes" />
		
		<cfset variables.transactionLog.addTransaction(arguments.transaction) />
	</cffunction>
</cfcomponent>
