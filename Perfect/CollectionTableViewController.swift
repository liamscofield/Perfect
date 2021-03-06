//
//  CollectionTableViewController.swift
//  Perfect
//
//  Created by AlienLi on 16/6/27.
//  Copyright © 2016年 limao. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh
import SwiftyUserDefaults

class CollectionTableViewController: UITableViewController {

    var colletionList: [CollectProductItem]!
    var currentPage: Int = 1
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.systemFontOfSize(18), NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        colletionList = [CollectProductItem]()
        self.navigationItem.title = "我的收藏"
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 200
        self.tableView.registerClass(CollectCell.self, forCellReuseIdentifier: "CollectCell")
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = UIColor.globalBackGroundColor()
        self.tableView.separatorStyle = .None
//        let footer = MJRefreshAutoNormalFooter.init { [weak self]() -> Void in
//            self?.fetchMore()
//        }
//        footer.automaticallyHidden = true
//        self.tableView.mj_footer = footer
        
        let header = MJRefreshNormalHeader.init { [weak self]() -> Void in
            self?.refreshHeader()
        }
        self.tableView.mj_header = header
        
    }
    
    func fetchMore() {
        
        NetworkHelper.instance.request(.GET, url: URLConstant.getLoginMemberFavoriteGoodsList.contant, parameters: ["rows": 20,"page": currentPage], completion: { [weak self](result: CollectProductResponse?) in
            guard let rows = result?.retObj?.rows else {
                self?.tableView.mj_footer.endRefreshingWithNoMoreData()
                return
            }
            self?.colletionList.appendContentsOf(rows)
            self?.tableView.reloadData()
            self?.tableView.mj_footer.endRefreshing()
        }) { (msg, code) in
            SVProgressHUD.showErrorWithStatus(msg)
            self.tableView.mj_footer.endRefreshing()
        }
    }
    
    func refreshHeader(){
        currentPage = 1
        NetworkHelper.instance.request(.GET, url: URLConstant.getLoginMemberFavoriteGoodsList.contant, parameters: ["rows": 20,"page": currentPage], completion: { [weak self](result: CollectProductResponse?) in
                self?.colletionList = result?.retObj?.rows
                self?.tableView.reloadData()
                self?.currentPage = self!.currentPage + 1
                self?.tableView.mj_header.endRefreshing()
            }) { (msg, code) in
                self.tableView.mj_header.endRefreshing()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
//        if !Util.logined {
//            let tab =  Tool.root.viewControllers.first as! RootTabBarController
//            tab.selectedIndex = 0
//        } else {
            NetworkHelper.instance.request(.GET, url: URLConstant.getLoginMemberFavoriteGoodsList.contant, parameters: ["rows": 20,"page": 1], completion: { [weak self](result: CollectProductResponse?) in
                self?.colletionList = result?.retObj?.rows
                self?.tableView.reloadData()
                self?.currentPage = self!.currentPage + 1
            }) { (msg, code) in
                SVProgressHUD.showErrorWithStatus(msg)
            }
//        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return colletionList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CollectCell", forIndexPath: indexPath) as! CollectCell

        // Configure the cell...
        cell.entity = colletionList[indexPath.row]
        cell.deleteHandler = {
            [weak self] tag in
            self?.deleteCollectItem(self!.colletionList[indexPath.row].id)
        }

        return cell
    }
    
    func deleteCollectItem(ID: Int64) {
        
        let alertController = UIAlertController.init(title: "", message: "确定删除此收藏商品？", preferredStyle: .Alert)
        
        let sureAction = UIAlertAction.init(title: "确认", style: .Default) { (_) in
            SVProgressHUD.show()
            NetworkHelper.instance.request(.GET, url: URLConstant.setLoginMemberGoodsFavorite.contant, parameters: ["goodsId":NSNumber.init(longLong: ID), "isFavorite": "false"], completion: { (result: DataResponse?) in
                self.colletionList = self.colletionList.filter({ (item) -> Bool in
                    return item.id != ID
                })
                self.tableView.reloadData()
                SVProgressHUD.dismiss()
            }) { (msg, code) in
                SVProgressHUD.showErrorWithStatus(msg)
            }

        }
        
        let cancelAction = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.Default) { (_) in
            
        }
        
        alertController.addAction(sureAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
   }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let detail = GoodsDetailViewController.someController(GoodsDetailViewController.self, ofStoryBoard: UIStoryboard.main)
        detail.id = self.colletionList![indexPath.row].id
        detail.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detail, animated: true)
    }
}


