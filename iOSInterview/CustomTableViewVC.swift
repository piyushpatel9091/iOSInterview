//
//  CustomTableViewVC.swift
//  iOSInterview
//
//  Created by MacBookPro on 03/09/17.
//  Copyright © 2017 MacBookPro. All rights reserved.
//

import UIKit
import SDWebImage


class CustomTableViewVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet var tableViewArtical:UITableView!
    //For Pasignation
    var pageNum:Int!
    var isLoading:Bool?
    
    var articalData = NSMutableArray()
    var articalGlobalData = NSMutableArray()
   // @IBOutlet var lblNoNotification:UILabel!
    
    
    
    // FIXME: - VIEW CONTROLLER METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewArtical.delegate = self
        tableViewArtical.dataSource = self
        
        tableViewArtical.register(UINib(nibName: "ArticalTableVC", bundle: nil), forCellReuseIdentifier: "articalCell")

        self.generalViewControllerSetting()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // TODO: - OTHER METHODS
    func generalViewControllerSetting(){
        pageNum=1;
        let indicator1 = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicator1.startAnimating()
        
        self.articalData = NSMutableArray()
        self.articalGlobalData = NSMutableArray()
        
        if Reachability.isConnectedToNetwork() == true {
            self.addLoadingIndicatiorOnFooterOnTableView()
            Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.postDataOnWebserviceForGetArticalList), userInfo: nil, repeats: false)
        }else{
            showAlert(CheckConnection, title: InternetError)
        }
        self.addTapGestureInOurView()
        
        
    }
    
    func addTapGestureInOurView(){
        let tapRecognizer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.backgroundTap(_:)))
        tapRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapRecognizer)
    }
    @IBAction func backgroundTap(_ sender:UITapGestureRecognizer){
        let point:CGPoint = sender.location(in: sender.view)
        let viewTouched = view.hitTest(point, with: nil)
        
        if viewTouched!.isKind(of: UIButton.self){
        }
        else{
            self.view.endEditing(true)
        }
    }
    
    
    func addLoadingIndicatiorOnFooterOnTableView(){
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.startAnimating()
        spinner.frame = CGRect(x: 0, y: 0, width: 320, height: 44)
        tableViewArtical.tableFooterView = spinner
    }
    func removeLoadingIndicatiorOnFooterOnTableView(){
        tableViewArtical.tableFooterView = nil
    }
    
    // TODO: - DELEGATE METHODS
    
    // TODO: - DELEGATE METHODS
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.articalData.count == 0 {
            return 0
        }
        return self.articalData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "articalCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ArticalTableVC
        

        
        if cell == nil {
            let nib  = Bundle.main.loadNibNamed("ArticalTableVC", owner: self, options: nil)
            cell = nib?[0] as? ArticalTableVC
        }
        cell!.selectionStyle = .none;
        
        
        if let articalName =  (self.articalData[indexPath.row] as AnyObject).value(forKey: "article_name") as? String
        {
            cell?.lblArticalName.text = "\(articalName)"
        }
        
        if let categoryData =  (self.articalData[indexPath.row] as AnyObject).value(forKey: "category") as? NSArray
        {
            let catData = categoryData
            if catData.count > 0 {
                cell?.lblCategory.isHidden = false
                let mutableStirng = NSMutableString()
                
                for i in 0...catData.count - 1 {
                    if i != 0{
                        mutableStirng.append(" , ")
                    }
                    mutableStirng.append((catData.object(at: i) as AnyObject).value(forKey: "ac_name") as! String)
                }
                cell?.lblCategory.text = mutableStirng as String
                
                
                cell?.lblCategory.sizeToFit()
                
                print("CategoryFrame : ",cell?.lblCategory.frame ?? "123")
                
                cell?.lblCategory.frame = CGRect(x: (cell?.lblCategory.frame.origin.x)!, y: ((cell?.imageViewArtical.frame.origin.y)! + (cell?.imageViewArtical.frame.size.height)! + 10.0), width: (cell?.lblCategory.frame.size.width)! + 10, height: (cell?.lblCategory.frame.size.height)! + 10.0)
                cell?.lblCategory.textAlignment = .center
                cell?.lblCategory.clipsToBounds = true
                cell?.lblCategory.layer.cornerRadius = 5.0
                //(catData.object(at: 0) as AnyObject).value(forKey: "ac_name") as? String
            }
            else{
                cell?.lblCategory.isHidden = true
            }
            
        }
        else{
            cell?.lblCategory.isHidden = true
        }
        
        
        
        if let favour =  (self.articalData[indexPath.row] as AnyObject).value(forKey: "is_favourite") as? NSNumber
        {
            let favourateArtical = "\(favour)"
            if favourateArtical == "1"{
                cell?.imageViewBookmarked.image = UIImage.init(named: "bookmark_green.png")
            }
            else if favourateArtical == "0"{
                cell?.imageViewBookmarked.image = UIImage.init(named: "bookmark_gray.png")
            }
        }
        else if let favour =  (self.articalData[indexPath.row] as AnyObject).value(forKey: "is_favourite") as? String
        {
            let favourateArtical = "\(favour)"
            if favourateArtical == "1"{
                cell?.imageViewBookmarked.image = UIImage.init(named: "bookmark_green.png")
            }
            else if favourateArtical == "0"{
                cell?.imageViewBookmarked.image = UIImage.init(named: "bookmark_gray.png")
            }
        }
        
        
        cell?.btnBookMark.tag = indexPath.row
        cell?.btnShare.tag = indexPath.row
        
        
        
        let imageUrl = (self.articalData[indexPath.row] as AnyObject).value(forKey: "article_img") as? String
        let fullUrl = NSString(format:"%@%@", ImageGetURL,imageUrl!) as String
        let url : NSString = fullUrl as NSString
        let urlStr : NSString = url.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
        let searchURL : NSURL = NSURL(string: urlStr as String)!
        
        
        cell?.activityIndicatorForArticalImage.isHidden = false
        cell?.activityIndicatorForArticalImage.startAnimating()
        
        cell?.imageViewArtical.sd_setImage(with: searchURL as URL, completed: { (image:UIImage?, error:Error?, cacheType:SDImageCacheType!, imageURL:URL?) in
            
            if ((error) != nil) {
                cell?.imageViewArtical.image = UIImage.init(named: "image_placeholder.png")
            }
            
            cell?.activityIndicatorForArticalImage.isHidden = true
            
        })
        
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 275.0
    }
    //func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //        var myCellHeight:CGFloat!
        //
        //        myCellHeight = 40.0
        //
        //
        //        var myLabel = UILabel.init()
        //        myLabel.frame = CGRect(x: 10.0, y: 10.0, width: 270.0, height: 20.0)
        //        myLabel.numberOfLines = 0
        //
        //        myLabel.text = (notificationData.object(at: indexPath.row)as AnyObject).value(forKey: "comments") as? String
        //
        //
        //
        //        myLabel = Utility.setlableFrame(myLabel, fontSize: 14.0)
        //
        //        if (myLabel.frame.size.height < 20.0) {
        //            myLabel.frame = CGRect(x: 10.0, y: 10.0, width: 270.0, height: 20.0)
        //        }
        //
        //        if ((notificationData.object(at: indexPath.row)as AnyObject).value(forKey: "comments") as? String) != ""{
        //            myCellHeight = myLabel.frame.size.height + 20.0
        //
        //        }
        //        else{
        //            myCellHeight = 40.0
        //        }
        //
        //        print("My Cell Height",myCellHeight)
        //        return myCellHeight
        
    //    return 100
    //}
    
    
    
    
    
    // TODO: - DELEGATE ScrollView
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == tableViewArtical {
            if isLoading == true{
                if (scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height {
                    pageNum = pageNum + 1
                    print(pageNum)
                    isLoading = false
                    
                    if Reachability.isConnectedToNetwork() == true {
                        self.addLoadingIndicatiorOnFooterOnTableView()
                        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.postDataOnWebserviceForGetArticalList), userInfo: nil, repeats: false)
                    } else {
                        showAlert(CheckConnection, title: InternetError)
                    }
                }
            }
            
        }
        
    }
    
    
    // TODO: - POST DATA METHODS
    func postDataOnWebserviceForGetArticalList(){
        
        let completeURL = NSString(format:"%@%@", MainURL,getArticalListURL) as String
        
        let pageNumber = "\(pageNum!)"
        
        let params:NSDictionary = [
            "lang_type":Language_Type,
            "page":pageNumber,
            "limit":PAGINATION_LIMITE
        ]
        
        
        
        let finalParams:NSDictionary = [
            "data" : params
        ]
        
        print("getNotification API Parameter :",finalParams)
        print("getNotification API URL :",completeURL)
        
        let sampleProtocol = SyncManager()
        sampleProtocol.delegate = self
        sampleProtocol.webServiceCall(completeURL, withParams: finalParams as! [AnyHashable : Any], withTag: getArticalListURLTag)
    }
    
    
    func syncSuccess(_ responseObject: Any!, withTag tag: Int) {
        switch tag {
        case getArticalListURLTag:
            let resultDict = responseObject as! NSDictionary;
            print("getNotification Response  : \(resultDict)")
            if resultDict.value(forKey: "status") as! String == "1"{
                
                var myData = NSArray()
                
                if self.pageNum == 1{
                    self.articalData = NSMutableArray()
                    self.articalGlobalData = NSMutableArray()
                }
                
                myData = resultDict.value(forKey: "data") as! NSArray
                
                if (myData.count > 0) {
                    for i in 0...myData.count - 1 {
                        self.articalGlobalData.add(myData[i])
                    }
                    
                    for i in 0...myData.count - 1 {
                        self.articalData.add(myData[i])
                    }
                    
                    print("My Article Data : ",myData)
                    
                    if (myData.count < PAGINATION_LIMITE) {
                        if (self.pageNum > 0) {
                            self.pageNum = self.pageNum - 1
                        }
                        self.isLoading = false
                    }else{
                        self.isLoading = true
                    }
                }
                else{
                    self.isLoading = false
                    if (self.pageNum > 0) {
                        self.pageNum = self.pageNum - 1
                    }
                    
                }
                
                if self.articalData.count == 0{
                    self.tableViewArtical.isHidden = true
                   // self.lblNoNotification.isHidden = false
                }
                else{
                    self.tableViewArtical.isHidden = false
                   // self.lblNoNotification.isHidden = true
                }
                
                self.tableViewArtical.reloadData()
                self.removeLoadingIndicatiorOnFooterOnTableView()
                
                
            }
            break
        default:
            break
            
        }
        
    }
    func syncFailure(_ error: Error!, withTag tag: Int) {
        switch tag {
        case getArticalListURLTag:
            self.isLoading = false
            if (self.pageNum > 0) {
                self.pageNum = self.pageNum - 1
            }
            self.removeLoadingIndicatiorOnFooterOnTableView()
            
            break
        default:
            break
            
        }
        print("syncFailure Error : ",error.localizedDescription)
        showAlert(Appname, title: FailureAlert)
    }
    
    
    
}
