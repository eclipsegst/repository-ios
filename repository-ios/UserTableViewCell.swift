//
//  UserTableViewCell.swift
//  repository-ios
//
//  Created by Zhaolong Zhong on 10/17/20.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    public static let identifier = "UserTableViewCell"
    
    var title: String = "" {
        // After title value being set to a value, we execute this block
        didSet {
            titleLabel.text = title
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "I'm a title"
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Table view cell container
        contentView.heightAnchor.constraint(equalToConstant:  64).isActive = true
        backgroundColor = UIColor.gray
        
        setTitleLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Add label to table view cell container "contentView"
    private func setTitleLabel() {
        contentView.addSubview(titleLabel)
        // Make sure the left margin of title aligned with contentView's left margin and add 4 space
        titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 4).isActive = true
        // Make sure the title label algin conterView center vertically
        titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
}


