library(XML)
doc = xmlTreeParse("./prescription/20150408_ea2dc1a6-22d5-4295-9d39-9bf015dc5a89/e41f44b8-04eb-4676-9ef9-3aaaab20a3d6.xml", useInternal = TRUE)
top = xmlRoot(doc)
xmlName(top)
names(top)

drug = top[["title"]]
names(drug)
names(top[[3]])

test <- xmlSApply(drug, xmlValue)
paste(test[names(test) != "br"], collapse=" ")

#####

library(stringr)
library(XML)

setwd("~/Downloads/prescription")

textFound = c()

for (i in 1:length(list.files())) {
  currentFolder = list.files()[i]
  currentFile = list.files(paste0("./", currentFolder))[1]
  
  #check to make sure currentFile is an xml file
  if (str_sub(currentFile, -4) == ".xml") {
    doc = xmlTreeParse(paste(".", currentFolder, currentFile, sep = "/"), useInternal = TRUE)
    top = xmlRoot(doc)
    drugInfo = top[["title"]]
    if (!is.null(drugInfo)) {
      text = xmlSApply(drugInfo, xmlValue)
      text = paste(text[names(text) != "br"], collapse=" ")
      textFound = c(textFound, text)
    } else {
      textFound = c(textFound, paste("NoneFound", as.character(i), sep = "_"))
    }
  }
}

textFound




