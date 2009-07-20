<cfset active_pools = event.getArg('active_pools') />
<cfset expired_pools = event.getArg('expired_pools') />
<cfset errors = event.getArg('errors') />

<cfinclude template="#request.includes_path#includes/helpers.cfm" />

<cfoutput>

<cfinvoke method="displayErrors" />

<h1>Pools</h1>

<cfif active_pools.length() GT 0>
	<h2>Active Pools</h2>
	<cfset pools = active_pools />
	<cfinclude template="pool_table.cfm" />	
</cfif>

<cfif expired_pools.length() GT 0>
	<h2>Expired Pools</h2>
	<cfset pools = expired_pools />
	<cfinclude template="pool_table.cfm" />	
</cfif>

<cfif request.current_user.hasRole('HR Staff')>
	<p>
		<a class="addLink" href="#request.path#index.cfm?event=pools.form">Add Pool</a>
	</p>
</cfif>

</cfoutput>