//
//  RegistroViewController.swift
//  ProyFinal
//
//  Created by Omar on 27/11/19.
//  Copyright © 2019 2020-1. All rights reserved.
//


import UIKit
import Firebase
import FirebaseFirestore

class RegistroViewController: UIViewController{
    var finID: String = ""
    
    @IBOutlet weak var crearButton: UIButton!
    @IBOutlet weak var emailUser: UITextField!
    @IBOutlet weak var passwordUser: UITextField!
    @IBOutlet weak var nombreUsuario: UITextField!
    @IBOutlet weak var promedioUsuario: UITextField!
    
    var ref: DocumentReference!
    var getRef: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupHideKeyboardOnTap()
        view.backgroundColor = .init(patternImage: UIImage(named: "bk4")!)
        
        getRef = Firestore.firestore()
    
    }
    
    @IBAction func crearUsuario(_ sender: UIButton) {
        
        let error = verificar()
        
        if error != nil{
            mostrarMensaje(mensaje: error!)
        } else {
            
            guard let email = emailUser.text, email != "", let password = passwordUser.text, password != "" else{
                return
            }
            
            
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                if let error = error{
                    print(error.localizedDescription)
                    self.mostrarMensaje(mensaje: error.localizedDescription)
                    return
                }
                print("Usuario creado")

                
                let userID = Auth.auth().currentUser?.uid
                let datos: [String: Any] = ["userID": userID!,"email": (user?.user.email!)!,"nombre": self.nombreUsuario.text!, "promedio": self.promedioUsuario.text!, "materias": []]
                
                self.getRef.collection("tutores").document(userID!).setData(datos, completion: { (error) in
                    if let error = error{
                        print(error.localizedDescription)
                        return
                    }
                    self.performSegue(withIdentifier: "registrar", sender: self)
                })
                
            }
            
            
        }
       
    }
    
    
    func verificar() -> String? {
        if emailUser.text == "" || passwordUser.text == "" || nombreUsuario.text == "" || promedioUsuario.text == "" {
         return "No dejes espacios vacios"
        }
        
        if passwordUser.text!.count < 8{
            return "Tu contraseña debe tener 8 carcteres mínimo"
        }
        
        return nil
    }
    
    func mostrarMensaje(mensaje: String){
        let error = UIAlertController(title: mensaje, message: nil, preferredStyle: .alert)
        error.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(error, animated: true, completion: nil)
    }
    
    @IBAction func atras(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
