//
//  TripHistoryController.swift
//  YagnikPractical_Z
//
//  Created by Yagnik Suthar on 14/06/20.
//  Copyright © 2020 Yagnik Suthar. All rights reserved.
//

import UIKit
import CoreData

class TripHistoryController: CoreViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var listTableView: UITableView!
    
    //MARK:- Properties
    var aryRides = [Ride]()

    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listTableView.tableFooterView = UIView()
        registerCell()
        fetchDetailFromCoreData()
    }
    
    //MARK:- For Register tablecell
    func registerCell() {
        self.listTableView.register(UINib(nibName: String(describing:TripHistoryTableCell.self), bundle: nil), forCellReuseIdentifier: String(describing:TripHistoryTableCell.self))
    }
    
    //MARK:- Push to Details screen
    func pushToDetailsController(ride : Ride) {
        let detailsVC = TripDetailsController.instantiateFromStoryboard()
        detailsVC.ride = ride
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }

}

//MARK:- Data Source and Delegate Methods
extension TripHistoryController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aryRides.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TripHistoryTableCell", for: indexPath) as? TripHistoryTableCell {
            cell.titleLabel.text = "Trip \(indexPath.row + 1)"
            let curRow = aryRides[indexPath.row]
            cell.configureCell(curRow)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let curRow = aryRides[indexPath.row]
        pushToDetailsController(ride: curRow)
    }
    
}

//MARK:- Fatching Data From Local DB(Core Data)
extension TripHistoryController {
    
    func fetchDetailFromCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<CdRide>(entityName: "CdRide")
        fetchRequest.returnsObjectsAsFaults = false
        
        let addressfetchRequest = NSFetchRequest<CdAddress>(entityName: "CdAddress")
        addressfetchRequest.returnsObjectsAsFaults = false
        
        do {
            let rides = try managedContext.fetch(fetchRequest) as [CdRide]
            
            let addresses = try managedContext.fetch(addressfetchRequest) as [CdAddress]
            
            if rides.count < 0 {
                return
            }
            
            if let ride = rides.last , let add = addresses.last {
                print(ride)
                print(add)
            }
            
            if aryRides.count > 0 {
                aryRides.removeAll()
            }
            
            //MARK:- Logic for setting up in model
            for rideIndex in 0..<rides.count {
                aryRides.append(Ride(rides[rideIndex])!)
                for addIndex in 0..<addresses.count {
                    if let id = aryRides[rideIndex].ride_id , id == addresses[addIndex].address_id {
                        if addresses[addIndex].type == 0 {
                            aryRides[rideIndex].pickup_address = Address(addresses[addIndex])!
                        }else {
                            aryRides[rideIndex].dropoff_address = Address(addresses[addIndex])!
                        }
                    }
                }
                print(rideIndex,aryRides[rideIndex])
            }
            
            self.listTableView.reloadData()

        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}
