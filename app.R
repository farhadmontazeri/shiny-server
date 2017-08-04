library(shiny)
library(DT)
library(shinyjs)
library(qgraph)
library(knitr)
library(XML)
NUM_PAGES <- 3



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
    "STEP", i,": ", ifelse(i==1,"Scoring Symptoms",ifelse(i==2,"Causal Relations",ifelse(i==3,"Report","") ))
    #ifelse(i==4,"Generate Report","")
    ))
})),hidden(actionButton("report", "Save Report")),#sliderInput("slider", "Slider", 1, 100, 50),





                 #actionButton("graph","Next"),
                 DT::dataTableOutput('phqscores'),
                 hidden(DT::dataTableOutput('phqcausal')),
                # verbatimTextOutput('sel'),
                # plotOutput("qgd")
                  hidden(uiOutput('markdown')) 
                 #tableOutput('sel')
  ),
  server = function(input, output, session) {
     rv <- reactiveValues(page = 1)
    sx<<-c("Little Interest","Feeling Down","Sleep Issues","Fatigue","Appetite Change","Worthlessness","Trouble Concentrate","Slow/Fidgety","Suicidality")
    p.scores<-c("Not at all","Several days","More than half the days","Nearly every day") 
    scores<-vector()
    scorenums<-vector()
    null.scores<<-vector()
    dbphq<<- read.csv("PHQ.csv",header=T,stringsAsFactors = FALSE)
    
   
    
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
     scores<<- sapply(sx, function(i) input[[i]])
     null.scores<<-vector()
     for (i in 1:length(scores)){
       if (is.null(scores[[i]])){
         null.scores<<-c(null.scores,i)
       }
       
     }
     print(null.scores)
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
        m2<<-as.matrix(m)
        as.matrix(m)
      }
      
      #str(sapply(sx, function(i) input[[i]]))
    })
    
    
    
    observe({
      toggleState(id = "prevBtn", condition = rv$page > 1)
      toggleState(id = "nextBtn", condition = rv$page < NUM_PAGES)
      hide(selector = ".page")
      shinyjs::show(sprintf("step%s", rv$page))
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
      pagenum<-rv$page
      if(pagenum==1){
        
        
        shinyjs::show("phqscores", anim=TRUE,animType = "slide", time=2)
        hide("phqcausal", anim=TRUE,animType = "slide", time=2)
        hide("qgd")
        
      }
      else if (pagenum==2){
        
        
        
        # session$sendCustomMessage(type = "showhide", message = list( up = "phqscores",down="phqcausal"))
        hide("phqscores", anim=TRUE,animType = "slide", time=2)
        #hide("qgd")
        shinyjs::toggle("phqcausal", anim=TRUE,animType = "slide", time=2)
        hide("markdown", anim=TRUE,animType = "slide", time=2)
        hide("report", anim=TRUE,animType = "slide", time=2)
      }else if(pagenum==3){
        m2numeric<<-apply(m2,2,as.numeric)
        hide("phqcausal")
        #shinyjs::show("qgd")
        qg<-qgraph(m2numeric,layout="spring")
        
        od<-centrality(qg)$OutDegree

        for (i in 1:length(scores)){
          
          scorenums=c(scorenums,scores[[i]])
        }
        sn<-as.integer(scorenums)
        r<-sn*(255%/%(max(sn)))
        nc<-rgb(255,0,0,alpha=r, maxColorValue = 255)
        lbl=c("Interest","Down","Sleep","Tired","Appetite","Worthless","Concentrate","slow/fidgety","Suicide")
        #lbl=paste(lbltitle,od,sep="-")
        oddf<<-data.frame("Symptom"=sx, "Outdegree"=od)
        oddf<<-oddf[order(oddf$Outdegree),]
        qgresult<<-qgraph(m2numeric,labels=lbl,bg="#385b39",edge.width=2,edge.color="white",label.scale=F,border.color="white",border.width=3,label.color="white",color=nc,label.font=14,layout="spring",vsize=od*2)
        shinyjs::show("report", anim=TRUE,animType = "slide", time=0.5)
        shinyjs::show("markdown", anim=TRUE,animType = "slide", time=2)
        #session$sendCustomMessage(type = "showhide", message = list( up = "phqcausal",down="markdown"))
        #
        
      }#else if(pagenum==4){
        
      #}
      
      
      })
    
    #dbphq<<- read.csv("PHQ.csv",header=T)
    output$markdown <- renderUI({
      h<<- HTML(markdown::markdownToHTML(knit('report.Rmd', quiet = TRUE)))
      
    })
    
    
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
    observeEvent(input$report,{
      session$sendCustomMessage(type = "sendtodevice", message = list( report = h))
    })  
    observe({
      if (is.null(input$clienttime)){ 
        return(NULL)}
      clientlocaltime<<- input$clienttime
    })
    observe({
      if (is.null(input$receivedreps)){ 
        return(NULL)}
      # get the window.reps sent as input$receivedreps from Parent Javascript 
      thekeys<- unlist(input$receivedreps$k)
      thereps<-unlist(input$receivedreps$r)
      rep2=(thereps)[[2]]
      logjs(rep2)
      
      
      
      
      html2 <- htmlParse(rep2,asText=TRUE,useInternalNodes=TRUE)
      
      if(!is.null(xmlRoot(html2))) {
        
        o = getNodeSet(html2, "//table")
      }
      readHTMLTable =
        function(tb)
        {
          # get the header information.
          colNames = sapply(tb[["thead"]][["tr"]]["th"], xmlValue)
          vals = sapply(tb[["tbody"]]["tr"],  function(x) sapply(x["td"], xmlValue))
          matrix(as.numeric(vals[-1,]),
                 nrow = ncol(vals),
                 dimnames = list(vals[1,], colNames[-1]),
                 byrow = TRUE
          )
        }  
      tables = lapply(o, readHTMLTable)
      logjs("iframe:tables extracted"+tables)
      names(tables) = lapply(o, function(x) xmlValue(x[["caption"]]))
      
      if(!is.null(xmlRoot(html2))) {
        
        oi <<- getNodeSet(html2, "//p/img")
        
      } 
      logjs("iframe:oi[[1]]"+oi[[1]])
      logjs("iframe:xmlvalueoi[[1]]"+xmlValue(oi[[1]]))
      
      
      
      
      })
      #dfgrouping<<-cbind.data.frame("column"=column,"color"=color,"groupname"=gname,stringsAsFactors=TRUE)
    session$onSessionEnded(stopApp)
    
    }
    )