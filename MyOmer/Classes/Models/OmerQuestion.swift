//
//  OmerQuestion.swift
//  MyOmer
//
//  Created by Aftab Akhtar on 3/10/18.
//  Copyright © 2018 Aftab Akhtar. All rights reserved.
//

import UIKit
import RealmSwift

class OmerQuestion: NSObject {
    
    var id: Int
    var question: String
    var contentBefore: String
    var contentAfter: String
    
    init(id: Int, question: String, contentBefore: String, contentAfter: String) {
        self.id = id
        self.question = question
        self.contentBefore = contentBefore
        self.contentAfter = contentAfter
    }
    
    init(questionData: [String: Any]) {
        self.id = questionData["id"] as! Int
        self.question = questionData["question"] as! String
        self.contentBefore = questionData["contentBefore"] as! String
        self.contentAfter = questionData["contentAfter"] as! String
    }
    
    func answer(year: Int) -> OmerAnswer? {
        let realm = try! Realm()
        return realm.object(ofType: OmerAnswer.self, forPrimaryKey: "\(id)\(year)")
    }
    
    static func `import`(questionsArray: [[String: Any]]) -> [OmerQuestion] {
        var questions: [OmerQuestion] = []
        for questionData in questionsArray {
            let question = OmerQuestion(questionData: questionData)
            questions.append(question)
        }
        return questions
    }

}
