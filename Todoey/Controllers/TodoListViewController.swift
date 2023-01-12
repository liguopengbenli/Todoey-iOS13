

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    let todoListArrayKey = "TodoListArray"
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let newItem1 = Item()
        let newItem2 = Item()
        let newItem3 = Item()
        newItem1.title = "Find Mike"
        newItem2.title = "Find Nike"
        newItem3.title = "Find Pike"
        itemArray.append(newItem1)
        itemArray.append(newItem2)
        itemArray.append(newItem3)
        
        loaditems()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem){
        var textFiled = UITextField()
        let alert = UIAlertController(title: "Add new todo item", message: "", preferredStyle: .alert)
        alert.addTextField{(alertTextField) in
            alertTextField.placeholder = "create new item"
            textFiled = alertTextField
        }
        let action = UIAlertAction(title: "Add item", style: .default){
            (action) in
            let newItem = Item()
            newItem.title = textFiled.text!
            
            self.itemArray.append(newItem)
            //self.defaults.set(self.itemArray, forKey: self.todoListArrayKey)
            self.saveItems()
        }
       
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    func saveItems(){
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("error encoding item array")
        }
        
        self.tableView.reloadData()
    }
    
    func loaditems(){
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("error decode item")
            }
        }
    }
    
    
    
    
}




