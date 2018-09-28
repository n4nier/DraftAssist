//
//  CategoryValues.swift
//  Draft Assist
//
//  Created by Nick Fournier on 2018-09-24.
//  Copyright © 2018 Nick Fournier. All rights reserved.
//

import UIKit

class CategoryValues: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var Goals: UITextField!
    @IBOutlet weak var Assists: UITextField!
    @IBOutlet weak var PIM: UITextField!
    @IBOutlet weak var PPP: UITextField!
    @IBOutlet weak var SHP: UITextField!
    @IBOutlet weak var GWG: UITextField!
    @IBOutlet weak var Hits: UITextField!
    @IBOutlet weak var Blocks: UITextField!
    
    let categorySettings = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        Goals.text = String(categorySettings.float(forKey: "goals"))
        Assists.text = String(categorySettings.float(forKey: "assists"))
        PIM.text = String(categorySettings.float(forKey: "pim"))
        PPP.text = String(categorySettings.float(forKey: "ppp"))
        SHP.text = String(categorySettings.float(forKey: "shp"))
        GWG.text = String(categorySettings.float(forKey: "gwg"))
        Hits.text = String(categorySettings.float(forKey: "hits"))
        Blocks.text = String(categorySettings.float(forKey: "blocks"))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        categorySettings.set(Float((Goals.text!.isEmpty ? "1": Goals.text!)),forKey: "goals")
        categorySettings.set(Float((Assists.text!.isEmpty ? "1" : Assists.text!)),forKey: "assists")
        categorySettings.set(Float((PIM.text!.isEmpty ? "1" : PIM.text!)),forKey: "pim")
        categorySettings.set(Float((PPP.text!.isEmpty ? "1" : PPP.text!)),forKey: "ppp")
        categorySettings.set(Float((SHP.text!.isEmpty ? "1" : SHP.text!)),forKey: "shp")
        categorySettings.set(Float((GWG.text!.isEmpty ? "1" : Hits.text!)),forKey: "gwg")
        categorySettings.set(Float((Hits.text!.isEmpty ? "1" : Hits.text!)),forKey: "hits")
        categorySettings.set(Float((Blocks.text!.isEmpty ? "1" : Blocks.text!)),forKey: "blocks")
    }
    @IBAction func NewDraftPressed(_ sender: Any) {
    }
    @IBAction func BackPressed(_ sender: Any) {
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}
