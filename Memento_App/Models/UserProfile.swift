//
//  UserProfile.swift
//  Memento_App
//
//  Created by Senior iOS Engineer on 15/10/2026.
//

import Foundation
import SwiftData

/// Modelo persistente que almacena las preferencias de seguridad, estado de onboarding y métricas del usuario.
@Model
public final class UserProfile {
    /// Identificador único del perfil.
    @Attribute(.unique) public var id: UUID
    
    /// Indica si el usuario ha habilitado la autenticación biométrica (Face ID / Touch ID).
    public var isBiometricsEnabled: Bool
    
    /// Código PIN de seguridad configurado por el usuario (almacenado localmente en SwiftData según requerimiento).
    public var pinCode: String?
    
    /// Bandera que indica si el usuario completó exitosamente el flujo de introducción/onboarding.
    public var hasCompletedOnboarding: Bool
    
    /// Contador global de preguntas introspectivas respondidas (utilizado para activar la selección periódica de categoría cada 10 preguntas).
    public var totalQuestionsAnswered: Int
    
    /// Fecha de la última vez que el usuario completó su check-in diario.
    public var lastCheckInDate: Date?
    
    /// Categoría temática actualmente seleccionada para las preguntas diarias.
    public var currentCategoryRaw: String
    
    public init(
        id: UUID = UUID(),
        isBiometricsEnabled: Bool = false,
        pinCode: String? = nil,
        hasCompletedOnboarding: Bool = false,
        totalQuestionsAnswered: Int = 0,
        lastCheckInDate: Date? = nil,
        currentCategory: QuestionCategory = .autoconocimiento
    ) {
        self.id = id
        self.isBiometricsEnabled = isBiometricsEnabled
        self.pinCode = pinCode
        self.hasCompletedOnboarding = hasCompletedOnboarding
        self.totalQuestionsAnswered = totalQuestionsAnswered
        self.lastCheckInDate = lastCheckInDate
        self.currentCategoryRaw = currentCategory.rawValue
    }
    
    /// Categoría actual fuertemente tipada.
    public var currentCategory: QuestionCategory {
        get {
            QuestionCategory(rawValue: currentCategoryRaw) ?? .autoconocimiento
        }
        set {
            currentCategoryRaw = newValue.rawValue
        }
    }
    
    /// Evalúa si el usuario ya ha completado su registro diario en la fecha actual (mismo día calendario).
    public var hasCompletedDailyCheckInToday: Bool {
        guard let lastDate = lastCheckInDate else { return false }
        return Calendar.current.isDateInToday(lastDate)
    }
}
