<!---
    Open Source base code: 
        https://github.com/edenspiekermann/a11y-dialog build 5.2.0
    
    Need help?
        Authored by: Daniel Horning <daniel.horning@its.ny.gov> 518-473-6049
    
    Purpose:
       Displays Accessibile Dialogs via simple calls

    Custom Tag Usage: <cf_MyDialogPopup Part="_SEGMENT_">
        Tag Segment Information:
            HeaderCSS:
                Included inside your <head> tag near other CSS includes
                Sample code:
                    <cf_MyDialogPopup Part="HeaderCSS">
            BodyStart:
                Include immediately following your start <body> tag
                    - this adds the start div that encloses your content
                        so that only the dialog is accessible.
                Sample code:
                    <cf_MyDialogPopup Part="BodyStart">
            BodyEnd:
                Include immediately preceding your end </body> tag
                    - this closes the div from the BodyStart tag and includes
                        the instantiation code for each of the dialogs
                Sample code:
                    <cf_MyDialogPopup Part="BodyEnd">
    
    Calling Dialogs:

        ShowCountDownDialog();      - No inputs required

        ShowAlertDialog(
            
            myDialogTitle, 			is a required input of type string (the title of the dialog)

            myDialogDescription,	is a required input of type string (the body of the dialog (html allowed))

            myDialogCloseURI,		is an optional input of type string (the close button with load the URL 
                                        located in the string) or function (called on button press)
                                        - set to '' to ignore

            myDialogExitURI,		is an optional input of type string (the X button with load the URL 
                                        located in the string) or function (called on button press)
                                        - set to '' to ignore

            myDialogCloseText		is a optional input of type string (the button text and aria label 
                                        of the 'close' button) - set to '' to ignore
        );

        ShowOKCancelDialog(
            
            myDialogTitle, 			is a required input of type string (the title of the dialog)

            myDialogDescription,	is a required input of type string (the body of the dialog (html allowed))

            myDialogOkURI, 			is an optional input of type string (the OK button with load the URL 
                                        located in the string) or function (called on button press)
                                        - set to '' to ignore

            myDialogCancelURI, 		is an optional input of type string (the Cancel button with load the  
                                        URL located in the string) or function (called on button press)
                                        - set to '' to ignore

            myDialogExitURI, 		is an optional input of type string (the X button with load the URL  
                                        located in the string) or function (called on button press)
                                        - set to '' to ignore

            myDialogOKText, 		is a optional input of type string (the button text and aria label  
                                        of the 'OK' button) - set to '' to ignore

            myDialogCancelText		is a optional input of type string (the button text and aria label  
                                        of the 'Cancel' button) - set to '' to ignore
        );


    Installation process:
        To install this Custom tag into your code you need the path of the css 
        and jscript folders where a11y-dialog.css and a11y-dialog.min.js located in
        attributes.frameworkPath ( a more generic version can
        be made that doesn't use DMV.Framework - but has not yet). Then you'll need
        to place a hidden form (keeping with the older MyDMV method for simplicity)
        following the BodyStart segment that includes hidKeepSessionUrl and hidLogoutUrl
        with a form name of clientVarsForm (in example) with the appropriate urls.
        You can then instantiate each of the dialogs as above.

        Sample code:
            <html>
                <head>
                    <title>Demo Page<title>
                    <cf_MyDialogPopup Part="HeaderCSS">
                </head>
                <body>
                    <cf_MyDialogPopup Part="BodyStart">
                    <form style="display:none;" name="clientVarsForm" action="?actionVars=true">
                        <input type="hidden" id="hidKeepSessionUrl" name="hidKeepSessionUrl"
                            value="#lib.MyDmv.Env.GetPortalUrl()#?extendsession=true" />
                        <input type="hidden" id="hidLogoutUrl" name="hidLogoutUrl"
                            value="#lib.MyDmv.Env.GetCrmRoot()#logout/index.cfm" />
                    </form>
                        -- YOUR PAGE HERE --
                    <cf_MyDialogPopup Part="BodyEnd">
                </body>
            </html>


--->
<cfparam name="ATTRIBUTES.Part" default="">
<cfparam name="attributes.frameworkPath" default="Framework" type="string" />
<cfif (left(attributes.frameworkPath,1) neq "/")><cfset attributes.frameworkPath = "/" & attributes.frameworkPath ></cfif> 
<cfif (right(attributes.frameworkPath,20) neq "Programs/edmvshared/")><cfset attributes.frameworkPath = attributes.frameworkPath & "/Programs/edmvshared/" ></cfif> 
<cfset attributes.frameworkPath = "//#cgi.SERVER_NAME##attributes.frameworkPath#">
<cfparam name="attributes.SessionTimeoutMinutes" default="2000" type="string" />
<cfparam name="attributes.URLExtendSession" default="" type="string" />
<cfparam name="attributes.URLLogoutSession" default="" type="string" />
<cfparam name="attributes.sessionenableurl" default="/mydmv/" type="string" />
<cfparam name="attributes.showTestLinks" default="false" type="boolean" />

<cftry>
    <cfswitch expression="#ATTRIBUTES.Part#">
        <cfcase value="HeaderCSS"><link href="<cfoutput>#attributes.frameworkPath#</cfoutput>css/a11y-dialog-custom.css" rel="stylesheet" type="text/css"  media="screen" /></cfcase>
        <cfcase value="BodyStart">
            <cfoutput><div id="mainA11"></cfoutput>
        </cfcase>
        <cfcase value="BodyEnd">
            <cfif(Server.DmvEnvironment eq "DEV" && attributes.showTestLinks eq true)>
	            <cfoutput><hr />
                <button class="link-like" data-a11y-dialog-show="dialog-countdown-timer">dialog-countdown-timer</button><br />
                <button class="link-like" data-a11y-dialog-show="dialog-alert">dialog-alert</button><br />
                <button class="link-like" data-a11y-dialog-show="dialog-ok-cancel">dialog-ok-cancel</button></cfoutput>
            </cfif>
            <cfoutput>
            </div>
            <div role="dialog" class="dialog" id="dialog-alert" style="display: none;">
                <div class="dialog-overlay" tabindex="-1"></div>
                <div class="dialog-content" aria-labelledby="dialogTitle-alert" aria-describedby="dialogDescription-alert">
                    <button data-a11y-dialog-hide class="dialog-close" aria-label="Close">&times;</button>

                    <h1 id="dialogTitle-alert">Informative Alert Window</h1>
                    <hr aria-hidden="true">
                    <p id="dialogDescription-alert">I am Groot!</p>
                    <hr aria-hidden="true">

                    <div class="dialogButtonsFlexDiv">
                        <div class="dialogButtons">
                            <button id="dialog-alert-close" name="Close" data-a11y-dialog-hide="" value="Close">Close</button>
                        </div>
                    </div>
                </div>
            </div>
            <div role="dialog" class="dialog" id="dialog-ok-cancel" style="display: none;">
                <div class="dialog-overlay" tabindex="-1"></div>
                <div class="dialog-content" aria-labelledby="dialogTitle-ok-cancel" aria-describedby="dialogDescription-ok-cancel">
                    <button data-a11y-dialog-hide class="dialog-close" aria-label="Close">&times;</button>

                    <h1 id="dialogTitle-ok-cancel">OK Cancel Window</h1>
                    <hr aria-hidden="true">
                    <p id="dialogDescription-ok-cancel">Descriptive message to tell you why to pick okay or cancel!</p>
                    <hr aria-hidden="true">

                    <div class="dialogButtonsFlexDiv">
                        <div class="dialogButtons">
                            <button id="dialog-ok-cancel-ok" name="Okay" data-a11y-dialog-hide="" value="OK">OK</button>
                        </div>
                        <div class="dialogButtons">                        
                            <button id="dialog-ok-cancel-cancel" name="Cancel" data-a11y-dialog-hide="" value="Cancel">Cancel</button>
                        </div>
                    </div>

                </div>
            </div>
            <div role="dialog" class="dialog" id="dialog-countdown-timer" style="display: none;">
                <div class="dialog-overlay" tabindex="-1"></div>
                <div class="dialog-content" aria-labelledby="dialogTitle-countdown-timer" aria-describedby="dialogDescription-countdown-timer">
                    <button data-a11y-dialog-hide class="dialog-close" aria-label="Close">&times;</button>

                    <h1 id="dialogTitle-countdown-timer">Your session is about to expire. Do you want to remain signed in to this application?</h1>
                    <hr aria-hidden="true">
                    <p id="dialogDescription-countdown-timer">
                        Your session will expire in <span id="dialog-countdown-timer-seconds">60</span> seconds. To keep working, select "Continue Session". Otherwise, your transaction will be canceled.
                    </p>
                    <hr aria-hidden="true">

                    <div class="dialogButtonsFlexDiv">
                        <div class="dialogButtons">
                            <button id="dialog-session-end" name="End Session" data-a11y-dialog-hide="" value="End Session">End Session</button>                       
                        </div>
                        <div class="dialogButtons">
                            <button id="dialog-session-continue" name="Continue Session" data-a11y-dialog-hide="" value="Continue Session">Continue Session</button>
                        </div>
                    </div>
                </div>
            </div>

            <script type="text/javascript" src="#attributes.frameworkPath#jscript/a11y-dialog.js"></script>
            <cfif (findNoCase("/MyDMV/mylic", cgi.SCRIPT_NAME))><script type="text/javascript" src="/MyDMV/mylic/includeJS.cfm"></script></cfif>
            <cfif (findNoCase("/MyDMV/MYLCC", cgi.SCRIPT_NAME))><script type="text/javascript" src="/MyDMV/MYLCC/includeJS.cfm"></script></cfif>
            <script>
                var myTimeout;
                var myCountdown;
                var myDialogs;
                var dialogCD;
                var dialogAL;
                var dialogOC;
                var dialogCloseURI;
                var dialogOkURI;
                var dialogCancelURI;
                var dialogExitURI;

                (function () {
                    document.addEventListener('DOMContentLoaded', function () {
                        var mainEl = document.getElementById('mainA11');
                        var dialogEl = document.getElementById('dialog-countdown-timer');
                        var dialogE2 = document.getElementById('dialog-alert');
                        var dialogE3 = document.getElementById('dialog-ok-cancel');
                        dialogCD = new window.A11yDialog(dialogEl, mainEl);
                        dialogAL = new window.A11yDialog(dialogE2, mainEl);
                        dialogOC = new window.A11yDialog(dialogE3, mainEl);
                        
                        dialogCD.on('show', function (dialogEl, triggerEl) {
                            dialogEl.removeAttribute("style");
                            runFinalCountdown();
                        });

                        dialogCD.on('hide', function (dialogEl, triggerEl) {
                            clearInterval(myCountdown);
                            if (triggerEl.srcElement.id == "dialog-session-continue")
                            {
                                extendMySession();
                            }
                            else
                            {  
                                endMySession();
                            }
                        });
                        
                        dialogAL.on('show', function (dialogE2, triggerEl) {
                            dialogE2.removeAttribute("style");
                        });
                        
                        dialogAL.on('hide', function (dialogE2, triggerEl) {
                            if (triggerEl.srcElement.id == "dialog-alert-close")
                            {
                                if (Object.prototype.toString.call(dialogCloseURI) === '[object Function]')
                                {
                                    dialogCloseURI();
                                }
                                else if (dialogCloseURI != "" && dialogCloseURI !== undefined)
                                {
                                    window.location = dialogCloseURI;
                                }
                            }
                            else // X case
                            {  
                                if (Object.prototype.toString.call(dialogExitURI) === '[object Function]')
                                {
                                    dialogExitURI();
                                }
                                else if (dialogExitURI != "" && dialogExitURI !== undefined)
                                {
                                    window.location = dialogExitURI;
                                }
                            }
                        });

                        dialogOC.on('show', function (dialogE3, triggerEl) {
                            dialogE3.removeAttribute("style");
                        });

                        dialogOC.on('hide', function (dialogE3, triggerEl) {
                            if (triggerEl.srcElement.id == "dialog-ok-cancel-ok")
                            {
                                if (Object.prototype.toString.call(dialogOkURI) === '[object Function]')
                                {
                                    dialogOkURI();
                                }
                                else if (dialogOkURI != "" && dialogOkURI !== undefined)
                                {
                                    window.location = dialogOkURI;
                                }
                            }
                            else if (triggerEl.srcElement.id == "dialog-ok-cancel-cancel")
                            {
                                if (Object.prototype.toString.call(dialogCancelURI) === '[object Function]')
                                {
                                    dialogCancelURI();
                                }
                                else if (dialogCancelURI != "" && dialogCancelURI !== undefined)
                                {
                                    window.location = dialogCancelURI;
                                }
                            }
                            else // X case
                            {  
                                if (Object.prototype.toString.call(dialogExitURI) === '[object Function]')
                                {
                                    dialogExitURI();
                                }
                                else if (dialogExitURI != "" && dialogExitURI !== undefined)
                                {
                                    window.location = dialogExitURI;
                                }
                            }
                        });

                        if(document.URL.toLowerCase().indexOf('#LCase(attributes.sessionenableurl)#') > 0)
                        {
                            var myTimeout = setTimeout(function() { dialogCD.show(); }, #1000*60*(attributes.SessionTimeoutMinutes-2)# );
                        }
                    });
                }());

                function ShowCountDownDialog()
                {
                    dialogCD.show();
                }

                function ShowAlertDialog(myDialogTitle, myDialogDescription, myDialogCloseURI, myDialogExitURI, myDialogCloseText)
                {
                    dialogCloseURI = '';
                    dialogExitURI = '';

                    if (myDialogTitle !== undefined)
                    {
                        document.getElementById("dialogTitle-alert").innerHTML = myDialogTitle;
                        if (myDialogTitle !== undefined)
                        {
                            document.getElementById("dialogDescription-alert").innerHTML = myDialogDescription;
                            if (myDialogCloseURI !== undefined)
                            {
                                dialogCloseURI = myDialogCloseURI;
                            }
                            if (myDialogExitURI !== undefined)
                            {
                                dialogExitURI = myDialogExitURI;
                            }
                            
                            else if (myDialogCloseURI !== undefined)
                            {
                                dialogExitURI = myDialogCloseURI;
                            }
                            if (myDialogCloseText == undefined || myDialogCloseText == '')
                            {
                                myDialogCloseText = 'Close';
                            }
                            document.getElementById('dialog-alert-close').setAttribute('value', filterTextFromHTML(myDialogCloseText));
                            document.getElementById("dialog-alert-close").innerHTML = myDialogCloseText;
                            dialogAL.show();
                        }
                    }
                }

                function ShowOKCancelDialog(myDialogTitle, myDialogDescription, myDialogOkURI, myDialogCancelURI, myDialogExitURI, myDialogOKText, myDialogCancelText)
                {
                    dialogOkURI = '';
                    dialogCancelURI = '';
                    dialogExitURI = '';

                    if (myDialogTitle !== undefined)
                    {
                        document.getElementById("dialogTitle-ok-cancel").innerHTML = myDialogTitle;
                        if (myDialogTitle !== undefined)
                        {
                            document.getElementById("dialogDescription-ok-cancel").innerHTML = myDialogDescription;
                            if (myDialogOkURI !== undefined)
                            {
                                dialogOkURI = myDialogOkURI;
                            }
                            if (myDialogCancelURI !== undefined)
                            {
                                dialogCancelURI = myDialogCancelURI;
                            }
                            if (myDialogExitURI !== undefined)
                            {
                                dialogExitURI = myDialogExitURI;
                            } 
                            else if (myDialogCancelURI !== undefined)
                            {
                                dialogExitURI = myDialogCancelURI;
                            }
                            if (myDialogOKText == undefined || myDialogOKText == '')
                            {
                                myDialogOKText = 'OK';
                            } 
                            if (myDialogCancelText == undefined || myDialogCancelText == '')
                            {
                                myDialogCancelText = 'Cancel';
                            }
                            document.getElementById('dialog-ok-cancel-ok').setAttribute('value', filterTextFromHTML(myDialogOKText));
                            document.getElementById("dialog-ok-cancel-ok").innerHTML = myDialogOKText;
                            document.getElementById('dialog-ok-cancel-cancel').setAttribute('value', filterTextFromHTML(myDialogCancelText));
                            document.getElementById("dialog-ok-cancel-cancel").innerHTML = myDialogCancelText;

                            dialogOC.show();
                        }
                    }
                }
                
                function runFinalCountdown()
                {
                    var seconds = 59;

                    myCountdown = setInterval(function() {
                        if (seconds > 0)
                        {
                            document.getElementById("dialog-countdown-timer-seconds").innerHTML = seconds;
                            seconds = seconds - 1;
                        }
                        else
                        {
                            document.getElementById("dialog-countdown-timer-seconds").innerHTML = "0";
                            endMySession();
                        }
                    }, 1000);
                }

                function restartCountdown()
                {
                    document.getElementById("dialog-countdown-timer-seconds").innerHTML = "60";
                    var myTimeout = setTimeout(function() { dialogCD.show(); }, #1000*60*(attributes.SessionTimeoutMinutes-2)# );
                }

                function extendMySession()
                {
                    var extendURL = '#attributes.URLExtendSession#';
					
                    if (extendURL != '')
					{
						var xmlhttp=new XMLHttpRequest();
                    
						xmlhttp.onreadystatechange = function() {
							if (this.readyState == 4 && this.status == 200) 
							{
								restartCountdown();  
							}
							else if (this.readyState == 4 && this.status != 200) 
							{
								endMySession();
							}
						};

						xmlhttp.open("GET",extendURL,true);
						xmlhttp.setRequestHeader('Content-Type', 'text/plain');
						xmlhttp.setRequestHeader('Content-Type', 'multipart/form-data');
						xmlhttp.send(null);
						
					}
                }

                function endMySession()
                {
					var logoutURL =  '#attributes.URLLogoutSession#';
					
					if (logoutURL != '')
					{
						window.location = logoutURL;
					}
				}

                function filterTextFromHTML(htmlString)
                {       /* This to ensure the aria-labels do not have html added from the button labels. */
                    if (typeof window.jQuery != 'undefined') {
                        try {
                            return $.parseHTML(htmlString, null, false).reduce(function (string, node) {
                                    return string += node.textContent;
                                }, "");
                        } catch (err) {
                            var d = document.createElement( 'div' );
                            d.innerHTML = htmlString;
                            return d.textContent;
                        }
                    } else {
                        var d = document.createElement( 'div' );
                        d.innerHTML = htmlString;
                        return d.textContent;
                    }
                }
            </script></cfoutput>
        </cfcase>
        <cfdefaultcase>
            <cfoutput><H1 style="font-weight:700;font-size:5em;background-color:white;color:red;">ERROR: No default output available.</h1></cfoutput>
            <cfthrow>
        </cfdefaultcase>
    </cfswitch>
    <cfcatch type="any">
        <cfrethrow>
    </cfcatch>
</cftry>