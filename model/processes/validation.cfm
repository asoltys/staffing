<cfif this.number EQ "">
	<cfset StructInsert(variables.errors,'number','Must specify a process number') />
</cfif>