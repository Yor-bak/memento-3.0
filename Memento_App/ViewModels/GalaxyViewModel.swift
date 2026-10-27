//
//  GalaxyViewModel.swift
//  Memento_App
//
//  Created by Senior iOS Engineer on 15/10/2026.
//

import SwiftUI
import SwiftData

/// ViewModel principal para `GalaxyHomeView`.
/// Administra la sincronización del grafo estelar desde SwiftData, el cálculo de constelaciones
/// y el estado de inspección del nodo seleccionado por el usuario.
@Observable
public final class GalaxyViewModel {
    
    // Servicios
    private let galaxyService: GalaxyServiceProtocol
    
    // Estado de la galaxia
    public var selectedNode: StarNode? = nil
    public var isDetailSheetPresented: Bool = false
    public var links: [ConstellationLink] = []
    
    public init(galaxyService: GalaxyServiceProtocol = GalaxyService()) {
        self.galaxyService = galaxyService
    }
    
    // MARK: - Actualización de Constelaciones
    @MainActor
    public func refreshConstellations(from nodes: [StarNode]) {
        self.links = galaxyService.buildConstellationConnections(nodes: nodes)
    }
    
    // MARK: - Selección e Inspección de Nodos
    public func selectNode(_ node: StarNode) {
        selectedNode = node
        isDetailSheetPresented = true
    }
    
    public func dismissDetailSheet() {
        isDetailSheetPresented = false
        selectedNode = nil
    }
    
    // MARK: - Semilla de Prueba para el Prototipo
    /// En caso de que el universo esté vacío en la primera ejecución de prueba,
    /// genera una constelación de ejemplo armónica para que el revisor experimente el grafo de inmediato.
    @MainActor
    public func seedInitialUniverseIfNeeded(modelContext: ModelContext) {
        let descriptor = FetchDescriptor<StarNode>()
        let count = (try? modelContext.fetchCount(descriptor)) ?? 0
        guard count == 0 else { return }
        
        let categories: [QuestionCategory] = [.autoconocimiento, .amor, .amigos, .familia, .proposito]
        
        // Crear 1 Luna central
        let moon = StarNode(
            date: Date().addingTimeInterval(-86400 * 15),
            category: QuestionCategory.autoconocimiento.rawValue,
            typeRaw: StarNodeType.moon.rawValue,
            positionX: 0,
            positionY: 0,
            contentSummary: "Luna de Consciencia: Origen del viaje interior de Memento",
            parentNodeId: nil
        )
        modelContext.insert(moon)
        
        // Crear 2 Estrellas Medianas orbitales
        let medium1 = StarNode(
            date: Date().addingTimeInterval(-86400 * 8),
            category: QuestionCategory.amor.rawValue,
            typeRaw: StarNodeType.medium.rawValue,
            positionX: -140,
            positionY: -80,
            contentSummary: "Constelación de Amor y Vulnerabilidad",
            parentNodeId: moon.id
        )
        let medium2 = StarNode(
            date: Date().addingTimeInterval(-86400 * 4),
            category: QuestionCategory.amigos.rawValue,
            typeRaw: StarNodeType.medium.rawValue,
            positionX: 130,
            positionY: 90,
            contentSummary: "Constelación de Amistad y Pertenencia",
            parentNodeId: moon.id
        )
        modelContext.insert(medium1)
        modelContext.insert(medium2)
        
        // Crear varias Mini Estrellas conectadas
        for i in 1...6 {
            let cat = categories[i % categories.count]
            let parent = (i % 2 == 0) ? medium1 : medium2
            let angle = Double(i) * 1.05
            let radius = 60.0 + Double(i * 12)
            let mini = StarNode(
                date: Date().addingTimeInterval(-Double(86400 * (8 - i))),
                category: cat.rawValue,
                typeRaw: StarNodeType.mini.rawValue,
                positionX: parent.positionX + (cos(angle) * radius),
                positionY: parent.positionY + (sin(angle) * radius),
                contentSummary: "Reflexión del día: Aprendiendo a habitar la quietud con sinceridad.",
                parentNodeId: parent.id
            )
            modelContext.insert(mini)
        }
    }
}
