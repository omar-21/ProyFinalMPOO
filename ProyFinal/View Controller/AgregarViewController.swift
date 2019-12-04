//
//  AgregarViewController.swift
//  ProyFinal
//
//  Created by Omar on 25/11/19.
//  Copyright © 2019 2020-1. All rights reserved.
//

import UIKit
import FirebaseFirestore

class AgregarViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var ref: DocumentReference!
    var getRef: Firestore!
    var userID: String!
    
    @IBOutlet weak var agregar: UIButton!
    @IBOutlet weak var picker: UIPickerView!
    var materiasArray: [String] = ["Álgebra","Álgebra Lineal","Cálculo I","Cálculo II","Cálculo III", "Química", "Ecuaciones Diferenciales", "Swift"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .init(patternImage: UIImage(named: "bk4")!)
        
        getRef = Firestore.firestore()
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return materiasArray.count
    }
    
   
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: materiasArray[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    
    @IBAction func eliminar(_ sender: UIButton) {
        let materia = materiasArray[picker.selectedRow(inComponent: 0)]
        self.getRef.collection("tutores").document(userID).getDocument { (document, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            let tutor = document?.data()
            let mats = tutor!["materias"] as? [String]
            if mats!.contains(self.materiasArray[self.picker.selectedRow(inComponent: 0)]) {
                self.getRef.collection("tutores").document(self.userID).updateData(["materias" : FieldValue.arrayRemove([materia])]) { (error) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    self.mostrarMensaje(mensaje: "Eliminaste \(materia) de tus materias")
                }
            } else {
                self.mostrarMensaje(mensaje: "No tienes \(materia) registrada")
                
            }
            
            
        }
    }
    
    
    @IBAction func agregar(_ sender: UIButton) {
        let materia = materiasArray[picker.selectedRow(inComponent: 0)]
        self.getRef.collection("tutores").document(userID).updateData(["materias" : FieldValue.arrayUnion([materia])]) { (error) in
            if let error = error {
                print(error.localizedDescription)
                
            }
            self.mostrarMensaje(mensaje: "Agregaste \(materia) a tus materias")
        }
        
        
        
    }
    
    func mostrarMensaje(mensaje: String){
        let error = UIAlertController(title: mensaje, message: nil, preferredStyle: .alert)
        error.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(error, animated: true, completion: nil)
    }
    
    

}
