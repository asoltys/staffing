<cfset staffers = event.getArg('staffers') />
<cfinclude template="#request.includes_path#includes/helpers.cfm" />

<cfstoredproc procedure="UpdateProcesses" datasource="#request.dsn#" />

<cfloop condition="#staffers.next()#">
	<cfset staffer = staffers.current() />
	<cfset at_risk_positions = staffer.getRecentlyEndangeredPositions() />
	<cfset late_positions = staffer.getRecentlyLatePositions() />
	
	
	<cfif at_risk_positions.length() GT 0 OR late_positions.length() GT 0>
		<cfif request.server EQ 'Dev'>
			<cfset to = request.admin />
			<cfset cc = "" />
		<cfelse>
			<cfset to = staffer.email />
			<cfset cc = request.human_resources_mailbox />
		</cfif>
		
		<cfmail to="#to#" cc="#cc#" bcc="adam.soltys@pwgsc-tpsgc.gc.ca" from="#request.admin#" subject="Positions Report" type="html">
			<style>
				table{
					background:##FFFFFF;
					border:1px solid ##CCCCCC;
					border-collapse:collapse;
					font-size:14px;
					margin:20px 10px 10px 10px;
					table-layout:auto;
					width:90%;
				}
				table tr th {
					background:##DDDFE1;
					font-weight:bold;
				}
				table tr td, table tr th {
					border:1px solid ##CCCCCC;
					padding:5px;
				}
				.hideEmail, .hidden{
					display:none;
				}
			</style>
		
			Good morning #staffer.first_name#,
			<br />
			<cfif late_positions.length() GT 0>
				<p>The following position(s) became late today:</p>
				
				<table>
					<tr>
						<th>Position</th>
						<th>Process</th>
						<th>Group / Level</th>
						<th>Title</th>
						<th>Branch</th>
					</tr>
					<cfloop condition="#late_positions.next()#">
						<cfset position = late_positions.current() />
						
						<tr>
							<td>#position.number#</td>
							<td><a href="#request.server_url##request.path#index.cfm?event=processes.ssda&amp;process_id=#position.process.id#">#position.process.number#</a></td>
							<td>#position.job.groupAndLevel()#</td>
							<td>#position.job.title#</td>
							<td>#position.job.branch#</td>
						</tr>
					</cfloop>
				</table>
			</cfif>
			
			<cfif at_risk_positions.length() GT 0>
				<p>The following position(s) became at risk today:</p>
				
				<table>
					<tr>
						<th>Position</th>
						<th>Process</th>
						<th>Group / Level</th>
						<th>Title</th>
						<th>Branch</th>
					</tr>
					<cfloop condition="#at_risk_positions.next()#">
						<cfset position = at_risk_positions.current() />
						
						<tr>
							<td>#position.number#</td>
							<td><a href="#request.server_url##request.path#index.cfm?event=processes.ssda&amp;process_id=#position.process.id#">#position.process.number#</a></td>
							<td>#position.job.groupAndLevel()#</td>
							<td>#position.job.title#</td>
							<td>#position.job.branch#</td>
						</tr>
					</cfloop>
				</table>
			</cfif>
						
			<p>Have a great day!</p>
			
			<p>Your Pal,</p>
			
			<p>The Staffing Application</p>
			
			<p><small>This email is just for informational purposes and no action is necessarily required on your part.</small></p>
		</cfmail>
	</cfif>
</cfloop>
