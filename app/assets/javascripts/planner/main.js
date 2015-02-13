(function($) {

    $.widget("custom.jsplanner", {


        options: {
            inittime:0,
            color: "#556b2f",
            backgroundColor: "black",
            timeLineHeight: "100",
            timeLineScale: 0.5,
            basicDivisionWidth: 80,
            currentTime: 0,
            resourceColumnWidth: 200,
            resourceHeaderRowHeight: 30,
            resourceLineRowHeight: 30,
            resourceData: {},
            appointmentduewarninghours: 0,
            exclusions: {},
            draginit:0,
            resourceAreaHeight:0,
            timelineLineColor:"#888888",
            timelineTextColor:"#222222",
            appointmentAreaLineColor:"#DDDDDD",
            exclusionZoneColor:"#FFFFFF",
            isTimelineCompression:-1,
            timelineArray:[],
            exclusionschange:false,
            preparedcentertime:0,
            timelineDaysPerWeek:5,
            timelineCompressionGapSize:50,
            timelineCompressionGapSizeDefault:50,
            compressedTimelineScale:0.005,
            contractoptionalfields:"",
            mjoboptionalfields:"",
            timelineHardOffset:5

        },
        globalconsts: {
            month : ["January","February","March", "April","May","June","July","August","September","October","November","December"],
            rweekday :{"Sunday":0,"Monday":1,"Tuesday":2,"Wednesday":3,"Thursday":4,"Friday":5,"Saturday":6},
            weekday :["Sunday","Monday","Tuesday","Wednesday","Thursday", "Friday","Saturday"],
            visithovertarget:-1
        },
        

        _setOption: function(key, value) {
            // Use the _setOption method to respond to changes to options
            switch (key) {
                case "length":
                    break;
            }
            // and call the parent function too!
            return this._superApply(arguments);
        },
        _create: function() { //fires on create of the widget. set some of our defaults here and register resize listener to resize widget if the container size changes
            var resourceData = [];
            this._setOption("resourceData", resourceData);
            var exclusionsData = [];
            this._setOption("exclusions", exclusionsData);
            this._setOption("currentlydraggedobject", "e.target.id", "");
            this._setOption("currentdragtype", "e.target.id", "");
            this._renderControl(false);
            var plannercontext = this;



            $(window).resize(function(e) {
                if (e.target == window) {
                    plannercontext._setOption("draginit",0);
                    plannercontext._setOption("exclusionschange",true);
                    plannercontext._renderControl(false);
                    $("#jsplannercontainer").hide();
                    $("#jsplannercontainer").show();
                }

            });
        },
        setRowHeight: function(value){
            this._setOption("resourceHeaderRowHeight",value);
            this._setOption("resourceLineRowHeight", value);
            this._resetTimeLine();
            this._resetResourceColumn();
            this._saveOptions();
        },
        jsplannerSetExclusionPeriod: function(exclusion) {

            var exclusionsData = [];
            exclusionsData = this.options.exclusions;
            exclusionsData.push(exclusion);
            this._setOption("exclusionschange",true);
            this._setOption("exclusions", exclusionsData);
        },
        jsplannerSetOpt: function(opt, val) { //allow us to set options from outside the planner object
            this._setOption(opt, val);
        },
        saveOptions: function(){
            this._saveOptions();
            this._resetTimeLine();
        },
        // Keep various pieces of logic in separate methods
        filter: function() {
            // Methods without an underscore are "public"
        },
        _hover: function() {
            // Methods with an underscore are "private"
        },

        _destroy: function() {
            // Use the destroy method to reverse everything your plugin has applied
            $(window).unbind("resize");
            this.element.html("");

            var element = this.element;
            var position = $.inArray(element, $.ui.dialog.instances);
            if (position > -1) {
                $.ui.dialog.instances.splice(position, 1);
            }



            return this._super();
        },

        jsplannersetcurrentcentertimetoday: function() //redraw the widget entirely
        {

            this._setOption("currentTime", this._getCurrentDayStart());
        },      

        jsplannerredraw: function() //redraw the widget entirely
        {
            this._renderControl(true);
        },

        jsplannerredrawappointments: function(resourcekey) //redraw only a single grid row - saves time and flickering when editing a job/
        {
            this._loadAndRenderPlannerEvents(resourcekey);
        },

        jsplannersettimelinescale: function(value) //allow user to set timeline scalar
        {   
            if (this.options.isTimelineCompression==-1){
                switch(value){
                    case 'm':
                        this._setOption("compressedTimelineScale", 0.002);
                    break;
                    case 'w':
                       this._setOption("compressedTimelineScale",0.01) ;
                    break;
                    case 'd':
                       this._setOption("compressedTimelineScale",0.05) ;
                    break;
                }
                $('#scaleslider').slider('value',this.options.compressedTimelineScale);
                this._setOption("exclusionschange",true);
                this._setOption("timelineArray",[])
                this._resetTimeLine();
                this._saveOptions();                
            }else{

                switch(value){
                    case 'm':
                       this._setOption("timeLineScale",0.011) ;
                    break;
                    case 'w':
                       this._setOption("timeLineScale",0.061) ;
                    break;
                    case 'd':
                       this._setOption("timeLineScale",0.3) ;
                    break;
                }
                $('#scaleslider').slider('value',this.options.timeLineScale);
                this._saveOptions();
                this._resetTimeLine();
            }
        },

        jsplannerConfirmDelete: function(id) //the user has confirmed the deletion of an appointment. remove it from the planner view
        {
            $("#jsplannerevent" + id).remove();
            this._renderControl(true);
        },

        _roundMinutes: function(timestamp) { //return only the hours from a timestamp
            var date = new Date();
            date.setTime(timestamp);
            date.setHours(date.getHours() + Math.round(date.getMinutes() / 60));
            date.setMinutes(0);
            return date.getTime();
        },

        _getHourFromEpoch: function(timestamp) { //return the time without minutes
            var myDate = new Date(timestamp);
            return myDate.getHours() + ":00";
        },


        addResourceData: function(jsonResourceData) { //adds a resources object to the widget (ie employees or subbies lists)
            var resourceData = this.options.resourceData;
            resourceData.push(jsonResourceData);
            this._setOption("resourceData", resourceData);
        },
        clearResourceData: function() { //adds a resources object to the widget (ie employees or subbies lists)
            var resourceData = [];
            this._setOption("resourceData", resourceData);
        },
        setJobFilter: function(value) { //change the filter on our jobs list
            var resourceData = [];
            var datasource = this.options.plannerdatasource;
            for (var i in datasource) {
                datasource[i].where = value;
            }

            this._setOption("plannerdatasource", datasource);
        },

        _renderControl: function(bSkipContainers) { //main render routine. redraws the whole widget.
            var containerwidth = (this.element.width() - this.options.resourceColumnWidth - 1);
            var bodyheight = this.element.height() - this.options.timeLineHeight - 2;
            var resourceData;
            var resourceQuery = [];
            var resultsobj;
            var currentGroupName = "";
            var plannercontext = this;
            resourceData = this.options.resourceData;

            var i = 0;
            var j = 0;
            var jsonResourceData = "";


                if (this.options.currentTime === 0) {
                    if (this.options.inittime!=0){
                        this._setOption("currentTime", this.options.inittime);
                        console.log(this.options.inittime);
                    }else{
                        this._setOption("currentTime", (this._getCurrentDayStart()));
                    }

                    //this._setOption("currentTime", Math.floor((new Date()).getTime() / 1000));
                }
                var centerPointTime = this.options.currentTime;

                var nearestHourTime = this._roundMinutes(centerPointTime);

                if (bSkipContainers==false){

                

                    //BEGIN RENDER COMPONENT
                    var srcHTML = "<div class='jsplannercontainer'>"; //componentmain container
                    //Begin Options Page for dialog



                    //RENDER HEADER
                    srcHTML += "<div class='jsplannerheadercontainer'>"; //component header container
                    srcHTML += "<div id='jsplannerdatepicker'></div>";
                    srcHTML += "<div class='jsplannerresourcecolumnhead' style='width:" + (this.options.resourceColumnWidth - 1) + "px;height:" + (this.options.timeLineHeight) + "px'>" + this._getControlPanelContent() + "</div>"; //resource column header
                    srcHTML += "<div class='jsplannertimelinecontainer' id='jsplannertimelinecontainer'>"; //container for timeline hides parts of the timeline outside visible area

                    srcHTML += "<div id='jsplannertimeline' class='jsplannertimeline' style='height:" + this.options.timeLineHeight + "px;width:1000px;margin-left:500px'>";
                    srcHTML += "<canvas id='timelinecanvas' style='pointer-events:none' height='" + this.options.timeLineHeight + "px' width=1000px'></canvas>"
                    srcHTML += "</div>"        

                    srcHTML += "</div>"; //timelinecontainer
                    srcHTML += "</div>"; //headercontainer
                    //END RENDER HEADER

                    //RENDER BODY
                    srcHTML += "<div class='jsplannerbodycontainer' style='height:" + bodyheight + "px;'>"; //component header container
                    srcHTML += "<div class='jsplannerresourcecolumn' id='jsplannerresourcecolumn' style='width:" + (this.options.resourceColumnWidth - 1) + "px;left:0px'>"; //resource column
                    srcHTML += "</div>"; //resource column

                    srcHTML += "<div id='jsplannerappointmentcontainer' class='jsplannerappointmentcontainer' style='width:" + (containerwidth-16 ) + "px'>"; //main appointment area container
                    srcHTML += "<div id='jsplannerappointmentarea' class='jsplannerappointmentarea' oncontextmenu='return false;'>";// style='height:" + this.options.resourceAreaHeight + "px;width:" + timelinewidth + "px;margin-left:" + parseInt(((timelinewidth / 2) * -1) ) + "px'>"
                    
                    srcHTML +="<div class='jsplannerAppointmentAreaCopyBox' id='jsplannerAppointmentAreaCopyBox'>Copy Target<br>Left-Click to Confirm<br>Right-Click to Cancel</div>";
                    srcHTML +="<div class='jsplannerTimeEditIndicator' id='jsplannerAppointmentStartIndicator' style='display:none'></div>";
                    srcHTML +="<div class='jsplannerTimeEditIndicator' id='jsplannerAppointmentEndIndicator' style='display:none'></div>";
                    srcHTML +="<div class='jsplannerAppointmentTooltip' id='jsplannerAppointmentTooltip'></div>";
                    //srcHTML += "<canvas id='appointmentareacanvas' height='1000px' width='1000px' style='position:relative;top:0px;left:0px;'></canvas>"
                    srcHTML += "</div>"; //main appointment area container

                    srcHTML += "</div>"
                    srcHTML += "</div>"; //bodycontainer
                    //END RENDER BODY

                    srcHTML += "</div>"; //jsplannercontainer
                    //END RENDER COMPONENT

                    this.element.html(srcHTML);
                }

                this._resetResourceColumn();

                this._resetTimeLine();
                $(".jsplannerresourcecolumnitem").unbind();
                $(".jsplannerresourcecolumnitem").click(function(event) {
                    event.stopPropagation();
                });
                $(".jsplannerresourcecolumngroup").unbind();
                $(".jsplannerresourcecolumngroup").click(function(event) {
                    $(this).toggleClass('jsplannerresourcecolumnheadsmall', 0, function() {});
                    if ($(this).hasClass('jsplannerresourcecolumnheadsmall')) {
                        $(this).css("height", plannercontext.options.resourceHeaderRowHeight);
                    } else {
                        $(this).css("height", "100%");
                    }

                    plannercontext._saveHiddenResources
                    plannercontext._renderTimelineHorizontalRows();
                });

                $('.jsplannerbodycontainer').perfectScrollbar('destroy');
                $('.jsplannerbodycontainer').perfectScrollbar();
                if (this.options.isTimelineCompression==-1){
                    $('#scaleslider').slider({
                        value: plannercontext.options.compressedTimelineScale,
                        min: 0.002,
                        max: 0.05,
                        step: 0.002,
                        stop: function(event, ui) {
                            plannercontext._setOption("compressedTimelineScale", ui.value);
                            plannercontext._setOption("exclusionschange",true);
                            plannercontext._setOption("timelineArray",[])
                            plannercontext._resetTimeLine();
                            plannercontext._saveOptions();
                        }
                    });                        
                }else{
                    $('#scaleslider').slider({
                        value: plannercontext.options.timeLineScale,
                        min: 0.011,
                        max: 0.3,
                        step: 0.005,
                        stop: function(event, ui) {
                            plannercontext._setOption("timeLineScale", ui.value);
                            plannercontext._resetTimeLine();
                            if (ui.value < 0.4) {
                                $(".jsplannertimelineTextmarker").addClass("jsplannertimelinetinytext");
                                //$(".jsplannertimelineDayTextmarker").addClass("jsplannertimelinetinytext")
                                plannercontext._saveOptions
                            }
                        }
                    });
                }


                $("#jsplannerdatepicker").hide();
                $("#plannerbutton").click(function(){
                    var correctedoffset=$("#plannerbutton").offset();
                    correctedoffset.top+=$("#plannerbutton").height()+10;
                    $("#jsplannerdatepicker").offset(correctedoffset);
                    $("#jsplannerdatepicker").show();

                }); 


                $("#jsplannerdatepicker").datepicker({ 
                    dateFormat: 'dd/mm/yy',
                    beforeShow: function() {
                        setTimeout(function() {
                            $('.ui-datepicker').css('z-index', 99999999999999);
                        }, 0);
                    }
                });


                
                $("#jsplannerdatepicker").change(function() {
                    $("#jsplannerdatepicker").hide();
                    var dateentered = $("#jsplannerdatepicker").val();
                    var e = new Date();
                    var d = new Date(dateentered.split("/")[2], dateentered.split("/")[1] - 1, dateentered.split("/")[0], 0, 0);
                    plannercontext._setOption("currentTime", Math.floor(d.getTime() / 1000));
                    plannercontext._setOption("exclusionschange",true);                    
                    plannercontext._setOption("timelineArray",[]);
                    plannercontext._renderControl(true);
                    plannercontext._debugVisibleGroups();
                });

                $("#jsplannerplus24h").unbind();
                $("#jsplannerplus24h").click(function() {
                    if (plannercontext.options.isTimelineCompression){
                        plannercontext._UpdateVisibleTimelineArray(plannercontext._getAverageTimelineSectionWidth()*-1)  
                        plannercontext._resetTimeLine();             
                    }else{
                        plannercontext._setOption("currentTime", plannercontext.options.currentTime + 86400);
                        plannercontext._renderControl(true);                        
                    }
                });

                $("#calendaroptions").unbind();
                $("#calendaroptions").click(function() {
                    plannercontext._trigger("optionsButton",null,plannercontext.options)
                });


                $("#jsplannerminus24h").unbind();
                $("#jsplannerminus24h").click(function() {
                    if (plannercontext.options.isTimelineCompression){
                        plannercontext._UpdateVisibleTimelineArray(plannercontext._getAverageTimelineSectionWidth())  
                        plannercontext._resetTimeLine();             
                    }else{                    
                        plannercontext._setOption("currentTime", plannercontext.options.currentTime - 86400);
                        plannercontext._renderControl(true);
                    }
                });

                $("#jsplannerplus1w").unbind();
                $("#jsplannerplus1w").click(function() {
                    if (plannercontext.options.isTimelineCompression){
                        plannercontext._UpdateVisibleTimelineArray(plannercontext._getAverageTimelineSectionWidth()*-plannercontext.options.timelineDaysPerWeek)  
                        plannercontext._resetTimeLine(true);
                    }else{                    
                        plannercontext._setOption("currentTime", plannercontext.options.currentTime + 604800);
                        plannercontext._renderControl(true);    
                    }                

                    
                });
                $("#jsplannerminus1w").unbind();
                $("#jsplannerminus1w").click(function() {
                    if (plannercontext.options.isTimelineCompression){
                        plannercontext._UpdateVisibleTimelineArray(plannercontext._getAverageTimelineSectionWidth()*plannercontext.options.timelineDaysPerWeek)  
                        plannercontext._resetTimeLine();
                    }else{                       
                        plannercontext._setOption("currentTime", plannercontext.options.currentTime - 604800);
                        plannercontext._renderControl(true);
                    }
                });

            
        }, //end rendercontrol
        _loadAndSetHiddenResources: function(){
            var headerHeight = this.options.resourceHeaderRowHeight;
            if (this._readcookie("jsplannerhiddenresources")!=null && this._readcookie("jsplannerhiddenresources")!=""){
                var hiddenResources=this._readcookie("jsplannerhiddenresources").split(",");
                for (var i= 0; i< hiddenResources.length;i++) {
                    $("#"+hiddenResources[i]).addClass("jsplannerresourcecolumnheadsmall");
                        if( $("#"+hiddenResources[i]).hasClass('jsplannerresourcecolumnheadsmall')) {
                        $("#"+hiddenResources[i]).css("height", headerHeight);
                    } else {
                        $("#"+hiddenResources[i]).css("height", "100%");
                    }    
                }
            }
        },
        _saveHiddenResources: function(){
            var hiddenlist=[];
            $("#jsplannerresourcecolumn").children('.jsplannerresourcecolumnheadsmall').each(function () {

                hiddenlist.push($(this).attr("id"));
            });
            this._savecookie("jsplannerhiddenresources",hiddenlist.toString());
        },

        _getControlPanelContent: function() { //adds the controlpanel html (top left corner box controls)
            var strHTML = "";
            strHTML += "";
            strHTML += "<div class='planner-button-1' style='height:35px;width:198px;font-size: 14px;padding-left:5px; line-height:12px'><div id='scaleslider' style='width:110px;left:80px;top:12px;' ></div>Time Scale</div>";
            strHTML += "<div id='calendaroptions' class='clusterbutton planner-button-2' style='height:32px;width:99px;float:right'><div style='margin-top:10px;line-height:12px'>Options</div></div>";//options
            strHTML += "<div id='plannerbutton' class='clusterbutton planner-button-3' style='height:32px;width:99px;' ><div style='margin-top:10px;line-height:12px'>Go To Date</div></div>"; //go to date

            strHTML += "<div id='jsplannerplus1w' class='clusterbutton planner-button-4' style='height:33px;width:49px;float:right' ><div style='margin-top:5px;line-height:12px'>Week<br><i class='fa fa-long-arrow-right' style='line-height:15px;font-size:16px;width:30px;text-align: center;'></i></div></div>"; //week -
            strHTML += "<div id='jsplannerplus24h' class='clusterbutton planner-button-5' style='height:33px;width:50px;float:right' ><div style='margin-top:5px;line-height:12px'>Day<br><i class='fa fa-long-arrow-right' style='line-height:15px;font-size:16px;width:30px;text-align: center;'></i></div></div>"; //day -
            strHTML += "<div id='jsplannerminus24h'class='clusterbutton planner-button-6' style='height:33px;width:48px;float:right' ><div style='margin-top:5px;line-height:12px'>Day<br><i class='fa fa-long-arrow-left' style='line-height:15px;font-size:16px;width:30px;text-align: center;'></i></div></div>";//day+
            strHTML += "<div id='jsplannerminus1w' class='clusterbutton planner-button-7' style='height:33px;width:51px'><div style='margin-top:5px;line-height:12px'>Week<br><i class='fa fa-long-arrow-left' style='line-height:15px;font-size:16px;width:30px;text-align: center;'></i></div></div>";//week +

            return strHTML;
        },

        _resetResourceColumn: function() { //redraws the resources column from the resource objects

            var containerwidth = (this.element.width() - this.options.resourceColumnWidth - 1);
            var bodyheight = this.element.height() - this.options.timeLineHeight - 2;
            var resourceData;
            var resourceQuery = [];
            var resultsobj;
            var currentGroupName = "";
            var plannercontext = this;
            resourceData = this.options.resourceData;

            if (resourceData.length!=0){
                var i = 0;
                var j = 0;
                var jsonResourceData = "";
                var srcHTMLRows = "";
                resultsobj = jQuery.parseJSON(resourceData);

                var resourceAreaHeight = 0;
                var headerHeight = this.options.resourceHeaderRowHeight;
                var lineHeight = this.options.resourceLineRowHeight;
                srcHTMLRows += "<div class='headercolumntopspacer'></div>"; //add resource column group
                for (j = 0; j < resultsobj.length; j++) {
                    var queryobj = resultsobj[j];
                    if (queryobj[0] !== undefined) {
                        currentGroupName = queryobj[0].resourcetype;
                        resourceAreaHeight += headerHeight;

                        srcHTMLRows += "<div class='jsplannerresourcecolumngroup' id='jsplannerresourcecolumngroupid" + currentGroupName + "' >"; //add resource column group
                        srcHTMLRows += "<div class='jsplannerresourcecolumngroupheader' style='height:" + (headerHeight) + "px' >" + currentGroupName + "</div>"; //add resource column group

                        for (k = 0; k < queryobj.length; k++) {
                            obj = queryobj[k];
                            srcHTMLRows += "<div class='jsplannerresourcecolumnitem' id='" + obj.resourceid.replace("&", "¬") + "' resourcename='" + obj.resourcename + "' engineerid='" + obj.engineerid + "' style='width:" + (this.options.resourceColumnWidth-1) + "px;height:" + (lineHeight) + "px'>" + obj.resourcename + "</div><br>"; //resource column item
                            resourceAreaHeight += lineHeight;
                        }

                        srcHTMLRows += "</div>"; //end resource column group
                    }
                }
                this._setOption("resourceAreaHeight", resourceAreaHeight);

                $("#jsplannerappointmentarea").css('height',resourceAreaHeight+"px");
                $("#jsplannerresourcecolumn").html(srcHTMLRows);

                this._loadAndSetHiddenResources();
            }
        },

        _resetTimeLine: function() { //redraws the timeline
            var plannercontext = this;



            $("#jsplannertimeline").css("left","0px");            
            $("#jsplannerappointmentarea").css("left","0px");  


            if (resourcedata!={}){

                    this._renderTimelineHorizontalRows();   
                    this._renderTimeline(false,true);
                    this._renderTimeline(true,true)

                    //set up the timeline dragging
                    if (this.options.draginit==0 ){
                        $("#jsplannertimeline").unbind();
                        $("#jsplannertimeline").draggable({
                            axis: 'x'
                        });
                        $("#jsplannerappointmentarea").unbind();
                        $("#jsplannerappointmentarea").draggable({
                            axis: 'x'
                        });
                        $("#jsplannerappointmentarea").draggable("disable");

                        $("#jsplannertimeline").on("dragstop", function(event, ui) {
                            if (plannercontext.options.isTimelineCompression==-1){
                                plannercontext._UpdateVisibleTimelineArray(ui.position.left);
                            }else{
                                plannercontext._setOption("currentTime", plannercontext._getCenterTimeFromPixelOffset(ui.position.left));
                            }
                            plannercontext._resetTimeLine();
                        });

                        $("#jsplannertimeline").on("drag", function(event, ui) {
                            $("#jsplannerappointmentarea").css("left", ui.position.left);
                            



                        });
                        this._setOption("draginit",1);
                    }


                    if (this.options.timeLineScale < 0.4) {
                        $(".jsplannertimelineTextmarker").addClass("jsplannertimelinetinytext");
                    }

            }
        },

        _getCurrentDayStart: function() {
            var d = new Date();
            d.setHours(0);
            d.setMinutes(0);
            d.setSeconds(0);
            return( Math.floor(d.getTime() / 1000) );           
        },

        _drawTimelineMarker: function(canvasobj,markerx) { //provides data to _resettimeline
            var ctx=canvasobj.getContext("2d");
            ctx.fillStyle=this.options.timelineLineColor;
            ctx.fillRect(markerx,90,1,10) 
        },  

        _drawTimelineDivider: function(canvasobj,y) { //provides data to _resettimeline
            var ctx=canvasobj.getContext("2d");
            ctx.fillStyle=this.options.timelineLineColor;
            ctx.fillRect(0,y,canvasobj.width,1)
        },

        _drawTimelineTextMarkerLeft: function(canvasobj,markerx,text,fontsize) { //provides data to _resettimeline
            var ctx=canvasobj.getContext("2d");
            ctx.fillStyle=this.options.timelineTextColor;
            ctx.textAlign="left"
            ctx.font=fontsize +"px";
            ctx.fillText(text,markerx,85); 
        }, 

        _drawTimelineTextMarkerRight: function(canvasobj,markerx,text,fontsize) { //provides data to _resettimeline
            var ctx=canvasobj.getContext("2d");
            ctx.fillStyle=this.options.timelineTextColor;
            ctx.textAlign="right"
            ctx.font=fontsize +"px";
            ctx.fillText(text,markerx,85); 
        }, 

        _drawTimelineTextMarker: function(canvasobj,markerx,text,fontsize) { //provides data to _resettimeline
            var ctx=canvasobj.getContext("2d");
            ctx.fillStyle=this.options.timelineTextColor;
            ctx.textAlign="center"
            ctx.font=fontsize +"px";
            ctx.fillText(text,markerx,85); 
        },

        _drawTimelineDayTextMarker: function(canvasobj,markerx,text,fontsize) { //provides data to _resettimeline
            var ctx=canvasobj.getContext("2d");
            ctx.fillStyle=this.options.timelineTextColor;            
            ctx.textAlign="center"
            ctx.font=fontsize +"px";
            ctx.fillText(text,markerx,55); 
        },

       _drawTimelineMonthTextMarker: function(canvasobj,markerx,text,fontsize) { //provides data to _resettimeline
            var ctx=canvasobj.getContext("2d");
            ctx.fillStyle=this.options.timelineTextColor;            
            ctx.textAlign="center"
            ctx.font=fontsize +"px";
            ctx.fillText(text,markerx,20); 
        }, 

        _drawTimelineDayMarker: function(canvasobj,markerx) { //provides data to _resettimeline
            var ctx=canvasobj.getContext("2d");
            ctx.fillStyle=this.options.timelineTextColor;            
            ctx.fillRect(markerx,34,1,33) ;
        },  

        _drawTimelineMonthMarker: function(canvasobj,markerx) { //provides data to _resettimeline
            var ctx=canvasobj.getContext("2d");
            ctx.fillStyle=this.options.timelineTextColor;            
            ctx.fillRect(markerx,0,1,34) ;
        },    

        _drawAppointmentAreaTimelineMarker: function(canvasobj,markerx,height) { //provides data to _resettimeline
            var ctx=canvasobj.getContext("2d");
            ctx.fillStyle=this.options.appointmentAreaLineColor;        
            ctx.fillRect(markerx,1,1,height) ;
        }, 

        _drawAppointmentAreaHorizontalDivider: function(canvas,yposition){
            if (canvas!=null){
                var ctx=canvas.getContext("2d")
                ctx.fillStyle=this.options.appointmentAreaLineColor;
                ctx.fillRect(0,yposition,canvas.width,1);
            }
        },  

        _drawExclusionZone: function(canvas,xposition,zonewidth){
            if (canvas!=null){
                var ctx=canvas.getContext("2d")
                ctx.fillStyle=this.options.exclusionZoneColor;//main gray box
                ctx.fillRect(xposition,0,zonewidth,canvas.height);
                                  
            }
        },    
              
        _UpdateVisibleTimelineArray: function(xadjustment){
            var startx=0;
            var endx=0;
            var starttime=0;
            var endtime=0;
            var markertime=0;
            var plannercontext=this;
            if (plannercontext.options.timelineArray.length!=0){
                for (var i=0;i<plannercontext.options.timelineArray.length;i++){
                    plannercontext.options.timelineArray[i].pixelstart+=xadjustment;
                    plannercontext.options.timelineArray[i].pixelend+=xadjustment;
                }

                while (plannercontext.options.timelineArray[0].pixelend<0){//remove items from the front of the array which are now beyond the left boundary of the display
                    plannercontext.options.timelineArray.splice(0,1);
                }

                while (plannercontext.options.timelineArray[plannercontext.options.timelineArray.length-1].pixelstart>plannercontext.options.timelinewidth){//remove items from the end of the array which are beyond the right limit of the display.
                    plannercontext.options.timelineArray.splice(plannercontext.options.timelineArray.length-1,1);
                }       
                


                while (plannercontext.options.timelineArray[0].pixelstart>0){//we have a gap at the beginning of the array, so add items until it is filled.

                    markertime=plannercontext.options.timelineArray[0].starttime-1800;
                    startx=1;
                    endx=0;
                    starttime=0;
                    endtime=0;

                    while (startx>0){

                        if ( plannercontext._isTimeStartOfExclusionPeriod(markertime)==true && plannercontext._isTimeEndOfExclusionPeriod(markertime)==false){
                            //have found the end of the exclusion period, so set the endpoints
                            endtime=markertime;
                            endx=plannercontext.options.timelineArray[0].pixelstart-plannercontext.options.timelineCompressionGapSize;// figure is just the leftmost current visible group minus the standard gap.
     
                        }
                        if (plannercontext._isTimeEndOfExclusionPeriod(markertime)==true && plannercontext._isTimeStartOfExclusionPeriod(markertime)==false){
                            //we have encountered the start of our group so now set the end points and complete
       
                            starttime=markertime;
                            startx=endx- Math.floor((endtime-starttime)*plannercontext.options.compressedTimelineScale);
     
                            var timelineobj={"starttime":starttime,"endtime":endtime,"dayofweek":"dunno","pixelstart":startx,"pixelend":endx};
                            plannercontext.options.timelineArray.unshift (timelineobj);

                        }
                        markertime-=1800;
                    }
                }

                while (this.options.timelineArray[this.options.timelineArray.length-1].pixelend<this.options.timelinewidth){
                    markertime=this.options.timelineArray[this.options.timelineArray.length-1].endtime+1800;
                    startx=1;
                    endx=0;
                    starttime=0;
                    endtime=0;
                    while (endx<this.options.timelinewidth){
                        if ( this._isTimeEndOfExclusionPeriod(markertime)==true && this._isTimeStartOfExclusionPeriod(markertime)==false){
                            //have found the start of the visible, so set the endpoints
                            starttime=markertime;
                            startx=this.options.timelineArray[this.options.timelineArray.length-1].pixelend+this.options.timelineCompressionGapSize;//this figure is just the righttmost current visible group plus the standard gap.
                        }
                        if (this._isTimeStartOfExclusionPeriod(markertime)==true && this._isTimeEndOfExclusionPeriod(markertime)==false){
                            //we have encountered the end of our group so now set the end points and complete
                            endtime=markertime;
                            endx=startx+ Math.floor((endtime-starttime)*this.options.compressedTimelineScale);
                            var timelineobj={"starttime":starttime,"endtime":endtime,"dayofweek":"dunno","pixelstart":startx,"pixelend":endx};
                            this.options.timelineArray.push (timelineobj);
                        }
                        markertime+=1800;
                    }
                    
                }

            }//count array 0
   
        },

        _createVisibleTimelineArray: function(){
            //generates an array of visible timelines for comparing when clicks are made and for rendering purposes.
            var centertime = Math.floor(this.options.currentTime);

            var sectionStartTime =centertime;
            var sectionEndTime=0;
            var sectionDayOfWeek="";
            var sectionStartX=0;
            var sectionEndX=0;
            var centralOffset=0;
            var currentXposition=Math.floor(this.options.timelinewidth/3);//start the x position at dead center in the timeline.

            if (this.options.exclusions.length==0){
                this.options.timelineArray=({"starttime":centertime-Math.floor((this.options.timelinewidth/3)*this.options.compressedTimelineScale),"endtime":centertime+Math.floor((this.options.timelinewidth/2)*this.options.compressedTimelineScale),"dayofweek":"","pixelstart":0,"pixelend":this.options.timelinewidth});
            }else{
                if (this.options.exclusionschange==false&&this.options.preparedcentertime==centertime){
                    //we have already calculated visible times for this so skip
                }else{
                    this._setOption("exclusionschange",false);
                    this._setOption("preparedcentertime",centertime);

                    this.options.timelineArray=[];//clear any current data in the timeline array
                    var i = centertime;
                    //need to generate this array in 2 parts, half going forward through time, and half going backwards.
                    while ((i) % 1800 !== 0) {
                        i++;
                    } //once here we've got the the frist halfhour marker on our timeline

                    this._setOption("timelineCompressionGapSize",Math.floor((this.options.timelineCompressionGapSizeDefault/100)*(this.options.compressedTimelineScale/ (0.05-0.002)*100)));
                    var markertime=i;
                    currentXposition=Math.floor(this.options.timelinewidth/3)+this.options.timelineHardOffset;
                    //start generating the visible timeline array here
                    while (sectionEndX<this.options.timelinewidth){
                        markertime+=1800;
                        if (this._isTimeStartOfExclusionPeriod(markertime)==true && this._isTimeEndOfExclusionPeriod(markertime)==false){
                            //we have found the start of an exclusion period so mark our current figures into the array.
                            sectionEndTime=markertime;
                            sectionStartX=currentXposition;
                            sectionEndX=sectionStartX+Math.floor((sectionEndTime-sectionStartTime)*this.options.compressedTimelineScale);
                            var timelineobj={"starttime":sectionStartTime,"endtime":sectionEndTime,"dayofweek":sectionDayOfWeek,"pixelstart":sectionStartX,"pixelend":sectionEndX};
                            this.options.timelineArray.push (timelineobj);
                            currentXposition=sectionEndX;
                            currentXposition+=this.options.timelineCompressionGapSize;//add 100 pixels as a buffer zone for now.
                        }
                        if(this._isTimeEndOfExclusionPeriod(markertime)==true){
                            sectionStartTime=markertime;
                        }
                    }

    
                    //now we have our timeline going forward through time from center, now calculate the one going backwards.


                    i=centertime;
                    while ((i) % 1800 !== 0) {
                        i--;
                    }
                         
                    currentXposition=Math.floor(this.options.timelinewidth/3)+this.options.timelineHardOffset-this.options.timelineCompressionGapSize;
                    sectionStartX=currentXposition;

                    sectionEndTime=i;
                    markertime=i;
                    while (sectionStartX>0){
                        markertime-=1800;
                        if (this._isTimeEndOfExclusionPeriod(markertime)==true && this._isTimeStartOfExclusionPeriod(markertime)==false){
                            //we have found the start of an exclusion period so mark our current figures into the array.
                            sectionStartTime=markertime;
                            sectionEndX=currentXposition;
                            sectionStartX=sectionEndX-(Math.floor((sectionEndTime-sectionStartTime)*this.options.compressedTimelineScale));
                            var timelineobj={"starttime":sectionStartTime,"endtime":sectionEndTime,"dayofweek":sectionDayOfWeek,"pixelstart":sectionStartX,"pixelend":sectionEndX};
                            this.options.timelineArray.unshift (timelineobj);
                            currentXposition=sectionStartX;
                            currentXposition-=this.options.timelineCompressionGapSize;//add 100 pixels as a buffer zone for now.
                        }
                        if(this._isTimeStartOfExclusionPeriod(markertime)==true){
                            sectionEndTime=markertime;
                        }
                    }
                    //now we should have our full timeline (fingers crossed)

                }

            }
        },

        _renderTimeLineBufferZone: function (canvas,startx,endx){
            if (startx<0 || endx<0||startx>this.options.timelinewidth||endx>this.options.timelinewidth){
                //something is asking us to render outside the visible area so ignore it.
            }else{
                    var ctx=canvas.getContext("2d");
                    ctx.fillStyle=this.options.exclusionZoneColor;
                    ctx.fillRect(startx,0,(endx-startx),canvas.height);
                    ctx.fillStyle="#555555";
                    ctx.fillRect(startx,0,1,canvas.height);  //left bounding line
                    ctx.fillRect(endx,0,1,canvas.height);  //right bounding line                         
            }
        },

        _renderTimeLineTopBufferZone: function (startx,endx){
            if (startx<0 || endx<0||startx>this.options.timelinewidth||endx>this.options.timelinewidth){
                //something is asking us to render outside the visible area so ignore it.
            }else{
                targetcanvas=document.getElementById("timelinecanvas");
                if (targetcanvas!=null){
                    var ctx=targetcanvas.getContext("2d")
                    ctx.fillStyle=this.options.exclusionZoneColor;
                    ctx.fillRect(startx,34,(endx-startx),70);
                    ctx.fillStyle="#555555";
                    ctx.fillRect(startx,34,1,70);  //left bounding line
                    ctx.fillRect(endx,34,1,70);  //right bounding line                     
                }
            }
        },

        _renderTimeline: function(bappointmentareamode,bRenderMode) { //provides data to _resettimeline
            var containerwidth = (this.element.width() - this.options.resourceColumnWidth);
            var timelinewidth = containerwidth *3;
            var timelinescale = this.options.timeLineScale;
            var centertime = Math.floor(this.options.currentTime);
            var targetcanvas=null;
            var lefttime = parseInt(centertime - (86400 / timelinescale)); //find out the extremities of our timeline scale
            var righttime = parseInt(centertime + (86400 / timelinescale));
            this._setOption("lefttime", lefttime);
            this._setOption("righttime", righttime);
            this._setOption("pixelpersecond", timelinewidth / (righttime - lefttime));
            this._setOption("timelinewidth", timelinewidth);
            //console.log("center:" +centertime+ " left:"+ lefttime+ " r:"+righttime+ " timelinewidth:" +timelinewidth + " scale:"+timelinescale+ " pps:" +  timelinewidth / (righttime - lefttime))
            var plannercontext = this;
            var srcHTML = "";


            //check if the timeline canvas is present and if so that it is the correct width. Then clear its content.
            if (bappointmentareamode==false){
                if($("#jsplannertimeline").width()!=timelinewidth){
                    $("#jsplannertimeline").css("width",timelinewidth);
                    $("#jsplannertimeline").css("margin-left" , (parseInt(timelinewidth / 3) * -1) );
                }
                targetcanvas=document.getElementById("timelinecanvas");
                if(targetcanvas!=null){
                    if (targetcanvas.width!=timelinewidth){
                        targetcanvas.width=timelinewidth;
                    }                        
                    var ctx=targetcanvas.getContext("2d")
                    ctx.clearRect(0, 0, timelinewidth, this.options.timeLineHeight);  
                }
            }else{

                if($("#jsplannerappointmentarea").width()!=timelinewidth){
                    $("#jsplannerappointmentarea").css("width",timelinewidth);
                    $("#jsplannerappointmentarea").css("margin-left" , (parseInt(timelinewidth / 3) * -1) );
                }

                targetcanvas==null;
                $('#jsplannerappointmentarea').children('.jsplannerAppointmentAreaRowCanvas').each(function () {
                    if (targetcanvas==null){
                        targetcanvas=this;
                    }
                });


                if (targetcanvas!=null){
                    targetcanvas.width=timelinewidth;
                    var ctx=targetcanvas.getContext("2d")
                    ctx.clearRect(0, 0, timelinewidth, this.options.resourceAreaHeight);  
          
              
                }                 
                /*targetcanvas=document.getElementById("appointmentareacanvas");

                if (targetcanvas!=null){

                    if (targetcanvas.width!=timelinewidth){
                        targetcanvas.width=timelinewidth;
                    }
                    var ctx=targetcanvas.getContext("2d")
                    ctx.clearRect(0, 0, timelinewidth, this.options.resourceAreaHeight);  
                } */  
                
            }
            if (this.options.isTimelineCompression==-1){


                //================YOU ARE ENTERING HELL ON EARTH=======================
                //======================THE PAIN STARTS HERE===========================
                //render timelines for timeline compression mode


                //console.log (this.options.timelineArray);
                //this._debugVisibleGroups();

                if (this.options.timelineArray.length>0){
                     //we need to generate our initial timelineArray.
                }else{
                    //we don't need to do anything here, the timeline array has already been adjusted
                     this._createVisibleTimelineArray();
                }


                lefttime=this._deriveTimeFromPixelPosition(0);
                righttime=this._deriveTimeFromPixelPosition(this.options.timelinewidth);

                if (righttime==0){//this is here for a fringe case caused by resizing where the timeline is not properly recalculated before the render resulting in a blank timeline.
                    this._setOption( "exclusionschange",true);
                    this._createVisibleTimelineArray();
                    lefttime=this._deriveTimeFromPixelPosition(0);
                    righttime=this._deriveTimeFromPixelPosition(this.options.timelinewidth);
                }

 
                this._setOption("lefttime", lefttime);
                this._setOption("righttime", righttime);
                //this._setOption("pixelpersecond", timelinewidth / (righttime - lefttime));

               i = lefttime;

                while (i % 1800 !== 0) {
                    i++;
               } //once here we've got the the frist hour marker on our timeline
                var markertime = i;


                if (bappointmentareamode === false) {

                    targetcanvas=document.getElementById("timelinecanvas");
                    if(targetcanvas!=null){
                        if (targetcanvas.width!=timelinewidth){
                            targetcanvas.width=timelinewidth;
                        }                        
                        var ctx=targetcanvas.getContext("2d")

                        ctx.clearRect(0, 0, timelinewidth, this.options.timeLineHeight); 



                        //day divider
                        this._drawTimelineDivider(targetcanvas,66);
                        //month divider
                        this._drawTimelineDivider(targetcanvas,34);
   

                        var leftposition=0;
                        for (var i=0;i<this.options.timelineArray.length;i++){//REnder the exclusion zones (as small buffer areas) first.
                            this._renderTimeLineTopBufferZone(leftposition,this.options.timelineArray[i].pixelstart);  
                            this._drawTimelineDayMarker(targetcanvas,leftposition);
                            this._drawTimelineDayMarker(targetcanvas,this.options.timelineArray[i].pixelstart);
                          
                            leftposition=this.options.timelineArray[i].pixelend;

                        }
                    }  


                }  else{
  
                    //this is where the appointment area render code will go

                   // $(".jsplannerAppointmentAreaRowCanvas").width=timelinewidth;
                    targetcanvas=null;

                    $('#jsplannerappointmentarea').children('.jsplannerAppointmentAreaRowCanvas').each(function () {
                        if (targetcanvas==null){
                            targetcanvas=this;
                        }
                    });


                    if (targetcanvas!=null){
                        targetcanvas.width=timelinewidth;
                        targetcanvas.height=this.options.resourceLineRowHeight;
                        var ctx=targetcanvas.getContext("2d")
                        ctx.clearRect(0, 0, timelinewidth, this.options.resourceAreaHeight);  
              
                        this._drawAppointmentAreaHorizontalDivider(targetcanvas,0);                      
                    } 



                   var leftposition=0;
                   if (targetcanvas!=null){
                       for (var i=0;i<this.options.timelineArray.length;i++){//REnder the exclusion zones (as small buffer areas) first.
                            this._renderTimeLineBufferZone(targetcanvas,leftposition,this.options.timelineArray[i].pixelstart);
                            leftposition=this.options.timelineArray[i].pixelend;
                       }
                    }
                }

                while (markertime <= righttime && targetcanvas!=null) { //timeline render
                    if(bappointmentareamode===false){
                        if(this._isTimestampInVisibleGroup(markertime)){

                            if (this.options.compressedTimelineScale<=0.024 && this.options.compressedTimelineScale>0.008){

                                this._drawTimelineMarker(targetcanvas,plannercontext._derivePixelPositionFromTime(markertime));
                                if (markertime % 3600==0 && this._isTimestampEndOfVisibleGroup(markertime)==false && this._isTimestampStartOfVisibleGroup(markertime)==false ) {
                                    this._drawTimelineTextMarker(targetcanvas,plannercontext._derivePixelPositionFromTime(markertime),plannercontext._getHoursFromTimestamp(markertime),10);
                                }
                                if (this._isTimestampEndOfVisibleGroup(markertime)==true) {
                                    this._drawTimelineTextMarkerRight(targetcanvas,plannercontext._derivePixelPositionFromTime(markertime),plannercontext._getOnlyHoursFromTimestamp(markertime),10);
                                }
                                if (this._isTimestampStartOfVisibleGroup(markertime)==true) {
                                    this._drawTimelineTextMarkerLeft(targetcanvas,plannercontext._derivePixelPositionFromTime(markertime),plannercontext._getOnlyHoursFromTimestamp(markertime),10);
                                }                                
                          
                                if (plannercontext._isHourClosestToCenterOfVisibleGroup(markertime)) {
                                    this._drawTimelineDayTextMarker(targetcanvas,plannercontext._derivePixelPositionFromTime(markertime),plannercontext._getDateFromTimestamp(markertime),10);
                                }


                            }else if(this.options.compressedTimelineScale<=0.008 && this.options.compressedTimelineScale>0.004){
                                this._drawTimelineMarker(targetcanvas,plannercontext._derivePixelPositionFromTime(markertime));
                                if (markertime % 3600==0 && this._isTimestampEndOfVisibleGroup(markertime)==false && this._isTimestampStartOfVisibleGroup(markertime)==false ) {
                                    this._drawTimelineTextMarker(targetcanvas,plannercontext._derivePixelPositionFromTime(markertime),plannercontext._getOnlyHoursFromTimestamp(markertime),10);
                                }
                                if (this._isTimestampEndOfVisibleGroup(markertime)==true) {
                                    this._drawTimelineTextMarkerRight(targetcanvas,plannercontext._derivePixelPositionFromTime(markertime),plannercontext._getOnlyHoursFromTimestamp(markertime),10);
                                }
                                if (this._isTimestampStartOfVisibleGroup(markertime)==true) {
                                    this._drawTimelineTextMarkerLeft(targetcanvas,plannercontext._derivePixelPositionFromTime(markertime),plannercontext._getOnlyHoursFromTimestamp(markertime),10);
                                }                                
                    
                                if (plannercontext._isHourClosestToCenterOfVisibleGroup(markertime)) {
                                    this._drawTimelineDayTextMarker(targetcanvas,plannercontext._derivePixelPositionFromTime(markertime),plannercontext._getDateFromTimestamp(markertime),10);
                                }
                            }else if(this.options.compressedTimelineScale<=0.004 && this.options.compressedTimelineScale>0.002){
                                if (markertime % 3600==0) { 
                                    this._drawTimelineMarker(targetcanvas,plannercontext._derivePixelPositionFromTime(markertime));
                                }
                               
                                if (plannercontext._isHourClosestToCenterOfVisibleGroup(markertime)) {
                                    this._drawTimelineDayTextMarker(targetcanvas,plannercontext._derivePixelPositionFromTime(markertime),plannercontext._getDateFromTimestamp(markertime),10);
                                }                               
                                testHour = plannercontext._getHoursFromTimestamp(markertime);                            
                               if (testHour == "10:00"||testHour == "12:00" || testHour == "14:00"|| testHour == "16:00") {
                                    this._drawTimelineTextMarker(targetcanvas,plannercontext._derivePixelPositionFromTime(markertime),plannercontext._getOnlyHoursFromTimestamp(markertime),10);
                                } 
                           }else if(this.options.compressedTimelineScale<=0.002 ){
                                if (markertime % 3600==0 && plannercontext._getOnlyHoursFromTimestamp(markertime) % 2 === 0) { 
                                    this._drawTimelineMarker(targetcanvas,plannercontext._derivePixelPositionFromTime(markertime));
                                }
                               
                                if (plannercontext._isHourClosestToCenterOfVisibleGroup(markertime)) {
                                    this._drawTimelineDayTextMarker(targetcanvas,plannercontext._derivePixelPositionFromTime(markertime),plannercontext._getTinyDateFromTimestamp(markertime),10);
                                }                               
                                testHour = plannercontext._getHoursFromTimestamp(markertime);                            
                               if (testHour == "10:00"||testHour == "12:00" || testHour == "14:00"|| testHour == "16:00") {
                                    this._drawTimelineTextMarker(targetcanvas,plannercontext._derivePixelPositionFromTime(markertime),plannercontext._getOnlyHoursFromTimestamp(markertime),10);
                                }  
                            }else{
                                this._drawTimelineMarker(targetcanvas,plannercontext._derivePixelPositionFromTime(markertime));
                                this._drawTimelineTextMarker(targetcanvas,plannercontext._derivePixelPositionFromTime(markertime),plannercontext._getHoursFromTimestamp(markertime),10);
                                if (plannercontext._isHourClosestToCenterOfVisibleGroup(markertime)) {
                                    this._drawTimelineDayTextMarker(targetcanvas,plannercontext._derivePixelPositionFromTime(markertime),plannercontext._getDateFromTimestamp(markertime),10);
                                }

                            }


                            //this hour is in a visible group so add an hour marker




                        }                        
                    }else{
                        //render the hour markers on the timeline

                        if (this._isTimestampEndOfVisibleGroup(markertime)==false && this._isTimestampStartOfVisibleGroup(markertime)==false  &&  this._isTimestampInVisibleGroup(markertime)==true){

                            if(this.options.compressedTimelineScale<=0.002 ){
                            
                                if (markertime % 3600==0 && plannercontext._getOnlyHoursFromTimestamp(markertime) % 2 === 0) {
                                    plannercontext._drawAppointmentAreaTimelineMarker(targetcanvas,plannercontext._derivePixelPositionFromTime(markertime),this.options.resourceLineRowHeight);
                                }
                            }else{
                                plannercontext._drawAppointmentAreaTimelineMarker(targetcanvas,plannercontext._derivePixelPositionFromTime(markertime),this.options.resourceLineRowHeight);
                            }
                        }
                    }


                    if (plannercontext._getIsTimestampMonthMarker(markertime) === true && bappointmentareamode==false) { //add markers for the months
                        this._drawTimelineMonthMarker(targetcanvas,plannercontext._derivePixelPositionFromTime(markertime));
                        this._drawTimelineMonthTextMarker(targetcanvas,plannercontext._derivePixelPositionFromTime(markertime + 1296000),plannercontext._getMonthMarkerText(markertime),10);
                    }
                    markertime+=1800;
                 
                }


                if (bappointmentareamode==true){

                    //we are at the end of our render now so duplicate the first line canvas to all the rest
                    $('#jsplannerappointmentarea').children('.jsplannerAppointmentAreaRowCanvas').each(function () {
                        if (this!=targetcanvas){
                        this.height=plannercontext.options.resourceLineRowHeight;
                        this.width=plannercontext.options.timelinewidth;
                        var ctx = this.getContext("2d");
                        ctx.drawImage(targetcanvas, 0, 0);
                        }
                    });
                }

               //========================END OF DANGER==================================




            }else{
                //render timeline with no compression on exclusions
                var i = 0;
                while ((lefttime + i) % 3600 !== 0) {
                    i++;
                } //once here we've got the the frist hour marker on our timeline

                var markertime = lefttime + i;

                while (markertime <= righttime && targetcanvas!=null) { //timeline render
                    if (bappointmentareamode === false) {
                        if (markertime % 3600 === 0) {

                            var testHour=0;
                            if (timelinescale >= 0.3) { //full size render
                                this._drawTimelineMarker(targetcanvas,plannercontext._derivePixelPositionFromTime(markertime));
                                this._drawTimelineTextMarker(targetcanvas,plannercontext._derivePixelPositionFromTime(markertime),plannercontext._getHoursFromTimestamp(markertime),10);
                                testHour = plannercontext._getHoursFromTimestamp(markertime);
                                if (testHour == "12:00" || testHour == "18:00" || testHour == "06:00") {
                                    this._drawTimelineDayTextMarker(targetcanvas,plannercontext._derivePixelPositionFromTime(markertime),plannercontext._getDateFromTimestamp(markertime),10);
                                }
                                if (testHour == "00:00") {
                                    this._drawTimelineDayMarker(targetcanvas,plannercontext._derivePixelPositionFromTime(markertime));
                                }
                            } else if (timelinescale < 0.3 && timelinescale >= 0.15) { //smaller render
                                this._drawTimelineMarker(targetcanvas,plannercontext._derivePixelPositionFromTime(markertime));
                                if (plannercontext._getOnlyHoursFromTimestamp(markertime) % 2 === 0) { //getting smaller so only mark even hours
                                    this._drawTimelineTextMarker(targetcanvas,plannercontext._derivePixelPositionFromTime(markertime),plannercontext._getHoursFromTimestamp(markertime),10);
                                }
                                testHour = plannercontext._getHoursFromTimestamp(markertime);
                                if (testHour == "12:00") { //only display day marker once from now on
                                    this._drawTimelineDayTextMarker(targetcanvas,plannercontext._derivePixelPositionFromTime(markertime),plannercontext._getDateFromTimestamp(markertime),10);
                                }
                                if (testHour == "00:00") {
                                    this._drawTimelineDayMarker(targetcanvas,plannercontext._derivePixelPositionFromTime(markertime));
                                }
                            } else if (timelinescale < 0.15 && timelinescale >= 0.1) {
                                //want to snap hourly from now on
                                this._drawTimelineMarker(targetcanvas,plannercontext._derivePixelPositionFromTime(markertime));
                                if (plannercontext._getOnlyHoursFromTimestamp(markertime) % 2 === 0) { //getting smaller so only mark even hours
                                    this._drawTimelineTextMarker(targetcanvas,plannercontext._derivePixelPositionFromTime(markertime),plannercontext._getHoursFromTimestamp(markertime),10);
                                }
                                testHour = plannercontext._getHoursFromTimestamp(markertime);
                                if (testHour == "12:00") { //only display day marker once from now on
                                    this._drawTimelineDayTextMarker(targetcanvas,plannercontext._derivePixelPositionFromTime(markertime),plannercontext._getDateFromTimestamp(markertime),10);
                                }
                                if (testHour == "00:00") {
                                    this._drawTimelineDayMarker(targetcanvas,plannercontext._derivePixelPositionFromTime(markertime));
                                }
                            } else if (timelinescale < 0.1 && timelinescale >= 0.061) {
                                if (plannercontext._getOnlyHoursFromTimestamp(markertime) % 3 === 0) { //getting really small so want to show fewer timeline markers
                                    this._drawTimelineMarker(targetcanvas,plannercontext._derivePixelPositionFromTime(markertime));                                
                                }
                                if (plannercontext._getOnlyHoursFromTimestamp(markertime) % 6 === 0) { //getting smaller so only mark even hours
                                    this._drawTimelineTextMarker(targetcanvas,plannercontext._derivePixelPositionFromTime(markertime),plannercontext._getHoursFromTimestamp(markertime),10);
                                }
                                testHour = plannercontext._getHoursFromTimestamp(markertime);
                                if (testHour == "12:00") { //only display day marker once from now on
                                    this._drawTimelineDayTextMarker(targetcanvas,plannercontext._derivePixelPositionFromTime(markertime),plannercontext._getDateFromTimestamp(markertime),10);
                                }
                                if (testHour == "00:00") {
                                    this._drawTimelineDayMarker(targetcanvas,plannercontext._derivePixelPositionFromTime(markertime));
                                }
                            } else if (timelinescale < 0.061 && timelinescale >= 0.042) {
                                if (plannercontext._getOnlyHoursFromTimestamp(markertime) % 3 === 0) { //getting really small so want to show fewer timeline markers
                                    this._drawTimelineMarker(targetcanvas,plannercontext._derivePixelPositionFromTime(markertime));                                
                                }
                                if (plannercontext._getOnlyHoursFromTimestamp(markertime) % 6 === 0) { //getting smaller so only mark even hours
                                    this._drawTimelineTextMarker(targetcanvas,plannercontext._derivePixelPositionFromTime(markertime),plannercontext._getHoursFromTimestamp(markertime),10);
                                }
                                testHour = plannercontext._getHoursFromTimestamp(markertime);
                                if (testHour == "12:00") { //only display day marker once from now on
                                    this._drawTimelineDayTextMarker(targetcanvas,plannercontext._derivePixelPositionFromTime(markertime),plannercontext._getDateFromTimestamp(markertime),10);
                                }
                                if (testHour == "00:00") {
                                    this._drawTimelineDayMarker(targetcanvas,plannercontext._derivePixelPositionFromTime(markertime));
                                }
                            } else if (timelinescale < 0.042 && timelinescale >= 0.010) {
                                if (plannercontext._getOnlyHoursFromTimestamp(markertime) % 12 === 0) { //getting really small so want to show fewer timeline markers
                                    this._drawTimelineMarker(targetcanvas,plannercontext._derivePixelPositionFromTime(markertime));                                     
                                }
                                //if(plannercontext._getOnlyHoursFromTimestamp(markertime)%12==0){ //getting smaller so only mark even hours
                                //    srcHTML+="<div class='jsplannertimelineTextmarker' style='left:"+(plannercontext._derivePixelPositionFromTime(markertime)-20)+"px'>"+plannercontext._getOnlyHoursFromTimestamp(markertime)+"</div>";
                                // }
                                testHour = plannercontext._getHoursFromTimestamp(markertime);
                                if (testHour == "12:00") { //only display day marker once from now on
                                    this._drawTimelineDayTextMarker(targetcanvas,plannercontext._derivePixelPositionFromTime(markertime),plannercontext._getSmallestDateFromTimestamp(markertime),10);
                                }
                                if (testHour == "00:00") {
                                    this._drawTimelineDayMarker(targetcanvas,plannercontext._derivePixelPositionFromTime(markertime));
                                }
                            }
                        }
                        if (plannercontext._getIsTimestampMonthMarker(markertime) === true) { //add markers for the months
                            this._drawTimelineMonthMarker(targetcanvas,plannercontext._derivePixelPositionFromTime(markertime));
                            this._drawTimelineMonthTextMarker(targetcanvas,plannercontext._derivePixelPositionFromTime(markertime + 1296000),plannercontext._getMonthMarkerText(markertime),10);
                        }

                    } else {
                            //Render appointment area
                            this._renderExclusionZones(targetcanvas,markertime);    
                            this._drawAppointmentAreaHorizontalDivider(targetcanvas,1);        
                            if (markertime % 3600 === 0) {
                                if (timelinescale < 0.042 && timelinescale >= 0.010) {
                                    if (plannercontext._getOnlyHoursFromTimestamp(markertime) % 12 === 0) {
                                        plannercontext._drawAppointmentAreaTimelineMarker(targetcanvas,plannercontext._derivePixelPositionFromTime(markertime),this.options.resourceAreaHeight);
                                    }
                                } else if (timelinescale < 0.1 && timelinescale >= 0) { //these are the grey timeline markers in the main appointments area
                                    if (plannercontext._getOnlyHoursFromTimestamp(markertime) % 3 === 0) {
                                        plannercontext._drawAppointmentAreaTimelineMarker(targetcanvas,plannercontext._derivePixelPositionFromTime(markertime),this.options.resourceAreaHeight);
                                    }
                                } else {
                                        plannercontext._drawAppointmentAreaTimelineMarker(targetcanvas,plannercontext._derivePixelPositionFromTime(markertime),this.options.resourceAreaHeight);
                                }
                            }
                    }
                    markertime += 1800; //add  half an hour
                }
                if (bappointmentareamode==true){

                    //we are at the end of our render now so duplicate the first line canvas to all the rest
                    $('#jsplannerappointmentarea').children('.jsplannerAppointmentAreaRowCanvas').each(function () {
                        if (this!=targetcanvas){
                        this.width=plannercontext.options.timelinewidth;
                        var ctx = this.getContext("2d");
                        ctx.drawImage(targetcanvas, 0, 0);
                        }
                    });
                }                
                if (bappointmentareamode === false) {
                    //day divider
                    this._drawTimelineDivider(targetcanvas,66);
                    //month divider
                    this._drawTimelineDivider(targetcanvas,34);
                    srcHTML += "<div class='jsplannertimelinemarkerred' style='left:" + plannercontext._derivePixelPositionFromTime(Math.floor((new Date()).getTime() / 1000)) + "px'></div>";
                }
            }//end uncompressed timeline mode render

        },

        _renderExclusionZones: function(canvas,markertime) {
            var output = "";
            var plannercontext = this;
            var exclusions = [];
            exclusions = this.options.exclusions;
            for (var i in exclusions) {
                if (exclusions[i].startday == plannercontext._getDayOfWeek(markertime * 1000)) {
                    if (exclusions[i].starttime == plannercontext._getHoursFromTimestamp(markertime)) {
                        plannercontext._drawExclusionZone(canvas,plannercontext._derivePixelPositionFromTime(markertime),(plannercontext._derivePixelPositionFromTime(plannercontext._getExclusionEndTimestamp(markertime, exclusions[i].endtime, exclusions[i].endday, plannercontext)) - plannercontext._derivePixelPositionFromTime(markertime)))
                    }
                }
            }
        },


        _getExclusionEndTimestamp: function(markertime, exclusionEndTime, exclusionEndDay, plannercontext) {
            var d = new Date();
            var currentmarker = markertime * 1000;
            d.setTime(currentmarker); //add a day then set the hour of the end time
            while (plannercontext._getDayOfWeek(currentmarker) != exclusionEndDay) {
                currentmarker += 7200000;
                d.setTime(currentmarker);
            }
            d.setHours(exclusionEndTime.substr(0, 2));
            d.setMinutes(exclusionEndTime.substr(3, 2));
            return (d.getTime() / 1000);
        },

        _loadAndRenderPlannerEvents: function(resourcekey) { //loads the planner events and draws them on the widget

            var plannercontext = this;
            var lefttime = this.options.lefttime;
            var righttime = this.options.righttime;
            var lineHeight = this.options.resourceLineRowHeight;
            var centertime = Math.floor((new Date()).getTime() / 1000);
            var resourceKeyFilter = "";
            if (resourcekey !== undefined) {
                $("#jsplannerrowcontainer" + resourcekey).html("");
            }
            var dataqueries = this.options.plannerdatasource;



            if (lefttime!=undefined&&righttime!=undefined && lefttime != 0 && righttime != 0){
                for (var i = 0; i < dataqueries.length; i++) {
                    //dataqueries[i].additionalwhere= " AND " +dataqueries[i].starttime+">=" + lefttime + " AND " +dataqueries[i].endtime+ "<=" +righttime ;
                    dataqueries[i].additionalwhere = " AND ((" + dataqueries[i].starttime + ">=" + lefttime + " AND " + dataqueries[i].starttime + "<=" + righttime + ") OR (" + dataqueries[i].endtime + ">=" + lefttime + " AND " + dataqueries[i].endtime + "<=" + righttime + ") OR (" + dataqueries[i].starttime + "<" + lefttime + " AND " + dataqueries[i].endtime + ">" + righttime + "))";
                    if (resourcekey !== undefined) {
                        dataqueries[i].additionalwhere += " AND " + dataqueries[i].resourcekey + "='" + resourcekey + "'";
                    }
                    dataqueries[i].optionalfields=this.options.contractoptionalfields+this.options.maintenanceoptionalfields;
                }

                var appointmentcontent = "";
                $.ajax({
                    type: "POST",
                    url: "/appointments/get_list_json",
                    data: {
                        action: 'appointments',
                        queryparam: dataqueries
                    }
                }).done(function(resultsobj) {
                    var contractOptionalFields=plannercontext.options.contractoptionalfields.split(",");
                    var maintenanceOptionalFields=plannercontext.options.maintenanceoptionalfields.split(",");

                    var queryobj = resultsobj;

                    for (var k = 0; k < queryobj.length; k++) {
                        var jobleftpos=(plannercontext._derivePixelPositionFromTime(queryobj[k].starttime) + 1) ;
                        var jobrightpos=(plannercontext._derivePixelPositionFromTime(queryobj[k].endtime));
                        var textoffset=0;
                        if (jobleftpos<Math.floor(plannercontext.options.timelinewidth/3) && jobrightpos> Math.floor(plannercontext.options.timelinewidth/3)     ){
                            textoffset=Math.floor(plannercontext.options.timelinewidth/3)-jobleftpos;
                        }

                        if (queryobj[k].xidmjob == -1) {
                            //this is an appointment from a contract
                            appointmentcontent = "";
                            appointmentcontent = ("<div class='jsplannerAppointmentBox appointmentviolet' id='jsplannerevent" + queryobj[k].id + "' style='left:" + jobleftpos + "px;width:" + ((plannercontext._derivePixelPositionFromTime(queryobj[k].endtime) - plannercontext._derivePixelPositionFromTime(queryobj[k].starttime)) - 1) + "px;height:" + (lineHeight-1) + "px'>");
                            appointmentcontent += ("<div class='jsplannerleftappointmentdraganchor appointmentvioletanchorleft' id='jsplannerldrag" + queryobj[k].id + "'></div>");
                            appointmentcontent += ("<div class='jsplannerappointmenttext' style='margin-left:"+textoffset+"px'>");
                            //appointmentcontent += plannercontext._blankNulls(queryobj[k].jobno) + " - " + plannercontext._blankNulls(queryobj[k].longdescription)+"<br>";
                            for(var l=0;l<contractOptionalFields.length;l++){
                              if(contractOptionalFields[l]!=""){
                                appointmentcontent +="<span class='fa fa-square jsplannertextsectionseparator'></span><span class='jsplannerappointmenttextarea'>" + plannercontext._blankNulls(queryobj[k][contractOptionalFields[l]])+"</span>"; 
                              }
                            }
                            appointmentcontent += ("</div>");
                            appointmentcontent += ("<div class='jsplannerrightappointmentdraganchor appointmentvioletanchorright' id='jsplannerrdrag" + queryobj[k].id + "'></div>");
                            appointmentcontent += ("</div>");

                            $("#jsplannerrowcontainer" + queryobj[k].resourcekey.replace("&", "¬")).append(appointmentcontent);
                            plannercontext._setJobAreaListeners($("#jsplannerevent" + queryobj[k].id));
                            plannercontext._setJobAreaListeners($("#jsplannerldrag" + queryobj[k].id));
                            plannercontext._setJobAreaListeners($("#jsplannerrdrag" + queryobj[k].id));
                        } else {
                            //appointment from an mjob
                            appointmentcontent = "";
                            var duestring="";

                            var jojbleftpos=0;
                            var jobstylestring="green";
                            if ((queryobj[k].integrationstatus <= 3 && queryobj[k].starttime < centertime)) {
                                jobstylestring="red";
                                duestring="<div class='jsplanneroverduelabel'>Overdue. </div>";
                            } else if(queryobj[k].integrationstatus==4) {
                                jobstylestring="red";

                            } else {
                                var hoursbeforestart = Math.ceil(((queryobj[k].starttime) - centertime) / 3600);

                                if (hoursbeforestart <= plannercontext.options.appointmentduewarninghours && queryobj[k].integrationstatus <= 3) {
                                    jobstylestring="orange";                                    
                                    duestring = "<span style='color:#FF4C00'>Due in " + hoursbeforestart + " hours</span>";
                                    if (hoursbeforestart <= 1) {
                                        duestring = "<span style='color:orange'>Due within the hour</span>";
                                    }
                                }
                            }

                            appointmentcontent = ("<div class='jsplannerAppointmentBox appointment"+jobstylestring+"' id='jsplannerevent" + queryobj[k].id + "' style='left:" + jobleftpos + "px;width:" + ((plannercontext._derivePixelPositionFromTime(queryobj[k].endtime) - plannercontext._derivePixelPositionFromTime(queryobj[k].starttime)) - 1) + "px;height:" + (lineHeight-1) + "px'>");
                            appointmentcontent += ("<div class='jsplannerleftappointmentdraganchor appointment"+jobstylestring+"anchorright' id='jsplannerldrag" + queryobj[k].id + "'></div>");
  
                            appointmentcontent += ("<div class='jsplannerappointmenttext' style='margin-left:"+textoffset+"px'>");
                            //appointmentcontent += plannercontext._blankNulls(queryobj[k].visitref) + " - " + plannercontext._blankNulls(queryobj[k].longdescription)+ "<br>";
                            appointmentcontent += ( duestring + " ");
                            appointmentcontent += ( "Status: "+queryobj[k].statustext )+"<br>";
                            for(var l=0;l<maintenanceOptionalFields.length;l++){
                              if(maintenanceOptionalFields[l]!=""){
                                appointmentcontent +="<span class='fa fa-square jsplannertextsectionseparator'></span><span>" + plannercontext._blankNulls(queryobj[k][maintenanceOptionalFields[l]])+"</span>"; 
                              }
                            }
                            appointmentcontent += ("</div>");
                            appointmentcontent += ("<div class='jsplannerrightappointmentdraganchor appointment"+jobstylestring+"anchorright' id='jsplannerrdrag" + queryobj[k].id + "'></div>");
                            appointmentcontent += ("</div>");

                            $("#jsplannerrowcontainer" + queryobj[k].resourcekey.replace("&", "¬")).append(appointmentcontent);
                            plannercontext._setJobAreaListeners($("#jsplannerevent" + queryobj[k].id));
                            plannercontext._setJobAreaListeners($("#jsplannerldrag" + queryobj[k].id));
                            plannercontext._setJobAreaListeners($("#jsplannerrdrag" + queryobj[k].id));
                        }
                    }
                }); //end of job data load
            }

            this._setContextMenus();

        },

        _setContextMenus:function(){
            if (!CAN_CREATE && !CAN_DELETE) return;

            var menuOptions = [];
            if (CAN_CREATE) {
                menuOptions.push({title: "Copy", cmd: "copy", uiIcon: "ui-icon-copy"});
            }
            if (CAN_DELETE) {
                menuOptions.push({title: "Delete", cmd: "delete", uiIcon: "ui-icon-trash"});
            }

            var plannercontext = this;
            $(document).contextmenu({
                delegate: ".jsplannerAppointmentBox",
                preventSelect: true,
                taphold: true,
                menu: menuOptions,
                // Handle menu selection to implement a fake-clipboard
                select: function(event, ui) {
                    var $target = ui.target;
                    switch(ui.cmd){
                        case "copy":
                                plannercontext._setOption("currentdragtype","copy");
                                plannercontext._setOption("jobstartwidth",$target.width());
                                plannercontext._setOption("currentlydraggedobject", $target.attr("id"));
                                plannercontext._setOption("copytarget", $target.parent().attr("id"));
                                $("#jsplannerAppointmentAreaCopyBox").css("height",plannercontext.options.resourceLineRowHeight-1+"px")
                                $("#jsplannerAppointmentAreaCopyBox").css("width",$target.width()+2+"px")
                                $("#jsplannerAppointmentAreaCopyBox").css("display","block");

                            break;
                        case "delete":
                                var data={appointmentid:$target.attr("id").replace("jsplannerevent", "")};
                                plannercontext._trigger("appointmentDelete", null, data)
                            break;
                    }


                }
            });

        },

        _setJobAreaListeners: function(object) { //sets the listeners that listen for drags happening to existing appointments
            var plannercontext = this;
            //mousedown on a job
            $( object.attr("id") ).unbind();

            object.mousedown(function(e) {

                try {
                     $(document).contextmenu("close");
                }
                catch(err) {}

                if (e.button==0){
                    if (!CAN_EDIT) {
                        plannercontext._setOption("changed", false);
                        return;
                    }

                    e.originalEvent.preventDefault();
                    e.stopPropagation();

                    switch (e.target.id.substr(0, 14)) {
                        case 'jsplannerevent':
                            plannercontext._setOption("currentlydraggedobject", (e.target.id));
                            plannercontext._setOption("jobstartwidth", $(this).width());
                            plannercontext._setOption("jobstartdragpagex", (e.pageX));
                            plannercontext._setOption("jobstartdragposition", (e.target.offsetLeft));
                            plannercontext._setOption("currentdragtype", "jobdrag");
                            plannercontext._setOption("originalresource", e.target.parentElement.id);
                            plannercontext._setOption("originalresourcename", e.target.parentElement.id);
                            break;

                        case 'jsplannerldrag':

                            plannercontext._setOption("currentlydraggedobject", e.target.parentElement.id);
                            plannercontext._setOption("jobstartwidth", $(this).parent().width() + 2);
                            plannercontext._setOption("jobstartdragpagex", (e.pageX));
                            plannercontext._setOption("jobstartdragposition", $("#" + e.target.parentElement.id).position().left);
                            plannercontext._setOption("currentdragtype", "jobldrag");
                            plannercontext._setOption("originalresource", e.target.parentElement.parentElement.id);
                            break;
                        case 'jsplannerrdrag':

                            plannercontext._setOption("currentlydraggedobject", e.target.parentElement.id);
                            plannercontext._setOption("jobstartwidth", $(this).parent().width());
                            plannercontext._setOption("jobstartdragpagex", (e.pageX));
                            plannercontext._setOption("jobstartdragposition", $("#" + e.target.parentElement.id).position().left);
                            plannercontext._setOption("currentdragtype", "jobrdrag");
                            plannercontext._setOption("originalresource", e.target.parentElement.parentElement.id);
                            break;
                    }

                    plannercontext._setOption("changed", false);
                }
            }); //end mousedown

            object.click(function(e) {
                if (plannercontext.options.changed === false) {
                    switch (e.target.id.substr(0, 14)) {

                        case 'jsplannerevent':
                            data = {
                                appointmentid: e.target.id.replace("jsplannerevent", ""),
                                resourcetype:  $("#"+e.target.id).parent().prevAll(".jsplannerAppointmentAreaRowHeaderContainer:first").attr("value")   
                            };
                            plannercontext._trigger("editappointment", null, data);
                            break;
                    }
                }
            });

            object.mousemove(function(e) {
                e.originalEvent.preventDefault();
                e.stopPropagation();
                plannercontext._ProcessMouseMoves(e, $(this));
            }); //end mousemove

            object.mouseup(function(e) {
                e.originalEvent.preventDefault();
                e.stopPropagation();
                plannercontext._ProcessMouseUps(e, $(this));

            }); //end mouseup
        },

        //if we register a mousemove trigger this event. it will decide if something is being dragged and render the object moving also checks for collisions before displaying
        _ProcessMouseMoves: function(e, thisObj) {
            var plannercontext = this;            
            var potentialLeftPosition = 0;
            var potentialRightPosition = 0;
            var renderposleft = 0;
            var renderposright = 0;
            var rendertop = 0;
                   
            switch (this.options.currentdragtype) {
                case '':
                    this._processNeutralMouse(e,thisObj);
                    break;
                case'copy':
     
                        var offset = thisObj.offset();
                        
                        potentialLeftPosition = this._snapPixelPosition((e.pageX - offset.left)-(this.options.jobstartwidth/2));
                        potentialRightPosition = potentialLeftPosition+(this.options.jobstartwidth);
 
                        $("#jsplannerAppointmentAreaCopyBox").css("left",potentialLeftPosition+1+"px");
                        if($("#" + thisObj.attr("id")).hasClass("jsplannerAppointmentAreaRowContainer")){
                            $("#jsplannerAppointmentAreaCopyBox").css("top",$("#" + thisObj.attr("id")).position().top+1+"px");

                            this._setOption("copytarget", thisObj.attr("id"));
                        }
                        if (this._isNoCollision(potentialLeftPosition, potentialRightPosition, "jsplannerAppointmentAreaCopyBox", thisObj.attr("id")) === true){
                            $("#jsplannerAppointmentAreaCopyBox").css("display","block");
                        }else{
                            $("#jsplannerAppointmentAreaCopyBox").css("display","none");
                        }
                        renderposleft=potentialLeftPosition+2;
                        renderposright=potentialRightPosition+2;

                        rendertop=$("#jsplannerAppointmentAreaCopyBox").position().top;
                        e.originalEvent.preventDefault();
                        e.stopPropagation();

                    break;
                case 'jobldrag':
                     
                    potentialLeftPosition = this._snapPixelPosition((e.pageX - this.options.jobstartdragpagex) + this.options.jobstartdragposition) + 1;
                    potentialRightPosition = this._snapPixelPosition(potentialLeftPosition + (this.options.jobstartwidth) + (this.options.jobstartdragposition - potentialLeftPosition)) + 1;
                    if (potentialLeftPosition != this.options.jobstartdragposition) {
                        this._setOption("changed", true);
                    }
                    if (this._isNoCollision(potentialLeftPosition, potentialRightPosition, this.options.currentlydraggedobject, this.options.originalresource) === true) {
                        $("#" + this.options.currentlydraggedobject).css("left", potentialLeftPosition);
                        $("#" + this.options.currentlydraggedobject).css("width", (this.options.jobstartwidth) + (this.options.jobstartdragposition - potentialLeftPosition));
                        renderposleft = potentialLeftPosition;
                        renderposright = renderposleft + (this.options.jobstartwidth) + (this.options.jobstartdragposition - potentialLeftPosition);
                        rendertop = $("#" + this.options.currentlydraggedobject).parent().position().top;
                    }
                    break;
                case 'jobrdrag':
                       
                    potentialLeftPosition = this._snapPixelPosition(this.options.jobstartdragposition) + 1;
                    potentialRightPosition = this._snapPixelPosition(this.options.jobstartdragposition + this.options.jobstartwidth + (e.pageX - this.options.jobstartdragpagex));
                    if (potentialRightPosition != this._snapPixelPosition(this.options.jobstartdragposition + this.options.jobstartwidth)) {
                        this._setOption("changed", true);
                    }
                    if (this._isNoCollision(potentialLeftPosition, potentialRightPosition, this.options.currentlydraggedobject, this.options.originalresource) === true) {
                        $("#" + this.options.currentlydraggedobject).css("width", (potentialRightPosition - potentialLeftPosition));
                        renderposleft = potentialLeftPosition;
                        renderposright = potentialRightPosition;
                        rendertop = $("#" + this.options.currentlydraggedobject).parent().position().top;
                    }
                    break;
                case 'jobdrag':
       
                    potentialLeftPosition = this._snapPixelPosition((e.pageX - this.options.jobstartdragpagex) + this.options.jobstartdragposition) + 1;
                    potentialRightPosition = potentialLeftPosition + this.options.jobstartwidth + 1;

                    if ($("#" + this.options.currentlydraggedobject).position().left !== 0 && $("#" + this.options.currentlydraggedobject).position().left + $("#" + this.options.currentlydraggedobject).width() != this.options.timelinewidth) { //only allow the user to drag a job if both of its anchors are inside the current load range.
                        if (potentialLeftPosition != this.options.jobstartdragposition) {

                            this._setOption("changed", true);
                        }
                        if (thisObj.attr("id") != this.options.currentlydraggedobject && $("#" + thisObj.attr("id")).hasClass("jsplannerAppointmentAreaRowContainer")) {
                            if (this._isNoCollision(potentialLeftPosition, potentialRightPosition, this.options.currentlydraggedobject, thisObj.attr("id")) === true) {
                                $("#" + this.options.currentlydraggedobject).css("left", potentialLeftPosition);
                                $("#" + this.options.currentlydraggedobject).detach().appendTo("#" + thisObj.attr("id"));
                                rendertop = $("#" + this.options.currentlydraggedobject).parent().position().top;
                                renderposleft = potentialLeftPosition;
                                renderposright = potentialRightPosition;
                                this._setOption("changed", true);

                            }
                            this._setOption("originalresource", thisObj.attr("id"));
                        } else {
                            if (this._isNoCollision(potentialLeftPosition, potentialRightPosition, this.options.currentlydraggedobject, this.options.originalresource) === true) {
                                $("#" + this.options.currentlydraggedobject).css("left", potentialLeftPosition);
                                renderposleft = potentialLeftPosition;
                                renderposright = potentialRightPosition;
                                rendertop = $("#" + this.options.currentlydraggedobject).parent().position().top;
                            }
                        }
                    }


                    break;
                case 'selectiondrag':
                      
                    var offset = thisObj.offset();
                    if ($("#jsplannerAppointmentAreaSelectionBox").css("display") == "block") {
                        if ($("#" + thisObj.attr("id")).hasClass("jsplannerAppointmentAreaRowContainer")) {
                            if (((e.pageX - offset.left) - this.options.dragstartposition) < 0) {
                                potentialLeftPosition = this._snapPixelPosition((e.pageX - offset.left));
          
                                potentialRightPosition = potentialLeftPosition + this.options.dragstartposition - this._snapPixelPosition((e.pageX - offset.left));
                                if (this._isNoCollision(potentialLeftPosition, potentialRightPosition, "jsplannerAppointmentAreaSelectionBox", thisObj.attr("id")) === true) {
                                    $("#jsplannerAppointmentAreaSelectionBox").css("left", this._snapPixelPosition((e.pageX - offset.left)));
                                    $("#jsplannerAppointmentAreaSelectionBox").css("width", this.options.dragstartposition - this._snapPixelPosition((e.pageX - offset.left)));
                                    renderposleft = this._snapPixelPosition((e.pageX - offset.left));
                                    renderposright = renderposleft + (this.options.dragstartposition - this._snapPixelPosition(e.pageX - offset.left));
                                    rendertop = $(".jsplannerAppointmentAreaSelectionBox").css("top").substr(0,$(".jsplannerAppointmentAreaSelectionBox").css("top").length-2);

                                }
                            } else {
                                potentialLeftPosition = this.options.dragstartposition;
                                potentialRightPosition = potentialLeftPosition + this._snapPixelPosition((e.pageX - offset.left)) - $("#jsplannerAppointmentAreaSelectionBox").position().left;
                                if (this._isNoCollision(potentialLeftPosition, potentialRightPosition, "jsplannerAppointmentAreaSelectionBox", thisObj.attr("id")) === true) {
                                    $("#jsplannerAppointmentAreaSelectionBox").css("left", this.options.dragstartposition);
                                    $("#jsplannerAppointmentAreaSelectionBox").css("width", this._snapPixelPosition((e.pageX - offset.left)) - $("#jsplannerAppointmentAreaSelectionBox").position().left);
                                    renderposleft = this.options.dragstartposition;
                                    renderposright = renderposleft + (this._snapPixelPosition(e.pageX - offset.left) - $("#jsplannerAppointmentAreaSelectionBox").position().left);
                                    rendertop = $(".jsplannerAppointmentAreaSelectionBox").css("top").substr(0,$(".jsplannerAppointmentAreaSelectionBox").css("top").length-2);
                                }
                            }
                        }
                    }
                    break;
                default:
                    this._processNeutralMouse(e,thisObj);                
                break;

            }
            if (this.options.currentdragtype == 'selectiondrag' ||this.options.currentdragtype == 'copy' || this.options.currentdragtype == 'jobdrag' || this.options.currentdragtype == 'jobldrag' || this.options.currentdragtype == 'jobrdrag') {


                $("#jsplannerAppointmentStartIndicator").css("top", (rendertop - 20) + "px");
                $("#jsplannerAppointmentStartIndicator").css("left", (renderposleft - 40) + "px");
                $("#jsplannerAppointmentEndIndicator").css("top", (rendertop - 20) + "px");
                $("#jsplannerAppointmentEndIndicator").css("left", renderposright + "px");

                $("#jsplannerAppointmentStartIndicator").html(this._getHoursFromTimestamp(this._snapTime(this._deriveTimeFromPixelPosition(renderposleft))));
                $("#jsplannerAppointmentEndIndicator").html(this._getHoursFromTimestamp(this._snapTime(this._deriveTimeFromPixelPosition(renderposright))));

                if ($("#jsplannerAppointmentEndIndicator").is(":hidden")) {
                    $("#jsplannerAppointmentEndIndicator").show("fade", 300);
                    $("#jsplannerAppointmentStartIndicator").show("fade", 300);
                }
            }
        },

        _processNeutralMouse:function(e,thisObj){
            var plannercontext=this;
                //currently doing nothing so tooltip checks

                if($(thisObj).attr("id").substr(0, 14)=="jsplannerevent"){
                    if (plannercontext.globalconsts.visithovertarget!=$(thisObj).attr("id")){
                        plannercontext.globalconsts.visithovertarget=$(thisObj).attr("id");
                        plannercontext._trigger("appointmentDetail",null,$(thisObj).html());                        
                    }

                }else{
                    plannercontext._trigger("appointmentDetail",null,"");
                    plannercontext.globalconsts.visithovertarget=-1;    
                }
                      
        },


        _isNoCollision: function(proposedStart, proposedEnd, event, targetresource) {

            var plannercontext = this;
            var result = true;
            $("#" + targetresource).children().each(function(i) {
                var existingleft = $(this).position().left;
                var existingright = existingleft + $(this).width();
                proposedEnd = plannercontext._snapPixelPositionHalfHour(proposedEnd);
                proposedStart = plannercontext._snapPixelPositionHalfHour(proposedStart);

                existingleft = plannercontext._snapPixelPositionHalfHour(existingleft);
                existingright = plannercontext._snapPixelPositionHalfHour(existingright); //not sure why we would snap already snapped values???

                if ($(this).attr("id") != event) { //don't want to match vs ourselves

                    if (proposedStart > existingleft && proposedStart < existingright) {
                        result = false;
                    }
                    if (proposedEnd > existingleft && proposedEnd < existingright) {
                        result = false;

                    }
                    if (proposedEnd >= existingright && proposedStart <= existingleft) {
                        result = false;
                    }
                    if (existingright >= proposedEnd && existingleft <= proposedStart) {
                        result = false;

                    }
                } else {

                    if (proposedStart == proposedEnd) { //this is the only case where we want to check vs ourselves (don't want 0 length jobs'
                        result = false;
                    }
                    if (proposedStart > proposedEnd) { //this is the only case where we want to check vs ourselves (don't want 0 length jobs'
                        result = false;
                    }
                }
            });
            return result;
        },

        _ProcessMouseUps: function(e, thisObj) {
            if (e.button==0 && this.options.currentlydraggedobject!=""){
                $("#jsplannerAppointmentEndIndicator").hide("fade", 300);
                $("#jsplannerAppointmentStartIndicator").hide("fade", 300);

                switch (this.options.currentdragtype) {

                    case 'copy':
                        


                        if($("#jsplannerAppointmentAreaCopyBox").css("display")!="none"){
                            var offset = $(this).offset();
                            this._copyAppointment(this.options.currentlydraggedobject.replace("jsplannerrowcontainer", ""), this._snapTime(this._deriveTimeFromPixelPosition($("#jsplannerAppointmentAreaCopyBox").position().left)), this._snapTime(this._deriveTimeFromPixelPosition($("#jsplannerAppointmentAreaCopyBox").position().left + $("#jsplannerAppointmentAreaCopyBox").width())), this.options.copytarget)
                            $("#jsplannerAppointmentAreaCopyBox").css("display","none");
                            this._setOption("currentdragtype",'');
                        }
                        break;
                        
                    case 'selectiondrag':
                        var offset = $(this).offset();

                        data = {
                            start: this._snapTime(this._deriveTimeFromPixelPosition($("#jsplannerAppointmentAreaSelectionBox").position().left)),
                            end: this._snapTime(this._deriveTimeFromPixelPosition($("#jsplannerAppointmentAreaSelectionBox").position().left + $("#jsplannerAppointmentAreaSelectionBox").width())),
                            resourcekey: this.options.currentlydraggedobject.replace("jsplannerrowcontainer", ""),
                            engineerid: $("#" + this.options.currentlydraggedobject).attr("engineerid"),
                            resourcename: $("#" + this.options.currentlydraggedobject).attr("resourcename").replace("¬", "&"),
                            resourcetype: $("#"+this.options.currentlydraggedobject).prevAll(".jsplannerAppointmentAreaRowHeaderContainer:first").attr("value")    

                        };
                        if (data.start != data.end) {
                            this._trigger("newappointment", null, data);
                        }
                        $("#jsplannerAppointmentAreaSelectionBox").hide();
                        $("#jsplannerAppointmentAreaSelectionBox").css("width", 0);

                        break;

                    case 'jobdrag':
                        if (this.options.changed === true) {
                            this._setOption("currentdragtype", '');
                            this._saveAppointment(this.options.currentlydraggedobject, $("#" + this.options.currentlydraggedobject).position().left, $("#" + this.options.currentlydraggedobject).position().left + $("#" + this.options.currentlydraggedobject).width(), $("#" + this.options.currentlydraggedobject).parent().attr("id"), $("#" + this.options.currentlydraggedobject).parent().attr("engineerid"), false, $("#" + this.options.currentlydraggedobject).parent().attr("resourcename").replace("¬", "&"));
                        }
                        break;
                    case 'jobrdrag':
                        if (this.options.changed === true) {
                            this._setOption("currentdragtype", '');
                            this._saveAppointment(this.options.currentlydraggedobject, -1, $("#" + this.options.currentlydraggedobject).position().left + $("#" + this.options.currentlydraggedobject).width(), $("#" + this.options.currentlydraggedobject).parent().attr("id"), $("#" + this.options.currentlydraggedobject).parent().attr("engineerid"), true, $("#" + this.options.currentlydraggedobject).parent().attr("resourcename").replace("¬", "&"));
                        }
                        break;
                    case 'jobldrag':
                        if (this.options.changed === true) {
                            this._setOption("currentdragtype", '');
                            this._saveAppointment(this.options.currentlydraggedobject, $("#" + this.options.currentlydraggedobject).position().left, -1, $("#" + this.options.currentlydraggedobject).parent().attr("id"), $("#" + this.options.currentlydraggedobject).parent().attr("engineerid"), true, $("#" + this.options.currentlydraggedobject).parent().attr("resourcename").replace("¬", "&"));
                        }
                        break;
                }
                this._setOption("currentdragtype", '');
                this._setOption("jsplannerrowcontainer", "");
                this._setOption("currentlydraggedobject", "");

            }else{
                //right click on something, only want to hide the copy box in this case
                if (this.options.currentdragtype=="copy"){
                    $("#jsplannerAppointmentAreaCopyBox").css("display","none");
                    this._setOption("currentdragtype",'');
                    this._renderControl(true);
                }
            }

        },
        _copyAppointment: function(appointmentid, timestart, timeend, resourcekey) {
         
            var data={
                appointmentid:appointmentid.replace("jsplannerevent", ""),
                timestart:timestart,
                timeend:timeend,
                resource:resourcekey.replace("jsplannerrowcontainer","")
            }
            this._trigger("processAppointmentCopy",null, data);            
        },


        _saveAppointment: function(id, timestart, timeend, resource, targetengineerid, forcenorowchange, resourcename) {
            var originalresourcekey="";
            var resourcekey="";
            if (forcenorowchange === true || $("#" + id).hasClass("appointmentcontract")) { //do not want to ask the user to rename a job if we are simply resizing or the job belongs to a contract.
                originalresourcekey = resource.replace("jsplannerrowcontainer", "");
                resourcekey = resource.replace("jsplannerrowcontainer", "");
            } else {
                originalresourcekey = this.options.originalresourcename.replace("jsplannerrowcontainer", "");
                resourcekey = resource.replace("jsplannerrowcontainer", "");
            }

            if (timestart != -1) {
                timestart = this._snapTime(this._deriveTimeFromPixelPosition(timestart));
            }
            if (timeend != -1) {
                timeend = this._snapTime(this._deriveTimeFromPixelPosition(timeend));
            }
            var data = {
                datatable: this.options.plannerdatasource[0].sourcetable,
                id: id.replace("jsplannerevent", ""),
                idfield: this.options.plannerdatasource[0].id,
                startfield: this.options.plannerdatasource[0].starttime,
                endfield: this.options.plannerdatasource[0].endtime,
                starttime: timestart,
                endtime: timeend,
                resourcefield: this.options.plannerdatasource[0].resourcekey,
                resourcekey: resourcekey,
                originalresourcekey: originalresourcekey,
                engineerid: targetengineerid,
                resourcename: resourcename

            };
            this._trigger("processAppointmentChange", null, data);
        },

        _setJobRowListeners: function(object) {
            //=====================MOUSE IS DEPRESSED, START DRAG CODE======================
            var plannercontext = this;

            object.mousedown(function(e) {
                try {
                     $(document).contextmenu("close");
                }
                catch(err) {}
                if (!CAN_CREATE) return;
                if (plannercontext.options.currentdragtype!=="copy" && e.button==0){

                    e.originalEvent.preventDefault();
                    e.stopPropagation();
                    var offset = $(this).offset();

                    plannercontext._setOption("dragstartposition", plannercontext._snapPixelPosition((e.pageX - offset.left)));
                    $(".jsplannerAppointmentAreaSelectionBox").css("left", e.pageX - offset.left);
                    $(".jsplannerAppointmentAreaSelectionBox").css("width",0+"px");
                    $(".jsplannerAppointmentAreaSelectionBox").css("top", $("#" + e.target.id).css("top"));
                    $(".jsplannerAppointmentAreaSelectionBox").css("height", plannercontext.options.resourceLineRowHeight);

                    $(".jsplannerAppointmentAreaSelectionBox").show();
                    plannercontext._setOption("dragstartrow", e.target.id);

                    plannercontext._setOption("currentlydraggedobject", (e.target.id));
                    plannercontext._setOption("currentdragtype", "selectiondrag"); 
                }

            });
            //=====================End MOUSE DOWN ==========================

            //=====================MOUSE IS MOVED======================
            object.mousemove(function(e) {
                e.stopPropagation();
                e.originalEvent.preventDefault();
                plannercontext._ProcessMouseMoves(e, $(this));
            });
            //=====================End MOUSE DOWN ==========================

            //=====================MOUSE IS UP Stop Drag======================
            object.mouseup(function(e) { //MOUSE UP, CLEAR SELECTION AND PROCESS
                e.stopPropagation();
                e.originalEvent.preventDefault();
                plannercontext._ProcessMouseUps(e, $(this));


            });
            //=====================End MOUSE UP ==========================
        },



        _renderTimelineHorizontalRows: function() {
            var lefttime = this.options.lefttime;
            var righttime = this.options.righttime;
            var headerHeight = this.options.resourceHeaderRowHeight;
            var lineHeight = this.options.resourceLineRowHeight;
            var currentTop = 1;
            var plannercontext = this;
            var rowselectorboxes = "";

            $(".jsplannerAppointmentAreaSelectionBox").remove(); //remove current selection box


            $(".jsplannerAppointmentAreaHorizontalDivider").remove(); //remove all existing horizontal dividers
            $(".jsplannerAppointmentAreaRowContainer").remove();
            $(".jsplannerAppointmentAreaRowCanvas").remove();

            $(".jsplannerAppointmentAreaRowHeaderContainer").remove();
            $(".appointmentheadercolumntopspacer").remove();


            $(".jsplannerresourcecolumngroup").each(function(index, value) {

                

            $("#jsplannerappointmentarea").append ("<div class='appointmentheadercolumntopspacer' style='top:"+(currentTop-1)+"px'></div>"); //add spacer
                if ($(this).hasClass("jsplannerresourcecolumnheadsmall") === true) {
                    $("#jsplannerappointmentarea").append("<div class='jsplannerAppointmentAreaRowHeaderContainer minimisedcontainer' value='" + this.id + "' style='top:" + (currentTop) + "px;height:" + (lineHeight) + "px'></div>");
                    //this is minimised so only draw the line for the header and carry on
                } else {
                    $("#jsplannerappointmentarea").append("<div class='jsplannerAppointmentAreaRowHeaderContainer' value='" + this.id + "' style='top:" + (currentTop) + "px;height:" + (lineHeight) + "px'></div>");
                    $(this).children('div .jsplannerresourcecolumnitem').each(function(i) {
                        currentTop += lineHeight;
                        //DRAW THE CONTAINER FOR EACH GRID ROW
                        //plannercontext._drawAppointmentAreaHorizontalDivider(currentTop);

                        $("#jsplannerappointmentarea").append("<div class='jsplannerAppointmentAreaRowContainer' id='jsplannerrowcontainer" + $(this).attr('id') + "' engineerid='" + $(this).attr('engineerid') + "'  resourcename='" + $(this).attr('resourcename') + "' style='top:" + (currentTop-1) + "px;height:" + (lineHeight) + "px'></div>");
                        $("#jsplannerappointmentarea").append("<canvas class='jsplannerAppointmentAreaRowCanvas' style='top:" + (currentTop-1) + "px;height:" + lineHeight + "px'></canvas");
                        plannercontext._setJobRowListeners($("#jsplannerrowcontainer" + $(this).attr('id')));
                    });
                    //this group is not minimised, process the children also
                }
                currentTop += headerHeight;
            }); //end each
            $("#jsplannerappointmentcontainer").css("height",currentTop+"px");
            //this._drawAppointmentAreaHorizontalDivider(currentTop);
            //selection drag box 
            $("#jsplannerappointmentarea").append("<div class='jsplannerAppointmentAreaSelectionBox' id='jsplannerAppointmentAreaSelectionBox'></div>");


            $(".jsplannerAppointmentAreaRowHeaderContainer").unbind();
            $(".jsplannerAppointmentAreaRowHeaderContainer").click(function(event) {
                $("#" + $(this).attr('value')).toggleClass('jsplannerresourcecolumnheadsmall', 0, function() {});
                $(this).toggleClass("jsplannerresourcecolumnheadsmall");
                if ($("#" + $(this).attr('value')).hasClass('jsplannerresourcecolumnheadsmall')) {
                    $("#" + $(this).attr('value')).css("height", headerHeight);
                } else {
                    $("#" + $(this).attr('value')).css("height", "100%");
                }

                plannercontext._saveHiddenResources();
                plannercontext._renderTimelineHorizontalRows();

                plannercontext._renderTimeline(true,true);

            });

            this._loadAndRenderPlannerEvents();
        },

        _snapTime: function(timestamp) {

            var timelinescale = this.options.timeLineScale;
            if (this.options.isTimelineCompression==-1){
                return this._snapToVisibleGroups(this._snapToNearestHalfHour(timestamp));
            }else{
                if (timelinescale >= 0.3) { //full size render
                    return this._snapToNearestHalfHour(timestamp);
                } else if (timelinescale < 0.3 && timelinescale >= 0.15) { //smaller render
                    return this._snapToNearestHalfHour(timestamp);
                } else if (timelinescale < 0.15 && timelinescale >= 0.1) {
                    //want to snap hourly from now on
                    return this._snapToNearestHour(timestamp);
                } else if (timelinescale < 0.1 && timelinescale >= 0.061) {
                    return this._snapToNearestThreeHour(timestamp);
                } else if (timelinescale < 0.061 && timelinescale >= 0.042) {
                    return this._snapToNearestThreeHour(timestamp);
                } else if (timelinescale < 0.042 && timelinescale >= 0.010) {
                    return this._snapToNearestTwelveHour(timestamp);
                }
            }
        },

        _snapToVisibleGroups: function(timestamp){
            for (var i=0;i<this.options.timelineArray.length-1;i++){

                if (this.options.timelineArray[i].endtime<=timestamp && timestamp<=this.options.timelineArray[i+1].starttime){
                    //we know that the current time is somewhere between 2 visible groups so we should snap it to the end or start times of one of the groups
                    if ((this.options.timelineArray[i+1].starttime-timestamp)>=(timestamp-this.options.timelineArray[i].endtime)){
                        return this.options.timelineArray[i].endtime;
                    }else{
                        return this.options.timelineArray[i+1].starttime;
                    }
                }
            }
            return timestamp;
        },

        _snapToNearestHalfHour: function(timestamp) {
            var tsDifference = timestamp % 1800;
            if (tsDifference <= 900) {
                return timestamp - tsDifference;
            } else {
                return timestamp + (1800 - tsDifference);
            }
        },
        _snapToNearestHour: function(timestamp) {
            var tsDifference = timestamp % 3600;
            if (tsDifference <= 1800) {
                return timestamp - tsDifference;
            } else {
                return timestamp + (3600 - tsDifference);
            }
        },
        _snapToNearestThreeHour: function(timestamp) {
            var tsDifference = timestamp % 10800;
            if (tsDifference <= 5400) {
                return timestamp - tsDifference;
            } else {
                return timestamp + (10800 - tsDifference);
            }
        },
        _snapToNearestTwelveHour: function(timestamp) {
            var tsDifference = timestamp % 43200;
            if (tsDifference <= 21600) {
                return timestamp - tsDifference;
            } else {
                return timestamp + (43200 - tsDifference);
            }
        },
        _snapPixelPosition: function(pixelposition) { //take a pixel position and derive the pixel position of the nearest half hour point
            return (this._derivePixelPositionFromTime(this._snapTime(this._deriveTimeFromPixelPosition(pixelposition))));
        },
        _snapPixelPositionHalfHour: function(pixelposition) { //take a pixel position and derive the pixel position of the nearest half hour point
            return (this._derivePixelPositionFromTime(this._snapToNearestHalfHour(this._deriveTimeFromPixelPosition(pixelposition))));
        },
        _derivePixelPositionFromTime: function(timestamp) { //returns a pixel position on the timeline from a timestamp in epoch format
            
            var lefttime = this.options.lefttime;
            var righttime = this.options.righttime;
            var pps = this.options.pixelpersecond;
            if (timestamp <= lefttime) return 0;
            if (timestamp >= righttime) return this.options.timelinewidth;

            if (this.options.isTimelineCompression==0){   
                return parseInt((timestamp - lefttime) * pps);
            }else{
                 for (var i=0;i<this.options.timelineArray.length;i++){
                    if (this.options.timelineArray[i].starttime<=timestamp && timestamp<=this.options.timelineArray[i].endtime){
                        var percofgroup=((timestamp-this.options.timelineArray[i].starttime)/(this.options.timelineArray[i].endtime-this.options.timelineArray[i].starttime))*100;
                        return (Math.floor(((this.options.timelineArray[i].pixelend-this.options.timelineArray[i].pixelstart)/100)*percofgroup)+this.options.timelineArray[i].pixelstart);
                    }
                }
                //it is possible that the timestamp occurs during a compression zone, so check that here
                for (var i=0;i<this.options.timelineArray.length-1;i++){
                    if (this.options.timelineArray[i].endtime<=timestamp && timestamp<=this.options.timelineArray[i+1].starttime){
                        var percofgroup=((timestamp-this.options.timelineArray[i].endtime)/(this.options.timelineArray[i+1].starttime-this.options.timelineArray[i].endtime))*100;
                        return (Math.floor(((this.options.timelineArray[i+1].pixelstart-this.options.timelineArray[i].pixelend)/100)*percofgroup)+this.options.timelineArray[i].pixelend);
                    }
                }

                return 0; //this is our catch all case - there has been no match on the timelines so return 0
            }
        },

        _deriveTimeFromPixelPosition: function(pixelposition) { //returns a timestamp in epoch format from a pixel position on the timeline
            if (this.options.isTimelineCompression==0){
                //get position in standard mode
                var lefttime = this.options.lefttime;
                var righttime = this.options.righttime;
                var timelinewidth = this.options.timelinewidth;
                return (lefttime + parseInt(((righttime - lefttime) / timelinewidth) * pixelposition));
            }else{
                //calculation for timeline compression mode
                for (var i=0;i<this.options.timelineArray.length;i++){
                    if (this.options.timelineArray[i].pixelstart<=pixelposition && pixelposition<=this.options.timelineArray[i].pixelend){
                        var percofgroup=((pixelposition-this.options.timelineArray[i].pixelstart)/(this.options.timelineArray[i].pixelend-this.options.timelineArray[i].pixelstart))*100;
                        return (Math.floor(((this.options.timelineArray[i].endtime-this.options.timelineArray[i].starttime)/100)*percofgroup)+this.options.timelineArray[i].starttime);
                    }
                }
                //it is possible that the time point we are looking for occurs during a compression zone, calculate this here
                for (var i=0;i<this.options.timelineArray.length-1;i++){
                    if (this.options.timelineArray[i].pixelend<=pixelposition && pixelposition<=this.options.timelineArray[i+1].pixelstart){
                        var percofgroup=((pixelposition-this.options.timelineArray[i].pixelend)/(this.options.timelineArray[i+1].pixelstart-this.options.timelineArray[i].pixelend))*100;
                        return (Math.floor(((this.options.timelineArray[i+1].starttime-this.options.timelineArray[i].endtime)/100)*percofgroup)+this.options.timelineArray[i].endtime);
                    }
                }                
                return 0; //this is our catch all case - there has been no match on the timelines so return 0
            }
        },

        _getCenterTimeFromPixelOffset: function(offset) {
            var pps = this.options.pixelpersecond;
            var centertime = this.options.currentTime;
            return (parseInt(centertime) + parseInt((offset * -1) / pps));
        },


        _getHoursFromTimestamp: function(timestamp) {
            var d = new Date(0); // The 0 there is the key, which sets the date to the epoch
            d.setUTCSeconds(timestamp);
            return (this._pad(d.getHours(), 2) + ":" + this._pad(d.getMinutes(), 2));
        },
        _getOnlyHoursFromTimestamp: function(timestamp) {
            var d = new Date(0); // The 0 there is the key, which sets the date to the epoch
            d.setUTCSeconds(timestamp);
            return (this._pad(d.getHours(), 2));
        },
        _getDateFromTimestamp: function(timestamp) {
            var d = new Date(0); // The 0 there is the key, which sets the date to the epoch
            d.setUTCSeconds(timestamp);
            return d.toDateString();
        },
        _getTinyDateFromTimestamp: function(timestamp) {
            var d = new Date(0); // The 0 there is the key, which sets the date to the epoch
            d.setUTCSeconds(timestamp);
            return this._pad(d.getDate(), 2) + "/" + this._pad(d.getMonth() + 1, 2) + "/" + d.getFullYear();
        },
        _getSmallestDateFromTimestamp: function(timestamp) {
            var d = new Date(0); // The 0 there is the key, which sets the date to the epoch
            d.setUTCSeconds(timestamp);
            return this._pad(d.getDate(), 2);
        },
        _pad: function(num, size) {
            var s = num + "";
            while (s.length < size) s = "0" + s;
            return s;
        },

        _getIsTimestampMonthMarker: function(timestamp) {
            var d = new Date(0); // The 0 there is the key, which sets the date to the epoch
            d.setUTCSeconds(timestamp);
            return (d.getDate() == 1 && d.getHours() === 0 && d.getMinutes()===0);
        },
        _getIsCompressionModeDayMarker: function(timestamp) {
                for (var i=0;i<this.options.timelineArray.length;i++){
                    if (this.options.timelineArray[i].starttime==timestamp || timestamp==this.options.timelineArray[i].endtime){
                        return true;
                    }
                }
                return false;
        },

        _readcookie: function (key) {
          var result;
          return (result = new RegExp('(?:^|; )' + encodeURIComponent(key) + '=([^;]*)').exec(document.cookie)) ? (result[1]) : null;
        },

        _savecookie: function(key, value) {
          var CookieDate = new Date;
          CookieDate.setFullYear(CookieDate.getFullYear() + 10);
          document.cookie = key + '=' + value + '; expires=' + CookieDate.toGMTString() + ';';
        },

        _getMonthMarkerText: function(timestamp) {

            var d = new Date(0); // The 0 there is the key, which sets the date to the epoch
            d.setUTCSeconds(timestamp);
            return (this.globalconsts.month[d.getMonth()] + " " + d.getFullYear());
        },


        _getDayNoOfWeek: function(timestamp){
            var d = new Date();
            d.setTime(timestamp);
            return (d.getDay());
        },

        _getDayNoOfWeekFromText: function(day){
            return (this.globalconsts.rweekday[day]);
        },

        _debugVisibleGroups:function(){
            for (var i=0;i<this.options.timelineArray.length;i++){
                console.log ("group:"+i+" start:"+this._getDateFromTimestamp(this.options.timelineArray[i].starttime) + " "+this._getHoursFromTimestamp(this.options.timelineArray[i].starttime)    + " End:"+this._getDateFromTimestamp(this.options.timelineArray[i].endtime)+ " "+this._getHoursFromTimestamp(this.options.timelineArray[i].endtime)  + " Width:" +(this.options.timelineArray[i].pixelend-this.options.timelineArray[i].pixelstart) + " xstart:" +this.options.timelineArray[i].pixelstart+ " xend:"+this.options.timelineArray[i].pixelend);
            }
        },
        _isTimestampStartOfVisibleGroup: function (markertime){
            for (var i=0;i<this.options.timelineArray.length;i++){
                    if(markertime==this.options.timelineArray[i].starttime){
                        return true;
                    }
            }
            return false;            
        },
        _isTimestampEndOfVisibleGroup: function (markertime){
            for (var i=0;i<this.options.timelineArray.length;i++){
                    if(markertime==this.options.timelineArray[i].endtime){
                        return true;
                    }
            }
            return false;            
        },

        _isHourClosestToCenterOfVisibleGroup: function (markertime){
            for (var i=0;i<this.options.timelineArray.length;i++){
                    if(markertime<=this.options.timelineArray[i].endtime && markertime>=this.options.timelineArray[i].starttime){
                        if (markertime==this._snapToNearestHour((this.options.timelineArray[i].endtime+this.options.timelineArray[i].starttime)/2)){
                            return true;
                        }
                    }
            }
            return false;     
        },

        _isTimestampInVisibleGroup: function(markertime){
            for (var i=0;i<this.options.timelineArray.length;i++){
                    if(markertime>=this.options.timelineArray[i].starttime && markertime<=this.options.timelineArray[i].endtime){
                        return true;
                    }
            }
            return false;
        },

        _getAverageTimelineSectionWidth: function(){
            var totalWidth=0;
            for (var i=0;i<this.options.timelineArray.length;i++){
                totalWidth+=((this.options.timelineArray[i].pixelend-this.options.timelineArray[i].pixelstart)+this.options.timelineCompressionGapSize);
            }
            return Math.floor((totalWidth/this.options.timelineArray.length));

        },

        _isTimeStartOfExclusionPeriod: function(markertime){
            var result=false;
            var exclusions = [];
            var markerDay=this._getDayOfWeek(markertime*1000);
            exclusions = this.options.exclusions;
            for (var i in exclusions) {
                if (exclusions[i].startday==markerDay) {
                    //we know that this time marker matches an exclusion day, so check the time.
                    if ((exclusions[i].starttime)==this._getHoursFromTimestamp(markertime)){
                        //we have a positive match against this exclusion zone so return true
                        return true;
                    }
                }
            }
            return false;//none of the current exclusion zones were matched so return false.
        },

        _isTimeEndOfExclusionPeriod: function(markertime){
            var result=false;
            var exclusions = [];
            var markerDay=this._getDayOfWeek(markertime*1000);
            exclusions = this.options.exclusions;
            for (var i in exclusions) {
                if (exclusions[i].startday==markerDay) {
                    //we know that this time marker matches an exclusion day, so check the time.
                    if ((exclusions[i].endtime)==this._getHoursFromTimestamp(markertime)){
                        //we have a positive match against this exclusion zone so return true
                        return true;
                    }
                }
            }
            return false;//none of the current exclusion zones were matched so return false.
        },
        _blankNulls:function(value){
            if (value==null){
                return "";
            }
            return value;
        },

        _saveOptions:function(){
            var options={
                'CompressedTimeScalar':this.options.compressedTimelineScale,
                'RowScalar':this.options.resourceLineRowHeight,
                'TimeScalar':this.options.timeLineScale,
                'IsTimelineCompression':this.options.isTimelineCompression,
                'CompressionDaysInWeek':this.options.timelineDaysPerWeek
            };

            this._trigger("saveOptions", null, options);
        },

        _getDayOfWeek: function(timestamp) {
            var d = new Date();
            d.setTime(timestamp);
            return (this.globalconsts.weekday[d.getDay()]);
        }
    });
})(jQuery);