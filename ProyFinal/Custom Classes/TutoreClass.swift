

class Tutor{
    var userID: String
    var nombre: String
    //var valoracion: Int
    var promedio: String
    var materias: [String]
    //var foto: String
    var horario: [Horario]
    var correo: String
    
    init(userID: String, nombre: String, promedio: String, materias: [String], horario: [Horario],correo: String) {
        self.userID = userID
        self.nombre = nombre
        //self.valoracion = valoracion
        self.promedio = promedio
        self.materias = materias
        //self.foto = foto
        self.horario = horario
        self.correo = correo
    }
    
    func agregarMateria(mat: String, tutor: Tutor){
        tutor.materias.append(mat)
    }
    
    
}
