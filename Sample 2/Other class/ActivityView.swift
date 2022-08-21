//
//  ActivityView.swift
//  Sample 2
//
//  Created by TechUnity IOS Developer on 20/08/22.
//

import UIKit
import Foundation

class ActivityIndicatorView
{
    var view: UIView!

var activityIndicator: UIActivityIndicatorView!

var title: String!

    init(title: String, center: CGPoint, width: CGFloat = 150, height: CGFloat = 90, Lableheight: CGFloat = 33)
{
    self.title = title

    let x = center.x - width/2.0
    let y = center.y - height/2.0

    self.view = UIView(frame: CGRect(x: x, y: y, width: width, height: height))
    self.view.backgroundColor = UIColor.white
    self.view.layer.cornerRadius = 10
//        self.view.layer.borderWidth = 1
//        self.view.layer.borderColor = UIColor.black.cgColor

    self.activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 150, height: 60))
    self.activityIndicator.color = UIColor.black
    self.activityIndicator.hidesWhenStopped = false

    let titleLabel = UILabel(frame: CGRect(x: 0, y: 40, width: 150, height: Lableheight))
    titleLabel.text = title
    titleLabel.numberOfLines = 3
    titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = .center

    self.view.addSubview(self.activityIndicator)
    self.view.addSubview(titleLabel)
}
    func getViewActivityIndicator() -> UIView
    {
        return self.view
    }

    func startAnimating()
    {
        self.activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }

    func stopAnimating()
    {
        DispatchQueue.main.async(execute: {() -> Void in
        self.activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()

        self.view.removeFromSuperview()
        })
    }
}
