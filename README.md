# SwiftRealtyComplete

# Swift Realty App (With Amazon AWS)
This is the completed Xcode project for the demo app called "SwiftRealty" - a basic app written in Swift for Apple iPhones that uses Amazon Web Services to integrate The Cloud. The purpose of the app is to teach iOS developers how to integrate Amazon Web Services into their projects. The app will allow realtors from a real estate agency the ability to add listings with data and images, that will then be stored in AWS S3 and AWS DynamoDB. The users will also be able to fetch and view all saved listings.

## Prerequisites

- XCode - version 8.0 or higher
- An iPhone running iOS 10.0 or higher (or a simulator equivalent)
- AWS Account - (You can use a free-tier account but will need a credit card to register)
- Basic iOS programming knowledge
- AWS Cognito Identity Pool ID (Created in tutorial at <a href="https://www.piercehubbard.com">https://www.piercehubbard.com</a>)
- AWS DynamoDB Table (Created in tutorial at <a href="https://www.piercehubbard.com">https://www.piercehubbard.com</a>)
- AWS S3 Bucket (Created in tutorial at <a href="https://www.piercehubbard.com">https://www.piercehubbard.com</a>)
- AWS IAM Custom Role Policy for DynamoDB Table (Created in tutorial at <a href="https://www.piercehubbard.com">https://www.piercehubbard.com</a>)

## Installing

- To run this app, first download the project.
- You should try downloading the starter project at <a href="https://github.com/MVPierce/SwiftRealtyStarter">https://github.com/MVPierce/SwiftRealtyStarter</a>, and then working through the entire tutorial - available free at <a href="https://www.piercehubbard.com">https://www.piercehubbard.com</a>. If you can't, don't have time, or keep getting stuck, you can run this project on an iPhone with iOS 10.0 or higher, BUT!!! (read next)
- EXCEPTION - for the app to run properly, you will need all things listed above that we went through in the tutorial. You really need to follow along with the project to make the app work properly, but I have this completed project available for your reference, in case you need the source code.
- Please realize that just jumping ahead and downloading this project won't work properly without walking through the proper steps to setup your AWS products.

## Use the App

### Save/View Listings
- Run the app where you will automatically be authenticaed by Amazon AWS Cognito.
- View table full of saved listings
- Tap on listing to expand details of selected listing
- Tap add button to save a new listing.

## Challenges

### Improve UX Design
- This is a very bare-bones app we worked through. The main purpose was just to show you some basics of how to integrate the Cloud (AWS) into your iOS apps. This app could be improved in so many ways. A lot of the UI leaves a lot to be desired. Numerous aspects of this app could be improved upon. I challenge you to make it look and feel as clean as possible!

## Built and Designed With
- XCode 8.2.1
- MacBook Pro 2012
- Tested with an iPhone 7 Simulator
- Repository with GitHub

## Author
- Created by Pierce Hubbard
- www.piercehubbard.com

