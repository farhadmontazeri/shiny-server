library(shiny)
library(DT)
library(shinyjs)
library(qgraph)
library(knitr)
library(XML)
library(reshape2)
library(ggplot2)
NUM_PAGES <- 4



shinyApp(
  ui = fluidPage(title = 'Depression Causality Table',useShinyjs(),
                 tags$head( tags$link(rel = "stylesheet", type = "text/css", href = "Pnetalyzer.css"),
                 tags$script(src="Pnetalyzer.js"),tags$script(src="download.js")),
                 
                 div(id="prevnext",
                # absolutePanel(
                 #  top = 0, right = 0,left=0,
                  # fixed = TRUE,style="width:100%;z-index:1000;margin-right: 5px !important;position:relative !important;
    #margin-left: 5px !important;",
                   
                 actionButton("prevBtn", "<<"),
                 
                 actionButton("nextBtn", ">>"),
  
                 
                              
                 
                 
                 



lapply(seq(NUM_PAGES), function(i) {
  hidden(div(
    class = "page",
    id = paste0("step", i),
    "STEP", i,": ", ifelse(i==1,"Scoring Symptoms",ifelse(i==2,"Causal Relations",ifelse(i==3,"Report",ifelse(i==4,"Progress","") )))
    #ifelse(i==4,"Generate Report","")
    ))
})),hidden(actionButton("report", "Save Report")),#sliderInput("slider", "Slider", 1, 100, 50),





                 #actionButton("graph","Next"),
               DT::dataTableOutput('phqscores'),
                 hidden(DT::dataTableOutput('phqcausal')),
                # verbatimTextOutput('sel'),
                # plotOutput("qgd")
                  hidden(uiOutput('markdown')),
                  hidden(uiOutput('pmarkdown'))
                 #tableOutput('sel')
  ),
  server = function(input, output, session) {
     rv <- reactiveValues(page = 1,m2=NULL,scores=vector())
     
     observe({
       if (is.null(input$pagenumber)){ 
         return(NULL)}
       rv$page<- input$pagenumber
       #routes(rvpage)
       logjs(paste0("rv$page is",rv$page))
       
     })
     
     
      
#routes= function(pagenumb){ 
     # logjs(paste0("routes function entered with pagenumb: ",pagenumb) )
     #if (is.null(pagenumb)){
     #}else if( pagenumb==1){
     
     sx<<-c("Little Interest","Feeling Down","Sleep Issues","Fatigue","Appetite Change","Worthlessness","Trouble Concentrate","Slow/Fidgety","Suicidality")
    p.scores<-c("Not at all","Several days","More than half the days","Nearly every day") 
    
    scorenums<-vector()
    null.scores<<-vector()
    qg<<-NULL
    od<<-NULL
    dbphq<<- read.csv("PHQ.csv",header=T,stringsAsFactors = FALSE)
  
    observe({
      toggleState(id = "prevBtn", condition = rv$page > 1)
      toggleState(id = "nextBtn", condition = rv$page < NUM_PAGES)
      hide(selector = ".page")
      shinyjs::show(sprintf("step%s", rv$page))
    })
    
    
    
    
   
    
    m0 <<- matrix(
      as.character(0:3), nrow = 9, ncol = 4, byrow = TRUE,
      dimnames = list(sx, p.scores)
    )
    for (i in seq_len(nrow(m0))) {
      m0[i, ] = sprintf(
        '<input type="radio" name="%s" value="%s"/>',
        sx[i], m0[i, ]
      )
    }
    m0
    output$phqscores = DT::renderDataTable(
      m0, escape = FALSE, selection = 'none', server = FALSE,
      options = list(dom = 't', paging = FALSE, ordering = FALSE),
      callback = JS("
                    table.rows().every(function(i, tab, row) {
                    var $this = $(this.node());
                    $this.attr('id', this.data()[0]);
                    $this.addClass('shiny-input-radiogroup');
                      });
                    Shiny.unbindAll(table.table().node());
                    Shiny.bindAll(table.table().node());
                    
                    $('#phqscores tbody').on( 'dblclick', 'td', function (e){
                      e.stopPropagation();
                    });
                    addtooltip('phqscores');
                    markr2bdel();
                    
                    
                    ")
                    
                    
                    
                    
                    
                    
                    
    )
    
    observe({
      input$phqscores
     rv$scores<- sapply(sx, function(i) input[[i]])
     null.scores<<-vector()
     for (i in 1:length(rv$scores)){
       if (is.null(rv$scores[[i]])){
         null.scores<<-c(null.scores,i)
       }
       
     }
    # print(null.scores)
     session$sendCustomMessage(type = "myCallbackHandlermarkrow", message = list( rw = null.scores))
     
    })
    
    
    
    
    
    
    
    
    
    
    
    
    
    sxn=length(sx)
    dn=list(sx,sx)
    m <<- matrix(
      0, nrow = sxn, ncol = sxn, byrow = TRUE,
      dimnames = dn)
    
    for (i in seq_len(nrow(m))) {
      m[i, ] = sprintf(
        '<input type="checkbox" name="%s" value="%s"/>',
        sx[i], m[i, ]
      )
      m[i,i ] = 
        '<input type="checkbox"  disabled/>'
      
      
    }
    m
    output$phqcausal = DT::renderDataTable(
      m, escape = FALSE, selection = list(target = 'cell'), server = FALSE,
      extensions = "FixedColumns",options = list(dom = 't', scrollX=TRUE,paging = FALSE, ordering = FALSE, fixedColumns = list(
     leftColumns = 1,
      heightMatch = 'auto'
       )
                     
                       ),
      callback = JS("table.rows().every(function(i, tab, row) {
                    var $this = $(this.node());
                    $this.attr('id', this.data()[0]);
                    $this.addClass('shiny-input-checkbox');
                    });
                    Shiny.unbindAll(table.table().node());
                    Shiny.bindAll(table.table().node());
$('#phqcausal tbody').on( 'click', 'td', function (e) 
        {//window.el=table.cell(this);
                    
                   var c=$(table.cell(this).node());
                    window.c2=c;
                    var viscol = table.cell( this ).index().columnVisible;
                    var r = table.cell( this ).index().row;
                    var c2 = table.cell( this ).index().column;
                    //console.log('viscol is'+'viscol'+' r is '+'r'+ 'c is '+'c'+' );
                    console.log(r);
                    console.log(c2);
                    console.log(viscol);
                    if (r+1==c2){
                        e.stopPropagation();
                      } else if (c.hasClass('selected')){
                      c.children()[0].checked=false;
                      } else {
                      //c.addClass('selected');
                      c.children()[0].checked=true;
                      }

  });
      $('#phqcausal tbody').on( 'dblclick', 'td', function (e){
        e.stopPropagation();
      });
      addtooltip('phqcausal');
      removeduplicates();
      
      
      
      
      ")
      )
    
    
    #output$sel = renderTable({
    observe({
      if(is.null(input$phqcausal_cells_selected)|| nrow(input$phqcausal_cells_selected)==0){return(NULL)}else{
        cs=input$phqcausal_cells_selected
        
        for(i in 1:nrow(cs)){
          r=cs[i,1]
          c=cs[i,2]
          m[r,c]<-1
          m[m!=1]<-0
        }
        rv$m2<<-as.matrix(m)
        as.matrix(m)
      }
      
      #str(sapply(sx, function(i) input[[i]]))
    })
    
    navPage <- function(direction) {
      #print(length(null.scores))
      if (rv$page==1 && length(null.scores)){
        showModal(modalDialog(
          title = "Warning",
          paste0("Please select a score for the highlighted symptom",ifelse(length(null.scores)>1,"s.","."))
        )) 
        
      }else{
        rv$page <- rv$page + direction
        # pagenum<<-rv$page
        # rv$page
      }
    }
    
    observeEvent(input$prevBtn, navPage(-1))
    observeEvent(input$nextBtn, navPage(1))
    observe({
      if (is.null(rv$page)){
        return(NULL)}else{
      pagenum<-rv$page
      if(pagenum==1){
        
        
        shinyjs::show("phqscores")#, anim=TRUE,animType = "slide", time=2)
        hide("phqcausal")
        hide("qgd")
        
      }
      else if (pagenum==2){
        
        
        
        # session$sendCustomMessage(type = "showhide", message = list( up = "phqscores",down="phqcausal"))
        hide("phqscores")
        #hide("qgd")
        shinyjs::toggle("phqcausal")
        hide("markdown", anim=TRUE,animType = "slide", time=2)
        hide("report", anim=TRUE,animType = "slide", time=2)
      }else if(pagenum==3){
        
        hide("phqcausal")
        #shinyjs::show("qgd")
        observe({
          rv$m2 
          
          m2numeric<<-apply(rv$m2,2,as.numeric)
          
          qg<<-qgraph(m2numeric,layout="spring")
          rv$od<<-centrality(qg)$OutDegree
          
          for (i in 1:length(rv$scores)){
            
            scorenums=c(scorenums,rv$scores[[i]])
          }
          #sn<-as.integer(scorenums)
          # r<-sn*(255%/%(max(sn)))
          # nc<-rgb(r,0,0, maxColorValue = 255)
          lbl=c("Interest","Down","Sleep","Tired","Appetite","Worthless","Concentrate","slow/fidgety","Suicide")
          
          
          oddf<<-data.frame("Symptom"=sx, "Outdegree"=rv$od)
          oddf<<-oddf[order(-oddf$Outdegree),] 
          
          
          
          qgresult<<-qgraph(apply(rv$m2,2,as.numeric),labels=lbl,bg="#385b39",edge.width=2,edge.color="white",label.scale=F,border.color="white",border.width=3,label.color="white",color="red",label.font=14,layout="spring",vsize=rv$od*2)
          
          
          
        })
        
        shinyjs::show("report", anim=TRUE,animType = "slide", time=0.5)
        output$markdown <- renderUI({
          
          h<<- HTML(markdown::markdownToHTML(knit('report.Rmd', quiet = TRUE)))
          
        })
        
        shinyjs::show("markdown", anim=TRUE,animType = "slide", time=2)
        #session$sendCustomMessage(type = "showhide", message = list( up = "phqcausal",down="markdown"))
        #
        
      }else if(pagenum==4){
        shinyjs::hide("report")
        shinyjs::hide("markdown")
        #testmerge()
        #shinyjs::show("pmarkdown")
        
   
    
    #dbphq<<- read.csv("PHQ.csv",header=T)
    
    
    #output$report <- downloadHandler(
    
    # filename = "report.html",
    # content = function(file) {
    
    ## tempReport <- file.path(tempdir(), "report.Rmd")
    ## file.copy("report.Rmd", tempReport, overwrite = TRUE)
    #f<<-file
    
    #params <- list(n = input$slider)
    
    # rmarkdown::render("report.Rmd", output_file = file,
    # params = params,
    # envir = new.env(parent = globalenv())
    
    # )
    #  }
    # )
    
    
    
    
    
    
   
    
    
    
    # } else if(pagenumb==4){
    #######????????????????????????????????????????????????????????????????????????????????????????????????
   
    
   
    
    
    gettnodes =function(rephtml){
      htmlparsed <- htmlParse(rephtml,asText=TRUE,useInternalNodes=TRUE)
      tnodes=NULL
      imgnodes=NULL
      if(!is.null(xmlRoot(htmlparsed))) {
        
        tnodes = getNodeSet(htmlparsed, "//table")
        imgnodes = getNodeSet(htmlparsed, "//p/img")
      }
      
      result=list(tnodes,imgnodes) 
    }
    
    
    
    #############
    
    readHTMLTable <-function(tb){
      
      # get the header information.
      colNames = sapply(tb[["thead"]][["tr"]]["th"], xmlValue)
      colNames[which(colNames=="")]=paste0("column",which(colNames==""))
      vals = sapply(tb[["tbody"]]["tr"],  function(x) sapply(x["td"], xmlValue))
      matrix(as.character(vals),
             nrow = ncol(vals),
             ncol=nrow(vals),
             dimnames = list(c(1:ncol(vals)), colNames),
             byrow = TRUE
      )
    }
    ######################################
    ex1s2sts=function(tblset){
      
      ts=list()
      
      for (i in 1:length(tblset)){
        
        ts[[i]]=list() 
        for (j in 1:length(tblset[[i]])){ 
          ts[[i]][[j]]= tblset[[j]][[i]]
          
        }
        
        ts[[i]]
      }
      ts
      
    }
    #########################################
    merging=function(tblgroup){                              
      #}
      merge1s=list()
      
      for (i in 1:length(tblgroup)){
        
        merge1s[[i]]=tblgroup[[i]][[1]]
        
        for (j in 2:length(tblgroup[[i]])){
          merge1s[[i]]=merge(merge1s[[i]],tblgroup[[i]][[j]],by=c(colnames( tblgroup[[i]][[1]])[1:(ncol(tblgroup[[i]][[1]])-1)]))
          
        }
        
      }
      merge1s
      
    }
    #######################
    removextrarows=function(mergedtable){
      mt=mergedtable
      nrmt=nrow(mt)
      ndate=length(thekeys)
      nondaterows=nrmt-ndate
      if (nondaterows!=1){
        mt=mt[-c(1:nondaterows-1),]
      }
      mt=as.data.frame(mt,stringsAsFactors = FALSE) 
      colnames(mt)=mt[1,]
      mt=mt[-1,]
      mt
      
    }
    ########################3
    getggplot=function(mergedtable){
      
      mt=data.frame(mergedtable,row.names = NULL,stringsAsFactors =FALSE)
      
      
      mt=cbind(mt,"date"=rownames(mt)) 
      
      # lapply(merged,function(x){colnames(x)[(((ncol(x)-length(thekeys)))+1):ncol(x)] <- format(as.Date(dfrep$keys, format = "%d.%m.%y"),format = "%Y-%m-%d")})
      
      
      mtlong <- melt(mt, id="date")
      
      #m1=as.data.frame(mergedtable,stringsAsFactors = FALSE) 
      # colnames(m1)=m1[1,]
      
      #m1=m1[-1,]
      #m1=cbind(m1,"date"=rownames(m1)) 
      # lapply(merged,function(x){colnames(x)[(((ncol(x)-length(thekeys)))+1):ncol(x)] <- format(as.Date(dfrep$keys, format = "%d.%m.%y"),format = "%Y-%m-%d")})
      #m1=data.frame(m1,row.names = NULL,stringsAsFactors =FALSE)
      
      #m1long <- melt(m1, id="date")
      
      ggplt<-ggplot(data=mtlong,aes(x=date, y=value, colour=variable,group = variable)) +geom_line()
      ggplt
      }
    
    getimgsources=function(reportnodeset){
      imgnodeset=reportnodeset[[2]]
      
      
      imgtag=unlist(lapply(imgnodeset,function(x){ (unlist(xmlAttrs(x)[[1]]))}) )
      
    }
      }
      
        } 
    })
    ########################################3   
     observe({
      if (is.null(input$receivedreps)){ 
       return(NULL)}
    # get the window.reps sent as input$receivedreps from Parent Javascript 
    #logjs("reports received by iframe")
       thekeys<- input$receivedreps$k
    thereps<-input$receivedreps$r

      thekeys<<-lapply(thekeys,function(x)as.Date(strptime(x,format="%m/%d/%Y, %I:%M:%S %p")))
      
      
      dfrep=data.frame("keys"= as.Date(unlist(thekeys),origin="1970-01-01"),#unlist(as.Date(thekeys, format = "%Y/%d/%m")),
                       "reports"=unlist(thereps),stringsAsFactors = FALSE)
      
      dfrep=dfrep[order(dfrep[, 1]), ]
      
      os= lapply(thereps,gettnodes)
      tablessets=list()
      for (i in 1:length(os)){
        tablessets[[i]] = lapply(os[[i]][[1]], readHTMLTable)
      }
      onestwos=ex1s2sts(tablessets)
      
      merged=merging(onestwos[c(1,2)])
      for (i in 1:length(merged)){
        names(merged[[i]])[(((ncol(merged[[i]])-length(thekeys)))+1):ncol(merged[[i]])] <- format(as.Date(dfrep$keys, format = "%d.%m.%y"),
                                                                                                  format = "%Y-%m-%d")
        rownames(merged[[i]])=NULL
        merged[[i]]=t(merged[[i]])
      }
      
      merged=lapply(merged,removextrarows)
      
      
      m1=merged[[1]]
      m1=lapply(m1,function(x)as.numeric(x))
      m1=as.data.frame(m1,stringsAsFactors = FALSE)
      totalscore=apply(m1,1,sum)
      #logjs(totalscore)
      dftotalscore=data.frame("Report.Date"=rownames(merged[[1]]), "Total.Score"=as.integer(totalscore), stringsAsFactors=FALSE)
      ggtotal<<-ggplot(dftotalscore, aes(x=Report.Date, y=Total.Score,fill=factor(Total.Score)))+geom_bar(stat = "identity",width=0.5,color="red")+geom_text(aes(label=Total.Score), vjust=1.6, color="blue", size=3.5)+scale_fill_brewer(palette="Reds")
      
      
      
      ggplots<<-lapply(merged,getggplot)
      
      imgsources<<-lapply(os,getimgsources)
      #########################
      output$pmarkdown <- renderUI({
        pmd<<- HTML(markdown::markdownToHTML(rmarkdown::render('preport.Rmd', quiet = TRUE)))
        
      })
       shinyjs::show("pmarkdown")
      
    })
     
      
     
       
    
    
    
    
observeEvent(input$report,{
  session$sendCustomMessage(type = "sendtodevice", message = list( report = h))
})  
observe({
  if (is.null(input$clienttime)){ 
    return(NULL)}
  clientlocaltime<<- input$clienttime
})  
    
    
 ###########################################33333   

   session$onSessionEnded(stopApp)
  }  
    
    )