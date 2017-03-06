//
//  DetailViewController.swift
//  BorrowedItems
//
//  Created by Badr  on 16/01/2017.
//  Copyright © 2017 Badr. All rights reserved.
//

import UIKit
import CoreData

class ListViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TimeFrameDelegate{

    //MARK: OUTLETS
    @IBOutlet weak var savebtn: UIBarButtonItem!
    
    @IBOutlet weak var titlelbl: UITextField!
    @IBOutlet weak var listimg: UIImageView!
    @IBOutlet weak var endlbl: UILabel!
    @IBOutlet weak var startlbl: UILabel!
    @IBOutlet weak var choosebtn: UIButton!
    @IBOutlet weak var ownerimg: UIImageView!
    @IBOutlet weak var namelbl: UITextField!

    //MARK: VARIABLES
    var passedList: List?
    var moc : NSManagedObjectContext!
    
    var startDate: Date?
    var endDate: Date?
    
    enum PhotoSelection {
        case list
        case owner
    }
    
    var photoSelection: PhotoSelection = .list
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moc = CoreDataHelper.managedObjectContext()
        configureView()
        navigationController?.delegate = self
        let listGestureRec = UITapGestureRecognizer(target: self, action: #selector(self.selectListPhoto))
        listimg.addGestureRecognizer(listGestureRec)
        let OwnerGestureRec = UITapGestureRecognizer(target: self, action: #selector(self.selectOwnerPhoto))
        ownerimg.addGestureRecognizer(OwnerGestureRec)
    }

    
    func configureView() {
        if let list = passedList {
            if let listTitle = list.title{
                titlelbl.text = listTitle
            }
            if let listImg = list.image {
                listimg.image = UIImage(data: listImg as Data)
            }
            
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "DD/MM/YYYY"
            
            if let availableStartDate = list.startAt {
                startlbl.text = "Start At: \(dateFormatter.string(from: availableStartDate as Date))"
            }
            if let availableEndDate = list.endAt {
                endlbl.text = "End At: \(dateFormatter.string(from: availableEndDate as Date))"
            }
            
            if let owner = list.owner {
                namelbl.text = owner.name
                if let image = owner.image {
                    ownerimg.image = UIImage(data: image as Data)
                }
            }
        }
    }
    
    //MARK: Image scaling for UIImagePicker
    func scalImageToSize(image: UIImage, toSize size:CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
    func scaleImage(image: UIImage, towidth width:CGFloat, andheight height: CGFloat) -> UIImage{
        let oldWidth = image.size.width
        let oldHeight = image.size.height
        
        let scaleFactor = (oldWidth > oldHeight) ? width/oldWidth : height/oldHeight
        
        let newWidth = scaleFactor * oldWidth
        let newHeight = scaleFactor * oldHeight
        
        let size = CGSize(width: newWidth, height: newHeight)
        
        return scalImageToSize(image: image, toSize: size)
    }
    
    //MARK: UIImagePicker methods
    func selectListPhoto() {
        photoSelection = PhotoSelection.list
        selectPhoto()
    }
    
    func selectOwnerPhoto() {
        photoSelection = PhotoSelection.owner
        selectPhoto()
    }
    
    func selectPhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let scaledImage = scaleImage(image: image, towidth: 120, andheight: 120)
            
            if photoSelection == .list {
                listimg.image = scaledImage
            } else {
                ownerimg.image = scaledImage
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Button Action methods
    @IBAction func saveList (sender: AnyObject) {
        if passedList == nil {
            let newList = List(context: moc)
            newList.title = titlelbl.text
            
            if let listImg = listimg.image {
                newList.image = UIImageJPEGRepresentation(listImg, 0.3) as NSData?
            }
            
            if let availableStartDate = startDate {
                newList.startAt = availableStartDate as NSDate?
            }
            
            if let availableEndDate = endDate {
                newList.endAt = availableEndDate as NSDate?
            }
            
            //Check Owner existence
            let request = NSFetchRequest<Owner>(entityName: "Owner")
            request.fetchLimit = 1
            if let name = namelbl.text {
                request.predicate = NSPredicate(format: "name == %@", name)
            }
            
            var objectno: Int?
            
            do{
            objectno = try moc.count(for: request)
            } catch {
                print(error)
            }
            if let count = objectno {
                if count == 0 {
                    let newOwner = Owner(context: moc)
                    newOwner.name = namelbl.text
                    if let image = ownerimg.image {
                    newOwner.image = UIImageJPEGRepresentation(image, 0.3) as NSData?
                    }
                    newOwner.addToList(newList)
                    
                } else {
                    var data: [Owner]?
                    do {
                        data = try moc.fetch(request)
                    } catch {
                        print ("couldn't fetch the existing Owner object: \(error)")
                    }
                    
                    if let fetchedOwnerData = data?.first {
                        fetchedOwnerData.addToList(newList)
                    }
                }
            }
        } else {
            if let availableStartDate = startDate {
                passedList?.startAt = availableStartDate as NSDate?
            }
            if let availableEndDate = endDate {
                passedList?.endAt = availableEndDate as NSDate?
            }
        }
        
        do {
            try moc.save()
        } catch {
            print("Couldn't save changes \(error)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chooseTimeFrame"{
            let vc = segue.destination as! CalenderViewController
            vc.timeFrameDelegate = self
        }
        
    }
    
    func didSelectDateRange(range: GLCalendarDateRange) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "DD/MM/YY"
        
        startlbl.text = "Start at: \(dateFormatter.string(from: range.beginDate))"
        endlbl.text = "End at: \(dateFormatter.string(from: range.endDate))"
        
        startDate = range.beginDate
        endDate = range.endDate
    }
    
    
    
    
 
    
    
    
    
    
    
    
    
    
    
    
    
}
