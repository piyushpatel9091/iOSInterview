//
//  Constants.swift
//  SwiftTutorialWithXIB
//
//  Created by Pritesh Pethani on 24/06/16.
//  Copyright © 2016 Pritesh Pethani. All rights reserved.
//

import Foundation
import UIKit

let APPDELEGATE = UIApplication.shared.delegate as! AppDelegate
let USERDEFAULT = UserDefaults.standard


enum UIUserInterfaceIdiom : Int
{
    case unspecified
    case phone
    case pad
}

struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    static let IS_IPAD_PRO          = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1366.0
}

struct Platform {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64) && os(iOS)
            isSim = true
        #endif
        return isSim
    }()
}


func showAlert(_ messageT:String,title:String){
        let alert:UIAlertView = UIAlertView(title: messageT, message: title, delegate: nil, cancelButtonTitle: "OK", otherButtonTitles: "CANCEL")
        alert.show()
    
//    let alert = UIAlertController(title: messageT, message: title, preferredStyle: UIAlertControllerStyle.alert)
//    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//    // show the alert
//    presentViewController(alert, animated: true, completion: nil)
    
 
    }

func showAlertForVarification(_ messageT:String,title:String,alertTag:Int){
    let alert:UIAlertView = UIAlertView(title: messageT, message: title, delegate: nil, cancelButtonTitle: "OK", otherButtonTitles: "CANCEL")
    alert.show()
    alert.cancelButtonIndex = -1
    alert.tag = alertTag
    
}

func isValidEmail(testStr:String) -> Bool {
    // print("validate calendar: \(testStr)")
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
}

func getStringData(currentFormat:String,strDate:String,newFormat:String) -> String {
    let dateFormater = DateFormatter()
    dateFormater.dateFormat = currentFormat
    let oldDate = dateFormater.date(from: strDate)
    dateFormater.dateFormat  = newFormat
    let newFormattedDate =  dateFormater.string(from: oldDate!)
    return newFormattedDate
}

func getStringDateFromDate(dateFormat:String,enterDate:Date) -> String {
    let dateFormater = DateFormatter()
    dateFormater.dateFormat = dateFormat
    let strDate = dateFormater.string(from: enterDate)
    return strDate
}

func convertDateToDeviceTimeZone(myDateString:String,Strformat:String,returnFormat:String) -> String {
    let dateFormater = DateFormatter()
    dateFormater.dateFormat = Strformat
    
    //Create the date assuming the given string is in GMT
    dateFormater.timeZone = TimeZone(secondsFromGMT: 0)
    
    let date = dateFormater.date(from: myDateString)
    
    dateFormater.dateFormat = returnFormat
    //Create a date string in the local timezone
    dateFormater.timeZone = TimeZone(secondsFromGMT: NSTimeZone.local.secondsFromGMT())
    let localDateString = dateFormater.string(from: date!)
    
    return localDateString
}



func lableTwoDiffrentColor(strVal:String,fontSize:CGFloat,color:UIColor,location:Int,range:Int) -> NSMutableAttributedString {
    var myMutableString = NSMutableAttributedString()
    myMutableString = NSMutableAttributedString(string: strVal, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: fontSize)])
    myMutableString.addAttribute(NSForegroundColorAttributeName, value: color, range: NSRange(location:location,length:range))
    return myMutableString
}

func pb_takeSnapshot(snapShotView:UIView) -> UIImage{
    let rect = snapShotView.bounds
    UIGraphicsBeginImageContextWithOptions(rect.size, true, 0.0)
    let context:CGContext = UIGraphicsGetCurrentContext()!
    snapShotView.layer.render(in: context)
    let capturedScreen:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsGetCurrentContext()
    return capturedScreen;
}



let PAGINATION_LIMITE = 10

let Language_Type = "1"
let MILE = "10000"


let Appname = "Doc99"
let FailureAlert = "Oops! Something went wrong. Please try again."

let CheckConnection = "Check Connection"
let InternetError = "Internet is not available."

let ExpireTokenMessage = "Your token is expired please login Again!"




let MainURL = "http://demo.magespider.com/doc99/api/"

//http://demo.magespider.com/doc99/api/upload/
let ImageGetURL = "http://demo.magespider.com/doc99/upload/image/"



let imageFileUploadUrl = "http://demo.magespider.com/doc99/upload/upload1.php"

let getArticalListURL = "General/ArticleList"
let getArticalListURLTag = 1011


