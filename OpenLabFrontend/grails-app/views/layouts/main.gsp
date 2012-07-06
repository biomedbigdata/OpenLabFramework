<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN"
 "http://www.w3.org/TR/html4/strict.dtd">
<html>

<!-- HEAD -->
<head>
    <!-- Title -->
    <title><g:layoutTitle default="OpenLaboratoryFramework"/></title>

    <!-- Core + Skin CSS -->
    <g:loadIcon/>
    <!-- <link rel="shortcut icon" href="${resource(dir: 'images', file: 'openlab_ico.gif')}" type="image/x-icon" /> -->

    <!-- JS resources -->
    <!-- custom event handling -->
    <r:script disposition="head">

        var olfEvHandler = new OlfEventHandler('OpenLabFrameworkEventHandler');

        function OlfEventHandler(name) {
            this.name = name;
            //Register custom event for changes to fields

            this.propertyValueChangedEvent = new YAHOO.util.CustomEvent("propertyValueChangedEvent", this);
            this.bodyContentChangedEvent = new YAHOO.util.CustomEvent("bodyContentChangedEvent", this);
        }

    </r:script>

    <r:require module="grailsui-autocomplete"/>
    <r:require module="grailsui-rich-editor"/>
    <r:require module="grailsui-dialog"/>
    <r:require module="grailsui-tabview"/>
    <r:require module="grailsui-data-table"/>
    <r:require module="grailsui-menu"/>
    <r:require module="grailsui-accordion"/>
    <r:require module="grailsui-tooltips"/>
    <r:require module="grailsui-expandable-panel"/>
    <r:require module="grailsui-styles"/>
    <r:require module="grailsui-core"/>

    <!-- Additional YUI JS files: -->
    <r:require module="bubbling-dispatcher"/>
    <r:require modules="yui-calendar, yui-layout, yui-resize, yui-history, yui-event, yui-tabview, yui-treeview"/>
    <!-- customized CSS files for yui -->
    <r:require module="myyui"/>

    <!-- Layout head (Sitemesh) -->
    <g:layoutHead/>

    <!-- Set javascript provider to prototype -->
    <r:require module="prototypeManual"/>

    <!-- include dymo label printer js library -->
    <r:require module="labelPrinter"/>

    <r:layoutResources/>

    <!-- Main CSS at the end to make sure it is effective -->
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'main.css')}"/>
</head>

<!-- BODY -->
<body class="yui-skin-sam">

    <!-- hidden history fields -->
    <input id="yui-history-field" type="hidden" value="empty"/>
    <input id="navigationFlagInput" type="hidden" value="false"/>

    <!-- TOP -->
    <div id='top1'>
        <sec:ifLoggedIn>
            <g:render template="/layouts/header"/>
        </sec:ifLoggedIn>
    </div>

    <!-- CENTER -->
    <div id="center1">
        <div id="body">
            <!-- Body -->
            <g:layoutBody/>
        </div>
    </div>

    <!-- RIGHT: Addins -->
    <sec:ifLoggedIn>
        <div id='right1' align="center">
            <richui:portlet views='[1, 2, 3, 4, 5]' controller="addin" action="swapPositions" readOnly='true'>
                <!-- Taglib providing addins -->
                <addin:layoutAddins controller="${session.bodyController ? params.bodyController : params.controller}"
                                    numberOfViews="${numberOfAddins ? numberOfAddins : 4}"/>
            </richui:portlet>
        </div>

        <!-- LEFT: Project Tree -->

        <div id="left1">
            <!-- include controller="projectTree" action="renderTree" params="[id: params.id]"-->
        </div>
    </sec:ifLoggedIn>

    <!-- BOTTOM: Footer -->
    <div id="bottom1">Version <g:meta name="app.version"/> on Grails <g:meta name="app.grails.version"/>
    </div>

    <!-- JS -->

    <!-- YUI layout -->
    <r:script>
        YAHOO.util.Event.onDOMReady(function () {

            var layout = new YAHOO.widget.Layout({
                units:[
                    { position:'top', height:100, body:'top1', zIndex:1, scroll:null },
                    { position:'right', header:'Addins', width:300, resize:false, collapse:true, scroll:true, body:'right1', animate:true, gutter:'5' },
                    { position:'bottom', height:28, body:'bottom1' },
                    { position:'left', header:'Project Tree', width:200, body:'left1', gutter:'5', resize:true, scroll:true, animate:true, collapse:true},
                    { position:'center', body:'center1', gutter:'5 0', scroll:true }
                ]
            });

            layout.render();
        });

    </r:script>

    <!-- yahoo navigation history -->

    <r:script>
        var bodyContentBookmarkedState = YAHOO.util.History.getBookmarkedState("bodyContent");
        var navigationFlag = false

        // If there is no bookmarked state, assign the default state:
        var bodyContentInitialState = bodyContentBookmarkedState || "";

        YAHOO.util.History.register("bodyContent", bodyContentInitialState, function(state){

            var navigationFlagInput = document.getElementById("navigationFlagInput")

            if(navigationFlagInput.value == "false"){
                new Ajax.Updater({success:'body',failure:'body'}, state+'&moveInHistory=true' ,{method:'get',asynchronous:true,evalScripts:true});
            }

            else navigationFlagInput.value = "false";
        });

        YAHOO.util.History.onReady(function () {
            var currentState = YAHOO.util.History.getCurrentState("bodyContent");

            if(currentState.toString() != "" && currentState.toString() != "${request.forwardURI+params.toQueryString()}")
                new Ajax.Updater({success:'body',failure:'body'}, currentState ,{method:'get',asynchronous:true,evalScripts:true});
        });

        YAHOO.util.History.initialize("yui-history-field");
    </r:script>

    <!-- yui loading panel for ajax -->
    <r:script type="text/javascript">
        ajaxLoadingPanel = new YAHOO.widget.Panel("ajaxLoad", {
                    width:"240px",
                    fixedcenter:true,
                    close:false,
                    draggable:false,
                    modal:true,
                    visible:false,
                    effect:{effect:YAHOO.widget.ContainerEffect.FADE, duration:0.5},
                    zIndex:5000000
                }
        );

        ajaxLoadingPanel.setHeader("Loadin, please wait...");
        ajaxLoadingPanel.setBody('<img src="<g:resource dir="images" file="loading.gif"/>"/>');
        ajaxLoadingPanel.render(document.body);

        YAHOO.util.Event.onDOMReady(function(){
            Ajax.Responders.register({
                onCreate : function(){
                    ajaxLoadingPanel.show();
                },
                onComplete : function(){
                    ajaxLoadingPanel.hide();
                }
            });
        });


    </r:script>

<r:layoutResources/>

</body>

</html>