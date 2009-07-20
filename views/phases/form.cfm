<cfset FormControls = event.getArg('FormControls') />

<h1>Phase Form</h1>

<form name="PhaseForm" action="index.cfm?event=processPhaseForm" method="post">
	<cfinvoke component="#FormControls#" method="textfield" field="id" label="none" required="no" type="hidden" />
	<cfinvoke component="#FormControls#" method="textfield" field="name" label="Name" required="yes" />
	<cfinvoke component="#FormControls#" method="textfield" field="sequence_number" label="Sequence Number" required="yes" />
	<input type="submit" name="submit_button" id="submit_button" value="Submit" />
</form>