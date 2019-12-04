//
//  TutorViewController.swift
//  ProyFinal
//
//  Created by Omar on 25/11/19.
//  Copyright © 2019 2020-1. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class TutorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var ref: DocumentReference!
    var getRef: Firestore!
    var tutor: Tutor!
    var horarios: [Horario] = []
    var weekdays = ["Lunes": 0, "Martes": 1, "Miércoles": 2, "Jueves": 3, "Viernes": 4]
    
    @IBOutlet weak var promedio: UILabel!
    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var foto: UIImageView!
    @IBOutlet weak var dias: UISegmentedControl!
    @IBOutlet weak var tabla: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .init(patternImage: UIImage(named: "bk4")!)
        getRef = Firestore.firestore()
        getHorario(uid: tutor.userID)
        dias.removeAllSegments()
        tabla.backgroundColor = .clear
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if horarios.isEmpty {
            return 0
        } else {
        return tutor.horario[dias.selectedSegmentIndex].horas.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath) as! HorasTableViewCell
        cell.hora.text = "\(tutor.horario[dias.selectedSegmentIndex].horas[indexPath.row]):00"
        cell.backgroundColor = .clear
        tableView.rowHeight = 50
        return cell
        
    }
    

    @IBAction func cambio(_ sender: UISegmentedControl) {
        self.tabla.reloadData()
        
    }
    
    func getHorario(uid: String){
        
        getRef.collection("horarios").addSnapshotListener{ (snapShot, error) in
            if error != nil || snapShot!.isEmpty {
                print(error!.localizedDescription)
                return
            } else {
                self.horarios.removeAll()
                self.dias.removeAllSegments()
                for document in snapShot!.documents{
                    let values = document.data()
                    let id = values["userID"] as? String
                    let dia = values["dia"] as? String
                    let horas = values["horas"] as? [Int]
                    if id == uid {
                        self.horarios.append(Horario(dia: dia!, horas: horas!))
                    }
                }
                self.horarios.sort(by: { (self.weekdays[$0.dia] ?? 7) < (self.weekdays[$1.dia] ?? 7) })
                
            }
            self.tutor.horario = self.horarios
            self.tabla.isHidden = false
            self.dias.isHidden = false
            self.foto.image = UIImage(named: "userlogo")
            self.nombre.text = self.tutor.nombre
            self.promedio.text = "Promedio: \(self.tutor.promedio)"
            for dia in self.horarios{
                self.dias.insertSegment(withTitle: dia.dia.capitalized, at: self.dias.numberOfSegments, animated: true)
            }
            self.dias.selectedSegmentIndex = 0
            self.tabla.reloadData()
            
        }
    }
    
    @IBAction func contact(_ sender: UIButton) {
        
        mostrarMensaje(mensaje: "Correo de tutor: \(tutor.correo)")
    }
    
    func mostrarMensaje(mensaje: String){
        let error = UIAlertController(title: mensaje, message: nil, preferredStyle: .alert)
        error.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(error, animated: true, completion: nil)
    }

}
