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

number_of_metadata_per_project <- function(df){

for (metadata in df$metadata) {
if (grepl("https://docs.google.com/spreadsheets",metadata)==TRUE) {
  cat(metadata)
  number <- nrow(as.data.frame(gsheet::gsheet2tbl(metadata)))
                            } else { number=0}
number_metadata <- append(number_metadata,number)
cat("Number of metadata in google spreadsheet for this project\n")
cat(number_metadata)
cat("\n")
}

  return(number_metadata)
}


number_of_bibliographic_reference_in_Zotero_per_project <- function(df,zotero_group,zotero_key){

for(project in df$content){
  cat("\n")
  publications_of_the_project_in_Zotero_with_tags <- ReadZotero(group = zotero_group,
                                                                .params = list(tag=project, key = zotero_key),
                                                                temp.file = tempfile(fileext = ".bib",tmpdir = getwd()),
                                                                delete.file = FALSE
  )
  publications_of_the_project_in_Zotero_full_text <- ReadZotero(group = zotero_group,
                                                                .params = list(q=project, key = zotero_key),
                                                                temp.file = tempfile(fileext = ".bib",tmpdir = getwd()),
                                                                delete.file = FALSE
  )
  cat("Number of publications found in Zotero (using keywords)\n")
  cat(length(number_publications_of_the_projects_in_Zotero_with_tags))
  number_publications_of_the_projects_in_Zotero_with_tags <- append(number_publications_of_the_projects_in_Zotero_with_tags,length(publications_of_the_project_in_Zotero_with_tags))
  number_publications_of_the_projects_in_Zotero_full_text <- append(number_publications_of_the_projects_in_Zotero_full_text,length(publications_of_the_project_in_Zotero_full_text))
  cat("\n")
  
}

df$Zotero_references_with_tags_with_tags <- number_publications_of_the_projects_in_Zotero_with_tags
df$Zotero_references_with_tags_full_text <- number_publications_of_the_projects_in_Zotero_full_text

return(df)
}



########################################EXAMPLE 1: CREATE A TIMELINE ##############################################
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
########################################EXAMPLE 2: PLOT BAR => NUMBER OF METADATA / DATASET DESCRIBED PER PROJECT ##############################################
number_metadata = c()
number_publications_of_the_projects_in_Zotero_with_tags = c()
number_publications_of_the_projects_in_Zotero_full_text = c()

COI_Projects$Metadata <-number_of_metadata_per_project(df=COI_Projects)
total_metadata<-sum(COI_Projects$Metadata)
Date <-Sys.Date()

main=paste("Metadata per project @", Sys.Date(),"(TOTAL: ",total_metadata," metadata)",sep="")
filename <- paste("Metadata_per_project_", Sys.Date(),sep="")
svg(paste(filename,".svg",sep=""), width=15, height=5)
#png(paste(filename,".png",sep=""), width=1500, height=500)
barplot(COI_Projects$Metadata,
        names.arg=COI_Projects$content,
        xlab="Project Name",
        cex.names=0.8,
        las=2,
        ylab="Number of Metadata",
        col="blue",
        main=main,
        border="red")

# http://www.sthda.com/french/wiki/fonction-abline-de-r-comment-ajouter-facilement-une-droite-a-un-graphique
abline(h=20,col="red",lty=2)
abline(h=30,col="red",lty=2)
abline(h=40,col="red",lty=2)

dev.off() # to complete the writing process and return output to your monitor

########################################EXAMPLE 3: PLOT BAR => NUMBER OF BIBLIOGRAPHIC REFERENCE IN ZOTERO PER PROJECT ##############################################
my_zotero_group <- "303882"
my_zotero_key  <-  "SxxjJB39vU7dnnEOCnbVSpBT"
COI_Projects<-number_of_bibliographic_reference_in_Zotero_per_project(df=COI_Projects,my_zotero_group,my_zotero_key)

main=paste("Zotero: Bilan par projet pour des recherches plein texte / Titre / Résumé @", Sys.Date(), sep="")
filename <- paste("Zotero_references_per_project_search_full_text", Sys.Date(),sep="")
svg(paste(filename,".svg",sep=""), width=15, height=5)

barplot(COI_Projects$Zotero_references_with_tags_full_text,
        names.arg=COI_Projects$content,
        xlab="Project Name",
        ylab="Number of References",
        cex.names=0.8,
        las=2,
        col="blue",
        main=main,
        border="red")

# http://www.sthda.com/french/wiki/fonction-abline-de-r-comment-ajouter-facilement-une-droite-a-un-graphique
abline(h=20,col="red",lty=2)
dev.off() # to complete the writing process and return output to your monitor

main=paste("Zotero: recherche par mots-clés@", Sys.Date(), sep="")
filename <- paste("Zotero_references_per_project_search_keywords", Sys.Date(),sep="")
svg(paste(filename,".svg",sep=""), width=15, height=5)

barplot(COI_Projects$Zotero_references_with_tags_with_tags,
        names.arg=COI_Projects$content,
        xlab="Project Name",
        cex.names=0.8,
        las=2,
        ylab="Number of References",
        col="blue",
        main=main,
        border="red")

# http://www.sthda.com/french/wiki/fonction-abline-de-r-comment-ajouter-facilement-une-droite-a-un-graphique
abline(h=20,col="red",lty=2)
dev.off() # to complete the writing process and return output to your monitor




