//
//  File.swift
//  AR-VideoPlayer
//
//  Created by MacBook Pro on 9/1/23.
//

import UIKit
import ARKit
import SwiftUI
class ToastView: UIView {
    let messageLabel = UILabel()

    init(message: String) {
        super.init(frame: .zero)

        alpha = 0 // Set initial alpha value to 0

        backgroundColor = UIColor.black.withAlphaComponent(0.7)
        layer.cornerRadius = 10

        messageLabel.text = message
        messageLabel.textColor = .white
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(messageLabel)

        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
