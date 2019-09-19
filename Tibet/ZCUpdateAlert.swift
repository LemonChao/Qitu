//
//  ZCUpdateAlert.swift
//  Tibet
//
//  Created by zchao on 2019/7/17.
//  Copyright © 2019 Leyukeji. All rights reserved.
//

import UIKit

class ZCUpdateAlert: UIView {

    var model: UpdateVersionModel!
    // 更新提示
    lazy var updateView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 4.0
        return view
    }()
    lazy var updateIcon: UIImageView = {
        let view = UIImageView(image: UIImage(named: "updateVersion_rocket"))
        view.contentMode = UIView.ContentMode.scaleToFill
        return view
    }()
    lazy var versionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    lazy var descTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        return textView
    }()
    lazy var updateButton: UIButton = {
        let button = UIButton.init(type: UIButton.ButtonType.custom)
        button.setTitle("立即更新", for: UIControl.State.normal)
        button.backgroundColor = HexColor("#bd2efc")
        button.layer.cornerRadius = 2
        button.addTarget(self, action: #selector(updateButtonAction), for: .touchUpInside)
        return button
    }()
    lazy var cancelButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage(named: "updateVersion_close"), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(dissmissAlert), for: .touchUpInside)
        return button
    }()

    init(fromModel tModel: UpdateVersionModel) {
        super.init(frame: UIScreen.main.bounds)
        self.model = tModel
        self.backgroundColor = RGBA(0, 0, 0,0.3)
        self.addSubview(updateView)
        self.addSubview(cancelButton)
        self.updateView.addSubview(updateIcon)
        self.updateView.addSubview(versionLabel)
        self.updateView.addSubview(descTextView)
        self.updateView.addSubview(updateButton)
        
        cancelButton.isHidden = self.model.force_update
        versionLabel.text = "发现新版本" + tModel.ver_nod
        descTextView.text = tModel.remark
        let size = descTextView.sizeThatFits(CGSize(width: SCREEN_WIDTH-FitWidth(130), height: 0))
        if size.height > FitWidth(60) {
            descTextView.showsVerticalScrollIndicator = true
            descTextView.isScrollEnabled = true
        }
        UIApplication.shared.delegate?.window!?.addSubview(self)
        
        updateView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH-FitWidth(80))
        }
        
        updateIcon.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(updateIcon.snp_width).multipliedBy(0.72)
        }
        
        versionLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(updateIcon.snp_bottom).offset(FitWidth(0))
        }
        
        descTextView.snp.makeConstraints { (make) in
            make.top.equalTo(versionLabel.snp_bottom).offset(FitWidth(10))
            make.left.right.equalToSuperview().inset(FitWidth(25))
            make.height.equalTo(FitWidth(60))
        }
        
        updateButton.snp.makeConstraints { (make) in
            make.top.equalTo(descTextView.snp.bottom).offset(FitWidth(5))
            make.left.right.equalToSuperview().inset(FitWidth(30))
            make.height.equalTo(FitWidth(40))
            make.bottom.equalToSuperview().inset(FitWidth(10))
        }
        
        cancelButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(FitWidth(20)+CGFloat(TabBarHeight))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    static func showUpdateAlert(withModel model: UpdateVersionModel) {
        let modelVerison = (model.ver_nod.replacingOccurrences(of: ".", with: "") as NSString).integerValue
        let currentVersion = (AppVersion.replacingOccurrences(of: ".", with: "") as NSString).integerValue
        if modelVerison > currentVersion {
            let alert = ZCUpdateAlert.init(fromModel: model)
            alert.animatedShow(withModel: model)
        }
    }
    
    func animatedShow(withModel tModel: UpdateVersionModel )  {
        
        let animation = CAKeyframeAnimation(keyPath: "transform")
        animation.duration = 0.6
        let values = [NSValue(caTransform3D: CATransform3DMakeScale(0.1, 0.1, 1.0)),NSValue(caTransform3D: CATransform3DMakeScale(1.2, 1.2, 1.0)),NSValue(caTransform3D: CATransform3DMakeScale(0.9, 0.9, 1.0)),NSValue(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0))]
        animation.values = values
        self.updateView.layer.add(animation, forKey: nil)
    }
    
    @objc func updateButtonAction()  {
        UIApplication.shared.open(URL(string: self.model.url)!, options: [:]) { (finish) in
            
            if !self.model.force_update { //不是强制更新
                self.dissmissAlert()
            }
        }
    }
    @objc func dissmissAlert()  {
        UIView.animate(withDuration: 0.6, animations: {
            self.updateView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.backgroundColor = UIColor.clear
            self.alpha = 0
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
    
    
    
    
    func addSystemConstraints() {
        self.updateView.translatesAutoresizingMaskIntoConstraints = false
        self.updateIcon.translatesAutoresizingMaskIntoConstraints = false
        self.versionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.descTextView.translatesAutoresizingMaskIntoConstraints = false
        self.updateButton.translatesAutoresizingMaskIntoConstraints = false
        self.cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        let updateViewCenterXCons = NSLayoutConstraint(item: updateView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let updateViewCenterYCons = NSLayoutConstraint(item: updateView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        let updateViewWithCons = NSLayoutConstraint(item: updateView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: FitWidth(300))
        let updateViewHeightCons = NSLayoutConstraint(item: updateView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant: FitWidth(500))
        self.addConstraints([updateViewCenterXCons,updateViewCenterYCons,updateViewWithCons,updateViewHeightCons])
        
        let updateIconTopCons = NSLayoutConstraint(item: updateIcon, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: updateView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
        let updateIconLeftCons = NSLayoutConstraint(item: updateIcon, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: updateView, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 0)
        let updateIconRightCons = NSLayoutConstraint(item: updateIcon, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: updateView, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1, constant: 0)
        let updateIconHeightCons = NSLayoutConstraint(item: updateIcon, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: FitWidth(50))
        self.updateView.addConstraints([updateIconTopCons,updateIconLeftCons,updateIconRightCons,updateIconHeightCons])
        
        let labelTopCons = NSLayoutConstraint(item: versionLabel, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: updateIcon, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: FitWidth(10))
        //        labelTopCons.isActive = true
        
        let labelCenterXCons = NSLayoutConstraint(item: versionLabel, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: updateView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let labelWidthCons = NSLayoutConstraint(item: versionLabel, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: updateView, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: 0)
        let labelHeightCons = NSLayoutConstraint(item: versionLabel, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: FitWidth(30))
        
        self.updateView.addConstraints([labelWidthCons,labelCenterXCons,labelHeightCons])
        self.updateIcon.addConstraint(labelTopCons)
    }
    
}
