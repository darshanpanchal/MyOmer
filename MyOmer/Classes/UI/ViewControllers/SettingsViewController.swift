//
//  SettingsViewController.swift
//  MyOmer
//
//  Created by Aftab Akhtar on 3/16/18.
//  Copyright © 2018 Aftab Akhtar. All rights reserved.
//

import UIKit
import MessageUI
import ActionSheetPicker_3_0
import INTULocationManager
import SwiftySunrise

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate let calendar = Calendar.current
    var settings = OmerSettings.current
    let inputFormatter = DateFormatter()
    let outputFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputFormatter.dateFormat = "H:m"
        outputFormatter.dateFormat = "hh:mm a"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.reloadData()
    }
    
    // MARK: - Memory Cleanup Methods
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Cell Methods
    
    func nightfallCell() -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NightfallCell")!
        
        let timeLabel = cell.contentView.viewWithTag(2) as! UILabel
        timeLabel.text = settings.nightfallTime.description()
        
        let refreshButton = cell.contentView.viewWithTag(3) as! UIButton
        if INTULocationManager.locationServicesState() == .available ||
           INTULocationManager.locationServicesState() == .notDetermined {
            refreshButton.isEnabled = true
        }
        else {
            refreshButton.isEnabled = false
        }
        
        return cell
    }
    
    func nightlyReminderCell() -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell")!
        
        let titleLabel = cell.contentView.viewWithTag(1) as! UILabel
        titleLabel.text = "Notify Nightly"
        
        let timeLabel = cell.contentView.viewWithTag(2) as! UILabel
        timeLabel.text = settings.nightlyReminder.time.description()
        
        let switchButton = cell.contentView.viewWithTag(3) as! UIButton
        switchButton.isSelected = settings.nightlyReminder.enabled
        
        return cell
    }
    
    func dailyReminderCell() -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell")!
        
        let titleLabel = cell.contentView.viewWithTag(1) as! UILabel
        titleLabel.text = "Notify Daily"
        
        let timeLabel = cell.contentView.viewWithTag(2) as! UILabel
        timeLabel.text = settings.dailyReminder.time.description()
        
        let switchButton = cell.contentView.viewWithTag(3) as! UIButton
        switchButton.isSelected = settings.dailyReminder.enabled
        
        return cell
    }
    func NotificationCell() -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell")!
        
        let titleLabel = cell.contentView.viewWithTag(1) as! UILabel
        titleLabel.text = "Enable notifications"
    
        let switchButton = cell.contentView.viewWithTag(3) as! UIButton
        switchButton.isSelected = settings.notificationEnable.enabled
        
        return cell
    }
    func contactUsCell() -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell")!
        return cell;
    }
    
    func headerCell(title: String) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell")!
        let titleLabel = cell.contentView.viewWithTag(1) as! UILabel
        titleLabel.text = title
        return cell;
    }
    
    // MARK: - UITableViewDataSource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 2
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
             return NotificationCell()
           // return nightfallCell()
        }
        else if indexPath.section == 1 {
            if indexPath.row == 0 {
                return nightlyReminderCell()
            }
            else {
                return dailyReminderCell()
            }
        }else if indexPath.section == 3{
            return nightfallCell()
        }else {
            return contactUsCell()
        }
    }
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 3 {
            
            let selectedDate = settings.nightfallTime.date
            ActionSheetDatePicker.show(withTitle: "", datePickerMode: .time, selectedDate: selectedDate, doneBlock: { (picker, date, view) in
                let calendar = Calendar.current
                let components = calendar.dateComponents([.hour, .minute], from: date as! Date)
                self.settings.nightfallTime.hour = components.hour!
                self.settings.nightfallTime.minute = components.minute!
                tableView.reloadData()
            }, cancel: { picker in
                
            }, origin: view)
        }
        
        if indexPath.section == 1 {
            
            if (indexPath.row == 0 && settings.nightlyReminder.enabled == false) ||
               (indexPath.row == 1 && settings.dailyReminder.enabled == false) {
                return
            }
        
            var selectedDate = settings.nightlyReminder.time.date
            if indexPath.row == 1 {
                selectedDate = settings.dailyReminder.time.date
            }
            
            ActionSheetDatePicker.show(withTitle: "", datePickerMode: .time, selectedDate: selectedDate, doneBlock: { (picker, date, view) in
                let calendar = Calendar.current
                let components = calendar.dateComponents([.hour, .minute], from: date as! Date)
                if indexPath.row == 0 {
                    self.settings.nightlyReminder.time.hour = components.hour!
                    self.settings.nightlyReminder.time.minute = components.minute!
                }
                else {
                    self.settings.dailyReminder.time.hour = components.hour!
                    self.settings.dailyReminder.time.minute = components.minute!
                }
                tableView.reloadData()
            }, cancel: { picker in
                
            }, origin: view)
        }
        
        if indexPath.section == 2 {
            if MFMailComposeViewController.canSendMail() {
                let mailComposerVC = MFMailComposeViewController()
                mailComposerVC.mailComposeDelegate = self
                mailComposerVC.setToRecipients([Config.ContactUs.toReceipient])
                mailComposerVC.setSubject("")
                mailComposerVC.setMessageBody("", isHTML: false)
                present(mailComposerVC, animated: false, completion: nil)
            }
            else {
                
            }
        }
        if indexPath.section == 0{
            print(settings.notificationEnable.enabled)
            if (settings.notificationEnable.enabled == false){
                 let kUserDefault = UserDefaults.standard
                  kUserDefault.set(settings.notificationEnable.enabled, forKey: "switchON")
                return
            }else{
                let kUserDefault = UserDefaults.standard
                kUserDefault.set(settings.notificationEnable.enabled, forKey: "switchOFF")
            }
             tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 3 {
            return headerCell(title: "Nightfall")
        }
        else if section == 1 {
            return headerCell(title: "Reminders")
        }else if section == 0{
             return headerCell(title: "Notification")
        }
        else {
            return headerCell(title: "Contact")
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 3 {
            return 90.0
        }
        return 63.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
}

extension SettingsViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension SettingsViewController {
    
    @IBAction func saveButton_Pressed(_ sender: Any) {
        
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: false) {
            self.settings.save()
            let calendar = OmerCalendar.getOmerCalendar()
            let notificationsManager = NotificationsManager(calendar: calendar)
            notificationsManager.scheduleNotifications()
        }
    }
    
    @IBAction func switchButton_Pressed(_ switchButton: UIButton) {
        
        switchButton.isSelected = !switchButton.isSelected
        let point = switchButton.convert(CGPoint(x: 0, y: 0), to: tableView)
        if let indexPath = tableView.indexPathForRow(at: point) {
            if indexPath.row == 0 {
                settings.nightlyReminder.enabled = switchButton.isSelected
            }
            else {
                settings.dailyReminder.enabled = switchButton.isSelected
            }
        }
    }
    @IBAction func notificationswitchButton_Pressed(_ switchButton: UIButton) {
        switchButton.isSelected = !switchButton.isSelected
        settings.notificationEnable.enabled = switchButton.isSelected
        if switchButton.isSelected == true{
             switchButton.setImage(UIImage(named: "switch_settings_off_icon"), for: .normal)
             settings.notificationEnable.enabled = switchButton.isSelected
            let kUserDefault = UserDefaults.standard
            kUserDefault.set(settings.notificationEnable.enabled, forKey: "switchOFF")
        }else{
            switchButton.setImage(UIImage(named: "switch_settings_icon"), for: .normal)
             settings.notificationEnable.enabled = switchButton.isSelected
            let kUserDefault = UserDefaults.standard
            kUserDefault.set(settings.notificationEnable.enabled, forKey: "switchON")
        }
    }
    @IBAction func refreshButton_Pressed(_ sender: Any) {
        
        let locationManager = INTULocationManager.sharedInstance()
        locationManager.requestLocation(withDesiredAccuracy: .city, timeout: 15.0, delayUntilAuthorized: true) { (location, accuracy, status) in
            if status == .success {
                if let location = location {
                    let sunsetTime = SwiftySunrise.sunPhaseTime(
                        forPhase: .sunset,
                        onDay: Date(),
                        atLatitude: location.coordinate.latitude,
                        andLongitude: location.coordinate.longitude
                    )!
                    let components = self.calendar.dateComponents([.hour, .minute], from: sunsetTime)
                    self.settings.nightfallTime.hour = components.hour!
                    self.settings.nightfallTime.minute = components.minute!
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func enableLocationButton_Pressed(_ sender: Any) {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
    }
    
    @IBAction func backButton_Pressed(_ sender: Any) {
        
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: false, completion: nil)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
