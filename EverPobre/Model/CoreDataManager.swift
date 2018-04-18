//
//  CoreDataManager.swift
//  EverPobre
//
//  Created by Adolfo Fernandez on 3/4/18.
//  Copyright © 2018 Adolfo Fernandez. All rights reserved.
//

import CoreData

class CoreDataManager : NSObject {
    
    static let sharedManager = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "EverPobre")
        container.loadPersistentStores{ (description, err) in
            if let err = err {
                fatalError("Carga de PersistantStore ha fallado: \(err)")
            }
            container.viewContext.automaticallyMergesChangesFromParent = true
        }
        return container
    }()


  
}
