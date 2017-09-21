//
//  DraftSetup.swift
//  Draft Assist
//
//  Created by Nick Fournier on 2017-09-19.
//  Copyright © 2017 Nick Fournier. All rights reserved.
//

import UIKit

class DraftSetup: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var RoundList: UITableView!
    @IBOutlet weak var PlayerList: UITableView!
    
    var playerArray: [String] = []
    var roundArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PlayerList.delegate = self
        PlayerList.dataSource = self
        
        roundArray = []
        playerArray = ["John", "Andy", "Dale"]
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
            cell?.textLabel!.text = playerArray[indexPath.row]
            return cell!
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
