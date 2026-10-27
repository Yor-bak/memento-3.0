//
//  QuestionCategory.swift
//  Memento_App
//
//  Created by Senior iOS UI/UX Engineer on 15/10/2026.
//

import Foundation
import SwiftUI

/// Representa las categorías temáticas de introspección disponibles en la aplicación Memento.
/// Configurado con la paleta de color estricta oficial para acentos estelares y halos cósmicos.
public enum QuestionCategory: String, CaseIterable, Codable, Identifiable, Sendable {
    case familia = "Familia"
    case amigos = "Amigos"
    case amor = "Amor"
    case trabajo = "Trabajo"
    case proposito = "Propósito"
    case autoconocimiento = "Autoconocimiento"
    
    public var id: String { rawValue }
    
    /// Icono SF Symbol representativo para la interfaz con estilo orgánico.
    public var iconName: String {
        switch self {
        case .familia: return "house.fill"
        case .amigos: return "person.2.fill"
        case .amor: return "heart.fill"
        case .trabajo: return "briefcase.fill"
        case .proposito: return "sparkles"
        case .autoconocimiento: return "eye.fill"
        }
    }
    
    /// Color temático cósmico estricto del Design System de Memento.
    public var accentColor: Color {
        switch self {
        case .familia: return Color.mementoGold
        case .amigos: return Color.mementoSoftBlue
        case .amor: return Color.mementoSkyBlue
        case .trabajo: return Color.mementoNavyBlue
        case .proposito: return Color.mementoDeepViolet
        case .autoconocimiento: return Color.mementoGold
        }
    }
    
    /// Breve descripción inspiracional para el usuario.
    public var subtitle: String {
        switch self {
        case .familia: return "Vínculos raíces y memorias del hogar"
        case .amigos: return "La tribu que eliges en tu camino"
        case .amor: return "Vulnerabilidad, entrega y apego"
        case .trabajo: return "Creación, vocación y esfuerzo"
        case .proposito: return "El sentido de tu viaje vital"
        case .autoconocimiento: return "El diálogo íntimo contigo mismo"
        }
    }
}
