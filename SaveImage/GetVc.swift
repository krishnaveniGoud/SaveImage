//
//  GetVc.swift
//  SaveImage
//
//  Created by Administrator on 10/10/15.
//  Copyright (c) 2015 Administrator. All rights reserved.
//

import UIKit
import CoreData
class GetVc: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var tolBar: UIToolbar!
    var myCell = GetTableViewCell()
    var nameArr = NSMutableArray()
    var dataArr = NSMutableArray()
    var data = NSData()
  
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tolBar.backgroundColor = UIColor(red: 136.0/255, green: 155.0/255, blue: 218.0/255, alpha: 1.0)
        self.tolBar.tintColor =  UIColor(red: 136.0/255, green: 155.0/255, blue: 218.0/255, alpha: 1.0)
        self.title = "Save"

        self.view.backgroundColor = UIColor(red: 136.0/255, green: 155.0/255, blue: 218.0/255, alpha: 1.0)

        
    }
  override  func  viewWillAppear(animated: Bool) {
    dataArr.removeAllObjects()
    myCell.profileImg = nil
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let managedContext = appDelegate.managedObjectContext!
    let fetchRequest = NSFetchRequest(entityName: "Profile")
    
    var error: NSError?
    let fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error)
        as! [NSManagedObject]?
    
    if let results = fetchedResults
    {
        for (var i=0; i < results.count; i++)
        {
            let single_result = results[i]
            var out = single_result.valueForKey("nsme") as! String
            println(out)
            var d = single_result.valueForKey("profileimage") as! NSData
           data = d
            nameArr.addObject(out)
            dataArr.addObject(d)
            
        }
    }
    else
    {
        println("cannot read")
    }

    
    }
    override func viewWillDisappear(animated: Bool) {
        
        dataArr.removeAllObjects()
        myCell.profileImg = nil
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToSavePage(sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("Save") as! ViewController
        
        self.presentViewController(nextViewController, animated:true, completion:nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
    return nameArr.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        myCell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! GetTableViewCell
        
        
        
            //cell.lable.text = self.ids [indexPath.row]
        myCell.profileImg.layer.borderWidth = 1.0
        myCell.profileImg.layer.masksToBounds = false
        myCell.profileImg.layer.borderColor = UIColor.blackColor().CGColor
        myCell.profileImg.layer.cornerRadius = myCell.profileImg.layer.frame.height/2
        
        myCell.profileImg.clipsToBounds = true

      
        myCell.nameLbl.text = nameArr[indexPath.row] as? String
        var image = UIImage(data:(dataArr[indexPath.row] as? NSData)!)
               myCell.imageView?.image = image
      

        
            return myCell
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        println("did select row: \(indexPath.row)")
        
        
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
