//
//  OmerChartViewController.swift
//  MyOmer
//
//  Created by Aftab Akhtar on 3/11/18.
//  Copyright © 2018 Aftab Akhtar. All rights reserved.
//

import UIKit

class OmerChartViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var weeks = [
        (OmerWeek(week: 1), false),
        (OmerWeek(week: 2), false),
        (OmerWeek(week: 3), false),
        (OmerWeek(week: 4), false),
        (OmerWeek(week: 5), false),
        (OmerWeek(week: 6), false),
        (OmerWeek(week: 7), false)
    ]
    let year = Date().currentYear
    let calendar = OmerCalendar.getOmerCalendar()
    var dayOfOmer = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dayOfOmer = calendar.dayOfOmer
    }
    
    // MARK: - Memory Cleanup Methods

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension OmerChartViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Cell Methods
    
    func weekCell(for indexPath: IndexPath) -> UITableViewCell {
        
        let week = weeks[indexPath.row].0
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeekCell")!
        
        let titleLabel = cell.contentView.viewWithTag(100) as! UILabel
        titleLabel.text = "Week \(indexPath.row + 1): \(week.title)"
        cell.backgroundColor = week.primaryColor
        
        return cell
    }
    
    func expandedWeekCell(for indexPath: IndexPath) -> UITableViewCell {
        
        let week = weeks[indexPath.row].0
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeekExpandedCell")!
        
        let titleLabel = cell.contentView.viewWithTag(100) as! UILabel
        titleLabel.text = "Week \(indexPath.row + 1): \(week.title)"
        
        var idx = 10
        for day in week.days() {
            let containerView = cell.contentView.viewWithTag(idx)!
            let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(gestureRecognizer:)))
            let dayNumberButton = cell.contentView.viewWithTag(idx+1) as! UIButton
            dayNumberButton.setTitle("\(day.day)", for: .normal)
            dayNumberButton.addGestureRecognizer(tapGestureRecognizer)
            dayNumberButton.addGestureRecognizer(longPressGestureRecognizer)
            let dayTitleLabel = cell.contentView.viewWithTag(idx+2) as! UILabel
            dayTitleLabel.text = day.shortTitle
            
            if day.day <= dayOfOmer {
                dayNumberButton.isUserInteractionEnabled = true
                if day.isBlessingSaid(forYear: year) {
                    containerView.backgroundColor = UIColor.white
                    containerView.layer.borderWidth = 0.0
                    containerView.layer.borderColor = UIColor.clear.cgColor
                    dayNumberButton.setTitleColor(week.primaryColor, for: .normal)
                    dayTitleLabel.textColor = week.primaryColor
                }
                else {
                    containerView.backgroundColor = week.primaryColor
                    containerView.layer.borderWidth = 1.0
                    containerView.layer.borderColor = UIColor.white.cgColor
                    dayNumberButton.setTitleColor(UIColor.white, for: .normal)
                    dayTitleLabel.textColor = UIColor.white
                }
            }
            else {
                dayNumberButton.isUserInteractionEnabled = false
                containerView.backgroundColor = UIColor.lightGray
                containerView.layer.borderWidth = 0.0
                containerView.layer.borderColor = UIColor.clear.cgColor
                dayNumberButton.setTitleColor(UIColor.gray, for: .normal)
                dayTitleLabel.textColor = UIColor.gray
            }
            idx += 10
        }
        
        cell.backgroundColor = week.primaryColor
        return cell
    }
    
    func headerCell() -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell")!
        return cell
    }
    
    // MARK: - UITableViewDataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weeks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let expanded = weeks[indexPath.row].1
        if expanded {
            return expandedWeekCell(for: indexPath)
        }
        else {
            return weekCell(for: indexPath)
        }
    }
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        for idx in 0...6 {
            weeks[idx].1 = false
        }
        weeks[indexPath.row].1 = true
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let expanded = weeks[indexPath.row].1
        if expanded {
            return 105.0
        }
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
}

extension OmerChartViewController {
    
    @IBAction func backButton_Pressed(_ sender: Any) {
        
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        
        if gestureRecognizer.state == .began {
            
            var message = ""
            let weekAndDay = getWeekAndDay(from: gestureRecognizer)
            let blessingSaid = weekAndDay.1.isBlessingSaid(forYear: year)
            if blessingSaid {
                message = "Are you sure you want to unrecord the day?"
            }
            else {
                message = "Are you sure you want to record the day?"
            }
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
            
            let yesAction = UIAlertAction(title: "Yes", style: .destructive, handler: { action in
                weekAndDay.1.markBlessing(!blessingSaid, forYear: self.year)
                self.tableView.reloadData()
            })
            alert.addAction(yesAction)
            
            let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
            alert.addAction(noAction)
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        
        let weekAndDay = getWeekAndDay(from: gestureRecognizer)
        let week = weekAndDay.0
        let day = weekAndDay.1
        
        let nc = NotificationCenter.default
        nc.post(name: .omerDayChanged, object: nil, userInfo: [
            "weekId": week.id,
            "week": week,
            "dayId": day.day,
            "day": day
        ])
        
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
    }
}

extension OmerChartViewController {
    
    func getWeekAndDay(from gestureRecognizer: UIGestureRecognizer) -> (OmerWeek, OmerDay) {
        let point = gestureRecognizer.view?.convert(CGPoint(x:0, y:0), to: tableView)
        let indexPath = tableView.indexPathForRow(at: point!)!
        let tag = gestureRecognizer.view?.tag
        let weekId = indexPath.row + 1
        let dayId = (indexPath.row * 7) + tag!/10
        return (
            OmerWeek(week: weekId),
            OmerDay(day: dayId)
        )
    }
}
