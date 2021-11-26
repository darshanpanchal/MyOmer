//
//  EmailAuthenticationViewController.swift
//  MyOmer
//
//  Created by IPS on 23/04/19.
//  Copyright © 2019 Aftab Akhtar. All rights reserved.
//

import UIKit
import MaterialComponents
import Firebase

class EmailAuthenticationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtEmail: MDCTextField!
    @IBOutlet weak var txtfirstname: MDCTextField!
    @IBOutlet weak var txtlastname: MDCTextField!
    @IBOutlet weak var txttitle: UILabel!
    @IBOutlet weak var btncontinue: UIButton!
    @IBOutlet weak var btnSkipForNow:UIButton!
    
    @IBOutlet weak var lblCondition:UILabel!
    
    var textFieldOutliine: MDCTextInputControllerOutlined?
    var textFieldfirstnameOutliine: MDCTextInputControllerOutlined?
     var textFieldPfirstnameOutliine: MDCTextInputControllerOutlined?
      let appDelegate1 = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.txtEmail.text = ""
        self.txtfirstname.text = ""
        self.txtlastname.text = ""
        
        self.txtEmail.delegate = self
//        self.txtEmail.backgroundColor = UIColor.red
//        self.txtEmail.placeholderLabel.backgroundColor = UIColor.green
        textFieldOutliine = MDCTextInputControllerOutlined(textInput: self.txtEmail)
        textFieldOutliine?.normalColor = UIColor.black.withAlphaComponent(0.5)
        textFieldOutliine?.activeColor = UIColor.rgb(2, green: 71, blue: 188, a:1.0)
        textFieldOutliine?.floatingPlaceholderActiveColor = UIColor.rgb(2, green: 71, blue: 188, a:1.0)
        textFieldOutliine?.errorColor = UIColor.red//UIColor.init(red: 167.0/255.0, green: 0, blue: 29.0/255.0, alpha: 1.0)
        textFieldOutliine?.floatingPlaceholderScale = 0.8
        textFieldOutliine?.leadingUnderlineLabelTextColor = UIColor.rgb(2, green: 71, blue: 188, a:1.0)
        textFieldOutliine?.underlineViewMode = .whileEditing
        textFieldOutliine?.borderFillColor = UIColor.white
