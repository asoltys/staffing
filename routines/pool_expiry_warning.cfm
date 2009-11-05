<cfset pool= createObject('component', 'hr_staffing.model.pools.Pool') />
<cfset pool.init(request.dsn) />

<cfset poolGateway = createObject('component', 'hr_staffing.model.pools.PoolGateway') />
<cfset poolGateway.init(request.dsn) />

<cfset query = poolGateway.select() />

<cfquery name="query" dbtype="query">
  SELECT * 
  FROM query
  WHERE expiry_date = #DateAdd('M', 1, DateFormat(Now(), "yyyy-mm-dd"))#
</cfquery>

<cfset pools = createObject('component', 'supermodel.ObjectList') />
<cfset pools.init(pool, query) />

<cfoutput>

<cfloop condition="#pools.next()#">
  <cfset pool = pools.current() />

  <cfmail 
    to="#request.human_resources_mailbox#" 
    from="'Pacific Web Services' <pacificweb.services@pwgsc-tpsgc.gc.ca>"
    subject="Pool Expiration Notice" 
    type="html">

  <p>
    This is a notification to inform you that the following pool will be expiring in one month's time:
  </p>

  <p>
    Process: <a href="#request.server_url##request.path#index.cfm?event=processes.ssda&amp;process_id=#pool.process.id#">#pool.process.number#</a><br />
    Group / Level: #pool.classification_level.classification.name#-#pool.classification_level.name#<br />
    Contact: #pool.contact.getName()#<br />
    Expiry Date: #DateFormat(pool.expiry_date, "yyyy-mm-dd")#<br />
    Description: #pool.description#
  </p>

  </cfmail>
</cfloop>

</cfoutput>