class CollectCell: UITableViewCell {
    
    var mainView: UIView!
    
    var goodImageView: UIImageView!
    var goodTitleLabel: UILabel!
    var goodDetailTitleLabel: UILabel!
    var priceLabel: UILabel!
    var deleteButton: UIButton!
    var deleteHandler: (Int -> Void)?
    var price: Float = 0.0 {
        willSet {
            let attributeString = NSMutableAttributedString.init(string: newValue.currency, attributes: [NSForegroundColorAttributeName: UIColor.globalRedColor()])
            attributeString.addAttributes([NSFontAttributeName: UIFont.systemFontOfSize(20)], range: NSMakeRange(0, 1))
            attributeString.addAttributes([NSFontAttributeName: UIFont.systemFontOfSize(20)], range: NSMakeRange(1, (newValue.currency as NSString).length - 1))
            priceLabel.attributedText = attributeString
        }
        
    }
    
    var entity: CollectProductItem? {
        willSet {
            if let _ = newValue {
                self.price = newValue!.price
                self.goodTitleLabel.text = newValue!.name
                self.goodImageView.kf_setImageWithURL(NSURL.init(string: newValue!.thumbnailId.perfectImageurl(200, h: 200, crop: true))!)
                self.goodDetailTitleLabel.text = newValue!.fullName
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .None
        self.backgroundColor = UIColor.clearColor()
        
        mainView = UIView()
        mainView.backgroundColor = UIColor.whiteColor()
        self.addSubview(mainView)
        mainView.snp_makeConstraints { (make) in
            make.left.right.top.equalTo(self)
            make.bottom.equalTo(self).offset(-10.pixelToPoint)
        }
        
        goodImageView = UIImageView()
        mainView.addSubview(goodImageView)
        goodImageView.snp_makeConstraints { (make) in
            make.left.equalTo(20.pixelToPoint)
            make.top.equalTo(24.pixelToPoint)
            make.width.height.equalTo(200.pixelToPoint)
            make.bottom.equalTo(-25.pixelToPoint)

        }
        
        goodTitleLabel = UILabel()
        goodTitleLabel.numberOfLines = 0
        goodTitleLabel.font = UIFont.systemFontOfSize(16.0)
        goodTitleLabel.textColor = UIColor.globalDarkColor()
        mainView.addSubview(goodTitleLabel)
        goodTitleLabel.snp_makeConstraints { (make) in
            make.left.equalTo(goodImageView.snp_right).offset(20.pixelToPoint)
            make.top.equalTo(40.pixelToPoint)
            make.right.equalTo(-20.pixelToPoint)
        }
        
        goodDetailTitleLabel = UILabel()
        goodDetailTitleLabel.numberOfLines = 2
        goodDetailTitleLabel.font = UIFont.systemFontOfSize(14.0)
        goodDetailTitleLabel.textColor = UIColor.globalLightGrayColor()
        mainView.addSubview(goodDetailTitleLabel)
        goodDetailTitleLabel.snp_makeConstraints { (make) in
            make.left.equalTo(goodTitleLabel)
            make.top.equalTo(goodTitleLabel.snp_bottom).offset(18.pixelToPoint)
            make.right.equalTo(-20.pixelToPoint)
        }
        
        priceLabel = UILabel()
        mainView.addSubview(priceLabel)
        priceLabel.snp_makeConstraints { (make) in
            make.left.equalTo(goodTitleLabel)
            make.baseline.equalTo(goodImageView.snp_bottom).offset(-20.pixelToPoint)
        }
        
        deleteButton = UIButton.init(type: .Custom)
        deleteButton.setImage(UIImage.init(named: "collection_delete_0"), forState: .Normal)

        mainView.addSubview(deleteButton)
        deleteButton.snp_makeConstraints { (make) in
            make.right.equalTo(-26.pixelToPoint)
            make.bottom.equalTo(-37.pixelToPoint)
            make.width.equalTo(40.pixelToPoint)
            make.height.equalTo(40.pixelToPoint)
        }
        
        deleteButton.addTarget(self, action: #selector(self.deleteCollect), forControlEvents: .TouchUpInside)
    }
    
    func deleteCollect() {
        self.deleteHandler?(self.tag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}