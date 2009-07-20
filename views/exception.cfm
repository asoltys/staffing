<cfset variables.exception = event.getArg("exception") />

	<!-- CONTENT BEGINS | DEBUT DU CONTENU --> 
	<div class="center">
		<h1><a name="cont" id="cont">
		<!-- CONTENT TITLE BEGINS | DEBUT DU TITRE DU CONTENU -->
		Mach-II Exception
		<!-- CONTENT TITLE ENDS | FIN DU TITRE DU CONTENU -->
		</a></h1>

<cfoutput>
		<table>
			<tr>
				<td valign="top"><h4>Message</h4></td>
				<td valign="top"><p>#variables.exception.getMessage()#</p></td>
			</tr>
			<tr>
				<td valign="top"><h4>Detail</h4></td>
				<td valign="top"><p>#variables.exception.getDetail()#</p></td>
			</tr>
			<tr>
				<td valign="top"><h4>Extended Info</h4></td>
				<td valign="top"><p>#variables.exception.getExtendedInfo()#</p></td>
			</tr>
			<tr>
				<td valign="top"><h4>Tag Context</h4></td>
				<td valign="top">
					<cfset variables.tagCtxArr = variables.exception.getTagContext() />
					<cfloop index="i" from="1" to="#ArrayLen(variables.tagCtxArr)#">
						<cfset variables.tagCtx = variables.tagCtxArr[i] />
						<p>#variables.tagCtx['template']# (#variables.tagCtx['line']#)</p>
					</cfloop>
				</td>
			</tr>
			<tr>
				<td valign="top"><h4>Caught Exception</h4></td>
				<td valign="top"><cfdump var="#variables.exception.getCaughtException()#" expand="false" /></td>
			</tr>
		</table>
	</div>
	<!-- CONTENT ENDS | FIN DU CONTENU -->
</cfoutput>