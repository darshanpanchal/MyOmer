import UIKit


extension String{
    static func noInternet()->String{
        return "No internet connection available"
    }
    static func unknownError()->String{
        return "An unknown error has occurred, try again"
    }
    enum UserDetails {
        case userId
        case name
        case email
        case serverAccessToken
        case deviceToken
    }
    static func getUserDetails(type:UserDetails)->String?{
        if type == .deviceToken{
            if let dt = UserDefaults.standard.object(forKey: "deviceToken") as? String{
                return dt.removeWhiteSpaces()
            }else{
                return "couldNotGetDeviceToken"
            }
        }
        if let ud = UserDefaults.standard.object(forKey: "userInfoDic") as? [String:AnyObject],let token = ud["access_token"] as? String{
            
            if type == .serverAccessToken{
                return token
            }else if type == .name{
                if let value = ud["Name"] as? String{
                    return value
                }
            }else if type == .userId{
                if let value = ud["Id"]{
                    return String(describing: value)
                }
            }else if type == .email{
                if let value = ud["Email"]{
                    return String(describing: value)
                }
            }
        }
        return nil
    }
}
extension UIView{
    static func hideKeyboard(){
        UIApplication.shared.sendAction(#selector(resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func showMessageLabel(msg:String = "No data found",font:UIFont = UIFont.italicSystemFont(ofSize: DeviceType.isIpad() ? 20 : 16),backgroundColor:UIColor = UIColor.init(white:1, alpha: 1)){
        let label = UILabel()
        label.text = msg
        label.font = font
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.tag = 851
        label.alpha = alpha
        label.backgroundColor = backgroundColor
        label.textAlignment = .center
        self.addSubview(label)
        if let superView = self.superview{
            superView.layoutIfNeeded()
        }
        label.frame = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width: self.bounds.width, height: self.bounds.height)
    }
    
    func removeMessageLabel(){
        for view in self.subviews{
            if view.tag == 851{
                view.removeFromSuperview()
            }
        }
    }
    
    func rotate360Degrees(duration: CFTimeInterval = 3.5) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Double.pi * 2)
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount=Float.infinity
        self.layer.add(rotateAnimation, forKey: nil)
    }
    
    func stopAllAnimations(){
        self.layer.removeAllAnimations()
    }
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = radius
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

extension CGFloat{
    static let heightOfContent:CGFloat = DeviceType.isIpad() ? 50 : (DeviceType.isIphone5sAndBelow() ? 40 : 45)
    static let leftRightPadding:CGFloat = DeviceType.isIpad() ? 100 : (DeviceType.isIphone5sAndBelow() ? 50 : 80)
    static let gapBetween:CGFloat = DeviceType.isIpad() ? 20 : 15
}
extension UILabel {
    func startBlink() {
        UIView.animate(withDuration: 0.5,
                       delay:0.0,
                       options:[.allowUserInteraction, .curveEaseInOut, .autoreverse, .repeat],
                       animations: { self.alpha = 0 },
                       completion: nil)
    }
    func stopBlink() {
        layer.removeAllAnimations()
        alpha = 1
    }
}

extension UIViewController {
    /*
    func saveImageInDocumentDirectory(image: UIImage) -> Bool {
        guard let data = UIImageJPEGRepresentation(image, 1) ?? image.pngData() else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        do {
            try data.write(to: directory.appendingPathComponent("ProfileImage.png")!)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }*/
    func clearTempFolder() {
        let fileManager = FileManager.default
        let tempFolderPath = NSTemporaryDirectory()
        do {
            let filePaths = try fileManager.contentsOfDirectory(atPath: tempFolderPath)
            print(filePaths)
            for filePath in filePaths {
                try fileManager.removeItem(atPath: tempFolderPath + filePath)
            }
        } catch {
            print("Could not clear temp folder: \(error)")
        }
    }
    
    func getSavedImageOfDocumentDirectory(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
    
    func presentAlert(withTitle title: String, message : String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { action in
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}




