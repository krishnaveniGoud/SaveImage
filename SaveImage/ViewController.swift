//
//  ViewController.swift
//  SaveImage
//
//  Created by Administrator on 07/10/15.
//  Copyright (c) 2015 Administrator. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController,UITextFieldDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate{
    var data = NSMutableArray()
   // var ImageData = NSData()
    @IBOutlet var tolBar: UIToolbar!
    var name_list = [NSManagedObject]()
     var imageData = NSData()
    @IBOutlet var nameTxt: UITextField!
    @IBOutlet var image: UIImageView!
    var picker:UIImagePickerController?=UIImagePickerController()
    var popover:UIPopoverController?=nil
   let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
        override func viewDidLoad() {
        super.viewDidLoad()
            self.tolBar.backgroundColor = UIColor(red: 136.0/255, green: 155.0/255, blue: 218.0/255, alpha: 1.0)
            self.view.backgroundColor = UIColor(red: 136.0/255, green: 155.0/255, blue: 218.0/255, alpha: 1.0)

        nameTxt.delegate = self
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
     
       }
    func saveData() {
        
        
       
        let managedContext = appDelegate.managedObjectContext!
      
        let entity = NSEntityDescription.entityForName("Profile",
            inManagedObjectContext: managedContext)
        let options = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext:managedContext)
        
        options.setValue(self.nameTxt.text, forKey: "nsme")
        options.setValue(imageData, forKey: "profileimage")
        
        var error: NSError?
        if !managedContext.save(&error)
        {
            println("Could not save\(error?.description)")
        }else{
            
            println("saved")
        }
    }
   


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }

    @IBAction func takeImageAction(sender: AnyObject) {
         image.image = nil
        var alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        var cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default)
            {
                UIAlertAction in
                self.openCamera()
                
        }
        var gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertActionStyle.Default)
            {
                UIAlertAction in
                self.openGallary()
        }
        var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel)
            {
                UIAlertAction in
                
        }
        
        picker?.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        // Present the controller
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else
        {
            popover=UIPopoverController(contentViewController: alert)
            popover!.presentPopoverFromRect(self.image.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
        

    }
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
        {
            
            picker!.sourceType = UIImagePickerControllerSourceType.Camera
            self .presentViewController(picker!, animated: true, completion: nil)
        }
        else
        {
            openGallary()
        }
    }
    func openGallary()
    {
        picker!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            self.presentViewController(picker!, animated: true, completion: nil)
        }
        else
        {
            popover=UIPopoverController(contentViewController: picker!)
            popover!.presentPopoverFromRect(self.image.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject])
    {
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        self.image.layer.borderWidth = 1.0
        self.image.layer.masksToBounds = false
        self.image.layer.borderColor = UIColor.blackColor().CGColor
        self.image.layer.cornerRadius = self.image.frame.height/2
        self.image.clipsToBounds = true
        
        self.image.image=info[UIImagePickerControllerOriginalImage] as? UIImage
     
        var data = UIImagePNGRepresentation(self.image.image)
        
        println("ImageData\(data!.length)")
        imageData = data
       
        
        
        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        println("picker cancel.")
    }
   
    @IBAction func retriveAction(sender: AnyObject) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("Get") as! GetVc
        
        self.presentViewController(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func fetchIemsAction(sender: AnyObject) {
        
        image.image = nil
        if  nameTxt.text.isEmpty {
            var alert = UIAlertController(title: "Error", message: "NameTextFieldShouldNotEmpty", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler:self.handleCancel))
            self.presentViewController(alert, animated: true, completion: {
                println("completion block")
            })

        }else{
        var error: NSError?
        let fetchRequest = NSFetchRequest(entityName:"Profile")
        let predicate = NSPredicate(format: "nsme == %@", nameTxt.text)
        fetchRequest.predicate = predicate
        let contxt: NSManagedObjectContext = appDelegate.managedObjectContext!
        let fetchResults = contxt.executeFetchRequest(fetchRequest, error: &error)
        if error != nil{
            var alert = UIAlertController(title: "Error", message: "SearchNameisSameAsSaveNameWithCaseSensitive", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler:self.handleCancel))
            self.presentViewController(alert, animated: true, completion: {
                println("completion block")
            })

        }else{
            let object: AnyObject = fetchResults![0]
            var d = object.valueForKey("profileimage") as! NSData
            imageData = d
            println("\(object)")
            self.image.layer.borderWidth = 1.0
            self.image.layer.masksToBounds = false
            self.image.layer.borderColor = UIColor.blackColor().CGColor
            self.image.layer.cornerRadius = self.image.frame.height/2
            self.image.clipsToBounds = true
            image.image = UIImage(data: imageData)

            
        }
    }
        
    }
    func handleCancel(alertView: UIAlertAction!)
    {
        println("Cancelled !!")
    }
    @IBAction func saveDataToDb(sender: AnyObject) {
        
         self.saveData()
    }

    @IBOutlet var saveImageAndNameAction: UIButton!
}

