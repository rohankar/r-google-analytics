#authenticates the script with Google analytics using OAuth and passes the queried data into a SQL database everytime it is run.
library(RGoogleAnalytics)

# Authorize the Google Analytics account
# This need not be executed in every session once the token object is created 
# and saved

client.id <- 
client.secret <- 
token <- Auth(client.id,client.secret)

# Save the token object for future sessions
save(token,file="./token_file")

# In future sessions it can be loaded by running load("./token_file")

ValidateToken(token)

query.sample <- Init(start.date = "2015-01-01",
                     end.date = "2015-10-18",
                     dimensions = "ga:date,ga:pagePath,ga:hour,ga:medium",
                     metrics = "ga:sessions,ga:pageviews",
                     max.results = 10000,
                     sort = "-ga:date",
                     table.id = "ga:89873379")


#Validate query using QueryBuilder object
ga.query <- QueryBuilder(query.sample)

# Extracted data and stored it in a data-frame
ga.data <- GetReportData(ga.query, token, split_daywise = T)

# Sanity Check for column names
dimnames(ga.data)

# Check the size of the API Response
dim(ga.data)

#simple table generated for sessions since jan
ga.data$date <- as.Date(ga.data$date, "%Y%m%d")
df <- ga.data[order(ga.data$date), ]
dt <- qplot(date, session, data=df, geom="line") + theme(aspect.ratio = 1/2)
dt + scale_x_date(labels = date_format("%m/%d"),breaks = date_breaks("day"))

#plot(ga.data$data, type="o", col="blue") 

#using RMySQL package performing data transactions with local db
library(RMySQL)
library(psych)
con <- dbConnect(MySQL(),
                 user = '',
                 password = '',
                 host = '',
                 dbname='')
dbWriteTable(conn = con, name = 'Test', value = as.data.frame(ga.data))