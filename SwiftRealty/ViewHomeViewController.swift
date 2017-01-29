//
//  ViewHomeViewController.swift
//  SwiftRealty
//
//  Created by Pierce on 1/24/17.
//  Copyright © 2017 Pierce. All rights reserved.
//

import UIKit

class ViewHomeViewController: UIViewController {
    
    var listing: Listing!
    
    var height: CGFloat = 0
    var width: CGFloat = 0
    let margin: CGFloat = 10
    
    var imageHeight: CGFloat = 0
    
    var imageView: UIImageView!
    
    var completionHandler:AWSS3TransferUtilityDownloadCompletionHandlerBlock?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidLayoutSubviews() {
        width = view.bounds.width
        height = view.bounds.height - topLayoutGuide.length
        imageHeight = (height)*7/16
        
        addImageContent()
        addTextContent()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addImageContent() {
        
        imageView = UIImageView()
        view.addSubview(imageView)
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.frame = CGRect(x: margin, y: margin + topLayoutGuide.length, width: width - 2*margin, height: imageHeight - 2*margin)
        
        getImageFromS3(listing: listing)
    }
    
    func addTextContent() {
        
        let descriptions = ["Address", "Price", "# Bedrooms", "# Bathrooms", "Square Footage", "Has Pool"]
        let values:[String] = [listing.address, "\(listing.price)", "\(listing.numberOfBedrooms)", "\(listing.numberOfBathrooms)", "\(listing.squareFootage)", "\(listing.hasPool)"]
        
        // Calculate container height based on remaining screen size (divide by n/2 because 2 items per row)
        let containerHeight: CGFloat = (height*9/16)/CGFloat(descriptions.count/2)
        let containerWidth: CGFloat = width/2
        
        // Create a row and column property to track the row and column through the loop
        var row = 0
        var column = 0
        for i in 0 ..< descriptions.count {
            
            // User a container view again for even spacing
            let container = UIView()
            view.addSubview(container)
            container.frame = CGRect(x: containerWidth*CGFloat(column), y: imageHeight + topLayoutGuide.length + containerHeight*CGFloat(row), width: containerWidth, height: containerHeight)
            
            let header = UILabel()
            container.addSubview(header)
            header.text = descriptions[i]
            header.font = getFont(type: .demiBold, size: 20)
            header.textColor = UIColor.darkGray
            header.numberOfLines = 0
            header.textAlignment = NSTextAlignment.center
            header.adjustsFontSizeToFitWidth = false
            
            // Get the size of the label text
            let headerSize:CGSize = header.attributedText!.size()
            
            // Set the header in the center of the container horizontally, and 5 from the top
            header.frame = CGRect(x: (containerWidth - headerSize.width)/2, y: 5, width: headerSize.width, height: headerSize.height)
            
            // Now let's draw a CALayer line to represent an underline partition
            let partition = CALayer()
            container.layer.addSublayer(partition)
            partition.frame = CGRect(x: header.frame.minX, y: header.frame.maxY, width: headerSize.width, height: headerSize.height)
            // Draw the line
            let draw = UIBezierPath()
            draw.move(to: CGPoint.zero)
            draw.addLine(to: CGPoint(x: headerSize.width, y: 0))
            // Make Layer Shape from path
            let lineShape = CAShapeLayer()
            lineShape.path = draw.cgPath
            lineShape.strokeColor = UIColor.darkGray.cgColor
            lineShape.lineWidth = 0.5
            partition.addSublayer(lineShape)
            
            let value = UILabel()
            container.addSubview(value)
            value.text = values[i]
            value.font = getFont(type: .regular, size: 15)
            value.textColor = UIColor.darkGray
            value.numberOfLines = 0
            value.textAlignment = NSTextAlignment.center
            value.adjustsFontSizeToFitWidth = false
            
            // Get the size of the label text
            let valueSize:CGSize = value.attributedText!.size()
            
            // Set the value label in the center of the container horizontally, and vertically (but minus the height of the header label and it's padding of 5pts on each side)
            value.frame = CGRect(x: (containerWidth - valueSize.width)/2, y: (containerHeight - valueSize.height)/2 + (headerSize.height + 10)/2, width: valueSize.width, height: valueSize.height)
            
            if column == 1 {
                // If we've just added content to the second column, change rows and start at column zero
                row += 1
                column = 0
            } else {
                // increment the column
                column += 1
            }
            
        }
        
    }
    
    
    func getImageFromS3(listing: Listing) {
        
        let transferUtility = AWSS3TransferUtility.default()
        
        let expression = AWSS3TransferUtilityDownloadExpression()
        expression.progressBlock = {(task: AWSS3TransferUtilityTask, progress: Progress) in
            
            // If you have a large set of images and want to display a progress bar to your user, this is where the progress of the download would be handled. We won't use it for the tutorial, but some of you may want to try using this.
            
        }
        
        completionHandler = { (task, location, data, error) in
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: data!)
                
                if let imagedata = UIImagePNGRepresentation(self.imageView.image!) {
                    let location = getDocumentsDirectory().appendingPathComponent(listing.imageFilename)
                    let url = URL(fileURLWithPath: location)
                    try? imagedata.write(to: url, options: [.atomic])
                }
            }
        } as AWSS3TransferUtilityDownloadCompletionHandlerBlock
        
        
        transferUtility.downloadData(fromBucket: listing.s3BucketName, key: listing.imageFilename, expression: expression, completionHander: completionHandler);
    }
    
    
    
    

}
