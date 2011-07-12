<cfoutput>

<h2>Region Selection</h2>

<p>
  <form id="region_form" action="#request.path#index.cfm" method="post">
    Display staffing data from
    <select id="region_id" name="region_id">
      <cfloop condition="#regions.next()#">
        <cfset region = regions.current() />
        <cfif structKeyExists(session, 'staffing_region') and region.id eq session.staffing_region>
          <cfset selected = 'selected = "selected"' />
        <cfelse>
          <cfset selected = '' />
        </cfif>
        <option value="#region.id#" #selected#>#region.name#</option>
      </cfloop>
    </select>

    <input id="submit" name="submit" type="submit" value="Go" />
  </form>
</p>

</cfoutput>
