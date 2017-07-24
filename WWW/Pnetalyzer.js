
$(document).ready(function () {
    
    Shiny.addCustomMessageHandler("myCallbackHandlermarkrow",
               function (message) {
                   //window.er= new array();
				   window.er=message.rw;
				   console.log(typeof(window.er));
                   markr2bdel();
               });
 
   Shiny.addCustomMessageHandler("sendtodevice",
               function (message) {
				   //parent.iFrameWin = window;
                   window.rep = message.report;
		    //parent.postMessage(rep,"*");
			window.parent.postMessage(['varA', window.rep], '*'); 
                   
               });  
window.removeduplicates = function () {
       
	 for (var i = 1; i < 10; i++) {
         //console.log(i);
	var tdcol1 = $('#phqcausal tbody tr:nth-child('+i+') td:nth-child(1) .tooltip:nth-child(1)').contents()[2];
     var tdcol1txt=tdcol1.wholeText;
	 var txtlen=tdcol1txt.length;
	 var halflen=txtlen/2; 
	 var firsthalf = tdcol1txt.slice(0, halflen);
	 
	 var sechalf = tdcol1txt.slice(halflen, txtlen);
	 //console.log(firsthalf);
	 //console.log(sechalf);
	 if(firsthalf==sechalf){tdcol1.replaceWith(firsthalf);}
	        
        }
    };
     window.markr2bdel = function () {
       
	   for (var i = 1; i < 10; i++) {
         //console.log(i);   
	var tdel = $('#phqscores tbody tr:nth-child(' + i + ')');
            if (typeof(window.er)==="number"){
				if (i==window.er){tdel.addClass('warning');}else {
                tdel.removeClass("warning");}}
			else{
            	if (window.er.indexOf(i) > -1) {
                tdel.addClass('warning');
                //console.log("add"+i);
            	} else {
                tdel.removeClass("warning");
		//console.log("remove"+i);
            	}
			}
        }
    }
///////////////////////////////////////////////

   
   	addtooltip = function (tbl) {
       var tts= [' Little interest or pleasure in doing things ',' Feeling down, depressed, or hopeless ','Trouble falling or staying asleep, or sleeping too much ','Feeling tired or having little energy','Poor appetite or overeating',' Feeling bad about yourself '+"�"+' or that you are a failure or \
have let yourself or your family down ',' Trouble concentrating on things, such as reading the \
newspaper or watching television','Moving or speaking so slowly that other people could have \
noticed'+"?"+' Or the opposite '+ "�" +' being so fidgety or restless \
that you have been moving around a lot more than usual ','Thoughts that you would be better off dead or of hurting \
yourself in some way'];
	     var t="#"+tbl+' '+'tbody'+' '+'tr';
	     
	    
	for (var i = 1; i < $(t).length+1; i++) {
            var t2="#"+tbl+' '+'tbody'+' '+'tr'+':nth-child('+ i +') td:nth-child(1)';
	    
		var tdfocus=$(t2);
	    var tdtxt = $(t2).text();
            var ttsi=tts[i-1];
	    tdfocus.html('<div class="tooltip">' + tdtxt + '<span class="tooltiptext">' + ttsi + '</span></div>');
   
        }
   }

//////////////////////////////////////////////////////////////////////////////////////////////////
  //var img = document.images[0];
  //img.onclick = function() {
  //  var url = img.src.replace(/^data:image\/[^;]/, 'data:application/octet-stream');
   // location.href = url;
 // };

    // table.rows().every( function ( rowIdx, tableLoop, rowLoop ) {       
    // var cells = table.cells([presel]).node();
    //  $(cells).addClass('warning');        


});
