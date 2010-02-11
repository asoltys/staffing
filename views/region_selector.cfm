<cfoutput>

<h2>Region Selection</h2>

<p>
  <form id="region_form" method="post">
    Display staffing data from
    <select id="region_id" name="region_id">
      <cfloop condition="#regions.next()#">
        <cfset region = regions.current() />
        <cfif region.id eq session.staffing_region>
          <cfset selected = 'selected = "selected"' />
        <cfelse>
          <cfset selected = '' />
        </cfif>
        <option value="#region.id#" #selected#>#region.name#</option>
      </cfloop>
    </select>
  </form>
</p>

</cfoutput>
