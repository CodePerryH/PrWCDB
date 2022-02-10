//
//  InputView.swift
//  PrWCDB
//
//  Created by admin on 2022/2/9.
//

import UIKit

class InputView: UIView {
    
    var insertBlock : (() -> ())?
    
    @IBOutlet weak var uidLabel: UILabel!
    
    @IBOutlet weak var nameTextFeild: UITextField!

    @IBOutlet weak var descTextFeild: UITextField!
    
    @IBOutlet weak var insertButton: UIButton!
    
    var identifier : Int? {
        didSet{
            insertButton.setTitle("更改信息", for: .normal)

        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        uidLabel.text = NSUUID().uuidString
    }
    
    @IBAction func addUserToDb(_ sender: Any) {
        ///添加数据
        let userModel = UserModel()
        userModel.uid = uidLabel.text ?? NSUUID().uuidString
        userModel.introduce = descTextFeild.text ?? ""
        userModel.name = nameTextFeild.text ?? ""
        if let identifier = identifier {
            userModel.identifier = identifier
        }
        
        PrWCDBBaseManager.shared.insertToDb(objects: [userModel], intoTable: userModelTableName)
        
        
        if let block = insertBlock {
            block()
        }
        
    }
}
