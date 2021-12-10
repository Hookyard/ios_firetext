//
//  Note.swift
//  MySiri
//
//  Created by Tristan Sarrazin on 01/12/2021.
//

import Foundation
import UIKit
import FirebaseFirestore


//classe permettant d'enregistrer les notes dans la base de donnée
class Note: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var tfTitre: UITextField!
    @IBOutlet var tvText: UITextView!
    @IBOutlet var btnSave: UIButton!
   
    private var titre: String!
    private var text: String!

    public var test: String! // variable qui est recuperé depuis le viewController c'est le texte qui etait contenu dans le ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfTitre.delegate = self
        
        print(test)
//        let db = Firestore.firestore()
//        db.collection("notes").document("test").setData(["Text" : test])
        self.tvText.text = test // on remplace le text par le text du ViewController
    }
    
    //recuperer le texte et le titre du textview et du textfield et afficher des alerts
    @IBAction func envoyer(){
        self.text = self.tvText.text
        self.titre = self.tfTitre.text
        if (titre == nil || titre == "") {
            showAlertTitle() // Si le titre est vide alors une alert est afficher pour dire a l'utilisateur qu'il ne doit pas etre vide
        } else {
            showAlertValider() // Si le titre n'est pas vide cela affiche une alert pour confirmer la validation
        }
//        print("le texte est \(text)")
//        print("le titre est \(titre)")       
    }
    
    func showAlert() { // affiche une alert pour dire que la note a bien etait enregistré
        let alert = UIAlertController(title: "Enregistrement", message: "Vous avez bien enregistré: \(text)", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Accepter", style: .cancel, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        
        present(alert, animated: true)
    }
    
    func showAlertTitle() { // Alert qui indique que le titre ne doit pasetre vide
        let alert = UIAlertController(title: "Attention!!", message: "Le titre ne doit pas etre vide", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Accepter", style: .cancel, handler: { action in
            print("Error")
        
        }))
    
        
        present(alert, animated: true)
    }
    
    func showAlertValider() { // alert pour indiquer quele choix est irreversible avec une option valider ou refuser
        let alert = UIAlertController(title: "Attention!!", message: "Vous ne pourrez pas modifier votre fichier après l'avoir validé", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Accepter", style: .cancel, handler: { action in
            self.saveData(text: self.text, titre: self.titre)
            self.showAlert()
        }))
        alert.addAction(UIAlertAction(title: "Refuser", style: .destructive, handler: { action in
            print("cancel")
        }))
        present(alert, animated: true)
    }
    
    
    func saveData(text: String,titre: String){
        let db = Firestore.firestore() // reference a la base de donnée
        db.collection("notes").document(titre).setData(["Text" : text]) // on va enregistrer dans la base de donnée un nouveau document avec un id titre et un attribut texte
    }
    
    @IBOutlet var textField: UITextField!
    
    
    // Le titre doit avoir un maximum 30 charactere
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       
        print(self.test)
        
        let currentText = textField.text ?? ""

        guard let stringRange = Range(range, in: currentText) else { return false }

        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        return updatedText.count <= 30
    }
}