//        textFieldOutliine?.textInput?.isHidden = true
//        textFieldOutliine?.floatingPlaceholderScale = 1.0
//        textFieldOutliine?.expandsOnOverflow = true
        self.txtEmail.isEnabled = true
        

        self.txtfirstname.delegate = self
        textFieldfirstnameOutliine = MDCTextInputControllerOutlined(textInput: self.txtfirstname)
        textFieldfirstnameOutliine?.normalColor = UIColor.black.withAlphaComponent(0.5)
        textFieldfirstnameOutliine?.activeColor = UIColor.rgb(2, green: 71, blue: 188, a:1.0)
        textFieldfirstnameOutliine?.floatingPlaceholderActiveColor = UIColor.rgb(2, green: 71, blue: 188, a:1.0)
        textFieldfirstnameOutliine?.errorColor = UIColor.red//UIColor.inittextFieldPassWordOutliine
        textFieldfirstnameOutliine?.floatingPlaceholderScale = 0.8
        textFieldfirstnameOutliine?.leadingUnderlineLabelTextColor = UIColor.rgb(2, green: 71, blue: 188, a:1.0)
        textFieldfirstnameOutliine?.underlineViewMode = .whileEditing
        textFieldfirstnameOutliine?.borderFillColor = UIColor.white
        
        self.txtfirstname.isEnabled = true
        
        self.txtlastname.delegate = self
        textFieldPfirstnameOutliine = MDCTextInputControllerOutlined(textInput: self.txtlastname)
        textFieldPfirstnameOutliine?.normalColor = UIColor.black.withAlphaComponent(0.5)
        textFieldPfirstnameOutliine?.activeColor = UIColor.rgb(2, green: 71, blue: 188, a:1.0)
        textFieldPfirstnameOutliine?.floatingPlaceholderActiveColor =  UIColor.rgb(2, green: 71, blue: 188, a:1.0)
        textFieldPfirstnameOutliine?.errorColor = UIColor.red//UIColor.inittextFieldPassWordOutliine
        textFieldPfirstnameOutliine?.floatingPlaceholderScale = 0.8
        textFieldPfirstnameOutliine?.leadingUnderlineLabelTextColor = UIColor.rgb(2, green: 71, blue: 188, a:1.0)
        textFieldPfirstnameOutliine?.underlineViewMode = .whileEditing
        textFieldPfirstnameOutliine?.borderFillColor = UIColor.white
        self.txtlastname.isEnabled = true
        
        self.txtEmail.textColor = UIColor.black
        self.txtfirstname.textColor = UIColor.black
         self.txtlastname.textColor = UIColor.black
        
        self.txttitle.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.txttitle.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.txttitle.layer.shadowOpacity = 1.0
        self.txttitle.layer.shadowRadius = 0.0
        self.txttitle.layer.masksToBounds = false
        self.txttitle.layer.cornerRadius = 4.0
        
        self.btncontinue.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.btncontinue.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.btncontinue.layer.shadowOpacity = 1.0
        self.btncontinue.layer.shadowRadius = 0.0
        self.btncontinue.layer.masksToBounds = false
        self.btncontinue.layer.cornerRadius = 5.0
        
        self.btnSkipForNow.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.btnSkipForNow.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.btnSkipForNow.layer.shadowOpacity = 1.0
        self.btnSkipForNow.layer.shadowRadius = 0.0
        self.btnSkipForNow.layer.masksToBounds = false
        self.btnSkipForNow.layer.cornerRadius = 5.0
        
        self.lblCondition.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.lblCondition.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.lblCondition.layer.shadowOpacity = 1.0
        self.lblCondition.layer.shadowRadius = 0.0
        self.lblCondition.layer.masksToBounds = false
        self.lblCondition.layer.cornerRadius = 4.0
    
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(EmailAuthenticationViewController.tapDetected))
        self.view.addGestureRecognizer(singleTap)
        // Do any additional setup after loading the view.
        
        self.btncontinue.clipsToBounds = true
        self.btncontinue.layer.cornerRadius = 30.0
        self.btncontinue.layer.borderColor = UIColor.black.cgColor
        self.btncontinue.layer.borderWidth = 0.75
        
        self.btnSkipForNow.clipsToBounds = true
        self.btnSkipForNow.layer.cornerRadius = self.btnSkipForNow.bounds.height/2.0
        self.btnSkipForNow.layer.borderColor = UIColor.black.cgColor
        self.btnSkipForNow.layer.borderWidth = 0.75
        
        
        self.setGradientBackground()
    }
    func setGradientBackground() {
        let colorTop =   UIColor.init(hexString: "#89cbc7").cgColor//UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor.init(hexString: "#00C4D8").cgColor//UIColor(red: 255.0/255.0, green: 94.0/255.0, blue: 58.0/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
//        self.view.layer.insertSublayer(gradientLayer)
    }
    @objc func tapDetected(){
        DispatchQueue.main.async {
            self.view.endEditing(true)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.txtEmail{
            self.txtEmail.resignFirstResponder()
//            self.txtfirstname.becomeFirstResponder()
            self.postRegisterAPIRequestMethod()
            return true
        }else if textField == self.txtfirstname{
            self.txtfirstname.resignFirstResponder()
            self.txtlastname.becomeFirstResponder()
            return true
        }else if textField == self.txtlastname{
            self.txtlastname.resignFirstResponder()
            self.postRegisterAPIRequestMethod()
            return true
        }else{
            return false
        }
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let typpedString = ((textField.text)! as NSString).replacingCharacters(in: range, with: string)
        
        guard !typpedString.isContainWhiteSpace() else{
            return false
        }
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if self.txtEmail == textField{
            self.txtEmail.placeholderLabel.backgroundColor = UIColor.init(hexString: "73C8C8")
        }else if self.txtfirstname == textField{
            self.txtfirstname.placeholderLabel.backgroundColor = UIColor.init(hexString: "73C8C8")
        }else if self.txtlastname == textField{
            self.txtlastname.placeholderLabel.backgroundColor = UIColor.init(hexString: "73C8C8")
        }else{

        }
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if self.txtEmail == textField{
            if self.txtEmail.text!.count > 0{
                self.txtEmail.placeholderLabel.backgroundColor =  UIColor.init(hexString: "73C8C8")
            }else{
                self.txtEmail.placeholderLabel.backgroundColor = UIColor.white
            }
        }else if self.txtfirstname == textField{
            if self.txtfirstname.text!.count > 0{
                self.txtfirstname.placeholderLabel.backgroundColor =  UIColor.init(hexString: "73C8C8")
            }else{
                self.txtfirstname.placeholderLabel.backgroundColor = UIColor.white
            }
        
        }else if self.txtlastname == textField{
            if self.txtlastname.text!.count > 0{
                self.txtlastname.placeholderLabel.backgroundColor =  UIColor.init(hexString: "73C8C8")
            }else{
                self.txtlastname.placeholderLabel.backgroundColor = UIColor.white
            }
        }else{

        }
        return true
    }
     // MARK: - Continue Button Action
    func isValidRegisterParameters()->Bool{
        guard self.txtEmail.text!.count > 0 else {
              DispatchQueue.main.async {
                
//                ShowToast.show(toatMessage: "Please enter email")
                self.textFieldOutliine?.setErrorText("Please enter email", errorAccessibilityValue: nil)
             }
            return false
        }
        guard self.txtEmail.text!.isValidEmail() else{
            DispatchQueue.main.async {
//                ShowToast.show(toatMessage: "Please enter valid email")
                self.textFieldOutliine?.setErrorText("Please enter valid email", errorAccessibilityValue: nil)
            }
            return false
        }
        /*
        guard self.txtfirstname.text!.count > 0 else {
            DispatchQueue.main.async {
                ShowToast.show(toatMessage: "Please enter first name")
                //self.textFieldfirstnameOutliine?.setErrorText("Please enter first name", errorAccessibilityValue: nil)
            }
            return false
        }
        guard self.txtlastname.text!.count > 0 else {
            DispatchQueue.main.async {
                ShowToast.show(toatMessage: "Please enter last name")
                //self.textFieldPfirstnameOutliine?.setErrorText("Please enter last name", errorAccessibilityValue: nil)
            }
            return false
        }*/
        DispatchQueue.main.async {
            self.textFieldOutliine?.setErrorText(nil, errorAccessibilityValue: nil)
            self.textFieldfirstnameOutliine?.setErrorText(nil,errorAccessibilityValue: nil)
            self.textFieldPfirstnameOutliine?.setErrorText(nil, errorAccessibilityValue: nil)
        }
        return true
    }
    @IBAction func onClickContinueBtn(semder:UIButton){

        self.postRegisterAPIRequestMethod()
    }
    @IBAction func buttonSkipSelector(sender:UIButton){
        self.appDelegate1.startup()
    }
    func postRegisterAPIRequestMethod(){
        if self.isValidRegisterParameters(){
            var params = [String:AnyObject]()
            params["email"] = self.txtEmail.text as AnyObject?
//            params["first_name"] = self.txtfirstname.text as AnyObject? //
//            params["last_name"] =  self.txtlastname.text as AnyObject? //
            UserDefaults.standard.removeObject(forKey: "RegisterEmailKey")
            ApiRequst.apiRequest(requestType: .post, queryString: nil , parameter: params, showHUD: true, headerValue: false, success: { (responseSuccess) in
                DispatchQueue.main.async(execute: {
                    if let json = responseSuccess as? [String:AnyObject]{
                        if let msgstr = json["message"] as? String, msgstr.count > 0{
                            ShowToast.show(toatMessage: "\(msgstr)")
                            UserDefaults.standard.set("\(self.txtEmail.text ?? "")", forKey:"RegisterEmailKey") // removeObject(forKey: "RegisterEmailKey")
                            UserDefaults.standard.set(true, forKey: "launchedBefore")
                            self.appDelegate1.startup()
                            Analytics.logEvent("User_Login", parameters:["Email":"\(self.txtEmail.text ?? "")"])
                            Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
                                AnalyticsParameterItemID: "email - \(self.txtEmail.text ?? "")",
                                AnalyticsParameterItemName: "\(self.txtEmail.text ?? "") logged In.",
                                AnalyticsParameterContentType: "email "
                                ])
                        }
                    }
                })
            }){ (responseFail) in
                print("\(responseFail)")
                if let json = responseFail as? [String:AnyObject]{
                    if let objFail = json["fail"] as? String{
                        ShowToast.show(toatMessage: objFail)
                    }else if let objFail = json["error"] as? String{
                        ShowToast.show(toatMessage: objFail)
                    }
                }
            }
        }
    }
    func setupWaiting(calendar: OmerCalendar) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let waitingOmerVC = storyboard.instantiateViewController(withIdentifier: "WaitingOmerViewController") as? WaitingOmerViewController {
            waitingOmerVC.omerCalendar = calendar
            self.present(waitingOmerVC, animated: true, completion: nil)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//extension EmailAuthenticationViewController {
//
//    func openNavigator(withIdentifier identifier: String) {
//        let omerChartNavigator = storyboard?.instantiateViewController(withIdentifier: identifier) as! UINavigationController
//        present(omerChartNavigator, animated: false, completion: nil)
//    }
//}
