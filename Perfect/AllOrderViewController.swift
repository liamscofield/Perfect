//
//  AllOrderViewController.swift
//  Perfect
//
//  Created by AlienLi on 16/6/20.
//  Copyright © 2016年 limao. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh

class AllOrderViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView!
    var item: [HistoryOrderItem]!
    var currentPage: Int = 1
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "查看订单"
        item = [HistoryOrderItem]()

        tableView = UITableView.init(frame: CGRectZero, style: .Plain)
        tableView.separatorStyle = .None
        self.view.addSubview(tableView)
        tableView.snp_makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 500.0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(AllOrderCell.self, forCellReuseIdentifier: "AllOrderCell")
        tableView.tableFooterView = UIView()

        
        NetworkHelper.instance.request(.GET, url: URLConstant.appOrderHistory.contant, parameters: ["rows": 20, "page": 1], completion: { (result: HistoryOrderResponse?) in
                if let _ = result?.retObj?.rows {
                    self.item = result?.retObj?.rows!
                    if self.item.count >= 20 {
                        self.tableView.mj_footer.endRefreshing()
                        self.currentPage = self.currentPage + 1
                    } else {
                        self.tableView.mj_footer.endRefreshingWithNoMoreData()
                    }
                    
                    self.tableView.reloadData()
                }
            }) { (errmsg, errcode) in
                SVProgressHUD.showErrorWithStatus(errmsg ?? "订单列表获取失败")
        }
        
        self.tableView.backgroundColor = UIColor.init(hexString: "#e4ebf0")
        
        let footer = MJRefreshAutoNormalFooter.init { [weak self]() -> Void in
            self?.fetchMoreOrder()
        }
        footer.automaticallyHidden = true
        self.tableView.mj_footer = footer
    }
    
    func fetchMoreOrder() {
        
        NetworkHelper.instance.request(.GET, url: URLConstant.appOrderHistory.contant, parameters: ["rows": 20, "page": currentPage], completion: { (result: HistoryOrderResponse?) in
            
            guard let rows = result?.retObj?.rows else {
                
                self.tableView.mj_footer.endRefreshing()
                return
            }
            
            self.item.appendContentsOf(rows)
            self.tableView.reloadData()
            if rows.count < 20 {
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
            } else {
                self.tableView.mj_footer.endRefreshing()
                self.currentPage = self.currentPage + 1
            }
        }) { (errmsg, errcode) in
            SVProgressHUD.showErrorWithStatus(errmsg ?? "订单列表获取失败")
        }
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return item.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AllOrderCell", forIndexPath: indexPath) as!  AllOrderCell
        cell.entity = self.item[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let orderDetailVC = OrderDetailViewController.someController(OrderDetailViewController.self, ofStoryBoard: UIStoryboard.main)
        orderDetailVC.entity = self.item[indexPath.row]
        self.navigationController?.pushViewController(orderDetailVC, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class AllOrderCell: UITableViewCell {
    
    var mainView: UIView!
    var packageImageView: UIImageView!
    var topLabel: UILabel!
    var deliverMarginView: UIView!
    var addressTagImageView: UIImageView!
    var nameTitleLabel: UILabel!
    var nameLabel: UILabel!
    var cellphoneLabel: UILabel!
    var addressTitleLabel: UILabel!
    var addressLabel: UILabel!
    var addressMarginView: UIView!
    var goodsImageView: UIImageView!
    var goodTitleLabel: UILabel!
    var priceLabel: UILabel!
    var quantityLabel: UILabel!
    var goodMariginView: UIView!
    var orderNumberTitleLabel: UILabel!
    var orderNumberLabel: UILabel!
    var modelTitleLabel: UILabel!
    var modelLabel: UILabel!
    var orderTimeTitleLabel: UILabel!
    var orderTimeLabel: UILabel!
    
    var price: Float = 0.0 {
        willSet {
//            let attributeString = NSMutableAttributedString.init(string: newValue.currency, attributes: [NSForegroundColorAttributeName: UIColor.globalRedColor()])
//            attributeString.addAttributes([NSFontAttributeName: UIFont.systemFontOfSize(20)], range: NSMakeRange(0, 1))
//            attributeString.addAttributes([NSFontAttributeName: UIFont.systemFontOfSize(20)], range: NSMakeRange(1, NSString.init(string: "\(newValue)").length))
//            priceLabel.attributedText = attributeString
//            
            priceLabel.textColor = UIColor.globalRedColor()
            priceLabel.font = UIFont.boldSystemFontOfSize(20.0)
            priceLabel.text = newValue.currency
        }

    }
    
    
    var entity: HistoryOrderItem? {
        willSet {
            if let _ = newValue {
                topLabel.text = newValue!.orderStepName
                if let color = newValue!.orderStepTextColor {
                    topLabel.textColor = UIColor.init(hexString: color)
                }
                nameLabel.text = newValue!.address?.consignee
                cellphoneLabel.text = newValue!.address?.phone
                if let fullname = newValue!.address?.areaFullName {
                    if let detail = newValue!.address?.address {
                        addressLabel.text = fullname + detail
                    }
                }
                
                goodsImageView.kf_setImageWithURL(NSURL.init(string: newValue!.productImageId.perfectImageurl(157, h: 157, crop: true))!)
                goodTitleLabel.text = newValue!.goodsName
                self.price = newValue!.totalPrice
                self.quantityLabel.text = "x\(newValue!.quantity)"
                orderNumberLabel.text = newValue!.orderSn
                modelLabel.text = newValue!.productName
                orderTimeLabel.text = newValue!.orderCreateDate
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clearColor()
        self.selectionStyle = .None
        
        mainView = UIView()
        mainView.backgroundColor = UIColor.whiteColor()
        
        self.addSubview(mainView)
        mainView.snp_makeConstraints { (make) in
            make.left.equalTo(21.pixelToPoint)
            make.right.equalTo(-21.pixelToPoint)
            make.top.equalTo(10.pixelToPoint)
            make.bottom.equalTo(self)
        }
        //快递区域
        packageImageView = UIImageView()
        mainView.addSubview(packageImageView)
        packageImageView.snp_makeConstraints { (make) in
            make.left.equalTo(mainView).offset(20.pixelToPoint)
            make.width.height.equalTo(30.pixelToPoint)
            make.top.equalTo(30.pixelToPoint)
        }
        packageImageView.image = UIImage.init(named: "order_package")
        
        
        topLabel = UILabel()
        mainView.addSubview(topLabel)
        topLabel.font = UIFont.systemFontOfSize(13)
        topLabel.text = "圆通快递"
        topLabel.textColor = UIColor.init(hexString: "#2fb76c")
        
        topLabel.snp_makeConstraints { (make) in
            make.centerY.equalTo(packageImageView)
            make.left.equalTo(packageImageView.snp_right).offset(27.pixelToPoint)
            make.right.equalTo(-8)
        }

        
        deliverMarginView = UIView()
        deliverMarginView.backgroundColor = UIColor.init(hexString: "#ebebeb")
        mainView.addSubview(deliverMarginView)
        deliverMarginView.snp_makeConstraints { (make) in
            make.left.right.equalTo(mainView)
            make.height.equalTo(1.pixelToPoint)
            make.top.equalTo(mainView).offset(78.pixelToPoint)
        }
        
        //地址区域
        addressTagImageView = UIImageView()
        mainView.addSubview(addressTagImageView)
        addressTagImageView.snp_makeConstraints { (make) in
            make.left.equalTo(packageImageView)
            make.width.height.equalTo(30.pixelToPoint)
            make.top.equalTo(deliverMarginView).offset(40.pixelToPoint)
        }
        addressTagImageView.image = UIImage.init(named: "order_address")
        
        nameTitleLabel = UILabel()
        mainView.addSubview(nameTitleLabel)
        
        nameTitleLabel.text = "收货人:"
        nameTitleLabel.font = UIFont.systemFontOfSize(13)
        nameTitleLabel.textColor = UIColor.init(hexString: "#333333")
        
        nameTitleLabel.snp_makeConstraints { (make) in
            make.left.equalTo(addressTagImageView.snp_right).offset(27.pixelToPoint)
            make.top.equalTo(deliverMarginView).offset(23.pixelToPoint)
        }
        
        nameLabel = UILabel()
        nameLabel.textColor = UIColor.init(hexString: "#333333")
        nameLabel.font = UIFont.systemFontOfSize(13)
        mainView.addSubview(nameLabel)
        nameLabel.snp_makeConstraints { (make) in
            make.left.equalTo(nameTitleLabel.snp_right)
            make.centerY.equalTo(nameTitleLabel)
        }
        
        cellphoneLabel = UILabel()
        cellphoneLabel.font = UIFont.systemFontOfSize(13)
        mainView.addSubview(cellphoneLabel)
        cellphoneLabel.snp_makeConstraints { (make) in
            make.right.equalTo(mainView).offset(-21.pixelToPoint)
            make.centerY.equalTo(nameTitleLabel)
        }
        
        addressTitleLabel = UILabel()
        mainView.addSubview(addressTitleLabel)
        addressTitleLabel.text = "收货地址:"
        addressTitleLabel.font = UIFont.systemFontOfSize(13)
        addressTitleLabel.textColor = UIColor.init(hexString: "#333333")
        addressTitleLabel.snp_makeConstraints { (make) in
            make.top.equalTo(nameTitleLabel.snp_bottom).offset(20.pixelToPoint)
            make.left.equalTo(nameTitleLabel)
            make.width.lessThanOrEqualTo(80)
        }
        
        addressLabel = UILabel()
        addressLabel.numberOfLines = 0
        addressLabel.font = UIFont.systemFontOfSize(13.0)
        addressLabel.textColor = UIColor.init(hexString: "#333333")
        addressLabel.text = "成都市高新区天府软件区G9 dfkajhfjkdfakfakfja"
        mainView.addSubview(addressLabel)
        addressLabel.snp_makeConstraints { (make) in
            make.top.equalTo(nameTitleLabel.snp_bottom).offset(20.pixelToPoint)
            make.left.equalTo(addressTitleLabel.snp_right)
            make.right.equalTo(mainView).offset(-21.pixelToPoint)
        }
        
        addressMarginView = UIView()
        addressMarginView.backgroundColor = UIColor.init(hexString: "#ebebeb")
        mainView.addSubview(addressMarginView)
        addressMarginView.snp_makeConstraints { (make) in
            make.left.right.height.equalTo(deliverMarginView)
            make.top.equalTo(addressLabel.snp_bottom).offset(23.pixelToPoint)
        }
        
        // 商品区域
        
        goodsImageView = UIImageView()
        mainView.addSubview(goodsImageView)
        goodsImageView.image = UIImage.init(named: "placeholder")
        goodsImageView.snp_makeConstraints { (make) in
            make.width.height.equalTo(157.pixelToPoint)
            make.top.equalTo(addressMarginView.snp_bottom).offset(25.pixelToPoint)
            make.left.equalTo(mainView).offset(25.pixelToPoint)
        }
        
        goodTitleLabel = UILabel()
        goodTitleLabel.font = UIFont.systemFontOfSize(14.0)
        goodTitleLabel.textColor = UIColor.blackColor()
        goodTitleLabel.numberOfLines = 0
        mainView.addSubview(goodTitleLabel)
        goodTitleLabel.snp_makeConstraints { (make) in
            make.left.equalTo(goodsImageView.snp_right).offset(27.pixelToPoint)
            make.top.equalTo(addressMarginView.snp_bottom).offset(33.pixelToPoint)
            make.right.equalTo(mainView).offset(-25.pixelToPoint)
        }
        
        priceLabel = UILabel()
        let price: NSString = "￥1000"
        let attributeString = NSMutableAttributedString.init(string: "￥1000", attributes: [NSForegroundColorAttributeName: UIColor.init(hexString: "#ee304e")])
        attributeString.addAttributes([NSFontAttributeName: UIFont.systemFontOfSize(10)], range: NSMakeRange(0, 1))
        attributeString.addAttributes([NSFontAttributeName: UIFont.systemFontOfSize(28)], range: NSMakeRange(1, price.length - 1))
        priceLabel.attributedText = attributeString
        
        mainView.addSubview(priceLabel)
        priceLabel.snp_makeConstraints { (make) in
            make.left.equalTo(goodTitleLabel)
            make.baseline.equalTo(goodsImageView.snp_bottom)
        }
        
        
        quantityLabel = UILabel()
        mainView.addSubview(quantityLabel)
        quantityLabel.textColor = UIColor.blackColor()
        quantityLabel.font = UIFont.systemFontOfSize(14.0)
        
        quantityLabel.snp_makeConstraints { (make) in
            make.right.equalTo(goodTitleLabel.snp_right)
            make.baseline.equalTo(priceLabel)
        }
        quantityLabel.text = "x2"
        
        goodMariginView = UIView()
        goodMariginView.backgroundColor = UIColor.init(hexString: "#ebebeb")
        mainView.addSubview(goodMariginView)
        goodMariginView.snp_makeConstraints { (make) in
            make.left.right.height.equalTo(addressMarginView)
            make.top.equalTo(goodsImageView.snp_bottom).offset(29.pixelToPoint)
        }
        //订单模块
        
        orderNumberTitleLabel = UILabel()
        orderNumberTitleLabel.textColor = UIColor.init(hexString: "#999999")
        orderNumberTitleLabel.font = UIFont.systemFontOfSize(12.0)
        mainView.addSubview(orderNumberTitleLabel)
        orderNumberTitleLabel.snp_makeConstraints { (make) in
            make.left.equalTo(mainView).offset(12.pixelToPoint)
            make.top.equalTo(goodMariginView.snp_bottom).offset(25.pixelToPoint)
        }
        orderNumberTitleLabel.text = "订单号:"
        
        orderNumberLabel = UILabel()
        mainView.addSubview(orderNumberLabel)
        orderNumberLabel.snp_makeConstraints { (make) in
            make.left.equalTo(orderNumberTitleLabel.snp_right).offset(8)
            make.centerY.equalTo(orderNumberTitleLabel)
        }
        orderNumberLabel.textColor = UIColor.init(hexString: "#999999")
        orderNumberLabel.font = UIFont.systemFontOfSize(12.0)
        orderNumberLabel.text = "112123323232"
        
        modelTitleLabel = UILabel()
        modelTitleLabel.textColor = UIColor.init(hexString: "#999999")
        modelTitleLabel.font = UIFont.systemFontOfSize(12.0)
        mainView.addSubview(modelTitleLabel)
        modelTitleLabel.snp_makeConstraints { (make) in
            make.left.equalTo(orderNumberTitleLabel)
            make.top.equalTo(orderNumberTitleLabel.snp_bottom).offset(20.pixelToPoint)
            make.width.lessThanOrEqualTo(80)
        }
        modelTitleLabel.text = "模块定制:"
        
        modelLabel = UILabel()
        mainView.addSubview(modelLabel)
        modelLabel.snp_makeConstraints { (make) in
            make.left.equalTo(modelTitleLabel.snp_right).offset(8)
            make.centerY.equalTo(modelTitleLabel)
        }
        modelLabel.textColor = UIColor.init(hexString: "#999999")
        modelLabel.font = UIFont.systemFontOfSize(12.0)
        modelLabel.text = "模块一"
        
        orderTimeTitleLabel = UILabel()
        mainView.addSubview(orderTimeTitleLabel)
        orderTimeTitleLabel.snp_makeConstraints { (make) in
            make.left.equalTo(modelTitleLabel)
            make.top.equalTo(modelTitleLabel.snp_bottom).offset(20.pixelToPoint)
            make.bottom.equalTo(mainView.snp_bottom).offset(-31.pixelToPoint)
            make.width.lessThanOrEqualTo(80)
        }
        orderTimeTitleLabel.textColor = UIColor.init(hexString: "#999999")
        orderTimeTitleLabel.font = UIFont.systemFontOfSize(12.0)
        orderTimeTitleLabel.text = "下单时间:"

        orderTimeLabel = UILabel()
        mainView.addSubview(orderTimeLabel)
        orderTimeLabel.snp_makeConstraints { (make) in
            make.left.equalTo(orderTimeTitleLabel.snp_right).offset(8)
            make.centerY.equalTo(orderTimeTitleLabel)
            
        }
        orderTimeLabel.textColor = UIColor.init(hexString: "#999999")
        orderTimeLabel.font = UIFont.systemFontOfSize(12.0)
        orderTimeLabel.text = "2011-39-12 12:00:00"

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
