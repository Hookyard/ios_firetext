//
//  showNote.swift
//  MySiri
//
//  Created by Tristan Sarrazin on 02/12/2021.
//

import Foundation
import UIKit
import FirebaseFirestore


//view qui permet d'afficher les notes avec leurs titre et le texte qui leurs est dediés
class showNote: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var lbTitre: UILabel!
    @IBOutlet var tvText: UITextView!
    @IBOutlet var btnSuppr: UIButton!
    
   
    private var titre: String!
    private var text: String!

    public var test: String!
    public var cellName: String!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        test = db.collection("notes").document(cellName).documentID
        
        self.lbTitre.text = cellName
        db.collection("notes").document(cellName).getDocument{
            snapshot, error in guard let data = snapshot?.data(), error == nil else {
                return
            }
        self.tvText.text = data["Text"] as! String
        }
    }
    
    //Appel la fonction howAlertValider pour signaler a l'utilisateur que c'est une action irreversible
    @IBAction func supprimer(){
        self.text = self.tvText.text
        self.titre = self.lbTitre.text
        
        showAlertValider()

    }
    
    //notification de confirmation
    func showAlert() {
        let alert = UIAlertController(title: "Reussi", message: "Vous avez bien supprimé: \(text)", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Accepter", style: .cancel, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        
        present(alert, animated: true)
    }
    
    //notifiaction pour etre sur de vouloir supprimer les notes
    func showAlertValider() {
        let alert = UIAlertController(title: "Attention!!", message: "Vous ne pourrez pas recuperer votre fichier après l'avoir supprimé", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Accepter", style: .cancel, handler: { action in
            self.deleteData(titre: self.titre)
            self.db.collection("notes").document(self.cellName).delete()
            self.showAlert()
        }))
        alert.addAction(UIAlertAction(title: "Refuser", style: .destructive, handler: { action in
            print("cancel")
        }))
        present(alert, animated: true)
    }
    
    //fonction qui permet de suprimer les notes de la base de donnée
    func deleteData(titre: String){
        let db = Firestore.firestore()
        db.collection("notes").document(titre).delete()
    }
    

}


