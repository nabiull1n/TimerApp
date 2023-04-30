//
//  CustomButton.swift
//  TimerApp
//
//  Created by Денис Набиуллин on 29.04.2023.
//

import UIKit

class CustomButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    init(title: String, titleColor: UIColor, backColor: UIColor){
        super.init(frame: .zero)
        layer.cornerRadius = 38
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        backgroundColor = backColor
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 2
        translatesAutoresizingMaskIntoConstraints = false
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
