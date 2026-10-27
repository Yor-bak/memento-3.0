//
//  GalaxyService.swift
//  Memento_App
//
//  Created by Senior iOS Engineer on 15/10/2026.
//

import Foundation
import CoreGraphics
import SwiftUI

/// Contrato para el motor matemático del grafo cósmico y reglas de consolidación estelar de Memento.
public protocol GalaxyServiceProtocol: Sendable {
    /// Calcula la posición cartesiana (X, Y) para una nueva mini estrella siguiendo una distribución
    /// en espiral de Fermat (proporción áurea) para evitar solapamientos y lograr una constelación armónica.
    func calculateNewMiniStarPosition(existingNodesCount: Int, aroundParent: CGPoint?) -> CGPoint
    
    /// Evalúa la lista actual de nodos y ejecuta las reglas de consolidación:
    /// - Cada 10 mini estrellas huérfanas se agrupan bajo una `MediumStarNode`.
    /// - Cada 2 estrellas medianas huérfanas se consolidan bajo un `MoonNode`.
    /// - Returns: Una tupla con nuevos nodos a insertar y actualizaciones de parentNodeId.
    func evaluateConsolidationRules(existingNodes: [StarNode]) -> ConsolidationResult
    
    /// Genera los pares de conexión (líneas de constelación) entre nodos hijos y nodos padres.
    func buildConstellationConnections(nodes: [StarNode]) -> [ConstellationLink]
}

/// Resultado de la evaluación de consolidación estelar.
public struct ConsolidationResult: Sendable {
    public let newMediumStars: [StarNode]
    public let newMoons: [StarNode]
    public let updatedChildLinks: [(childId: UUID, parentId: UUID)]
}

/// Representa una conexión visual entre dos nodos en la galaxia.
public struct ConstellationLink: Identifiable, Sendable {
    public let id: String
    public let startPoint: CGPoint
    public let endPoint: CGPoint
    public let accentColor: Color
    public let linkType: StarNodeType
    
    public init(startPoint: CGPoint, endPoint: CGPoint, accentColor: Color, linkType: StarNodeType) {
        self.id = "\(startPoint.x),\(startPoint.y)->\(endPoint.x),\(endPoint.y)"
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.accentColor = accentColor
        self.linkType = linkType
    }
}

/// Implementación del servicio de matemáticas espaciales y reglas de consolidación.
public final class GalaxyService: GalaxyServiceProtocol {
    
    public init() {}
    
    // MARK: - Algoritmo de Posicionamiento (Fermat Spiral / Golden Ratio)
    /// Emplea el ángulo áureo (~137.5077°) para dispersar los nodos uniformemente sin patrones repetitivos o colisiones.
    public func calculateNewMiniStarPosition(existingNodesCount: Int, aroundParent: CGPoint? = nil) -> CGPoint {
        let goldenAngle = 137.5077640500378 * (Double.pi / 180.0)
        let index = Double(existingNodesCount + 1)
        
        if let parent = aroundParent {
            // Distribución orbital alrededor de una estrella mediana o luna padre
            let localRadius = 60.0 + (sqrt(index.truncatingRemainder(dividingBy: 10) + 1.0) * 35.0)
            let angle = index * goldenAngle
            let x = parent.x + (cos(angle) * localRadius)
            let y = parent.y + (sin(angle) * localRadius)
            return CGPoint(x: x, y: y)
        } else {
            // Distribución espiral amplia en el universo principal
            let spreadFactor = 75.0
            let radius = spreadFactor * sqrt(index)
            let angle = index * goldenAngle
            let x = cos(angle) * radius
            let y = sin(angle) * radius
            return CGPoint(x: x, y: y)
        }
    }
    
    // MARK: - Reglas de Consolidación
    public func evaluateConsolidationRules(existingNodes: [StarNode]) -> ConsolidationResult {
        var newMediumStars: [StarNode] = []
        var newMoons: [StarNode] = []
        var updatedChildLinks: [(childId: UUID, parentId: UUID)] = []
        
        // 1. Filtrar mini estrellas que aún no tienen nodo padre asignado
        let unlinkedMiniStars = existingNodes.filter { $0.starType == .mini && $0.parentNodeId == nil }
        
        // Agrupar en lotes de 10
        let miniBatchesCount = unlinkedMiniStars.count / 10
        for batchIndex in 0..<miniBatchesCount {
            let startIndex = batchIndex * 10
            let batch = Array(unlinkedMiniStars[startIndex..<(startIndex + 10)])
            
            // Calcular el baricentro (centro de masa) de las 10 estrellas para posicionar la estrella mediana
            let avgX = batch.reduce(0.0) { $0 + $1.positionX } / 10.0
            let avgY = batch.reduce(0.0) { $0 + $1.positionY } / 10.0
            let dominantCategory = batch.first?.category ?? QuestionCategory.autoconocimiento.rawValue
            
            let mediumStar = StarNode(
                date: Date(),
                category: dominantCategory,
                typeRaw: StarNodeType.medium.rawValue,
                positionX: avgX,
                positionY: avgY,
                contentSummary: "Constelación de 10 reflexiones consolidadas en \(dominantCategory)",
                parentNodeId: nil
            )
            newMediumStars.append(mediumStar)
            
            // Asignar el nuevo MediumStar como padre a los 10 nodos hijos
            for mini in batch {
                updatedChildLinks.append((childId: mini.id, parentId: mediumStar.id))
            }
        }
        
        // 2. Filtrar estrellas medianas sin padre (incluyendo las recién creadas)
        let allMediumStars = (existingNodes.filter { $0.starType == .medium && $0.parentNodeId == nil } + newMediumStars)
        let mediumBatchesCount = allMediumStars.count / 2
        
        for batchIndex in 0..<mediumBatchesCount {
            let startIndex = batchIndex * 2
            let batch = Array(allMediumStars[startIndex..<(startIndex + 2)])
            
            let avgX = batch.reduce(0.0) { $0 + $1.positionX } / 2.0
            let avgY = batch.reduce(0.0) { $0 + $1.positionY } / 2.0
            let category = batch.first?.category ?? QuestionCategory.autoconocimiento.rawValue
            
            let moon = StarNode(
                date: Date(),
                category: category,
                typeRaw: StarNodeType.moon.rawValue,
                positionX: avgX,
                positionY: avgY,
                contentSummary: "Luna de Consciencia: Convergencia de 2 constelaciones mayores",
                parentNodeId: nil
            )
            newMoons.append(moon)
            
            // Vincular las 2 estrellas medianas a la luna
            for medium in batch {
                updatedChildLinks.append((childId: medium.id, parentId: moon.id))
            }
        }
        
        return ConsolidationResult(
            newMediumStars: newMediumStars,
            newMoons: newMoons,
            updatedChildLinks: updatedChildLinks
        )
    }
    
    // MARK: - Enlaces de Constelación
    public func buildConstellationConnections(nodes: [StarNode]) -> [ConstellationLink] {
        var links: [ConstellationLink] = []
        let nodeDict = Dictionary(uniqueKeysWithValues: nodes.map { ($0.id, $0) })
        
        for node in nodes {
            guard let parentId = node.parentNodeId, let parentNode = nodeDict[parentId] else {
                continue
            }
            
            links.append(
                ConstellationLink(
                    startPoint: node.point,
                    endPoint: parentNode.point,
                    accentColor: node.accentColor,
                    linkType: node.starType
                )
            )
        }
        
        return links
    }
}
