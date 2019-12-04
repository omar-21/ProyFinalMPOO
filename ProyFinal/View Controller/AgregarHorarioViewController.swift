//
//  AgregarHorarioViewController.swift
//  ProyFinal
//
//  Created by Omar on 27/11/19.
//  Copyright © 2019 2020-1. All rights reserved.
//

import UIKit
import FirebaseFirestore

class AgregarHorarioViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var userID: String!
    var ref: DocumentReference!
    var getRef: Firestore!
    
    var horas = [7,8,9,10,11,12,13,14,15,16,17,18,19,20]
    var nomDias = ["Lunes","Martes","Miércoles","Jueves","Viernes"]
    @IBOutlet weak var dias: UISegmentedControl!
    @IBOutlet weak var picker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .init(patternImage: UIImage(named: "bk4")!)
        getRef = Firestore.firestore()
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return horas.count
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: "\(horas[row]):00", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
   
    func mostrarMensaje(mensaje: String){
        let error = UIAlertController(title: mensaje, message: nil, preferredStyle: .alert)
        error.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(error, animated: true, completion: nil)
    }
    
    @IBAction func eliminar(_ sender: UIButton) {
      
        self.getRef.collection("horarios").whereField("userID", isEqualTo: userID!).getDocuments { (snapshot, error) in
            if error != nil || snapshot?.isEmpty == true {
                self.mostrarMensaje(mensaje: "No tienes ninguna materia registrada")
            } else{
                var n = 0
                for document in snapshot!.documents {
                    //let id = document.documentID
                    let values = document.data()
                    //let usID = values["userID"] as? String
                    let dia = values["dia"] as? String
                    let hrs = values["horas"] as? [Int]
                    let selectedDia = self.nomDias[self.dias.selectedSegmentIndex]
                    let selectedHora = self.horas[self.picker.selectedRow(inComponent: 0)]
                    
                    if selectedDia == dia && (hrs?.contains(selectedHora))! {
                        self.getRef.collection("horarios").document("\(self.userID!)_\(dia!)").updateData(["horas" : FieldValue.arrayRemove([selectedHora])], completion: { (error) in
                            if let error = error {
                                print(error.localizedDescription)
                                return
                            }
                        })
                        
                        self.mostrarMensaje(mensaje: "Eliminaste las \(selectedHora) del día \(selectedDia)")
                        break
                    }
                    n += 1
                }
                if n == snapshot?.documents.count {
                    self.mostrarMensaje(mensaje: "No se encuentra el horario seleccionado")
                }
            }
        }
    }
    
    
    @IBAction func agregar(_ sender: UIButton) {
        print("wow")

        let data1: [String: Any] = ["userID": userID!, "dia": nomDias[dias.selectedSegmentIndex] ,"horas": [horas[picker.selectedRow(inComponent: 0)]]]
        
        
        self.getRef.collection("horarios").whereField("userID", isEqualTo: userID!).getDocuments { (snapshot, error) in
            if error != nil || snapshot?.isEmpty == true {
                self.getRef.collection("horarios").document("\(self.userID!)_\(self.nomDias[self.dias.selectedSegmentIndex])").setData(data1, completion: { (error) in
                    if let error = error{
                        print(error.localizedDescription)
                        return
                    }
                    self.mostrarMensaje(mensaje: "Agregaste las \(self.horas[self.picker.selectedRow(inComponent: 0)]) el día \(self.nomDias[self.dias.selectedSegmentIndex])")
                })
            } else{
                var n = 0
                for document in snapshot!.documents{
                    
                    let id = document.documentID
                    let values = document.data()
                    //let usID = values["userID"] as? String
                    let dia = values["dia"] as? String
                    var hrs = values["horas"] as? [Int]
                    
                    if dia == self.nomDias[self.dias.selectedSegmentIndex] {
                        hrs?.append(self.horas[self.picker.selectedRow(inComponent: 0)])
                        hrs?.sort()
                        self.getRef.collection("horarios").document(id).updateData(["horas" : hrs!], completion: { (error) in
                            if let error = error {
                                print(error.localizedDescription)
                            }
                        })
                        self.mostrarMensaje(mensaje: "Agregaste las \(self.horas[self.picker.selectedRow(inComponent: 0)]) el día \(dia!)")
                        break
                    }
                    n += 1
                }
                if n == snapshot?.documents.count {
                    self.getRef.collection("horarios").document("\(self.userID!)_\(self.nomDias[self.dias.selectedSegmentIndex])").setData(data1, completion: { (error) in
                        if let error = error{
                            print(error.localizedDescription)
                        }
                    })
                    let day = data1["dia"]! as? String
                    self.mostrarMensaje(mensaje: "Agregaste las \(self.horas[self.picker.selectedRow(inComponent: 0)]) hrs el día \(day!.lowercased())")
                }
            }
        }
        
    }
    

}
