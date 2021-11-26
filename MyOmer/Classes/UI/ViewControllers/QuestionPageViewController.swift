//
//  QuestionPageViewController.swift
//  MyOmer
//
//  Created by Aftab Akhtar on 3/10/18.
//  Copyright © 2018 Aftab Akhtar. All rights reserved.
//

import UIKit

class QuestionPageViewController: UIPageViewController {
    
    var week: OmerWeek?
    var day: OmerDay?
    var currentIndex = 0
    
    init(week: OmerWeek?, day: OmerDay) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.week = week
        self.day = day
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let questionViewController = storyboard.instantiateViewController(withIdentifier: "QuestionViewController") as! QuestionViewController
        if let day = day {
            questionViewController.totalQuestions = day.questions.count
            if day.questions.count > 0 {
                questionViewController.question = day.questions[0]
            }
        }
        setViewControllers([ questionViewController ], direction: .reverse, animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        for view in view.subviews {
            if view is UIPageControl {
                (view as! UIPageControl).pageIndicatorTintColor = UIColor.darkGray
                (view as! UIPageControl).currentPageIndicatorTintColor = week?.secondaryColor
            }
        }
    }
    
    // MARK: - Memory Cleanup Methods

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension QuestionPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let questionVC = viewController as? QuestionViewController
        if questionVC == nil {
            return nil
        }
        
        var index = (viewController as! QuestionViewController).index
        if index == 0 {
            return nil
        }
        index -= 1
        return questionVCAtIndex(index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let questionVC = viewController as? QuestionViewController
        if questionVC == nil {
            return nil
        }
        
        var index = questionVC!.index
        index += 1
        
        if index >= (day?.questions.count)! {
            return nil
        }
        
        return questionVCAtIndex(index)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        if let day = day {
            if day.questions.count > 0 {
                return day.questions.count
            }
            else {
                return 0
            }
        }
        else {
            return 0
        }
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}

extension QuestionPageViewController {
    
    func questionVCAtIndex(_ index: Int) -> QuestionViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let questionVC = storyboard.instantiateViewController(withIdentifier: "QuestionViewController") as! QuestionViewController
        questionVC.index = index
        currentIndex = index
        if let day = day {
            questionVC.totalQuestions = day.questions.count
            questionVC.question = day.questions[index]
        }
        return questionVC
    }
}

