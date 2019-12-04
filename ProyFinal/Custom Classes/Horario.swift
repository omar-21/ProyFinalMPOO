//
//  Horario.swift
//  ProyFinal
//
//  Created by Omar on 25/11/19.
//  Copyright © 2019 2020-1. All rights reserved.
//

class Horario{
    var dia: String
    var horas: [Int]
    
    init(dia: String, horas: [Int]) {
        self.dia = dia
        self.horas = horas
    }
    
    func numeroHoras(horario: Horario) -> Int {
        return horario.horas.count
    }
}
