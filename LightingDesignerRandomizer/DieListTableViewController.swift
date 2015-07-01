//
//  DieListTableViewController.swift
//  Tech Dice
//
//  Created by Brian Hoehne on 4/8/15.
//  Copyright (c) 2015 BHD. All rights reserved.
//

import UIKit
import CoreData

class DieTableViewCell: UITableViewCell {
    @IBOutlet weak var effectName: UILabel!
    
}

class NewEffectTableViewCell: UITableViewCell {
    
    @IBOutlet weak var newEffectTextField: UITextField!
    @IBOutlet weak var addNewEffect: UIButton!
}

class DieListTableViewController: UITableViewController {

    @IBOutlet var navBar: UINavigationItem!
    var managedObjectContext: NSManagedObjectContext?
    var elementList: EffectList?
    var elements = [EffectName]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBar.title = elementList!.listName
        elements = elementList!.pullEffects()
        
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            managedObjectContext!.deleteObject(elements[indexPath.row])
        }
        elements = elementList!.pullEffects()
        self.tableView.reloadData()
    }

    
    @IBAction func addEffect(sender: UIButton) {
        let indexPath = NSIndexPath(forRow: sender.tag, inSection: 0)
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! NewEffectTableViewCell
        elementList?.addNewEffect(managedObjectContext!, effectName: cell.newEffectTextField.text)
        cell.newEffectTextField.text = nil
        elements = elementList!.pullEffects()
        self.tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return (elements.count + 1)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = indexPath.row
        if row < elements.count {
        let cell = tableView.dequeueReusableCellWithIdentifier("effect", forIndexPath: indexPath)as! DieTableViewCell
            cell.effectName.text = elements[row].name
            return cell
        }else {
            
            // Final cell used to add a new element
            let cell = tableView.dequeueReusableCellWithIdentifier("new", forIndexPath: indexPath)as! NewEffectTableViewCell
            cell.addNewEffect.tag = row
            
            return cell
    }
    }

   }
