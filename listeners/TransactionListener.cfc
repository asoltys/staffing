<cfcomponent extends="MachII.framework.Listener">
		
<!----------------------------------------------------------------------------------------- configure

	Description:	Create an empty struct to hold all the position objects for the application
	
---------------------------------------------------------------------------------------------------->

	<cffunction name="configure" access="public" output="false" returntype="void" 
			hint="Configures this listener as part of the Mach-II framework">
	</cffunction>
	
<!--------------------------------------------------------------------------------------- prepareList

	Description:	
	
---------------------------------------------------------------------------------------------------->

	<cffunction name="prepareList" access="public" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var process = createObject('component', 'hr_staffing.model.processes.process') />
		<cfset process.init(request.dsn) />
		<cfset process.read(event.getArg('process_id')) />
		<cfset process.readTransactions() />
		
		<cfset process.transactions.order('transaction_datetime DESC') />

		<cfset event.setArg('process', process) />
		<cfset event.setArg('transactions', process.transactions) />
	</cffunction>
</cfcomponent>
