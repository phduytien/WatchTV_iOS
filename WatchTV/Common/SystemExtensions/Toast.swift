//
//  UIViewController+Toast.swift
//  WatchTV
//
//  Created by Tien Pham on 11/4/24.
//

import Foundation
import UIKit

enum MessageType {
    case alert
    case warning
    case success
}

struct Toast {
    static func showToast(message: String, type: MessageType) {
        let keyWindow = UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .last
        guard let window = keyWindow else { return }
        let toastLabel = UILabel()
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(toastLabel)
        toastLabel.bottomAnchor.constraint(equalTo: window.bottomAnchor, constant: -24).isActive = true
        toastLabel.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: 32).isActive = true
        toastLabel.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -32).isActive = true
        toastLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
        
        toastLabel.backgroundColor = type == .alert ? UIColor(hex: "#DC3545") : type == .warning ?  UIColor(hex: "#FFC107"): UIColor(hex: "#28A745")
        toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont.systemFont(ofSize: 16)
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 0.0
        toastLabel.numberOfLines = 2
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 1.0
        }, completion: {(_) in
            UIView.animate(withDuration: 0.5, delay: 2.0, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }, completion: {_ in
                toastLabel.removeFromSuperview()
            })
        })
    }
}
