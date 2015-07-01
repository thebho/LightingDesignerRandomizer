//
//  DiceViewController.swift
//  Tech Dice
//
//  Created by Brian Hoehne on 4/8/15.
//  Copyright (c) 2015 BHD. All rights reserved.
//

import UIKit
import CoreData


class TestView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect) {
        // Creates the die rectangle based on the given rect attribute
        let h = rect.height
        let w = rect.width
        var color:UIColor = UIColor.yellowColor()
        
        var drect = CGRect(x: (w * 0.25),y: (h * 0.25),width: (w * 0.5),height: (h * 0.5))
        var bpath:UIBezierPath = UIBezierPath(rect: drect)
        
        color.set()
        bpath.stroke()
        
        NSLog("drawRect has updated the view")
        
    }
}

extension Array {
    func randomItem() -> T {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}
class DiceViewController: UIViewController {
    
    // initiates die
    let die = TestView(frame: CGRectMake(100, 100, 300, 300))
    
    // fetches managedObjectContext from AppDelegate
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    // initiates die element label
    @IBOutlet weak var effectName: UILabel!
    var effectList: EffectList?
    var effectsArray = [EffectName]()
    var colorOptions = [UIColor.whiteColor(), UIColor.greenColor(), UIColor.magentaColor(), UIColor.cyanColor()]
    var timer: NSTimer?
    var timerCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildOriginal()
        effectList = NewListBuilder().pullActive(managedObjectContext!)
        loadEffects()
        self.navigationItem.title = effectList!.listName
        var navAppearance = UINavigationBar.appearance()
        navAppearance.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.lightGrayColor()]
//        view.addSubview(die)

    }
    @IBAction func unwindToThisViewController(segue: UIStoryboardSegue) {
        effectList = NewListBuilder().pullActive(managedObjectContext!)
        loadEffects()
        self.navigationItem.title = effectList!.listName
        effectName.text = "Shake"
        effectName.textColor = UIColor.whiteColor()

        
    }
    
    func buildOriginal () {
        NewListBuilder().newList(managedObjectContext!)

    }
    
    override func viewWillAppear(animated: Bool) {
        effectList = NewListBuilder().pullActive(managedObjectContext!)
        effectsArray = effectList!.pullEffects()
        self.navigationItem.title = effectList!.listName
    }
    func loadEffects() {
        effectsArray = effectList!.pullEffects()
    }
    
    func rollDice() {
        timerCount = 0
        timer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: Selector("animateDice"), userInfo: nil, repeats: true)
    }
    
    func animateDice () {
        timerCount += 1
        effectName.text = effectsArray.randomItem().name
        effectName.textColor = colorOptions.randomItem()
        if timerCount == 12 {
            timer?.invalidate()
        }
    }
    
    // When phone has stopped shaking, begins rollDice sequence
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent) {
        rollDice()
    }
    
    // Allows shake gesture recognizer
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    // Segues to TableViewController with list of dice
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "changeList"{
            let navVC = segue.destinationViewController as! EffectListTableViewController
            navVC.managedObjectContext = managedObjectContext!

        }
    }
    
}
