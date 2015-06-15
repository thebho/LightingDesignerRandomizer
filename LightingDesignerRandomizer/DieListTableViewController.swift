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
    var effectsList: EffectList?
    var effects = [EffectName]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBar.title = effectsList!.listName
        effects = effectsList!.pullEffects()
        self.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            managedObjectContext!.deleteObject(effects[indexPath.row])
        }
        effects = effectsList!.pullEffects()
        self.tableView.reloadData()
    }

    
    @IBAction func addEffect(sender: UIButton) {
        let indexPath = NSIndexPath(forRow: sender.tag, inSection: 0)
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! NewEffectTableViewCell
        effectsList?.addNewEffect(managedObjectContext!, effectName: cell.newEffectTextField.text)
        cell.newEffectTextField.text = nil
        effects = effectsList!.pullEffects()
        self.tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return (effects.count + 1)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = indexPath.row
        if row < effects.count {
        let cell = tableView.dequeueReusableCellWithIdentifier("effect", forIndexPath: indexPath)as! DieTableViewCell
            cell.effectName.text = effects[row].name
            return cell
        }else {
            let cell = tableView.dequeueReusableCellWithIdentifier("new", forIndexPath: indexPath)as! NewEffectTableViewCell
            cell.addNewEffect.tag = row
            
            return cell
    }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
