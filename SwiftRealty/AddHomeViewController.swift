//
//  AddHomeViewController.swift
//  SwiftRealty
//
//  Created by Pierce on 1/24/17.
//  Copyright © 2017 Pierce. All rights reserved.
//

import UIKit

class AddHomeViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var height: CGFloat = 0
    var width: CGFloat = 0
    
    // We'll set a fixed height to the vertical area we want set aside at the bottom of the screen for the user to select an image, and for it to be displayed.
    var imageHeight: CGFloat = 0
    
    var textFields: [UITextField] = [UITextField]()
    var poolSwitch: UISwitch!
    
    var s3BucketName = "yourbucketname_lowercase"
    
    var listingImage: UIImage?
    
    var pickImageButton: UIButton!
    var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    override func viewDidLayoutSubviews() {
        height = view.bounds.height - self.topLayoutGuide.length
        width = view.bounds.width
        
        // We don't need to add the image functionality just yet, but knowing how much of the screen's height we want it to take up at the bottom of the screen will help calculate even spacing between the fields above.
        imageHeight = height * 7/16
        
        addFields()
        
        let saveButton = UIButton()
        view.addSubview(saveButton)
        saveButton.setTitle("Save Listing", for: UIControlState.normal)
        saveButton.setTitleColor(UIColor.blue, for: UIControlState.normal)
        saveButton.titleLabel?.font = getFont(type: .demiBold, size: 20)
        saveButton.frame = CGRect(x: (width-200)/2, y: (view.bounds.height) - (60), width: 200, height: 50)
        saveButton.addTarget(self, action: #selector(saveListing), for: UIControlEvents.touchUpInside)
        
        addImageContent()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addImageContent() {
        
        // This is vertical and horizontal
        let margin: CGFloat = 10
        let buttonHeight: CGFloat = 50    // Same height we used for the saveButton
        
        pickImageButton = UIButton()
        view.addSubview(pickImageButton)
        pickImageButton.setTitleColor(UIColor.red, for: UIControlState.normal)
        pickImageButton.setTitle("Choose Listing Image", for: UIControlState.normal)
        pickImageButton.titleLabel?.font = getFont(type: .demiBold, size: 20)
        pickImageButton.addTarget(self, action: #selector(chooseImageSource), for: UIControlEvents.touchUpInside)
        
        let actualImageHeight: CGFloat = imageHeight - (buttonHeight + 2*margin)*2    // Image height section - 2 buttons of 50pts in height + 10pt margin on top and bottom of each
    
        imageView = UIImageView()
        view.addSubview(imageView)
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.frame = CGRect(x: margin, y: (view.bounds.height) - (buttonHeight + 2*margin + actualImageHeight), width: width - (margin*2), height: actualImageHeight)
        
        pickImageButton.frame = CGRect(x: (width-200)/2, y: imageView.frame.minY - (margin+buttonHeight), width: 200, height: buttonHeight)
    }
    
    func addFields() {
        
        let descriptions = ["Address", "Price", "# Bedrooms", "# Bathrooms", "Square Footage", "Has Pool"]
        let containerHeight: CGFloat = 45
        
        // This will help make the code neater below.
        let n = CGFloat(descriptions.count)
        
        // To detect an even space between field
        let spacing: CGFloat = ((height - imageHeight) - (containerHeight * n))/(n+1)
        
        for i in 0 ..< Int(n) {
            
            // I will use container views just to keep space calculations easier
            let container = UIView()
            view.addSubview(container)
            let yDisplacement: CGFloat = topLayoutGuide.length + (spacing + (spacing + containerHeight)*CGFloat(i))
            container.frame = CGRect(x: 0, y: yDisplacement, width: width, height: containerHeight)
            
            // Instantiate a new label for the description
            let label = UILabel()
            container.addSubview(label)
            label.text = "\(descriptions[i]):"
            label.font = getFont(type: .demiBold, size: 15)
            label.textColor = UIColor.darkGray
            label.textAlignment = NSTextAlignment.left
            let labelSize = label.attributedText!.size()
            
            // Margin for both sides
            let margin: CGFloat = 10
            
            // Now I want the label to be centered in the frame of it's container view on the y-axis
            label.frame = CGRect(x: margin, y: (containerHeight-labelSize.height)/2, width: labelSize.width, height: labelSize.height)
            
            // We want text fields for every entry type except the very last one which we'll want a UISwitch for
            if i < Int(n)-1 {
                // Set the desired size of the textFields:
                let fieldWidth: CGFloat = width/2
                let fieldHeight: CGFloat = containerHeight-5
                // Create UITextField instance
                let field = UITextField()
                container.addSubview(field)
                field.delegate = self
                field.borderStyle = UITextBorderStyle.roundedRect
                field.font = getFont(type: .regular, size: 15)
                field.textColor = UIColor.darkGray
                field.textAlignment = NSTextAlignment.right
                field.keyboardType = i == 0 ? UIKeyboardType.alphabet : UIKeyboardType.numberPad
                field.frame = CGRect(x: width - (fieldWidth+margin), y: 2.5, width: fieldWidth, height: fieldHeight)
                textFields.append(field)
            } else {
                // Create UISwitch instance
                let poolSwitch = UISwitch()
                container.addSubview(poolSwitch)
                poolSwitch.isOn = false // Most homes don't have pools so lets set this to off by default
                poolSwitch.frame = CGRect(x: width - (poolSwitch.bounds.width+margin), y: (containerHeight-poolSwitch.bounds.height)/2, width: poolSwitch.bounds.width, height: poolSwitch.bounds.height)
                self.poolSwitch = poolSwitch
            }
            
        }
        
    }
    
    func showCameraOption() {
        // Check if the device has a camera
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            
            // Device has a camera, now create the image picker controller
            let imagePicker:UIImagePickerController = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
            
        }
        else {
            NSLog("No Camera")
        }
    }
    
    func showPhotoLibrary() {
        // Check if the device has access to a photo library
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            
            // Device has a photolibrary
            let imagePicker:UIImagePickerController = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
            
        }
        else {
            NSLog("No Photo Library")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // To dismiss the image picker
        self.dismiss(animated: true, completion: nil)
        
        listingImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        imageView.image = listingImage
        pickImageButton.setTitle("Change Image", for: UIControlState.normal)
    }
    
    func chooseImageSource() {
        
        let message:String = "Please Select Either Your Camera Or Photo Library"
        let titleA:String = "Camera"
        let titleB:String = "Photo Library"
        
        // Create a new alert controller
        let actionSheet:UIAlertController = UIAlertController(title: "Choose Source", message: message, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        // Add an alert action for camera option
        let firstAlertAction:UIAlertAction = UIAlertAction(title: titleA, style: UIAlertActionStyle.default, handler: {
            (alertAction:UIAlertAction) in
            
            self.showCameraOption()
            
        })
        
        // Add an alert action for photo library option
        let secondAlertAction:UIAlertAction = UIAlertAction(title: titleB, style: UIAlertActionStyle.default, handler: {
            (alertAction:UIAlertAction) in
            
            self.showPhotoLibrary()
            
        })
        
        let cancelAlertAction:UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        actionSheet.addAction(firstAlertAction)
        actionSheet.addAction(secondAlertAction)
        actionSheet.addAction(cancelAlertAction)
        
        // Display it to the user
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func saveListing() {
        if let image = listingImage {
            saveListingImageInS3(image: image)
        } else {
            print("Have user choose an image")
        }
    }
    
    
    func saveListingFromUserInput(bucketName: String, imageName: String) {
        
        let mapper = AWSDynamoDBObjectMapper.default()
        
        let listing = startNewListingFromTextFieldInput()
        
        // Now we need to add the status from our hasPool UISwitch
        listing.hasPool = poolSwitch.isOn
        
        // generate a random ID number and check that there isn't a Listing already assigned to that ID
        var random = Int(arc4random_uniform(UInt32(300000)))
        var matches = homes.filter{ $0.id == random }
        while (matches.count > 0) {
            // Homes has a listing with that ID - so regenerate
            random = Int(arc4random_uniform(UInt32(300000)))
            matches = homes.filter{ $0.id == random }
        }
        
        // Now assign the id number
        listing.id = random
        
        // TODO: - Save image to S3 bucket, and store imageFile name and bucket name
        listing.imageFilename = imageName
        listing.s3BucketName = bucketName
        
        mapper.save(listing).continue({ (task:AWSTask) -> AnyObject? in
            if task.error != nil {
                print(task.error as Any)
            }
            
            if task.exception != nil {
                print(task.exception as Any)
            }
            
            if task.result != nil {
                print("Listing saved successfully!")
            }
            
            return nil
        })
    }
    
    func saveListingImageInS3(image: UIImage) {
      
        // Start by generating a new UUID number for the image
        let uniqueImageName = UUID().uuidString + ".png"
        
        // Setup a path variable
        var path = ""
        
        // Start by re-creating the UIImage as Data
        if let data = UIImagePNGRepresentation(image) {
            path = getDocumentsDirectory().appendingPathComponent(uniqueImageName)
            let url = URL(fileURLWithPath: path)
            try? data.write(to: url, options: [.atomic])
        } else {
            // TODO - Alert the user image saving failed
            print("Image upload faile")
            return
        }
        
        // Instantiate a URL with the image path
        let uploadFileUrl = URL(fileURLWithPath: path)
        
        // Create an instance of AWSS3TransferUtilityUploadCompletionHandlerBlock (whoa that's a mouthful)
        // This is where you put code you want to execute when the upload is complete
        let completionHandler = { (task, error) -> Void in
            DispatchQueue.main.async {
                
                if error != nil {
                    print(error as Any)
                   
                } else {
                    // Upload was a success!
                    // Asynchronously start to save the listing in DynamoDB with the bucket name and UUID name for the image file.
                    self.saveListingFromUserInput(bucketName: self.s3BucketName, imageName: uniqueImageName)
                    
                }
            }
            } as AWSS3TransferUtilityUploadCompletionHandlerBlock
        
        // Get the default instance of AWSS3TransferUtitlity
        let transferUtility = AWSS3TransferUtility.default()
        
        // Upload the file asynchronously pass in the bucket name and the uniqueImageName
        transferUtility.uploadFile(uploadFileUrl, bucket: self.s3BucketName, key: uniqueImageName, contentType: "image/png", expression: nil, completionHander: completionHandler).continue({ (task) -> AnyObject! in
            if let error = task.error {
                print("Image Save Failure: %@", error.localizedDescription)
            }
            if let exception = task.exception {
                print("Image Save Exception: %@", exception.description)
            }
            if let _ = task.result {
                // You don't want to put anything here you don't want handled before the upload is complete. This is just to alert you that the upload started.
                print("Image Upload Has Begun!")
            }
            
            return nil;
        })

    }
 
    
    func startNewListingFromTextFieldInput() -> Listing {
        
        let returnListing = Listing()
        for i in 0 ..< textFields.count {
            var text: String = " "
            if let textFieldText = textFields[i].text {
                if textFieldText != "" {
                    text = textFieldText
                } else { text = " " }
            } else { text = " " }
            switch i {
            case 0: returnListing?.address = text
            case 1:
                if let price = Double(text) {
                    returnListing?.price = price
                } else { returnListing?.price = 0.0 }
            case 2:
                if let bedrooms = Int(text) {
                    returnListing?.numberOfBedrooms = bedrooms
                } else { returnListing?.numberOfBedrooms = 0 }
            case 3:
                if let bathrooms = Int(text) {
                    returnListing?.numberOfBathrooms = bathrooms
                } else { returnListing?.numberOfBathrooms = 0 }
            case 4:
                if let sqFeet = Double(text) {
                    returnListing?.squareFootage = sqFeet
                } else { returnListing?.squareFootage = 0.0 }
            default:
                break
            }
            
        }
        return returnListing!
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touches.first != nil else { return }
        
        view.endEditing(true)
    }

}

extension AddHomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// I want to use a variation of the AvenirNext font, so I'm creating a convenience function to get the right font throughout the app. Types: 0 - Regular, 1 - Bold, 2 - Light, 3 - LightItalic, 4 - BoldItalic
public enum MyFontType: Int {
    case regular = 0
    case demiBold = 1
    case ultraLight = 2
    case ultraLightItalic = 3
    case demiBoldItalic = 4
}

public func getFont(type: MyFontType, size: CGFloat) -> UIFont {
    var fontName:String = ""
    switch type {
    case .regular:
        fontName = "AvenirNext-Regular"
    case .demiBold:
        fontName = "AvenirNext-DemiBold"
    case .ultraLight:
        fontName = "AvenirNext-UltraLight"
    case .ultraLightItalic:
        fontName = "AvenirNext-UltraLightItalic"
    case .demiBoldItalic:
        fontName = "AvenirNext-DemiBoldItalic"
    }
    return UIFont(name: fontName, size: size)!
}

public func getDocumentsDirectory() -> NSString {
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let documentsDirectory = paths[0]
    return documentsDirectory as NSString
}
