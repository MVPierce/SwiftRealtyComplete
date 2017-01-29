//
//  SwiftRealtyTableTableViewController.swift
//  SwiftRealty
//
//  Created by Pierce on 1/24/17.
//  Copyright © 2017 Pierce. All rights reserved.
//

import UIKit

var homes:[Listing] = []

class SwiftRealtyTableViewController: UITableViewController {

    var selectedIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register the .xib cell file with a reuse identifier of "CustomHomeCell"
        let nib = UINib.init(nibName: "CustomHomeTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CustomHomeCell")
        
        fetchListings()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchListings()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return homes.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "view_listing", sender: self)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomHomeCell") as! CustomHomeTableViewCell
        
        cell.setCellContent(address: homes[indexPath.row].address, price: homes[indexPath.row].price)

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // We don't want to execute this code if we're activing the segue to the AddHomeVC
        if segue.identifier == "view_listing" {
            let destination = segue.destination as! ViewHomeViewController
            destination.listing = homes[selectedIndex]
        }
    }
    
    
    func fetchListings() {
        // Create the object mapper
        let objectMapper = AWSDynamoDBObjectMapper.default()
        // Create a default DBScanExpression. I don't need any filters because I want to fetch every question object in the table.
        let expression = AWSDynamoDBScanExpression()
        
        // Scan the table
        objectMapper.scan(Listing.self, expression: expression).continue({ (task: AWSTask) -> AnyObject? in
            if let _ = task.error {
                print("Error Fetching Listings")
                return nil
            }
            if let result = task.result {
                print("Listings loaded from DynamoDB!!")
                // Scan successful.
                homes = result.items as! [Listing]
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
            return nil
        })
        
    }
    

}
