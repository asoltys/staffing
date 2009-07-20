<cfif this.name EQ "">
	<cfset StructInsert(variables.errors,'name','Must provide a name') />
</cfif>