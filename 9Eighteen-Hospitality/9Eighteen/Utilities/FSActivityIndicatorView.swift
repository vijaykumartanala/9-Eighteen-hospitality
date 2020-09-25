//
//  FSActivityIndicatorView.swift
//  FanStar
//
//  Created by Kumar, Sravan on 07/07/18.
//  Copyright © 2018 Kumar, Sravan. All rights reserved.
//

import UIKit
import SwiftGifOrigin

class FSActivityIndicatorView {

    internal enum ActivityStyle: Int {
        case dark
        case light
    }
    
    static let shared = FSActivityIndicatorView()
    private var view: UIView!
    private var activityView: UIView!

    //MARK:- custom methods
    private func createActivityView() -> UIImageView {
        let activityView = UIImageView(frame: .zero)
        activityView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityView)
        activityView.image = UIImage.gif(name: "loader")
        activityView.contentMode = .scaleAspectFill
        activityView.clipsToBounds = true
        activityView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        activityView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        return activityView
    }
    
    internal func show() {
        guard let keyWindow = UIApplication.shared.keyWindow else { return }
        view = UIView(frame: .zero)
        view.tag = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        keyWindow.addSubview(view)
        
        view.leadingAnchor.constraint(equalTo: keyWindow.leadingAnchor, constant: 0).isActive = true
        keyWindow.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        view.topAnchor.constraint(equalTo: keyWindow.topAnchor, constant: 0).isActive = true
        keyWindow.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        activityView = createActivityView()
    }
    
    internal func dismiss() {
        guard let keyWindow = UIApplication.shared.keyWindow else { return }
            keyWindow.viewWithTag(2)?.removeFromSuperview()
            activityView = nil
            view = nil
    }
}


