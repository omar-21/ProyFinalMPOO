


import UIKit
 import FirebaseFirestore

class TutoresViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
        
    var results: [Tutor] = []
    var materiaSelected: String!
    var ref: DocumentReference!
    var getRef: Firestore!
    
    @IBOutlet weak var tabla: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = materiaSelected
        
        view.backgroundColor = .init(patternImage: UIImage(named: "bk4")!)
        tabla.backgroundColor = .clear
        getRef = Firestore.firestore()
        tabla.isHidden = true
        getTutores(mat: materiaSelected)
        
        

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath) as! TutoresTableViewCell
        
        cell.foto.image = UIImage(named: "userlogo")        //Foto de cada tutor
        cell.nombre.text = results[indexPath.row].nombre
        cell.promedio.text = "Promedio: \(results[indexPath.row].promedio)"
        cell.backgroundColor = .clear
        tableView.rowHeight = 110
        return cell 
    }
    
    func getTutores(mat: String){
        getRef.collection("tutores").whereField("materias", arrayContains: mat).getDocuments { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                for document in snapshot!.documents {
                    let values = document.data()
                    let uID = values["userID"] as? String
                    let nombre = values["nombre"] as? String
                    let promedio = values["promedio"] as? String
                    let mats = values["materias"] as? [String]
                    let mail = values["email"] as? String
                    self.results.append(Tutor(userID: uID!, nombre: nombre!, promedio: promedio!, materias: mats!, horario: [], correo: mail!))
                }
            }
            if self.results.isEmpty{
                self.tabla.isHidden = true
                self.navigationController?.popViewController(animated: true)
                self.mostrarMensaje(mensaje: "No hay tutores para esta materia")
                
            } else{
                self.tabla.isHidden = false
                self.tabla.reloadData()
            }
            
        }
        
        
    }
    func mostrarMensaje(mensaje: String){
        let error = UIAlertController(title: mensaje, message: nil, preferredStyle: .alert)
        error.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(error, animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vistaTres = segue.destination as! TutorViewController
        let myIndexPath = tabla.indexPathForSelectedRow
        vistaTres.tutor = results[(myIndexPath?.row)!]
    }

}
