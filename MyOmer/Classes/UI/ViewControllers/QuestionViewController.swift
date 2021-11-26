//
//  QuestionViewController.swift
//  MyOmer
//
//  Created by Aftab Akhtar on 3/10/18.
//  Copyright © 2018 Aftab Akhtar. All rights reserved.
//

import UIKit
import RealmSwift

class QuestionViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var question: OmerQuestion?
    var totalQuestions = 0
    var index = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Memory Cleanup Methods

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension QuestionViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: UITableViewDataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell")!
        
        let answerContainer = cell.contentView.viewWithTag(4)!
        let pageLabel = cell.contentView.viewWithTag(1) as! UILabel
        let questionLabel = cell.contentView.viewWithTag(2) as! UILabel
        let answerTextView = cell.contentView.viewWithTag(3) as! UITextView
        
        if let question = question {
            answerContainer.isHidden = false
            pageLabel.isHidden = false
            questionLabel.isHidden = false
            answerTextView.isHidden = false
            pageLabel.text = "\(index+1) of \(totalQuestions)"
            questionLabel.textAlignment = .left
            questionLabel.text = question.question
            answerTextView.text = question.answer(year: Date().currentYear)?.answer
        }
        else {
            answerContainer.isHidden = true
            pageLabel.isHidden = true
            questionLabel.isHidden = false
            answerTextView.isHidden = true
            pageLabel.text = ""
            questionLabel.textAlignment = .center
            questionLabel.text = Config.Question.noQuestionText
            answerTextView.text = ""
        }
        
        return cell
    }
    
    // MARK: UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension QuestionViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        let answer = OmerAnswer(question: question!, year: Date().currentYear, answer: textView.text!)
        let realm = try! Realm()
        try! realm.write {
            realm.add(answer, update: true)
        }
    }
}
