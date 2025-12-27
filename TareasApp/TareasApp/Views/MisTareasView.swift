//
//  MisTareasView.swift
//  TareasApp
//
//  Created by Anthony on 27/12/25.
//

import SwiftUI

struct MisTareasView: View {
    @ObservedObject var viewModel: TareasViewModel
    @Binding var selectedTab: Int
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.tareas.isEmpty {
                    // Estado vacío
                    VStack(spacing: 20) {
                        ZStack {
                            Circle()
                                .fill(Color.blue.opacity(0.1))
                                .frame(width: 120, height: 120)
                            
                            Image(systemName: "checklist")
                                .font(.system(size: 50))
                                .foregroundColor(.blue)
                        }
                        
                        Text("No hay tareas")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("Crea tu primera tarea para comenzar")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                } else {
                    // Lista de tareas
                    List {
                        ForEach(viewModel.tareas) { tarea in
                            TareaCardView(tarea: tarea, viewModel: viewModel)
                        }
                        .onDelete(perform: deleteTareas)
                    }
                    .listStyle(.plain)
                }
                
                // Botón flotante
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            selectedTab = 1
                        }) {
                            Image(systemName: "plus")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(width: 60, height: 60)
                                .background(Color.blue)
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 5)
                        }
                        .padding(.trailing, 25)
                        .padding(.bottom, 25)
                    }
                }
            }
            .navigationTitle("Mis Tareas")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private func deleteTareas(at offsets: IndexSet) {
        offsets.forEach { index in
            let tarea = viewModel.tareas[index]
            viewModel.eliminarTarea(tarea: tarea)
        }
    }
}

struct TareaCardView: View {
    let tarea: Tarea
    @ObservedObject var viewModel: TareasViewModel
    
    var prioridadColor: Color {
        switch tarea.prioridad {
        case "Alta":
            return .red
        case "Media":
            return .orange
        case "Baja":
            return .green
        default:
            return .gray
        }
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            // Checkbox
            Button(action: {
                viewModel.toggleCompletada(tarea: tarea)
            }) {
                Image(systemName: tarea.completada ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(tarea.completada ? .green : .gray)
            }
            .buttonStyle(.plain)
            
            VStack(alignment: .leading, spacing: 8) {
                // Título
                Text(tarea.titulo)
                    .font(.headline)
                    .strikethrough(tarea.completada)
                    .foregroundColor(tarea.completada ? .secondary : .primary)
                
                // Descripción
                if !tarea.descripcion.isEmpty {
                    Text(tarea.descripcion)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                // Prioridad y fecha
                HStack(spacing: 10) {
                    // Badge de prioridad
                    HStack(spacing: 4) {
                        Circle()
                            .fill(prioridadColor)
                            .frame(width: 8, height: 8)
                        Text(tarea.prioridad)
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(prioridadColor.opacity(0.1))
                    .cornerRadius(12)
                    
                    // Estado
                    Text(tarea.completada ? "Completada" : "Pendiente")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    // Fecha
                    Text(tarea.fechaCreacion, style: .date)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 8)
    }
}
