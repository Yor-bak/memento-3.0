//
//  DailyEntry.swift
//  Memento_App
//
//  Created by Senior iOS Engineer on 15/10/2026.
//

import Foundation
import SwiftData

/// Modelo persistente que almacena el registro completo del día: check-in holístico y respuestas introspectivas.
@Model
public final class DailyEntry {
    /// Identificador único del registro diario.
    @Attribute(.unique) public var id: UUID
    
    /// Marca de tiempo en la que se generó la entrada.
    public var timestamp: Date
    
    /// Calificación de calidad de sueño (escala 1 a 5).
    public var sleepQuality: Int
    
    /// Calificación del estado de ánimo (escala 1 a 5).
    public var moodScore: Int
    
    /// Calificación de alimentación y bienestar físico (escala 1 a 5).
    public var nutritionScore: Int
    
    /// Respuestas textuales redactadas por el usuario a las preguntas diarias de introspección.
    public var answers: [String]
    
    /// Categoría temática a la que correspondían las preguntas de esta sesión.
    public var category: String
    
    /// Identificador del nodo de estrella generado en el grafo galáctico correspondiente a esta entrada.
    public var associatedStarNodeId: UUID?
    
    public init(
        id: UUID = UUID(),
        timestamp: Date = Date(),
        sleepQuality: Int,
        moodScore: Int,
        nutritionScore: Int,
        answers: [String],
        category: String,
        associatedStarNodeId: UUID? = nil
    ) {
        self.id = id
        self.timestamp = timestamp
        self.sleepQuality = sleepQuality
        self.moodScore = moodScore
        self.nutritionScore = nutritionScore
        self.answers = answers
        self.category = category
        self.associatedStarNodeId = associatedStarNodeId
    }
}
