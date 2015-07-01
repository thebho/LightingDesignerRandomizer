//
//  EffectListTableViewController.swift
//  Tech Dice
//
//  Created by Brian Hoehne on 4/8/15.
//  Copyright (c) 2015 BHD. All rights reserved.
//

import UIKit
import CoreData


class DieNameCell: UITableViewCell {
    
    @IBOutlet weak var dieName: UILabel!
    @IBOutlet weak var editListOutlet: UIButton!
}

class EffectListTableViewController: UITableViewController {
    

    var managedObjectContext: NSManagedObjectContext?
    var theatersArray = [EffectList]()
    var activeListName: EffectList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fetches all lists in the database
        pullAllLists()
        
        // Prevents user from segueing backwards without picking an effect list
        self.navigationItem.hidesBackButton = true
        
        self.navigationItem.title = "Select Die"

    }
    
    func pullAllLists() {
        let fetchRequest = NSFetchRequest(entityName: "EffectList")
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [EffectList]{
            theatersArray = fetchResults
        } else {
            println("Requst Failed")
        }
    }
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            managedObjectContext!.deleteObject(theatersArray[indexPath.row])
        }
        pullAllLists()
        self.tableView.reloadData()
    }
    

    @IBAction func editListAction(sender: UIButton) {
        activeListName = theatersArray[sender.tag]
    }
    
    // Hides iPhone status
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (theatersArray.count + 1)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = indexPath.row
        if row < theatersArray.count {
            let cell = tableView.dequeueReusableCellWithIdentifier("chooseCell", forIndexPath: indexPath) as! DieNameCell
            cell.dieName.text = theatersArray[row].listName
            cell.editListOutlet.tag = row
            cell.tag = row
            return cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("addCell", forIndexPath: indexPath) as! UITableViewCell
            
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row != theatersArray.count {
            
        }
    }
    
    // Adds action sheet to name new list, and segues to new blank list page
    @IBAction func addList(sender: UIButton) {
        var newListName = ""
        let actionSheetController: UIAlertController = UIAlertController(title: "New Die", message: "Name your new Die", preferredStyle: .Alert)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
        }
        actionSheetController.addAction(cancelAction)
        //Create and an option action
        let addAction: UIAlertAction = UIAlertAction(title: "Add", style: .Default) { action -> Void in
            let newListName = actionSheetController.textFields![0] as! UITextField
            EffectList.createNewEffectList(self.managedObjectContext!, listName: newListName.text)
            self.pullAllLists()
            self.tableView.reloadData()
        }
        actionSheetController.addAction(addAction)
        //Add a text field
        actionSheetController.addTextFieldWithConfigurationHandler { textField -> Void in
        }
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }
   
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "dieList"{
            let navVC = segue.destinationViewController as! DieListTableViewController
            navVC.elementList = theatersArray[sender!.tag]
            navVC.managedObjectContext = managedObjectContext!
    
        }else if segue.identifier == "changeDie"{
            
            // Returns to to main view controller and changes active list to selected list
            NewListBuilder().activateList(managedObjectContext!, listToActivate: theatersArray[sender!.tag])
        }
    }
}
