Summary:

Rate My Dorm is an app that allows students to rate and review their college dorm rooms and residence halls. Users can search for and browse ratings and reviews of dorms at colleges and universities. The site aims to help prospective students get a sense of the dorm options available at schools they are considering.


Project Setup:

This app is built using SwiftUI for the user interface and Firebase for the backend data and storage.


Data Models:

User:
id: DocumentID
email: String
username: String
universityName: String
forumIds: [String]
reviewIds: [String]

Review:
id: DocumentID
userId: DocumentID
dornName: String
universityName: String
roomRating: Number(Int)
buildingRating: Number(Int)
locationRating: Number(Int)
bathroomRating: Number(Int)
comment: String
photo: String
classYears: [String]
roomTypes: [String]
overallRating: Number(Double)
timeStamp: Timestamp

Dorm:
id: DocumentID
name: String
universityName: String
overallRating: Number(Double)
reviews: [String]    //review ids
photos: [String]
roomOverallRating: Number(Int)
buildingOverallRating: Number(Int)
locationOverallRating: Number(Int)
bathroomOverallRating: Number(Int)
freshmanCounts: Number(Int)
sophomoreCounts: Number(Int)
juniorCounts: Number(Int)
seniorCounts: Number(Int)
graduateCounts: Number(Int)

Resources:
id: DocumentID
title: String
description: String
coverPhoto: String
link: String

Forum:
id: DocumentID
userId: DocumentID
username: String
title: String
description: String
parentPostId: String
timeStamp: TimeStamp

University:
id: DocumentID
name: String
dorms: [String]    // dorm ids

Implementation:

In the RateMyDorm project, we have implemented 6 main features with the data model defined above.

Login / Signup
We have implemented user authentication by leveraging the Firebase user authentication feature, allowing students to login and signup with the app. Users can create an account by providing their email, password, username, and university that they attend. These details are securely stored in the database. Appropriate validations are also added on both signup and login.

View Dorms & Reviews
Upon logging into the RateMyDorm app, users are presented with a homepage showing a list of all the dorms available in their university. The dorm list displays some key information like name, overall rating for that dorm as well as the number of ratings. Users can select any dorm from this list to view more detailed information and reviews.

The dorm details page shows overall rating, rating breakdowns (overall room rating, overall building rating, etc.), class years when the reviewers lived at that dorm, and detailed reviews.

Resource
The Resources section provides students quick access to university provided information related to dorms and campus housing. Each list item will redirect to the official website resource from the university in an in-app browser.

Add review for a dorm
The core feature of the app allows students to post reviews for dorms on campus that they have stayed at. To add a review, they need to first search for a dorm, select it and write a detailed review by selecting all those ratings, class years, room types as defined in the data model. They also need to leave a comment for at least 20 words, and have the option to upload a photo as well. The reviews are associated with the user account that posted it and the dorm being reviewed.

Forum
We have a forum section where users can participate in discussions through threads and posts. It serves as a message board to ask questions, seek advice etc related to dorms and student housing. Users can create new threads or contribute to existing threads through posts and comments.

My profile
The profile page summarizes their activity on the app through information like reviews posted, forum threads & posts created.


Further improvements:

Although RateMyDorm already enables users to post dorm reviews and provides useful housing resources, additional features can be implemented gradually to improve the application. For photo uploads in reviews, currently there is a limit of one photo per review. This can be enhanced by allowing users to upload multiple images while posting a review, providing more visual representation of the dorm room and facilities. Additionally, to verify the authenticity of reviews, new signups can be required to validate their .edu university email address. This ensures only student users, verified via their official educational email IDs, can contribute ratings and feedback on the platform. Finally, a "Report Missing Info" feature can allow users to flag any lack of information or listings regarding specific dorms to the app admin so the database can be updated accordingly.
