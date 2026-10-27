//
//  DTOs.swift
//  Memento_App
//
//  Created by Senior iOS Engineer on 15/10/2026.
//

import Foundation
import SwiftUI

// MARK: - Documentación para Conexión Backend / LLM
/// Este archivo contiene todos los Data Transfer Objects (DTOs) estructurados para ser
/// serializados directamente a JSON y enviados a endpoints REST / microservicios del LLM.
///
/// Convenciones:
/// - Todos los tipos conforman `Codable` y `Sendable`.
/// - Fechas formateadas en ISO8601 para interoperabilidad estándar con APIs backend.

/// Tipo de nodo en la visualización del grafo espacial de Memento.
public enum StarNodeType: String, Codable, CaseIterable, Sendable {
    /// Nodo generado tras completar el set diario de 2 preguntas introspectivas.
    case mini
    /// Nodo consolidado al agrupar 10 estrellas pequeñas (patrón emocional detectado).
    case medium
    /// Nodo supremo generado al consolidar 2 estrellas medianas (hito de autoconocimiento).
    case moon
    
    /// Radio base visual del nodo en puntos de pantalla.
    public var visualRadius: CGFloat {
        switch self {
        case .mini: return 12
        case .medium: return 24
        case .moon: return 40
        }
    }
    
    /// Radio del halo de brillo cósmico.
    public var glowRadius: CGFloat {
        switch self {
        case .mini: return 16
        case .medium: return 32
        case .moon: return 56
        }
    }
    
    /// Título descriptivo para la interfaz.
    public var displayTitle: String {
        switch self {
        case .mini: return "Estrella Diaria"
        case .medium: return "Constelación Focal"
        case .moon: return "Luna de Consciencia"
        }
    }
}

/// DTO empaquetado para el envío de las métricas de bienestar diario hacia el backend.
/// Endpoint objetivo: `POST /api/v1/checkin/daily`
public struct DailyCheckInSubmission: Codable, Sendable {
    public let id: UUID
    public let timestamp: Date
    public let sleepQuality: Int
    public let moodScore: Int
    public let nutritionScore: Int
    public let moodLabel: String
    
    public init(
        id: UUID = UUID(),
        timestamp: Date = Date(),
        sleepQuality: Int,
        moodScore: Int,
        nutritionScore: Int,
        moodLabel: String
    ) {
        self.id = id
        self.timestamp = timestamp
        self.sleepQuality = sleepQuality
        self.moodScore = moodScore
        self.nutritionScore = nutritionScore
        self.moodLabel = moodLabel
    }
}

/// Representa una pregunta reflexiva presentada al usuario.
public struct DailyQuestion: Identifiable, Codable, Sendable {
    public let id: UUID
    public let text: String
    public let category: QuestionCategory
    public let promptHint: String
    
    public init(
        id: UUID = UUID(),
        text: String,
        category: QuestionCategory,
        promptHint: String
    ) {
        self.id = id
        self.text = text
        self.category = category
        self.promptHint = promptHint
    }
}

/// DTO empaquetado para enviar las reflexiones escritas al LLM para generación de resumen y extracción de patrones.
/// Endpoint objetivo: `POST /api/v1/reflections/analyze`
public struct ReflectionSubmission: Codable, Sendable {
    public let submissionId: UUID
    public let date: Date
    public let category: QuestionCategory
    public let questionOneId: UUID
    public let answerOne: String
    public let questionTwoId: UUID
    public let answerTwo: String
    
    public init(
        submissionId: UUID = UUID(),
        date: Date = Date(),
        category: QuestionCategory,
        questionOneId: UUID,
        answerOne: String,
        questionTwoId: UUID,
        answerTwo: String
    ) {
        self.submissionId = submissionId
        self.date = date
        self.category = category
        self.questionOneId = questionOneId
        self.answerOne = answerOne
        self.questionTwoId = questionTwoId
        self.answerTwo = answerTwo
    }
}
