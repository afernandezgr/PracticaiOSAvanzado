//
//  NoteCell.swift
//  EverPobre
//
//  Created by Adolfo Fernandez on 4/4/18.
//  Copyright © 2018 Adolfo Fernandez. All rights reserved.
//

import UIKit

class NoteCell : UITableViewCell {
    
    var note : Note? {
        didSet {
            nameNoteLabel.text = note?.title
            
        }
    }
    
    let nameNoteLabel: UILabel = {
        let label = UILabel()
        label.text = "Notename"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = . darkBlue
        
        addSubview(nameNoteLabel)
        nameNoteLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        nameNoteLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        nameNoteLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        nameNoteLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

