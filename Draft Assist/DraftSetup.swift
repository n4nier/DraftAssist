//
//  DraftSetup.swift
//  Draft Assist
//
//  Created by Nick Fournier on 2017-09-19.
//  Copyright © 2017 Nick Fournier. All rights reserved.
//

import UIKit
import CoreData

class DraftSetup: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    @IBOutlet weak var roundList: UITableView!
    @IBOutlet weak var playerList: UITableView!
    @IBOutlet weak var playerSearch: UISearchBar!
    
    var playerArray: [NSManagedObject] = []
    var roundArray: [String] = []
    var aPlayers: [Player] = []
    var playerSearchResults: [Player] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerList.delegate = self
        playerList.dataSource = self
        playerSearch.delegate = self
        
        roundArray = []
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Player")

        do {
            playerArray = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        for item in playerArray {
            let player = item as! Player
            aPlayers.append(player)
        }
        
        playerList.tableHeaderView = playerSearch
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var Count: Int?
        if tableView == self.roundList {
            Count = roundArray.count
        }
        
        if !searchBarIsEmpty() {
            Count = playerSearchResults.count
        }
        
        if tableView == self.playerList {
            Count = playerArray.count
        }
        
        return Count!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.roundList {
            let cell = tableView.dequeueReusableCell(withIdentifier: "testCell1")
            cell?.textLabel!.text = roundArray[indexPath.row]
            return cell!
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "testCell")
            let player: Player
            if !searchBarIsEmpty() {
                player = playerSearchResults[indexPath.row]
            } else {
                player = aPlayers[indexPath.row]
            }
            cell?.textLabel!.text = player.playerName
            return cell!
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.playerSearchResults = self.aPlayers.filter({(player: Player) -> Bool in
            return player.playerName!.lowercased().contains(searchText.lowercased())
        })
        
        playerList.reloadData()
//        if (searchText == "") {
//            searchActive = false;
//        } else {
//            searchActive = true;
//        }
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return playerSearch.text?.isEmpty ?? true
    }
    /*
    //MARK: Search bar delegate functions
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        warrantiesTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }*/
}
