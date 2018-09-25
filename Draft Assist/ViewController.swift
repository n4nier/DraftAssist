//
//  ViewController.swift
//  Draft Assist
//
//  Created by Nick Fournier on 2017-09-11.
//  Copyright © 2017 Nick Fournier. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate {
    @IBOutlet weak var PlayerList: UITableView!
    @IBOutlet weak var RecommendedPlayer: UILabel!
    @IBOutlet weak var roundLabel: UILabel!
    
    var playerArray: [NSManagedObject] = []
    var aPlayers: [Player] = []
    var draftRound: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let categorySettings = UserDefaults.standard
        let categories = ["goals", "assists", "pim", "ppp", "shp", "gwg", "hits", "blocks"]
        for category in categories {
            if categorySettings.integer(forKey: category) == 0 {
                categorySettings.set(1, forKey: category)
            }
        }
        
        loadPlayers()
        
        RecommendedPlayer.text = evaluatePlayers()
        
        PlayerList.delegate = self
        PlayerList.dataSource = self
        
        roundLabel.text = "Round " + "\(draftRound)" + ":"
    }
    
    @IBAction func nextRound(_ sender: Any) {
        draftRound += 1
        roundLabel.text = "Round " + "\(draftRound)" + ":"
        loadPlayers()
        PlayerList.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aPlayers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let player: Player = aPlayers[indexPath.row]
        cell?.textLabel!.text = player.playerName
        return cell!
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Set round to default (0)
            guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return
            }
            let playerID = self.aPlayers[indexPath.row].id
            
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Player")
            fetchRequest.predicate = NSPredicate(format: "id = %ld", playerID)
            
            var playerToDelete: [NSManagedObject] = []
            do {
                playerToDelete = try managedContext.fetch(fetchRequest)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
            
            for item in playerToDelete {
                let player = item as! Player
                player.round = 0
            }
            
            // save locally
            do {
                try managedContext.save()
                DispatchQueue.main.async {
                    print("Saved delete")
                }
            } catch {
                DispatchQueue.main.async {
                    print("Error importing notes to core data")
                }
                return
            }
            
            self.aPlayers.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func evaluatePlayers() -> String
    {
        return "abc"
    }
    
    func loadPlayers()
    {
        aPlayers = [Player]()
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Player")
        fetchRequest.predicate = NSPredicate(format: "round > 0 AND round <= %ld", draftRound)
        
        do {
            playerArray = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        for item in playerArray {
            let player = item as! Player
            aPlayers.append(player)
        }
    }
    
    @IBAction func clearPressed(_ sender: Any) {
        draftRound = 1
        roundLabel.text = "Round " + "\(draftRound)" + ":"
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Player")
        
        var allPlayers: [NSManagedObject] = []
        do {
            allPlayers = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        for item in allPlayers {
            let player = item as! Player
            player.round = 0
        }
        
        // save locally
        do {
            try managedContext.save()
            DispatchQueue.main.async {
                print("Saved clear")
            }
        } catch {
            DispatchQueue.main.async {
                print("Error importing notes to core data")
            }
            return
        }
        
        loadPlayers()
        PlayerList.reloadData()
    }
    
    @IBAction func Options(_ sender: AnyObject) {
        let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popOverID")
        
        popController.modalPresentationStyle = UIModalPresentationStyle.popover
        popController.preferredContentSize = CGSize(width: 200, height: 85)
        
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popController.popoverPresentationController?.delegate = self
        popController.popoverPresentationController?.sourceView = (sender as! UIView)
        popController.popoverPresentationController?.sourceRect = sender.bounds
        
        self.present(popController, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
}

