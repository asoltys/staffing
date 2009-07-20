<cfif this.title EQ "">
	<cfset StructInsert(variables.errors,'title','Must provide a title') />
</cfif>

<cfif this.classification_level_id EQ "">
	<cfset StructInsert(variables.errors,'classification_id','Must specify the group and level') />
</cfif>

<cfif this.branch EQ "">
	<cfset StructInsert(variables.errors,'branch','Must specify the branch') />
</cfif>