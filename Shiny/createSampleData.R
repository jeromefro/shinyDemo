# Create Sample Data

indications <- c(rep("cancer",3), rep("heart attack",3))
drugs <- c("Drug A", "Drug B", "Drug C", "Drug X", "Drug Y", "Drug Z")

sampleCompoundData <- cbind(indications, drugs)

write.csv(sampleCompoundData, "./Data/sampleCompoundData.csv", row.names=FALSE)
test <- read.csv("./Data/sampleCompoundData.csv")


drugs <- rep(drugs, each = 3)
similar <- c()
for (i in 1:6) {
  for (j in 1:3) {
    current <- paste0(drugs[(i-1)*3 + j], as.character(j))
    similar <- c(similar, current)
  }
}

sampleSimilarData <- cbind(drugs, similar)

write.csv(sampleSimilarData, "./Data/sampleSimilarData.csv", row.names=FALSE)
test <- read.csv("./Data/sampleSimilarData.csv")

drugs <- rep(similar, times=c(3,2,1,4,1,1,5,3,6,3,3,2,4,1,3,5,1,2)*10)
country <- rep(c("United States", "United Kingdom", "Canada", "Japan"), times = c(20, 15, 8, 7)*10)
country <- sample(country)
event <- rep(c("Pain", "Fatigue", "Nausea", "Diarrhoea"), times = c(20, 14, 10, 6)*10)
event <- sample(event)
indication1 <- rep(c("High Blood Pressure", "High Cholesterol"), times = c(14,11)*10) 
indication1 <- sample(indication1)
indication2 <- rep(c("Colon Caner", "Lung Cancer", "Breast Cancer"), times = c(11, 8, 6)*10)
indication2 <- sample(indication2)
indication <- c(indication1, indication2)

sampleAdverseData <- data.frame(drugs, country, event, indication)
sampleAdverseData <- sampleAdverseData[rep(1:nrow(sampleAdverseData),each=3),] 

write.csv(sampleAdverseData, "./Data/sampleAdverseData.csv", row.names=FALSE)
test <- read.csv("./Data/sampleAdverseData.csv", colClasses = "character")


center <- rep(c("National Cancer Institute",
                "National Institute of General Medicine Science",
                "National Heart, Lung, and Blood Institute",
                "National Institute on Aging"),
              times = c(18, 6, 4, 8))
center <- sample(center)
amount <- rep(c(100000, 150000, 200000, 50000, 30000, 400000, 95000, 72000, 113000),
              times = 4)
amount <- sample(amount)
sampleCancerFundsData <- data.frame(center, drug = similar, amount, indication = "cancer")

write.csv(sampleCancerFundsData, "./Data/sampleCancerFundsData.csv", row.names=FALSE)
test <- read.csv("./Data/sampleCancerFundsData.csv", 
                 colClasses = c("character", "character","numeric", "character"))


center <- rep(c("National Institute of Neuroligical Disorders and Stroke",
                "National Institute of General Medicine Science",
                "National Heart, Lung, and Blood Institute",
                "National Institute on Aging"),
              times = c(2, 4, 18, 12))
center <- sample(center)
amount <- rep(c(100000, 150000, 200000, 50000, 30000, 400000, 95000, 72000, 113000),
              times = 4)
amount <- sample(amount)
sampleHeartFundsData <- data.frame(center, drug = similar, amount, indication = "heart attack")

sampleFundsData <- rbind(sampleCancerFundsData, sampleHeartFundsData)

write.csv(sampleFundsData, "./Data/sampleFundsData.csv", row.names=FALSE)
test <- read.csv("./Data/sampleFundsData.csv", 
                 colClasses = c("character", "character","numeric", "character"))

trials <- c()
for (j in 1:36) {
    current <- paste0("Trial ", as.character(j))
    trials <- c(trials, current)
}
trials <- sample(trials)

ids <- sample(100000:199999, size = 36)

sampleTrialData <- data.frame(Drug = similar, ID = ids, Name = trials, Description = "Description..." )

write.csv(sampleTrialData, "./Data/sampleTrialData.csv", row.names=FALSE)
test <- read.csv("./Data/sampleTrialData.csv", colClasses = "character")
