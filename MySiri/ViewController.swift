//
//  ViewController.swift
//  MySiri
//
//  Created by Tristan Sarrazin on 01/12/2021.
//

import UIKit
import InstantSearchVoiceOverlay


// class qui permet l'affichage d'une saisie vocale ainsi que le texte qui en resulte
class ViewController: UIViewController {

//    let voiceOverlay = VoiceOverlayController()

    @IBOutlet var btnRecord: UIButton!
    @IBOutlet var btnChangeActivity: UIButton!
    @IBOutlet var tvText: UITextView!
    
    var text: String = ""
    private var titre: String!
    
    
    // Utilisation d'une API pour le voiceOverlay qui permet de faciliter l'utilisaton de la saisie vocale
    lazy var voiceOverlayController: VoiceOverlayController = {
      let  recordableHandler = {
        return SpeechController(locale: Locale(identifier: "fr_FR")) // Permet de dire a la saisie de comprendre le francais
      }
      return VoiceOverlayController(speechControllerHandler: recordableHandler)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // creation du bouton pour lancer l'enregistrement
        btnRecord.setTitleColor(.white, for: .normal)
    }

    @IBAction func onClickSpeakBtn() {
//        voiceOverlayController.settings.autoStart = false;
//        voiceOverlayController.settings.autoStop = false;
        
        // Affichage du texte de la saisie dans le textView ainsi que la console
        voiceOverlayController.start(on: self) { text, final, _ in
            if final {
                print("Final text: \(text)")
                self.tvText.text = text
                self.text = text
                
            } else {
                print("In progress: \(text)")
                self.tvText.text = text
                self.text = text
            }
        } errorHandler: { error in
            print("Une erreur est survenu")
    }

}
    
    // Si le message est vide alors utilisation de showAlertTitle pour dire qu'il n'y a pas de texte
    func showAlertTitle() {
        let alert = UIAlertController(title: "Attention!!", message: "Il n'y a pas de texte", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Accepter", style: .cancel, handler: { action in
            print("Error")
        
        }))
    
        
        present(alert, animated: true)
    }
    
    // Changement de vue pour aller sur listeDesTextsSauvergardes
    @IBAction func listeDesTextesSauvegardesController() {
        let story = UIStoryboard(name: "Main", bundle: nil)
        let newController = story.instantiateViewController(identifier: "listeDesTextesSauvegardesController")
        navigationController?.pushViewController(newController, animated: true)
    }
    
    
    // Envoie des inforamtions vers la class Note puis changement de vue
    @IBAction func enregistrerLesInformations() {
        self.titre = self.tvText.text
        if (titre == nil || titre == "") {
            showAlertTitle()
        } else {
            let storyForRegister = UIStoryboard(name: "Main", bundle: nil)
            let newController = storyForRegister.instantiateViewController(identifier: "enregistrementController") as Note?
            print(self.text)
            self.tvText.text = ""
            newController?.test = self.text
            navigationController?.pushViewController(newController!, animated: true)
        }
        
    }
}
