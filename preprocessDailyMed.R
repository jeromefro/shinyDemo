# this script is to unzip all the zip files in one download from DailyMed, and
# delete all non-xml files

library(stringr)

setwd("~/Downloads/prescription")

for (i in 1:length(list.files())) {
  currentFolder = list.files()[i]
  
  if (str_sub(currentFolder, -4) == ".zip") {
    filename = str_sub(currentFolder, start = 1, end = -5)
    unzip(currentFolder, exdir = filename)
    files = list.files(paste0("./", filename))
    toRemove = c()
    for (i in 1:length(files)) {
      if (str_sub(files[i], -4) != ".xml") {
        toRemove = c(toRemove, paste0("./",filename,"/",files[i]))
      }
    }
    file.remove(toRemove)
    file.remove(currentFolder)
  }
}
