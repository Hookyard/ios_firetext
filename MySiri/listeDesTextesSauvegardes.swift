//
//  listeDesTextesSauvegardes.swift
//  MySiri
//
//  Created by Tristan Sarrazin on 01/12/2021.
//


//UITableView pour afficher les notes depuis une base de donnée

import UIKit
import Foundation
import FirebaseFirestore

class listeDesTextesSauvegardes: UITableViewController {
    
    @IBOutlet var tvTitre: UITableView!
    private var liste = [String]()
    private var titreLabel: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var refreshControl: UIRefreshControl?
        
        tvTitre!.delegate = self
        tvTitre!.dataSource = self
        
        var testString: String?
        
        //        liste.append("enregistrement1")
        //        liste.append("enregistrement2")
        //liste.append("enregistrement3")
        
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // recuperation des id de la base de donnée les affichers
        let db = Firestore.firestore()
        db.collection("notes").getDocuments(){ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents:\(err)")
            } else{
                
                self.liste.removeAll()
                
                for document in querySnapshot!.documents{
                    print("\(document.documentID)")
                    self.liste.append("\(document.documentID)")
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                    
                    //                testString = document.documentID
                    //                self.liste.append(testString!)
                    //print("\(document.data())")
                    //print("\(document.data()["Text"] as! String)")
                    
                }
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return liste.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "celluleTest", for: indexPath)
        let titre = liste[indexPath.row]
        cell.textLabel?.text = titre
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        let story = UIStoryboard(name: "Main", bundle: nil)
        let newController = story.instantiateViewController(identifier: "showNoteController") as showNote
        newController.cellName = cell?.textLabel?.text
        navigationController?.pushViewController(newController, animated: true)
        
    }
    
    func addRefreshControl() {
        
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = UIColor.red
        refreshControl?.addTarget(self, action: #selector(refreshList), for: .valueChanged)
        tableView.addSubview(refreshControl!)
    }
    
    @objc func refreshList() {
        tableView.reloadData()
    }
} 

