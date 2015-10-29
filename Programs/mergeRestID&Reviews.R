setwd("~/Box Sync/PhD study/DataMining/DataMiningProject/yelp_dataset_challenge_academic_dataset")
library("jsonlite")

# read business dataset
business <- stream_in(file("yelp_academic_dataset_business.json"))
# extract restaurants
restaurant <- business[which (grepl("Restaurants", business$categories)), ]
# write restaurant IDs into a csv file
write.table(restaurant$business_id, file = "RestID.csv", row.names = F)

# read review dataset
review <- stream_in(file("yelp_academic_dataset_review.json"))
# delete useless info
review <- review[ ,c(2,4,6,8)]

# merge restaurant ID with reviews
RestReview <- merge(RestID, review, by.x = "x", by.y = "business_id")
colnames(RestReview)[1] <- "business_id"
# write all reviews into a csv file
write.csv(RestReview, file = "RestReview.csv", row.names = F)

# count the number of reviews per user
reviewCount <- as.data.frame(table(RestReview$user_id))
reviewCount <- reviewCount[order(reviewCount$Freq),]

# count the number of users having more than 5/10 reviews
length(reviewCount[which (reviewCount$Freq > 5),1])
length(reviewCount[which (reviewCount$Freq > 10),1])

# the total number of reviews
sum(reviewCount[which (reviewCount$Freq <= 5),2])
sum(reviewCount[which (reviewCount$Freq > 5),2])

# the total number of reviews
sum(reviewCount[which (reviewCount$Freq <= 10),2])
sum(reviewCount[which (reviewCount$Freq > 10),2])

# only reserve users with more than 5 reviews
reviewCount5 <- reviewCount[which (reviewCount$Freq > 5), ]
RestReview5 <- merge(reviewCount5, RestReview, by.x = "Var1", by.y = "user_id")
RestReview5 <- RestReview5[, -2]
colnames(RestReview5)[1] <- "user_id"
write.csv(RestReview5, file = "RestReview5.csv", row.names = F)

# only reserve users with more than 10 reviews
reviewCount10 <- reviewCount[which (reviewCount$Freq > 10), ]
RestReview10 <- merge(reviewCount10, RestReview, by.x = "Var1", by.y = "user_id")
RestReview10 <- RestReview10[, -2]
colnames(RestReview10)[1] <- "user_id"
write.csv(RestReview10, file = "RestReview10.csv", row.names = F)



