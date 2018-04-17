//
//  NotebookCell.swift
//  EverPobre
//
//  Created by Adolfo Fernandez on 3/4/18.
//  Copyright © 2018 Adolfo Fernandez. All rights reserved.
//

import UIKit

class NotebookCell : UITableViewHeaderFooterView {
   
    var notebook : Notebook? {
        didSet {
            nameNotebookLabel.text = notebook?.title
            defaultNoteBookImage.isHidden = !(notebook?.defaultNotebook)!
        }
    }
    
    let nameNotebookLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let defaultNoteBookImage: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "favorites"))
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .white
        return imageView
    }()
    
    override init(reuseIdentifier: String?) {
        
        super.init(reuseIdentifier: reuseIdentifier)
        
        
        self.backgroundView?.backgroundColor = .lightBlue
        
        addSubview(nameNotebookLabel)
        nameNotebookLabel.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        nameNotebookLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        nameNotebookLabel.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -58).isActive = true
        nameNotebookLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        //print("\(notebook?.title) \(notebook?.defaultNotebook)")
        
        addSubview(defaultNoteBookImage)
        defaultNoteBookImage.leftAnchor.constraint(equalTo: nameNotebookLabel.rightAnchor, constant: 16).isActive = true
        defaultNoteBookImage.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -16).isActive = true
        defaultNoteBookImage.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor).isActive = true
        defaultNoteBookImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
        defaultNoteBookImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
}
