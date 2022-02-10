//
//  ListTableViewController.swift
//  PrWCDB
//
//  Created by admin on 2022/2/9.
//

import UIKit
import WCDBSwift



class ListTableViewController: UITableViewController {
    
    private var users : [UserModel] = [UserModel]()
    
    private lazy var addButton  : UIButton = {
        let bt = UIButton()
        bt.setTitle("添加", for: .normal)
        bt.setTitleColor(UIColor.white, for: .normal)
        bt.titleLabel?.font = UIFont.systemFont(ofSize: 18,weight: .bold)
        bt.addTarget(self, action: #selector(addDbModel), for: .touchUpInside)
        bt.backgroundColor = UIColor.black
        bt.layer.cornerRadius = 25
        return bt
    }()
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        getDbModels()
        
    }

    private func configUI(){
        view.addSubview(addButton)
        addButton.frame = CGRect(x: UIScreen.main.bounds.width - 80, y: UIScreen.main.bounds.height - 150, width: 50, height: 50)
        
        self.tableView.register(UINib(nibName: "ListTableViewCell",bundle: nil), forCellReuseIdentifier: "ListTableViewCell")
        
        let foot = UILabel()
        foot.text = "左滑删除，选中更改"
        foot.textColor = .black
        foot.textAlignment = .center
        foot.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        foot.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60)
        tableView.tableFooterView = foot
        

    }
    ///从数据库获取数据源
    func getDbModels(){
        users.removeAll()
        if let datas = PrWCDBBaseManager.shared.qureyFromDb(fromTable: userModelTableName, cls: UserModel.self) {
            users.append(contentsOf: datas)
        }
        tableView.reloadData()
    }
    ///删除
    func deleteListModel(uid : String){
        let query = UserModel.Properties.uid == uid

        PrWCDBBaseManager.shared.deleteFromDb(fromTable: userModelTableName, where: query)
    }
    
    
    //MARK: Button Action
    @objc func addDbModel(){
        let addView : InputView = Bundle.main.loadNibNamed("InputView", owner: nil, options: nil)?.first as! InputView
        addView.bounds = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 30, height: 250)
        addView.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
        let popV = PrPopView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        popV.contenView = addView
        popV.showCenterViewInWindow(canTopBgv: true)
        
        addView.insertBlock = { [weak self] in
            popV.dismissView()
            self?.getDbModels()
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
        let model = users[indexPath.row]
        cell.nameLabel.text = model.name
        cell.uidLabel.text = "uid:\(model.uid)"
        cell.descLabel.text = model.introduce
        // Configure the cell...

        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = users[indexPath.row]
        
        let addView : InputView = Bundle.main.loadNibNamed("InputView", owner: nil, options: nil)?.first as! InputView
        addView.bounds = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 30, height: 250)
        addView.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
        let popV = PrPopView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        popV.contenView = addView
        popV.showCenterViewInWindow(canTopBgv: true)

        addView.uidLabel.text = model.uid
        addView.descTextFeild.text = model.introduce
        addView.nameTextFeild.text = model.name
        addView.identifier = model.identifier
        addView.insertBlock = { [weak self] in
            popV.dismissView()
            self?.getDbModels()
        }

    }
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            let model = users[indexPath.row]
            deleteListModel(uid: model.uid)
            users.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}
