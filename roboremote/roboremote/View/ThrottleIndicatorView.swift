//
//  ThrottleIndicator.swift
//  roboremote
//
//  Created by Gustaf Nilklint on 2017-12-24.
//  Copyright © 2017 Tomas Nilsson. All rights reserved.
//

import UIKit

@IBDesignable
class ThrottleIndicatorView : UIView {
    
    var throttleInput : CGFloat = 0 {
        didSet{
            setupBarConstraints()
        }
    }
    
    var fwdHeight : NSLayoutConstraint!
    var revHeight : NSLayoutConstraint!
    
    var fwdView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.green
        return view
    }()
    var revView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.red
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        primitiveInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        primitiveInit()
    }
    
    func primitiveInit() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 7.5
        clipsToBounds = true
        addSubview(fwdView)
        addSubview(revView)
        
        self.widthAnchor.constraint(equalTo: fwdView.widthAnchor).isActive = true
        self.centerXAnchor.constraint(equalTo: fwdView.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: fwdView.bottomAnchor, constant: 0.5).isActive = true
        fwdHeight = fwdView.heightAnchor.constraint(equalToConstant: 0)
        fwdHeight.isActive = true
        
        self.widthAnchor.constraint(equalTo: revView.widthAnchor).isActive = true
        self.centerXAnchor.constraint(equalTo: revView.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: revView.topAnchor).isActive = true
        revHeight = revView.heightAnchor.constraint(equalToConstant: 0)
        revHeight.isActive = true
    }
    
    func setupBarConstraints() {
        if throttleInput > 0 {
            self.revHeight.constant = 0
            self.fwdHeight.constant = self.bounds.height / 2 * throttleInput
        }else{
            self.fwdHeight.constant = 0
            self.revHeight.constant = self.bounds.height / -2 * throttleInput
        }
        self.setNeedsLayout()
    }
    
    override func draw(_ rect: CGRect) {
        clearsContextBeforeDrawing = true
        
        let horizontalScale = UIBezierPath()
        horizontalScale.move(to: CGPoint(x: 0, y: self.bounds.height/2))
        horizontalScale.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height/2))
        
        UIColor.gray.set()
        horizontalScale.lineWidth = 1
        horizontalScale.stroke()
        
    }
}
