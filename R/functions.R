################### timevis package / https://daattali.com/shiny/timevis-demo/ ################################
# OTHER EXAMPLES HERE https://daattali.com/shiny/timevis-demo/
library(timevis)
require(timeline)
library(dplyr)
###############################################################################################################

create_timeline_for_projects <- function(df){
  number_row<-nrow(df)
  list_COI_Projects <- data.frame(id= 1:number_row,
                                  content = df$content,
                                  start   = df$start,
                                  end     = df$end,
                                  group     = df$group#,
                                  # groups = groups
                                  ) #%>%  setGroups(groups)
  timevis(data=list_COI_Projects,fit=TRUE, zoomFactor = 1)
  myTimeline <- timevis(data=list_COI_Projects,fit=TRUE, zoomFactor = 1)
  Timeline_file <- "IOC_Projects_Timeline.html"
  htmlwidgets::saveWidget(myTimeline, Timeline_file, selfcontained = F)
  
  return(Timeline_file)
}

########################################EXAMPLE##############################################
DataGroup_gsheet <- "https://docs.google.com/spreadsheets/d/1dQLucq5OAm1qBHPuJv_7mDEOWq9x0Cyknp6ecVtGtS4/edit?usp=sharing"
DataGroup <- as.data.frame(gsheet::gsheet2tbl(DataGroup_gsheet))
names(DataGroup)
DataGroupA = subset(DataGroup, select = c(Projet,Projet_Acronym,Budget,StartDate,EndDate,Subject,Datasets) )
names(DataGroupA)
COI_Projects = rename(DataGroupA, Title=Projet,content=Projet_Acronym, Funding=Budget, start=StartDate, end=EndDate, group=Subject, metadata=Datasets)
names(COI_Projects)
COI_Projects$start <- as.Date(COI_Projects$start, format="%d-%m-%Y")
COI_Projects$end <- as.Date(COI_Projects$end, format="%d-%m-%Y")

groups <- distinct(COI_Projects, group)
groups$id <-distinct(COI_Projects, group)

create_timeline_for_projects(df=COI_Projects)
#############################################################################################

