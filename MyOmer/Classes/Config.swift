//
//  Config.swift
//  MyOmer
//
//  Created by Aftab Akhtar on 3/18/18.
//  Copyright © 2018 Aftab Akhtar. All rights reserved.
//

import UIKit

internal struct Config {
    internal struct URL {
      // OLD "https://www.meaningfullife.com/product/spiritual-guide-to-counting-the-omer/"
        static let bookUrl = "https://www.meaningfullife.com/product/spiritual-guide-to-counting-the-omer-english/?utm_source=OmerApp&utm_campaign=OmerApp2019"
        static let donateUrl = "https://meaningfullife.com/help/donate/"
    }
    internal struct TechSupport {
        static let toReceipients = [
            "myomer@meaningfullife.com"
        ]
        static let subject = "Report MyOmer Bug"
        static let body = "Thank you for taking the time to report an issue with the MyOmer app. Please explain in detail the issue you are encountering, the make, the model of your phone, and include a screen shot if possible.\n\nWe will respond promptly.\n\nThank you."
    }
    internal struct Share {
        static let text = "49 Simple Steps to personal transformation Start your journey with My Omer: Sefirat HaOmer Counter. https://appsto.re/us/3EVjL.i"
    }
    internal struct ShareView {
        static let text =  "MyOmer: 49 Steps to Personal Refinement. Get the app for daily exercises and omer reminders. \nhttps://www.meaningfullife.com/myomer"
    }
    //iOS :- https://appsto.re/us/3EVjL.i \n Android :- https://play.google.com/store/apps/details?id=com.myomer.myomer
    internal struct Meditation {
        static let noMeditationText = "Get started with today’s journal questions and exercise."
    }
    internal struct Question {
        static let noQuestionText = "Please check back tomorrow for more journal questions."
    }
    internal struct Video {
        static let noVideoText = "Please check back tomorrow for more videos."
    }
    internal struct ContactUs {
        static let toReceipient = "myomer@meaningfullife.com"
    }
    internal struct Notification {
        static let firstDayTitle = "Meaningful Life Center"
        static let lastDayTitle = "You Completed the Omer!"
        static let otherDaysTitle = "Count the Omer"
        static let firstNightBody = "The first night of the Omer is Saturday after nightfall. Check daily for excercises and wisdom to grow as a person and take the 49 day journey to personal refinement."
        static let lastDayBody = "is 49th day of the Omer. Congratulations. You have examined every aspect of your personality."
        static let countString = "Make sure you count before nightfall."
        static let countStringAfter = "Make sure you count after nightfall."
    }
}
