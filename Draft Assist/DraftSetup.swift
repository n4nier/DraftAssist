//
//  DraftSetup.swift
//  Draft Assist
//
//  Created by Nick Fournier on 2017-09-19.
//  Copyright © 2017 Nick Fournier. All rights reserved.
//

import UIKit
import CoreData

class DraftSetup: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var RoundList: UITableView!
    @IBOutlet weak var PlayerList: UITableView!
    @IBOutlet weak var playerSearch: UISearchBar!
    
    var playerArray: [NSManagedObject] = []
    var roundArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PlayerList.delegate = self
        PlayerList.dataSource = self
        
        roundArray = []
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Players")

        do {
            playerArray = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var Count: Int?
        
        if tableView == self.RoundList {
            Count = roundArray.count
        }
        
        if tableView == self.PlayerList {
            Count = playerArray.count
        }
        
        return Count!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if tableView == self.RoundList {
            let cell = tableView.dequeueReusableCell(withIdentifier: "testCell1")
            cell?.textLabel!.text = roundArray[indexPath.row]
            return cell!
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "testCell")
            let player = playerArray[indexPath.row] as! Players
            cell?.textLabel!.text = player.playerName
            return cell!
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
