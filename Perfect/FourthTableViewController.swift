//
//  FourthTableViewController.swift
//  Perfect
//
//  Created by AlienLi on 16/5/28.
//  Copyright © 2016年 limao. All rights reserved.
//

import UIKit
import SVProgressHUD
import Async


class FourthTableViewController: UITableViewController,AvatarDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let items = [["查看订单","收货地址管理","密码设置"],["个人信息","清除缓存","退出/更换账号"]]
    var header: UIView!
    var avatarImageView: UIImageView!
    var nickNameLabel: UILabel!
    var phoneLabel: UILabel!
    var imagePicker: UIImagePickerController?
    var updateAvatar: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = UIImagePickerController.init()
        imagePicker?.delegate = self
        self.tableView.registerClass(MeCell.self, forCellReuseIdentifier: MeCell.identifier)
        
        header = UIView.init(frame: CGRectMake(0, 0, Tool.width, 525.pixelToPoint))
        
        let headerBgImageView = UIImageView()
        headerBgImageView.image = UIImage.init(named: "me_bg")
        header.addSubview(headerBgImageView)
        headerBgImageView.snp_makeConstraints { (make) in
            make.edges.equalTo(header)
        }
       
        
        let circle = UIImageView()
        circle.image = UIImage.init(named: "me_circle")
        header.addSubview(circle)
        circle.snp_makeConstraints { (make) in
            make.width.height.equalTo(220.pixelToPoint)
//            make.center.equalTo(header)
            make.left.equalTo(header).offset(20)
            make.centerY.equalTo(header).offset(20)
        }
        
        
        
        avatarImageView = UIImageView()
        avatarImageView.userInteractionEnabled = true
        avatarImageView.layer.cornerRadius = 220.pixelToPoint / 2
        avatarImageView.layer.masksToBounds = true
        
        header.addSubview(avatarImageView)
        
        avatarImageView.snp_makeConstraints { (make) in
            make.edges.equalTo(circle).inset(UIEdgeInsetsMake(2, 2, 2, 2))
        }
        
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.changeAvatar))
        avatarImageView.addGestureRecognizer(tap)
        nickNameLabel = UILabel()
        nickNameLabel.text = ""
        nickNameLabel.textColor = UIColor.whiteColor()
        nickNameLabel.font = UIFont.systemFontOfSize(18)
        header.addSubview(nickNameLabel)
        
        nickNameLabel.snp_makeConstraints { (make) in
            make.left.equalTo(avatarImageView.snp_right).offset(20)
            make.baseline.equalTo(circle.snp_centerY).offset(-10)
        }
        
        phoneLabel = UILabel()
        header.addSubview(phoneLabel)
        phoneLabel.text = "13432332323"
        phoneLabel.textColor = UIColor.whiteColor()
        phoneLabel.font = UIFont.systemFontOfSize(18)
        
        phoneLabel.snp_makeConstraints { (make) in
            make.left.equalTo(nickNameLabel)
            make.top.equalTo(nickNameLabel.snp_bottom).offset(20)
        }
        
        

        
        self.tableView.tableHeaderView = header
        self.tableView.backgroundColor = UIColor.globalBackGroundColor()
        
