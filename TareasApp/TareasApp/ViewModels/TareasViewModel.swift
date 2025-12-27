//
//  TareasViewModel.swift
//  TareasApp
//
//  Created by Anthony on 27/12/25.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

class TareasViewModel: ObservableObject {
    @Published var tareas: [Tarea] = []
    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    init() {
        fetchTareas()
    }
    
    deinit {
        listener?.remove()
    }
    
    // Obtener tareas en tiempo real
    func fetchTareas() {
        listener = db.collection("tareas")
            .order(by: "fechaCreacion", descending: true)
            .addSnapshotListener { [weak self] querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error al obtener tareas: \(error?.localizedDescription ?? "Error desconocido")")
                    return
                }
                
                self?.tareas = documents.compactMap { document -> Tarea? in
                    try? document.data(as: Tarea.self)
                }
            }
    }
    
    // Crear nueva tarea
    func agregarTarea(titulo: String, descripcion: String, prioridad: String) {
        let nuevaTarea = Tarea(
            titulo: titulo,
            descripcion: descripcion,
            prioridad: prioridad,
            completada: false,
            fechaCreacion: Date()
        )
        
        do {
            _ = try db.collection("tareas").addDocument(from: nuevaTarea)
        } catch {
            print("Error al agregar tarea: \(error.localizedDescription)")
        }
    }
    
    // Marcar tarea como completada/pendiente
    func toggleCompletada(tarea: Tarea) {
        guard let id = tarea.id else { return }
        
        db.collection("tareas").document(id).updateData([
            "completada": !tarea.completada
        ]) { error in
            if let error = error {
                print("Error al actualizar tarea: \(error.localizedDescription)")
            }
        }
    }
    
    // Eliminar tarea
    func eliminarTarea(tarea: Tarea) {
        guard let id = tarea.id else { return }
        
        db.collection("tareas").document(id).delete { error in
            if let error = error {
                print("Error al eliminar tarea: \(error.localizedDescription)")
            }
        }
    }
}
