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

class Toast {
    static func showToast(message: String, type: MessageType) {
        let keyWindow = UIApplication
            .shared
            .connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .last
        guard let window = keyWindow else {
            return
        }
        let toastLabel = UILabel(
            frame: CGRect(
                x: 36,
                y: window.frame.size.height - 64,
                width: window.frame.size.width - 72,
                height: 40
            )
        )
        toastLabel.backgroundColor = type == .alert ? UIColor(hex: "#DC3545") : type == .warning ?  UIColor(hex: "#FFC107"): UIColor(hex: "#28A745")
        toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont.systemFont(ofSize: 16)
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 0.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        window.addSubview(toastLabel)
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 1.0
        }, completion: {(_) in
            if (type != .warning) {
                UIView.animate(withDuration: 0.5, delay: 2.0, options: .curveEaseOut, animations: {
                    toastLabel.alpha = 0.0
                }, completion: {_ in
                    toastLabel.removeFromSuperview()
                })
            }
        })
    } }
