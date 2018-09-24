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
        
        Goals.text = String(categorySettings.integer(forKey: "goals"))
        Assists.text = String(categorySettings.integer(forKey: "assists"))
        PIM.text = String(categorySettings.integer(forKey: "pim"))
        PPP.text = String(categorySettings.integer(forKey: "ppp"))
        SHP.text = String(categorySettings.integer(forKey: "shp"))
        GWG.text = String(categorySettings.integer(forKey: "gwg"))
        Hits.text = String(categorySettings.integer(forKey: "hits"))
        Blocks.text = String(categorySettings.integer(forKey: "blocks"))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        categorySettings.set(Int(Goals.text ?? "1")!,forKey: "goals")
        categorySettings.set(Int(Assists.text ?? "1")!,forKey: "assists")
        categorySettings.set(Int(PIM.text ?? "1")!,forKey: "pim")
        categorySettings.set(Int(PPP.text ?? "1")!,forKey: "ppp")
        categorySettings.set(Int(SHP.text ?? "1")!,forKey: "shp")
        categorySettings.set(Int(GWG.text ?? "1")!,forKey: "gwg")
        categorySettings.set(Int(Hits.text ?? "1")!,forKey: "hits")
        categorySettings.set(Int(Blocks.text ?? "1")!,forKey: "blocks")
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
