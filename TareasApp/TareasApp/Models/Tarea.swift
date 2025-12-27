//
//  Tarea.swift
//  TareasApp
//
//  Created by Anthony on 27/12/25.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Tarea: Identifiable, Codable {
    @DocumentID var id: String?
    var titulo: String
    var descripcion: String
    var prioridad: String // "Alta", "Media", "Baja"
    var completada: Bool
    var fechaCreacion: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case titulo
        case descripcion
        case prioridad
        case completada
        case fechaCreacion
    }
}

enum Prioridad: String, CaseIterable {
    case alta = "Alta"
    case media = "Media"
    case baja = "Baja"
    
    var color: String {
        switch self {
        case .alta:
            return "red"
        case .media:
            return "orange"
        case .baja:
            return "green"
        }
    }
}
