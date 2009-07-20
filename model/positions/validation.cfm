<cfif this.job_id EQ "">
	<cfset StructInsert(variables.errors,'job_id','Must specify a job') />
</cfif>

<cfif this.tenure_id EQ "">
	<cfset StructInsert(variables.errors,'tenure_id','Must specify a tenure') />
</cfif>

<cfif this.security_level_id EQ "">
	<cfset StructInsert(variables.errors,'security_level_id','Must specify a security level') />
</cfif>

<cfif this.language_consideration_id EQ "">
	<cfset StructInsert(variables.errors,'language_consideration_id','Must specify a language consideration') />
</cfif>

<cfif this.location EQ "">
	<cfset StructInsert(variables.errors,'location','Must specify the location') />
</cfif>
