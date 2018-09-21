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
    
    var playerArray: [NSManagedObject] = []
    var aPlayers: [Player] = []
    var draftRound: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        RecommendedPlayer.text = myMethod()
        
        PlayerList.delegate = self
        PlayerList.dataSource = self
        
        loadPlayers()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let player: Player = aPlayers[indexPath.row]
        cell?.textLabel!.text = player.playerName
        return cell!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func myMethod() -> String
    {
        return "abc"
    }
    
    func loadPlayers()
    {
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
        self.PlayerList.reloadData()
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

