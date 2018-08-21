//
//  ViewController.swift
//  CoreDataTutorials
//
//  Created by Juan Meza on 1/6/18.
//  Copyright © 2018 Tech-IN. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    //var names:  [String] = []
    //var year: [String] = []
    var people: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
       getData()
        
    }
    
    func getData() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "People")
        
        do {
            people = try managedContext.fetch(fetchRequest)
            tableView.reloadData()
            
        } catch {
            
            print(error.localizedDescription)
            
        }
    }

    @IBAction func addDetails(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add details", message: "Add new name and year", preferredStyle: .alert)
        
        alert.addTextField{ (textField) in
            textField.placeholder = "Type your name"
        }
        alert.addTextField{ (textField2) in
            textField2.placeholder = "Type your year"
        }
        
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
            
            guard let textfield = alert.textFields?.first, let textfield2 = alert.textFields?[1], let name = textfield.text, let year = textfield2.text else { return }
            
            self.save(name: name, year: year)
            //self.names.append(name)
            //self.year.append(year)
            self.tableView.reloadData()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alert.addAction(saveAction)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
    
    /*func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let person = people[indexPath.row]
        
        person.setValue("Hillary Clinton", forKey: "name")
        person.setValue("1942", forKey: "year")
        
        do {
            try person.managedObjectContext?.save()
            getData()
        } catch {
            
        }
        
    }*/
    
    //Delete
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let person = people[indexPath.row]
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        managedContext.delete(person)
        people.remove(at: indexPath.row)
        
        do {
            try managedContext.save()
            getData()
        } catch {
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //return names.count
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "dataCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) ?? UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        //let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let person = people[indexPath.row]
        let name = person.value(forKey: "name") as? String ?? ""
        let year = person.value(forKey: "year") as? String ?? ""
        
        cell.textLabel?.text = name
        cell.detailTextLabel?.text = year
        //cell.textLabel?.text = names[indexPath.row]
        //cell.detailTextLabel?.text = year[indexPath.row]
        
        
        return cell
    }
    
    func save(name: String, year: String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "People", in: managedContext)
        
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        person.setValue(name, forKey: "name")
        person.setValue(year, forKey: "year")
        
        do {
            try managedContext.save()
            people.append(person)
        } catch {
            print(error.localizedDescription)
        }
        
    }
}

