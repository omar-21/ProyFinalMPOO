//
//  ViewController.swift
//  ProyFinal
//
//  Created by 2020-1 on 10/7/19.
//  Copyright © 2019 2020-1. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tabla: UITableView!
    
    var materias: [String] = ["Álgebra","Álgebra Lineal","Cálculo I","Cálculo II","Cálculo III", "Química", "Ecuaciones Diferenciales", "Swift"]
    var materiasImg: [String] = ["algebra","alglin","derivada","integral","vectorial","quimica","ed","swift"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .init(patternImage: UIImage(named: "bk4")!)
        tabla.backgroundColor = .clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .white
        
        
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return materias.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath) as! MateriasTableViewCell
        cell.imagenMat.image = UIImage(named: materiasImg[indexPath.row])
        cell.imagenMat.layer.cornerRadius = 10
        cell.materia.text = materias[indexPath.row]
        cell.backgroundColor = .clear
        tableView.rowHeight = 100
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vistaDos = segue.destination as! TutoresViewController
        let myIndexPath = tabla.indexPathForSelectedRow
        vistaDos.materiaSelected = materias[(myIndexPath?.row)!]
        
    }
}

