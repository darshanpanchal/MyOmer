//
//  ApiRequst.swift

import Alamofire
import Foundation
import UIKit


let kBaseServerURL:String = "https://www.meaningfullife.com/api/"


typealias SUCCESS = (_ response:Any)->()
typealias FAIL = (_ response:Any)->()

class ApiRequst:NSObject{
    static let serverURL = "https://www.meaningfullife.com/api/"
    
    enum RequestType {
        case POST
        case GET
        case PUT
        case DELETE
        case OPTIONS
    }
    static func apiRequest(requestType:HTTPMethod,queryString:String?,parameter:[String:AnyObject]?,showHUD:Bool = true,headerValue:Bool = true,success:@escaping SUCCESS,fail:@escaping FAIL){
        if !Reachability.isAvailable(),showHUD {
            ShowToast.show(toatMessage: String.noInternet())
            return
        }
        DispatchQueue.main.async {
            if showHUD{
                ShowHud.show()
            }
        }
        
        let urlString = kBaseServerURL + (queryString == nil ? "" : queryString!)
        
        let url = URL(string: urlString.removeWhiteSpaces())!
        var headers: HTTPHeaders = ["":""]
        var strAccessToken:String = ""
        //        if User.isUserLoggedIn,let currentUser = User.getUserFromUserDefault(){
        //            strAccessToken = "Bearer \(currentUser.api_token)"
        //        }
        if headerValue{
            headers = ["Accept":" application/json","Authorization":"\(strAccessToken)"]
        }else{
            headers = ["Accept":" application/json"]
        }
        
        
        
        
        Alamofire.request(url, method: requestType, parameters: parameter, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                DispatchQueue.main.async {
                    if showHUD{
                        ShowHud.hide()
                    }
                }
                switch response.result{
                case .success:
                    if response.response?.statusCode == 200{
                        success(response.result.value ?? ["success":"success"])
                    }else if response.response?.statusCode == 500{
                        fail(response.result.value ?? ["fail":"Internal Server Error"])
                    }else if response.response?.statusCode == 400{
                        fail(response.result.value ?? ["fail":"Bad request was sent"])
                    }else if response.response?.statusCode == 401{
                        //                                DispatchQueue.main.async {
                        //                                    if let window = (UIApplication.shared.delegate as? AppDelegate)?.window{
                        //                                        if let rootNavigation :UINavigationController =  window.rootViewController as? UINavigationController{
                        //                                            rootNavigation.popToRootViewController(animated: true)
                        //                                        }
                        //                                    }
                        //                                }
                        fail(response.result.value ?? ["fail":"UNAUTHORIZED"])
                    }else if response.response?.statusCode == 404{
                        fail(response.result.value ?? ["fail":"NOT FOUND"])
                    }else{
                        fail(response.result.value ?? ["fail":"something went wrong"])
                    }
                    break
                case .failure:
                    fail(response.result.value ?? ["fail":"something went wrong"])
                    break
                }
                print(response.request as Any)  // original URL request
                print(response.response as Any) // URL response
                print(response.result.value as Any)   // result of response serialization
        }
    }
    static func uploadImage(requestType:HTTPMethod,queryString:String?,parameter:[String:AnyObject],imageData:Data,showHUD:Bool,headerValue:Bool = true,success:@escaping SUCCESS,fail:@escaping FAIL){
        if !Reachability.isAvailable(),showHUD {
            ShowToast.show(toatMessage: String.noInternet())
            return
        }
        if showHUD{
            DispatchQueue.main.async {
                ShowHud.show()
            }
        }
        let urlString = kBaseServerURL + (queryString == nil ? "" : queryString!)
        
        
        //let URL = "http://staging.live.stockholmapplab.com/api/amazons3/native/experience/image/upload/image"
        var headers: HTTPHeaders = ["Content-type": "multipart/form-data"]
        var strAccessToken:String = ""
        //        if User.isUserLoggedIn,let currentUser = User.getUserFromUserDefault(){
        //            strAccessToken = "Bearer \(currentUser.api_token)"
        //        }
        //
        
        if headerValue{
            headers = ["Accept":" application/json","Authorization":"\(strAccessToken)"]
        }else{
            headers = ["Accept":" application/json"]
        }
        // headers = ["Accept":" application/json"]
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in parameter {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            // if let data = imageData{
            multipartFormData.append(imageData, withName: "image", fileName: "image.png", mimeType: "image/png")
            //}
            
        }, usingThreshold: UInt64.init(), to: urlString, method:requestType, headers: headers) { (result) in
            
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    
                    if let objResponse = response.response,objResponse.statusCode == 200{
                        if let successResponse = response.value as? [String:Any]{
                            success(successResponse)
                        }
                    }else if let objResponse = response.response,objResponse.statusCode == 401{
                        if let failResponse = response.value as? [String:Any]{
                            fail(failResponse)
                        }
                    }else if let objResponse = response.response,objResponse.statusCode == 400{
                        if let failResponse = response.value as? [String:Any]{
                            fail(failResponse)
                        }
                    }else if let error = response.error{
                        DispatchQueue.main.async {
                            ShowToast.show(toatMessage: "\(error.localizedDescription)")
                            fail(["error":"\(error.localizedDescription)"])
                        }
                    }else{
                        //                        DispatchQueue.main.async {
                        //                            ShowToast.show(toatMessage: "\(kCommonError)")
                        //                            fail(["error":"\(kCommonError)"])
                        //                        }
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    ShowToast.show(toatMessage: "\(error.localizedDescription)")
                    fail(["error":"\(error.localizedDescription)"])
                }
            }
        }
    }
    static func doRequest(requestType:RequestType,queryString:String?,parameter:[String:AnyObject]?,multipartObject:[String:Any]? = nil,showHUD:Bool = true,completionHandler:@escaping (Any)->()){
        
        if !Reachability.isAvailable(),showHUD {
            ShowToast.show(toatMessage: String.noInternet())
            return
        }
        
        func unknownError(){
            DispatchQueue.main.async{
                if showHUD{
                    ShowToast.show(toatMessage: String.unknownError())
                }
            }
        }
        if showHUD{
            ShowHud.show()
        }
        
        let urlString = kBaseServerURL + (queryString == nil ? "" : queryString!)
        var request = URLRequest(url: URL(string: urlString.removeWhiteSpaces())!)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.timeoutInterval = 60
        request.httpMethod = String(describing: requestType)
        
        if let multipart = multipartObject {
            let bodyData = NSMutableData()
            let tempData = NSMutableData()
            let boundary = "Boundary-\(UUID().uuidString)"
            let contentType : NSString = "multipart/form-data; boundary=\(boundary)" as NSString
            request.setValue(contentType as String, forHTTPHeaderField: "Content-Type")
            if parameter != nil{
                for (keys, values) in parameter! {
                    tempData.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                    tempData.append("Content-Disposition: form-data; name=\"\(keys)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
                    tempData.append("\(values)\r\n".data(using: String.Encoding.utf8)!)
                }
                for (key, value) in multipart {
                    if let fileData = value as? Data{
                        tempData.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                        tempData.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\("36575678567878.jpg")\"\r\n".data(using: String.Encoding.utf8)!)
                        tempData.append("Content-Type: \("jpg")\r\n\r\n".data(using: String.Encoding.utf8)!)
                        tempData.append(fileData)
                        tempData.append("\r\n".data(using: String.Encoding.utf8)!)
                        tempData.append("--".appending(boundary.appending("--")).data(using: String.Encoding.utf8)!)
                    }
                }
                bodyData.append(tempData as Data)
                request.httpBody = bodyData as Data
            }
        }
        else{
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
            if let params = parameter{
                do{
                    let parameterData = try JSONSerialization.data(withJSONObject:params, options:.prettyPrinted)
                    request.httpBody = parameterData
                }catch{
                    unknownError()
                    return
                }
            }
        }
        
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            DispatchQueue.main.async(execute: {
                if showHUD{
                    ShowHud.hide()
                }
            })
            if error == nil,data != nil
            {
                print(urlString,String(data: data!, encoding: .utf8)!)
                if let httpStatus = response as? HTTPURLResponse  { // checks http errors
                    if httpStatus.statusCode == 200{
                        do{
                            if let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: AnyObject]{
                                DispatchQueue.main.async(execute: {
                                    if  let errorDic = json["err"] as? [String:AnyObject]{
                                        print(errorDic)
                                        // ViewController
                                    }else{
                                        completionHandler(json)
                                    }
                                })
                                return
                            }
                        }
                        catch{
                            DispatchQueue.main.async(execute: {
                                completionHandler(["status":"200" as AnyObject])
                            })
                            return
                        }
                    }else
                    {
                        do{
                            if let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: AnyObject]{
                                DispatchQueue.main.async(execute: {
                                    if  let errorDic = json["err"] as? [String:AnyObject]{
                                        print(errorDic)
                                        // ViewController
                                    }else{
                                        completionHandler(false)
                                    }
                                })
                            }
                            return
                        }
                        catch{
                            print(httpStatus.statusCode)
                            
                        }
                    }
                    
                }
            }
            DispatchQueue.main.async(execute: {
                if let errorOccred = error{
                    ShowToast.show(toatMessage: errorOccred.localizedDescription)
                }else{
                    unknownError()
                }
            })
        })
        task.resume()
    }
}


