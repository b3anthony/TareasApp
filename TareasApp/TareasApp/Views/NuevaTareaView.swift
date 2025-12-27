//
//  NuevaTareaView.swift
//  TareasApp
//
//  Created by Anthony on 27/12/25.
//

import SwiftUI

struct NuevaTareaView: View {
    @ObservedObject var viewModel: TareasViewModel
    @Binding var selectedTab: Int
    
    @State private var titulo: String = ""
    @State private var descripcion: String = ""
    @State private var prioridad: String = "Media"
    @State private var mostrarAlerta = false
    
    let prioridades = ["Alta", "Media", "Baja"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("INFORMACIÓN BÁSICA")) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Título de la tarea")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        TextField("Ej: Completar informe mensual", text: $titulo)
                            .textFieldStyle(.roundedBorder)
                    }
                    .padding(.vertical, 5)
                }
                
                Section(header: Text("DETALLES")) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Descripción (opcional)")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        TextEditor(text: $descripcion)
                            .frame(minHeight: 100)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                    }
                    .padding(.vertical, 5)
                }
                
                Section(header: Text("PRIORIDAD")) {
                    Picker("Prioridad", selection: $prioridad) {
                        ForEach(prioridades, id: \.self) { prioridad in
                            HStack {
                                Circle()
                                    .fill(colorForPrioridad(prioridad))
                                    .frame(width: 10, height: 10)
                                Text(prioridad)
                            }
                            .tag(prioridad)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section {
                    Button(action: crearTarea) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .font(.title3)
                            Text("Crear Tarea")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(titulo.isEmpty ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .disabled(titulo.isEmpty)
                    .listRowBackground(Color.clear)
                }
            }
            .navigationTitle("Nueva Tarea")
            .navigationBarTitleDisplayMode(.large)
            .alert("Campo requerido", isPresented: $mostrarAlerta) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("El título de la tarea es obligatorio")
            }
        }
    }
    
    private func crearTarea() {
        guard !titulo.trimmingCharacters(in: .whitespaces).isEmpty else {
            mostrarAlerta = true
            return
        }
        
        viewModel.agregarTarea(
            titulo: titulo,
            descripcion: descripcion,
            prioridad: prioridad
        )
        
        // Limpiar formulario
        titulo = ""
        descripcion = ""
        prioridad = "Media"
        
        // Cambiar a la pestaña "Mis Tareas"
        selectedTab = 0
    }
    
    private func colorForPrioridad(_ prioridad: String) -> Color {
        switch prioridad {
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
}
