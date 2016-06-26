//
//  RegisterViewController.swift
//  Perfect
//
//  Created by AlienLi on 16/5/28.
//  Copyright © 2016年 limao. All rights reserved.
//

import UIKit
import ChameleonFramework
import SVProgressHUD
import SwiftyUserDefaults

class RegisterViewController: BaseViewController, UITextFieldDelegate {

    var verifyButton: UIButton!
    var cellphoneTextfield: UITextField!
    var verifyTextField: UITextField!
    var passwordTextfield: UITextField!
    var registerButton: UIButton!
    var protocolCheckButton: UIButton!
    var protocolLabel: UILabel!
    var personalButton: UIButton!
    var enterPriseButton: UIButton!
    
    var timer: NSTimer?
    var timerCount: Int = 60
    
    var cellphone: String! = ""
    var validCode: String! = ""
    var password: String! = ""
    var userProtocolChecked: Bool = false
    var personalRegister: Bool = true
    
    var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "注册"
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.systemFontOfSize(15), NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        //背景
        let imageview = UIImageView()
        self.view.addSubview(imageview)
        imageview.snp_makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        imageview.image = UIImage.init(named: "loginBg")
        
        
        scrollView = UIScrollView.init()
        scrollView.backgroundColor = UIColor.clearColor()
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)
        scrollView.backgroundColor = UIColor.clearColor()
        
        scrollView.snp_makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        setupViews()
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        self.cellphoneTextfield.resignFirstResponder()
        self.passwordTextfield.resignFirstResponder()
        self.verifyTextField.resignFirstResponder()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        
        super.viewWillAppear(animated)
    }
    
    func setupViews() {
        //图标
        let icon = UIImageView()
        icon.image = UIImage.init(named: "h6")
        scrollView.addSubview(icon)
        icon.snp_makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.width.height.equalTo(80)
            make.top.equalTo(scrollView.snp_top).offset(60)
        }
        
        let userTagImageView = UIImageView()
        userTagImageView.image = UIImage.init(named: "perfect")
        scrollView.addSubview(userTagImageView)
        userTagImageView.snp_makeConstraints { (make) in
            make.left.equalTo(30)
            make.width.height.equalTo(25)
            make.top.equalTo(icon.snp_bottom).offset(80)
        }
        
        cellphoneTextfield = UITextField()
        cellphoneTextfield.addTarget(self, action: #selector(self.textFieldDidEditChanged(_:)), forControlEvents: .EditingChanged)
        cellphoneTextfield.attributedPlaceholder = NSAttributedString.init(string: "手机号", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        cellphoneTextfield.textColor = UIColor.whiteColor()
        cellphoneTextfield.keyboardType = .NumberPad
        scrollView.addSubview(cellphoneTextfield)
        
        cellphoneTextfield.snp_makeConstraints { (make) in
            make.left.equalTo(userTagImageView.snp_right).offset(8)
            make.centerY.equalTo(userTagImageView)
            make.right.equalTo(view).offset(-20)
            make.height.equalTo(35)
        }
        
        let line0 = UIView()
        line0.backgroundColor = UIColor.lightGrayColor()
        scrollView.addSubview(line0)
        
        line0.snp_makeConstraints { (make) in
            make.left.equalTo(view).offset(14)
            make.right.equalTo(view).offset(-14)
            make.top.equalTo(userTagImageView.snp_bottom).offset(14)
            make.height.equalTo(1)
        }

        let passwordTagImageView = UIImageView()
        passwordTagImageView.image = UIImage.init(named: "perfect")
        scrollView.addSubview(passwordTagImageView)
        passwordTagImageView.snp_makeConstraints { (make) in
            make.left.equalTo(30)
            make.width.height.equalTo(25)
            make.centerY.equalTo(userTagImageView.snp_centerY).offset(50)
        }

        passwordTextfield = UITextField()
        passwordTextfield.attributedPlaceholder = NSAttributedString.init(string: "密码", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        passwordTextfield.textColor = UIColor.whiteColor()

        passwordTextfield.addTarget(self, action: #selector(self.textFieldDidEditChanged(_:)), forControlEvents: .EditingChanged)
        passwordTextfield.secureTextEntry = true
        scrollView.addSubview(passwordTextfield)
        
        
        passwordTextfield.snp_makeConstraints { (make) in
            make.centerY.equalTo(cellphoneTextfield).offset(50)
            make.left.right.equalTo(cellphoneTextfield)
            make.height.equalTo(cellphoneTextfield)
        }
        
        let line1 = UIView()
        line1.backgroundColor = UIColor.lightGrayColor()
        scrollView.addSubview(line1)
        line1.snp_makeConstraints { (make) in
            make.left.right.equalTo(line0)
            make.centerY.equalTo(line0.snp_centerY).offset(50)
            make.height.equalTo(1)
        }
        
        let verifyTagImageView = UIImageView()
        verifyTagImageView.image = UIImage.init(named: "perfect")
        scrollView.addSubview(verifyTagImageView)
        verifyTagImageView.snp_makeConstraints { (make) in
            make.left.equalTo(30)
            make.width.height.equalTo(25)
            make.centerY.equalTo(passwordTagImageView.snp_centerY).offset(50)
        }
        
        verifyTextField = UITextField()
        verifyTextField.addTarget(self, action: #selector(self.textFieldDidEditChanged(_:)), forControlEvents: .EditingChanged)
        verifyTextField.attributedPlaceholder = NSAttributedString.init(string: "验证码", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        verifyTextField.textColor = UIColor.whiteColor()
        verifyTextField.keyboardType = .NumberPad

        scrollView.addSubview(verifyTextField)
        
        verifyTextField.snp_makeConstraints { (make) in
            make.left.height.equalTo(cellphoneTextfield)
            make.centerY.equalTo(passwordTextfield).offset(50)
            make.width.lessThanOrEqualTo(150)
        }
        
        verifyButton = UIButton.init(type: .Custom)
        verifyButton.setAttributedTitle(NSAttributedString(string: "获取验证码", attributes: [NSForegroundColorAttributeName: UIColor.lightGrayColor(),NSFontAttributeName: UIFont.systemFontOfSize(12)]), forState: .Normal)

        verifyButton.addTarget(self, action: #selector(self.verify), forControlEvents: .TouchUpInside)
        scrollView.addSubview(verifyButton)
        verifyButton.snp_makeConstraints { (make) in
            make.right.equalTo(view).offset(-10)
            make.centerY.equalTo(verifyTextField.snp_centerY)
            make.width.lessThanOrEqualTo(100)
        }
        
        let marginView = UIView()
        scrollView.addSubview(marginView)
        marginView.backgroundColor = UIColor.lightGrayColor()
        marginView.snp_makeConstraints { (make) in
            make.right.equalTo(view).offset(-100)
            make.width.equalTo(1)
            make.height.equalTo(30)
            make.centerY.equalTo(verifyButton)
        }

        let line2 = UIView()
        line2.backgroundColor = UIColor.lightGrayColor()
        scrollView.addSubview(line2)
        line2.snp_makeConstraints { (make) in
            make.left.right.equalTo(line0)
            make.top.equalTo(line1.snp_bottom).offset(50)
            make.height.equalTo(1)
        }
        
        protocolCheckButton = UIButton.init(type: .Custom)
        protocolCheckButton.addTarget(self, action: #selector(self.checkProtocol), forControlEvents: .TouchUpInside)
        protocolCheckButton.setImage(UIImage.init(named: "perfect"), forState: .Normal)
        scrollView.addSubview(protocolCheckButton)
        protocolCheckButton.snp_makeConstraints { (make) in
            make.left.equalTo(view).offset(20)
            make.width.height.equalTo(25)
            make.top.equalTo(line2.snp_bottom).offset(20)
        }
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.gotoProtocol))
        protocolLabel = UILabel()
        let agree: NSString = "同意注册协议"
        let attributeString = NSMutableAttributedString.init(string: "同意注册协议", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        attributeString.addAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], range: NSMakeRange(0, 2))
        attributeString.addAttributes([NSForegroundColorAttributeName: UIColor.greenColor()], range: NSMakeRange(2, agree.length - 2))
        protocolLabel.attributedText = attributeString

        protocolLabel.addGestureRecognizer(tap)
        protocolLabel.userInteractionEnabled = true
        scrollView.addSubview(protocolLabel)
        protocolLabel.snp_makeConstraints { (make) in
            make.centerY.equalTo(protocolCheckButton)
            make.left.equalTo(protocolCheckButton.snp_right).offset(10)
        }
        
        let enterpriseLabel = UILabel()
        enterpriseLabel.text = "企业"
        enterpriseLabel.textColor = UIColor.whiteColor()
        scrollView.addSubview(enterpriseLabel)
        enterpriseLabel.snp_makeConstraints { (make) in
            make.right.equalTo(line2.snp_right)
            make.centerY.equalTo(protocolCheckButton)
        }
        
        enterPriseButton = UIButton.init(type: .Custom)
        enterPriseButton.addTarget(self, action: #selector(self.choosePersonalOrEnterprise), forControlEvents: .TouchUpInside)
        enterPriseButton.setImage(UIImage.init(named: "perfect"), forState: .Normal)
        scrollView.addSubview(enterPriseButton)
        enterPriseButton.snp_makeConstraints { (make) in
            make.width.height.equalTo(protocolCheckButton)
            make.right.equalTo(enterpriseLabel.snp_left)
            make.centerY.equalTo(enterpriseLabel)
        }
        
        let personalLabel = UILabel()
        personalLabel.text = " 个人  /"
        personalLabel.textColor = UIColor.whiteColor()

        scrollView.addSubview(personalLabel)
        personalLabel.snp_makeConstraints { (make) in
            make.right.equalTo(enterPriseButton.snp_left).offset(-8)
            make.centerY.equalTo(enterPriseButton)
        }
        
        personalButton = UIButton.init(type: .Custom)
        personalButton.addTarget(self, action: #selector(self.choosePersonalOrEnterprise), forControlEvents: .TouchUpInside)

        personalButton.setImage(UIImage.init(named: "perfect"), forState: .Normal)
        scrollView.addSubview(personalButton)
        personalButton.snp_makeConstraints { (make) in
            make.width.height.equalTo(enterPriseButton)
            make.centerY.equalTo(enterPriseButton)
            make.right.equalTo(personalLabel.snp_left).offset(8)
        }
        
        
        registerButton = UIButton.init(type: .Custom)
        registerButton.addTarget(self, action: #selector(self.register), forControlEvents: .TouchUpInside)
        registerButton.setTitle("注册", forState: .Normal)
        registerButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        registerButton.backgroundColor = UIColor.clearColor()
        registerButton.layer.cornerRadius = 3.0
        registerButton.layer.masksToBounds = true
        registerButton.layer.borderWidth = 1
        registerButton.layer.borderColor = UIColor.whiteColor().CGColor
        scrollView.addSubview(registerButton)

        registerButton.snp_makeConstraints { (make) in
            make.top.equalTo(line2.snp_bottom).offset(60)
            make.centerX.equalTo(scrollView)
            make.height.equalTo(45)
            make.left.equalTo(14)
        }


    }
    
    //MARK: 注册
    func register() {
        if checkValidation() {
            NetworkHelper.instance.request(.GET, url: URLConstant.Register.contant, parameters: ["username": cellphone,"password": password, "validCode": validCode, "phone": cellphone, "type": (personalRegister ? "person" : "company")], completion: { (result: RegisterResponse?) in
                    Defaults[.password] = self.password
                    SVProgressHUD.showSuccessWithStatus("注册成功")
                }, failed: { (errMsg: String?, errCode: Int) in
                    SVProgressHUD.showErrorWithStatus(errMsg ?? "注册失败")
            })
        }
    }
    
    func checkProtocol() {
        if userProtocolChecked {
            userProtocolChecked = false
            protocolCheckButton.setImage(UIImage.init(named: "perfect"), forState: .Normal)
        } else {
            userProtocolChecked = true
            protocolCheckButton.setImage(UIImage.init(named: "perfect"), forState: .Normal)
        }
    }
    
    func choosePersonalOrEnterprise() {
        if personalRegister {
            personalRegister = false
            enterPriseButton.setImage(UIImage.init(named: "perfect"), forState: .Normal)
            personalButton.setImage(UIImage.init(named: "perfect"), forState: .Normal)
        } else {
            personalRegister = true
            enterPriseButton.setImage(UIImage.init(named: "perfect"), forState: .Normal)
            personalButton.setImage(UIImage.init(named: "perfect"), forState: .Normal)
        }
    }
    
    func gotoProtocol() {
        let proto = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ProtocolViewController") as! ProtocolViewController
        
        self.navigationController?.pushViewController(proto, animated: true)
    }
    
    
    func checkValidation() -> Bool {
        
        guard self.cellphone!.isValidCellPhone else {
            showAlertWithMessage("请输入11位手机号码", block: { (_) -> Void in
                
            })
            return false
        }
        
        guard self.cellphone != "" else {
            showAlertWithMessage("手机不能输入为空", block: { (_) -> Void in
                
            })
            return false
        }
        
        guard (self.password as NSString).length >= 6 else {
            showAlertWithMessage("请输入至少6位密码", block: { (_) -> Void in
                
            })
            return false
        }
        guard self.validCode != "" else {
            showAlertWithMessage("请输入验证码", block: { (_) -> Void in
                
            })
            return false
        }
        
        
        guard self.password != "" else {
            showAlertWithMessage("请输入密码", block: { (_) -> Void in
                
            })
            
            return false
        }
        
        guard self.password!.isValidPassword else {
            showAlertWithMessage("密码为6-16位字母数字", block: { (_) -> Void in
                
            })
            
            return false
        }
        
        
        guard userProtocolChecked else {
            showAlertWithMessage("请勾选同意注册协议", block: { (_) -> Void in
                
            })
            
            return false
        }
        
        return true
    }

    func configureFetchValidCode(mode: CMValidateButtonMode) {
        
        if mode == .Timer {
            let string = "\(timerCount) s"
            verifyButton.userInteractionEnabled = false
            verifyButton.setAttributedTitle(NSAttributedString(string: string, attributes: [NSForegroundColorAttributeName: UIColor.lightGrayColor(),NSFontAttributeName: UIFont.systemFontOfSize(12)]), forState: .Normal)
        } else {
            
            verifyButton.userInteractionEnabled = true
            verifyButton.setAttributedTitle(NSAttributedString(string: "重新获取验证码", attributes: [NSForegroundColorAttributeName: UIColor.lightGrayColor(),NSFontAttributeName: UIFont.systemFontOfSize(12)]), forState: .Normal)
        }
        
    }
    //MARK: 输入框处理
    func textFieldDidEditChanged(textfield: UITextField) {
        //
        if textfield == cellphoneTextfield {
            cellphone = textfield.text
            
            let text = NSString(string: cellphone!)
            if text.length > 11 {
                textfield.text = text.substringToIndex(11)
                cellphone = textfield.text
            }
        } else if textfield == verifyTextField {
            validCode = textfield.text
            let text = NSString(string: validCode!)
            if text.length > 6 {
                textfield.text = text.substringToIndex(6)
                validCode = textfield.text
            }
        } else {
            password = textfield.text
            let p = password as NSString
            if p.length > 16 {
                textfield.text = p.substringToIndex(16)
                password = textfield.text
            }
        }
    }
    
    func verify() {
        //获取验证码
        if cellphone.isValidCellPhone {
            self.timer = NSTimer.YQ_scheduledTimerWithTimeInterval(1.0, closure: {
                    self.timerCount -= 1
                    if self.timerCount <= 0 {
                        self.restoreTimer()
                    } else {
                        self.configureFetchValidCode(.Timer)
                        self.verifyButton.userInteractionEnabled = false
                    }
                }, repeats: true)
            
            NetworkHelper.instance.request(.GET, url: URLConstant.getMobileValidCode.contant, parameters: ["username": cellphone, "phone":cellphone,"busiType": "reg"], completion: { (result: DataResponse?) in
                SVProgressHUD.showSuccessWithStatus("验证码获取成功")
                self.restoreTimer()
                
            }) { (errMsg, errCode) in
                SVProgressHUD.showErrorWithStatus(errMsg ?? "验证码获取失败")
                self.restoreTimer()
            }
        } else {
            showAlertWithMessage("请输入正确的手机号码", block: nil)
        }
    }
    

    func restoreTimer() {
        self.timerCount = 60
        self.timer?.invalidate()
        self.configureFetchValidCode(.Normal)
        self.verifyButton.userInteractionEnabled = true
    }


    deinit{
        self.timer?.invalidate()
        self.timer = nil
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

enum CMValidateButtonMode {
    case Normal
    case Timer
}