//        let logout = UIButton.init(type: .Custom)
//        logout.backgroundColor = UIColor.clearColor()
//        logout.setTitleColor(UIColor.init(hexString: "#b33333"), forState: .Normal)
//        logout.addTarget(self, action: #selector(self.logout), forControlEvents: .TouchUpInside)
//        logout.setTitle("退出登录", forState: .Normal)
//        logout.frame = CGRectMake(0, 0, Tool.width, 129.pixelToPoint)
//        self.tableView.tableFooterView = logout
    }
    
    
    func logout() {
        Util.logined = false
        let tab =  Tool.root.viewControllers.first as! RootTabBarController
        tab.selectedIndex = 0
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if !updateAvatar {
            
            if let url = NSUserDefaults.standardUserDefaults().objectForKey("avatar") as? String {
                self.avatarImageView.kf_setImageWithURL(NSURL.init(string: url)!)
            }
            
            
            
            NetworkHelper.instance.request(.GET, url: URLConstant.appMemberCenterIndex.contant, parameters: ["rows": 0, "page": 1], completion: { [weak self](res: PersonalCenterResponse?) in
                
                let memberInfo = res?.retObj?.memberInfo
                NSUserDefaults.standardUserDefaults().setObject(memberInfo!.avatarImgId.perfectImageurl(200, h: 200, crop: true), forKey: "avatar")
                self?.avatarImageView.kf_setImageWithURL(NSURL.init(string: memberInfo!.avatarImgId.perfectImageurl(200, h: 200, crop: true))!)
                self?.nickNameLabel.text = memberInfo?.nick
                
            }) { (errMsg: String?, errCode: Int) in
                
            }
        } else {
            
        }
        
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return items.first!.count
        } else {
            return items.last!.count
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier(MeCell.identifier, forIndexPath: indexPath) as! MeCell
            cell.title.text = items[indexPath.section][indexPath.row]
            if indexPath == NSIndexPath.init(forRow: 2, inSection: 1) {
                cell.title.textColor = UIColor.globalRedColor()
            }
            return cell
    }
 
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath == NSIndexPath.init(forRow: 0, inSection: 0) {
            let orderVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("AllOrderViewController") as! AllOrderViewController
            orderVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(orderVC, animated: true)
            
        } else if indexPath == NSIndexPath.init(forRow: 1, inSection: 0) {
            let addressVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("AddressViewController") as! AddressViewController
            addressVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(addressVC, animated: true)
       } else if indexPath == NSIndexPath.init(forRow: 2, inSection: 0) {
            let change = Tool.sb.instantiateViewControllerWithIdentifier("ChangePasswordViewController") as! ChangePasswordViewController
            change.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(change, animated: true)
        } else if indexPath == NSIndexPath.init(forRow: 0, inSection: 1) {
            let personal = PeronalViewController.someController(PeronalViewController.self, ofStoryBoard: UIStoryboard.main)
            personal.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(personal, animated: true)
        } else if indexPath == NSIndexPath.init(forRow: 1, inSection: 1) {
                //提示清楚缓存
                SVProgressHUD.showWithStatus("正在清除缓存")
                Async.main(after: 1.0, block: {
                    SVProgressHUD.showSuccessWithStatus("清除成功")
                })
        } else {
            self.logout()
        }
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 22.pixelToPoint : 0.01
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 110.pixelToPoint
    }

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.separatorInset = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsetsZero
    }
    
    
    func profile() {
        let profileVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("PeronalViewController") as! PeronalViewController
        profileVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(profileVC, animated: true)
    }

    
    func changeAvatar() {
        
        let avatarVC = AvatarViewController.someController(AvatarViewController.self, ofStoryBoard: UIStoryboard.main)
        avatarVC.modalPresentationStyle = .OverCurrentContext
        avatarVC.view.backgroundColor = UIColor.clearColor()
        avatarVC.delegate = self
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        delegate.window!.rootViewController!.presentViewController(avatarVC, animated: false, completion: nil)
    }
    
    func didSelectItem(item: PhotoType) {
        if item == .Camera {
            imagePicker?.sourceType = .Camera
            imagePicker?.allowsEditing = true
        } else {
            imagePicker?.sourceType = .PhotoLibrary
            imagePicker?.allowsEditing = true
        }
        
        self.presentViewController(imagePicker!, animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        
        picker.dismissViewControllerAnimated(false) {
            
            //上传头像
            self.avatarImageView.image = image
            NetworkHelper.instance.uploadImage(image, forType: ["category": "avatar"], completion: { (result: UploadImageResponse?) in
                    let imgId = result?.retObj?.imgId
                    self.updateAvatarID(imgId!)
                }, failed: { (msg, code) in
                    SVProgressHUD.showErrorWithStatus(msg)
            })
        }
    }
    
    func updateAvatarID(imageId: Int64) {
        NetworkHelper.instance.request(.GET, url: URLConstant.updateLoginMemberInfo.contant, parameters: ["avatarId": imageId.toNSNumber], completion: { (result: DataResponse?) in
                self.updateAvatar = true
            }) { (msg, code) in
                SVProgressHUD.showErrorWithStatus(msg)
        }
    }

}

class MeCell: UITableViewCell {
    static let identifier = "MeCell"
    
    var title: UILabel!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        title = UILabel.init()
        title.textColor = UIColor.init(hexString: "#333333")
        title.font = UIFont.systemFontOfSize(15.0)
        self.addSubview(title)
        title.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(24.pixelToPoint)
            make.centerY.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

