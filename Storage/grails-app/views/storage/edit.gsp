<html>
    <head>
        <title>Storage</title>
        <g:setProvider library="prototype"/>
        <meta name="layout" content="${params.bodyOnly?'body':'main'}" />
	</head>
<body>

<div class="body" style="width:80%;">
<h1>Storage Configuration</h1>
<table width="200">
 <tr><th>Select StorageType</th><th>Select Compartment</th></tr>
 <tr>
  <td>
  	<span id="storageTypeSelectDiv">
		<g:select from="${storageTypeList}" name="storageTypeSelect" value="" onchange="${remoteFunction(action:'updateCompartmentSelect', update:'compartmentSelectDiv', params:'\'selectedValue=\'+this.value')}"/>
	</span>
        <div class="buttons">
            <g:form> 
                <g:hiddenField name="bodyOnly" value="true" />
                <span class="button">
                	<g:submitToRemote class="create" controller="storageType" action="create" update="[success:'body',failure:'error']" value="${message(code: 'default.button.list.label', default: 'Create')}" />
                	<g:submitToRemote class="list" controller="storageType" action="list" update="[success:'body',failure:'error']" value="${message(code: 'default.button.list.label', default: 'List all')}" />
               	</span>
            </g:form>
    	</div>
  </td>
  <td>
  	<span id="compartmentSelectDiv">
		<g:render plugin="storage" template="/layouts/compartmentSelect"/>
	</span>
	        <div class="buttons">
            <g:form> 
                <g:hiddenField name="bodyOnly" value="true" />
                <span class="button">
                	<g:submitToRemote class="create" controller="compartment" action="create" update="[success:'body',failure:'error']" value="${message(code: 'default.button.list.label', default: 'Create')}" />
                	<g:submitToRemote class="list" controller="compartment" action="list" update="[success:'body',failure:'error']" value="${message(code: 'default.button.list.label', default: 'List all')}" />
               	</span>
            </g:form>
    	</div>
  </td>
 </tr>
</table>

<div class="buttons">
	<g:link controller="storage" action="exportHierarchy">Export Storage Hierarchy to XLS</g:link>
</div>

<div id="boxListArea"></div>

</body>
</div>
</html>