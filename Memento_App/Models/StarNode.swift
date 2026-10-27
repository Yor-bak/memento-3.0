//
//  StarNode.swift
//  Memento_App
//
//  Created by Senior iOS Engineer on 15/10/2026.
//

import Foundation
import SwiftData
import SwiftUI

/// Modelo persistente que representa un cuerpo celeste en el grafo galáctico (estrella pequeña, mediana o luna).
@Model
public final class StarNode {
    /// Identificador único del nodo en el universo.
    @Attribute(.unique) public var id: UUID
    
    /// Fecha de consolidación o creación de la estrella.
    public var date: Date
    
    /// Categoría temática principal asociada al nodo.
    public var category: String
    
    /// Representación en cadena del tipo de nodo (`mini`, `medium`, `moon`).
    public var typeRaw: String
    
    /// Coordenada horizontal (X) relativa en el lienzo infinito de la galaxia.
    public var positionX: Double
    
    /// Coordenada vertical (Y) relativa en el lienzo infinito de la galaxia.
    public var positionY: Double
    
    /// Resumen conciso o frase introspectiva generada por el LLM o extraída de las respuestas.
    public var contentSummary: String
    
    /// Identificador del nodo padre en caso de estar agrupado o conectado en una constelación jerárquica.
    public var parentNodeId: UUID?
    
    public init(
        id: UUID = UUID(),
        date: Date = Date(),
        category: String,
        typeRaw: String = StarNodeType.mini.rawValue,
        positionX: Double,
        positionY: Double,
        contentSummary: String,
        parentNodeId: UUID? = nil
    ) {
        self.id = id
        self.date = date
        self.category = category
        self.typeRaw = typeRaw
        self.positionX = positionX
        self.positionY = positionY
        self.contentSummary = contentSummary
        self.parentNodeId = parentNodeId
    }
    
    /// Tipo de nodo estelar fuertemente tipado.
    public var starType: StarNodeType {
        get {
            StarNodeType(rawValue: typeRaw) ?? .mini
        }
        set {
            typeRaw = newValue.rawValue
        }
    }
    
    /// Coordenada convertida a `CGPoint` para renderizado en el Canvas de SwiftUI.
    public var point: CGPoint {
        CGPoint(x: positionX, y: positionY)
    }
    
    /// Color temático derivado de la categoría para el halo visual.
    public var accentColor: Color {
        QuestionCategory(rawValue: category)?.accentColor ?? Color.mementoSoftBlue
    }
}
