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
    @IBOutlet weak var roundLabel: UILabel!
    
    var playerArray: [NSManagedObject] = []
    var aRound: [Player] = []
    var aPlayers: [Player] = []
    var playerSearchResults: [Player] = []
    var searchActive: Bool = false
    var fromFiltered: Bool = false
    var round: Int = 1
    
    @IBAction func saveButton(_ sender: UIButton) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Player")
        
        for player in aRound {
            let playerName: String
            playerName = player.playerName!
            
            let predicate = NSPredicate(format: "playerName = '\(playerName)'")
            fetchRequest.predicate = predicate
            do {
                let playerSave = try managedContext.fetch(fetchRequest)
                if playerSave.count == 1 {
                    let objectUpdate = playerSave[0] as NSManagedObject
                    objectUpdate.setValue(round, forKey: "round")
                    do {
                        try managedContext.save()
                    } catch {
                        print(error)
                    }
                }
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
        round = round + 1
        roundLabel.text = "Round " + "'\(round)'"
        aRound.removeAll()
        self.roundList.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerList.delegate = self
        playerList.dataSource = self
        roundList.delegate = self
        roundList.dataSource = self
        playerSearch.delegate = self
        
        roundLabel.text = "Round " + "\(round)"

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
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DraftSetup.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var Count: Int?
        if tableView == self.roundList {
            Count = aRound.count
        } else {
            if (searchActive) {
                Count = playerSearchResults.count
            } else {
                Count = aPlayers.count
            }
        }
        return Count!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.roundList {
            let cell = tableView.dequeueReusableCell(withIdentifier: "testCell1")
            if !aRound.isEmpty {
                let player: Player = aRound[indexPath.row]
                cell?.textLabel!.text = player.playerName
            }
             return cell!
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "testCell")
            let player: Player
            if (searchActive) {
                player = playerSearchResults[indexPath.row]
            } else {
                player = aPlayers[indexPath.row]
            }
            cell?.textLabel!.text = player.playerName
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.playerList {
            let clickedRow: Player
            if (fromFiltered && !searchBarIsEmpty()) {
                clickedRow = playerSearchResults[indexPath.row]
                self.playerList.reloadData()
                var removeAt: Int
                for player in aPlayers {
                    if player.playerName == clickedRow.playerName {
                        removeAt = aPlayers.index(of: player)!
                        aPlayers.remove(at: removeAt)
                        self.playerList.beginUpdates()
                        self.playerList.deleteRows(at: [IndexPath(row: removeAt, section: 0)], with: .fade)
                        self.playerList.endUpdates()
                        fromFiltered = false
                    }
                }
            } else {
                clickedRow = aPlayers[indexPath.row]
                aPlayers.remove(at: indexPath.row)
                self.playerList.beginUpdates()
                self.playerList.deleteRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .fade)
                self.playerList.endUpdates()
            }
            aRound.append(clickedRow)
            self.roundList.beginUpdates()
            self.roundList.insertRows(at: [IndexPath(row: aRound.count-1, section: 0)], with: .automatic)
            self.roundList.endUpdates()
        } else {
            let clickedRow: Player
            clickedRow = aRound[indexPath.row]
            aRound.remove(at: indexPath.row)
            self.roundList.beginUpdates()
            self.roundList.deleteRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .fade)
            self.roundList.endUpdates()
            
            aPlayers.append(clickedRow)
            self.playerList.beginUpdates()
            self.playerList.insertRows(at: [IndexPath(row: aRound.count-1, section: 0)], with: .automatic)
            self.playerList.endUpdates()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.playerSearchResults = self.aPlayers.filter({(player: Player) -> Bool in
            return player.playerName!.lowercased().contains(searchText.lowercased())
        })
        
        if (playerSearchResults.count == 0) {
            searchActive = false;
            fromFiltered = false;
        } else {
            searchActive = true;
            fromFiltered = true;
        }
        self.playerList.reloadData()
    }
    
    //MARK: Search bar delegate functions
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        searchActive = true;
//        fromFiltered = true;
//    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if searchActive == true {
            fromFiltered = true
        }
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        fromFiltered = false;
        self.playerList.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchActive == true {
            fromFiltered = true
        }
        searchActive = false;
    }
    
    func searchBarIsEmpty() -> Bool {
         // Returns true if the text is empty or nil
        return playerSearch.text?.isEmpty ?? true
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}
