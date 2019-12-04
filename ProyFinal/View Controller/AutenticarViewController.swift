//
//  AutenticarViewController.swift
//  ProyFinal
//
//  Created by Omar on 27/11/19.
//  Copyright © 2019 2020-1. All rights reserved.
//

import UIKit
import Firebase

class AutenticarViewController: UIViewController {
    @IBOutlet weak var emailUser: UITextField!
    @IBOutlet weak var passwordUser: UITextField!
    @IBOutlet weak var ingresarBoton: UIButton!
    @IBOutlet weak var crearBoton: UIButton!
    @IBOutlet weak var icono: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupHideKeyboardOnTap()
        view.backgroundColor = .init(patternImage: UIImage(named: "bk4")!)
        icono.image = UIImage(named: "appic")
        icono.layer.cornerRadius = 10
        ingresarBoton.layer.cornerRadius = 10
        crearBoton.layer.cornerRadius = 10
        
        
        
    }
    
    
    @IBAction func autUsuario(_ sender: UIButton) {
        let error = verificar()
        if error != nil{
            mostrarMensaje(mensaje: error!)
        } else {
            guard let email = emailUser.text, email != "", let password = passwordUser.text, password != "" else{
                return 
            }
        
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if let error = error{
                    print(error.localizedDescription)
                    self.mostrarMensaje(mensaje: error.localizedDescription)
                    return
                } else {
                    print("Usuario autenticado")
                    self.performSegue(withIdentifier: "autenticar", sender: self)
                }
            
            }
    
        }
    }
    
    func verificar() -> String? {
        if emailUser.text == "" || passwordUser.text == "" {
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
    
    
}
extension UIViewController {
    func setupHideKeyboardOnTap() {
        self.view.addGestureRecognizer(self.endEditingRecognizer())
        self.navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer())
    }
    
    private func endEditingRecognizer() -> UIGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        tap.cancelsTouchesInView = false
        return tap
    }
}
