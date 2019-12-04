//
//  PerfilViewController.swift
//  ProyFinal
//
//  Created by Omar on 27/11/19.
//  Copyright © 2019 2020-1. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class PerfilViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var promedio: UILabel!
    @IBOutlet weak var materias: UILabel!
    @IBOutlet weak var tabla: UITableView!
    @IBOutlet weak var segmented: UISegmentedControl!
    @IBOutlet weak var horarioLabel: UILabel!
    @IBOutlet weak var foto: UIImageView!
    
    var tutores: [Tutor] = []
    var horarios: [Horario] = []
    var weekdays = ["Lunes": 0, "Martes": 1, "Miércoles": 2, "Jueves": 3, "Viernes": 4]
    
    var ref: DocumentReference!
    var getRef: Firestore!
    var userID = Auth.auth().currentUser!.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .init(patternImage: UIImage(named: "bk4")!)
        tabla.backgroundColor = .clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .white
        getRef = Firestore.firestore()
        getProfile(id: userID)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if horarios.isEmpty {
            return 0
        } else {
            return horarios[segmented.selectedSegmentIndex].horas.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath) as! HorasTableViewCell
        cell.hora.text = "\(horarios[segmented.selectedSegmentIndex].horas[indexPath.row]):00"
        cell.backgroundColor = .clear
        tableView.rowHeight = 50
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "materia" {
            let materiaView = segue.destination as! AgregarViewController
            materiaView.userID = userID
        }else{
            let materiaView = segue.destination as! AgregarHorarioViewController
            materiaView.userID = userID
        }
    }
    
    @IBAction func cambio(_ sender: UISegmentedControl) {
        tabla.reloadData()
    }
    
    
    func getHorario(uid: String){
        
        getRef.collection("horarios").addSnapshotListener{ (snapShot, error) in
            if error != nil || snapShot!.isEmpty {
                print(error!.localizedDescription)
                return
            } else {
                self.horarios.removeAll()
                self.segmented.removeAllSegments()
                for document in snapShot!.documents{
                    let values = document.data()
                    let id = values["userID"] as? String
                    let dia = values["dia"] as? String
                    let horas = values["horas"] as? [Int]
                    if id == self.userID && horas!.isEmpty == false{
                        self.horarios.append(Horario(dia: dia!, horas: horas!))
                    }
                }
               
                self.horarios.sort(by: { (self.weekdays[$0.dia] ?? 7) < (self.weekdays[$1.dia] ?? 7) })
                
            }
            if self.horarios.isEmpty{
                self.tabla.isHidden = true
                self.horarioLabel.text = "Agrega tu horario de asesorías"
            } else {
                self.horarioLabel.isHidden = false
                self.horarioLabel.text = "Horario:"
                self.tabla.isHidden = false
                self.segmented.isHidden = false
                for dia in self.horarios{
                    self.segmented.insertSegment(withTitle: dia.dia.capitalized, at: self.segmented.numberOfSegments, animated: true)
                }
                self.segmented.selectedSegmentIndex = 0
                self.tabla.reloadData()
            }
            
            
        }
        
    }
    
    
    
    func getProfile(id: String){
        
        getRef.collection("tutores").addSnapshotListener{ (snapShot, error) in
            if let error = error{
                print(error.localizedDescription)
                return
            } else {
            self.tutores.removeAll()
            for document in snapShot!.documents{
                if document.documentID == id {
                    let values = document.data()
                    let nombre = values["nombre"] as? String ?? "No hay nombre"
                    let promedio = values["promedio"] as? String ?? "No hay promedio"
                    let materias = values["materias"] as? [String] ?? []
                    let mail = values["correo"] as? String ?? "No hay correo"
                    let tutor = Tutor(userID: id, nombre: nombre, promedio: promedio, materias: materias, horario: [], correo: mail)
                   
                    self.tutores.append(tutor)
                    self.foto.image = UIImage(named: "userlogo")
                    self.nombre.text = tutor.nombre
                    self.promedio.text = "Promedio: \(tutor.promedio)"
                    self.materias.text = tutor.materias.joined(separator: ", ")
                    self.segmented.removeAllSegments()
                    
                    
                    if tutor.materias.isEmpty == true {
                        self.materias.text = "Agrega materias y tu horario de asesoria para empezar a ser tutor"
                        self.horarioLabel.isHidden = true
                        self.tabla.isHidden = true
                        self.segmented.isHidden = true
                    } else {
                        self.getHorario(uid: self.userID)
                        }
                    
                    
                    break
                }
                
                
            }
            }
        }
    }
    


}
