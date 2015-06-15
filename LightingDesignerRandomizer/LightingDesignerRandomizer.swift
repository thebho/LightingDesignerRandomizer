//
//  LightingDesignerRandomizer.swift
//  LightingDesignerRandomizer
//
//  Created by Brian Hoehne on 4/8/15.
//  Copyright (c) 2015 BHD. All rights reserved.
//

import Foundation
import CoreData

class EffectName: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var effectList: EffectList
    
    
    class func createNewEffectName(moc: NSManagedObjectContext, name: String, list: EffectList) -> EffectName {
        let newEffect = NSEntityDescription.insertNewObjectForEntityForName("EffectName", inManagedObjectContext: moc) as! EffectName
        
        newEffect.name = name
        newEffect.effectList = list
        
        return newEffect
    }

}

class EffectList: NSManagedObject {
    
    @NSManaged var listName: String
    @NSManaged var effects: NSSet
    @NSManaged var active: Bool
    
    
    class func createNewEffectList(moc: NSManagedObjectContext, listName: String) -> EffectList {
        let newList = NSEntityDescription.insertNewObjectForEntityForName("EffectList", inManagedObjectContext: moc)as! EffectList
        
        newList.listName = listName
        
        return newList
    }
    
    func pullEffects () -> [EffectName] {
        if let effectList = effects.allObjects as? [EffectName] {
            return effectList
            
        }else {
            println("pull effects error")
            return []
        }
    }
    
    func addNewEffect (moc: NSManagedObjectContext, effectName: String) {
        EffectName.createNewEffectName(moc, name: effectName, list: self)
    }

    
}


struct NewListBuilder {
    func newList (moc: NSManagedObjectContext) -> EffectList {
        
        let fetchRequest = NSFetchRequest(entityName: "EffectList")
        if let fetchResults = moc.executeFetchRequest(fetchRequest, error: nil) as? [EffectList]{
            if fetchResults.count > 0 {
                return pullActive(moc)! }
        } else {
            println("Requst Failed")
        }

        println("Called new list")
        
        let defaultList = EffectList.createNewEffectList(moc, listName: "Default")
        let defaults = ["Rainbow Effect", "Slutty Effect", "Milk The Cow", "Add LED Birdie", "Bally Hoo", "PiAnk!"]
        
        for def in defaults {
            EffectName.createNewEffectName(moc, name: def, list: defaultList)
        }
        defaultList.active = true
        return defaultList
    }
    
    func pullActive (moc: NSManagedObjectContext) -> EffectList? {
        let fetchRequest = NSFetchRequest(entityName: "EffectList")
        if let fetchResults = moc.executeFetchRequest(fetchRequest, error: nil) as? [EffectList]{
            for fetched in fetchResults {
                if fetched.active {
                    return fetched
                }
            }
        } else {
            println("Requst Failed")
            return nil
        }
        return nil
    }
    
    func activateList (moc: NSManagedObjectContext, listToActivate: EffectList){
        let fetchRequest = NSFetchRequest(entityName: "EffectList")
        if let fetchResults = moc.executeFetchRequest(fetchRequest, error: nil) as? [EffectList]{
            for fetched in fetchResults {
                if fetched.active {
                    fetched.active = false
                }
                
            }
        }
        
        listToActivate.active = true
        println(listToActivate.listName)
    }
}
