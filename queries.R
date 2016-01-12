library(RGoogleAnalytics)

query.SessionsDayQuery <- Init(start.date = "2015-08-01",
                               end.date = "2015-10-29",
                               metrics = "ga:sessions, ga:pageviews",
                               dimensions = "ga:date, ga:year,ga:day",
                               max.results = 10000,
                               table.id = "ga:89873379")

query.WeightedBounceQuery<- Init(start.date = "2015-10-01",
                                 end.date = "2015-11-24",
                                 metrics = "ga:pageviews, ga:bounceRate",
                                 dimensions = "ga:pagePath ",
                                 max.results = 10000,
                                 table.id = "ga:89873379")

query.SessionsHourQuery <- Init(start.date = "2015-08-01",
                                end.date = "2015-10-29",
                                metrics = "ga:sessions, ga:pageviews",
                                dimensions = "ga:date, ga:hour",
                                max.results = 10000,
                                table.id = "ga:89873379")

query.NewReturnSessionsQuery <- Init(start.date = "2015-08-01",
                                     end.date = "2015-10-29",
                                     dimensions = "ga:userType",
                                     metrics = "ga:sessions",
                                     max.results = 10000,
                                     table.id = "ga:89873379")

query.SessionsByCountryQuery <- Init(start.date = "2015-08-01",
                                     end.date = "2015-10-26",
                                     dimensions = "ga:country",
                                     metrics = "ga:sessions",
                                     sort = "-ga:sessions",
                                     max.results = 10000,
                                     table.id = "ga:89873379")

query.AvgTimeSpentDayQuery <- Init(start.date = "2015-08-01",
                                   end.date = "2015-10-26",
                                   dimensions = "ga:date",
                                   metrics = "ga:sessions,ga:sessionDuration,ga:pageviews",
                                   sort = "-ga:sessions",
                                   max.results = 10000,
                                   table.id = "ga:89873379")

query.AvgTimeSpentHourQuery <- Init(start.date = "2015-08-01",
                                    end.date = "2015-10-26",
                                    dimensions = "ga:date,ga:hour",
                                    metrics = "ga:sessions,ga:sessionDuration,ga:pageviews",
                                    max.results = 10000,
                                    table.id = "ga:89873379")

query.KeywordQuery <- Init(start.date = "2015-08-01",
                           end.date = "2015-10-26",
                           dimensions = "ga:keyword",
                           metrics = "ga:sessions",
                           sort = "-ga:sessions",
                           max.results = 10000,
                           table.id = "ga:89873379")

query.ReferringSitesQuery <- Init(start.date = "2015-08-01",
                                  end.date = "2015-10-26",
                                  dimensions = "ga:source",
                                  metrics = "ga:sessionDuration, ga:pageviews, ga:exits",
                                  sort = "-ga:pageviews",
                                  max.results = 1000,
                                  filters = "ga:medium==referral",
                                  table.id = "ga:89873379")

query.EngagementQuery <- Init(start.date = "2015-08-01",
                              end.date = "2015-10-29",
                              dimensions = "ga:sessionDurationBucket",
                              metrics = "ga:sessions, ga:pageviews",
                              sort = "-ga:sessionDurationBucket",
                              max.results = 1000,
                              filters = "ga:sessionDurationBucket!~^[0-8]$",
                              table.id = "ga:89873379")


# Create the Query Builder object so that the query parameters are validated
ga.query <- QueryBuilder(query.NewReturnSessionsQuery)

# Extracted data and stored it in a data-frame

ga.NewReturnSessionsDf<- GetReportData(ga.query, token)

ga.query <- QueryBuilder(query.SessionsByCountryQuery)
ga.SessionsByCountryDf<- GetReportData(ga.query, token)

ga.query <- QueryBuilder(query.WeightedBounceQuery)
ga.WeightedBounceDf<- GetReportData(ga.query, token)

ga.query <- QueryBuilder(query.AvgTimeSpentDayQuery)
ga.AvgTimeSpentDayDf<- GetReportData(ga.query, token, split_daywise = T)
#AvgTimeSpentDayDf$AvgTimeSpent<- (AvgTimeSpentDayDf$profit / AvgTimeSpentDayDf$revenue) * 100

ga.query <- QueryBuilder(query.AvgTimeSpentHourQuery)
ga.AvgTimeSpentHourDf<- GetReportData(ga.query, token, split_daywise = T)

ga.query <- QueryBuilder(query.KeywordQuery)
ga.KeywordDf<- GetReportData(ga.query, token)

ga.query <- QueryBuilder(query.ReferringSitesQuery)
ga.ReferringSitesDf<- GetReportData(ga.query, token)

ga.query <- QueryBuilder(query.EngagementQuery)
ga.EngagementDf<- GetReportData(ga.query, token)

ga.query <- QueryBuilder(query.SessionsDayQuery)
ga.SessionsDayDf<- GetReportData(ga.query, token, split_daywise = T)

ga.query <- QueryBuilder(query.SessionsHourQuery)
ga.SessionsHourDf<- GetReportData(ga.query, token, split_daywise = T)
# Sanity Check for column names
dimnames(ga.NewReturnSessionsDf)

# Check the size of the API Response
dim(ga.NewReturnSessionsDf)

#Calulating derived metrics
#Weighted Bounce Rate

unique(ga.WeightedBounceDf$pagePath)
ga.WeightedBounceDf$WeightedBounceRate <- (ga.WeightedBounceDf$pageviews / sum(ga.WeightedBounceDf$pageviews)) * ga.WeightedBounceDf$bounceRate 

#exporting to an excel spreadsheet
library(xlsx)
write.xlsx(ga.WeightedBounceDf, "D:/Projects/weighted_bounce_rate.xlsx")

