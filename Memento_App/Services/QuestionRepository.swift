//
//  QuestionRepository.swift
//  Memento_App
//
//  Created by Senior iOS Engineer on 15/10/2026.
//

import Foundation

// MARK: - Documentación para Conectar con Backend / Microservicio LLM
/// Para sustituir este Mock por una llamada real de red hacia el backend / LLM:
///
/// 1. Crear una clase `RemoteQuestionRepository: QuestionRepositoryProtocol`:
///    ```swift
///    public final class RemoteQuestionRepository: QuestionRepositoryProtocol {
///        private let session: URLSession
///        private let baseURL = URL(string: "https://api.memento.app/v1")!
///
///        public func fetchDailyQuestions(for category: QuestionCategory) async throws -> [DailyQuestion] {
///            let url = baseURL.appendingPathComponent("questions/daily")
///                .appending(queryItems: [URLQueryItem(name: "category", value: category.rawValue)])
///            let (data, response) = try await session.data(from: url)
///            guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw NetworkError.serverError }
///            return try JSONDecoder().decode([DailyQuestion].self, from: data)
///        }
///    }
///    ```
/// 2. Inyectar `RemoteQuestionRepository` en `DailyQuestionsViewModel` o en el contenedor de dependencias.

/// Contrato para la obtención de preguntas reflexivas diarias.
public protocol QuestionRepositoryProtocol: Sendable {
    /// Obtiene el conjunto de 2 preguntas diarias de introspección para la categoría indicada.
    func fetchDailyQuestions(for category: QuestionCategory) async throws -> [DailyQuestion]
    
    /// Devuelve el catálogo completo de preguntas disponibles en el repositorio local.
    func fetchCatalog() -> [DailyQuestion]
}

/// Implementación Mock robusta y reflexiva con al menos 6 preguntas preconfiguradas
/// diseñadas con enfoque psicológico para fomentar la autoconsciencia.
public final class MockQuestionRepository: QuestionRepositoryProtocol {
    
    private let questionsCatalog: [DailyQuestion] = [
        // 1. Familia
        DailyQuestion(
            text: "¿Qué herencia emocional o hábito de tu familia sigues repitiendo hoy de forma inconsciente?",
            category: .familia,
            promptHint: "Piensa en tus reacciones cotidianas, tono de voz o formas de resolver conflictos..."
        ),
        // 2. Familia
        DailyQuestion(
            text: "Si pudieras agradecerle hoy algo específico a uno de tus ancestros, ¿qué sería y a quién?",
            category: .familia,
            promptHint: "Conecta con la gratitud hacia quienes abrieron el camino antes que tú..."
        ),
        // 3. Amigos
        DailyQuestion(
            text: "¿En qué vínculo de amistad estás sintiendo un desbalance entre lo que das y lo que recibes?",
            category: .amigos,
            promptHint: "La reciprocidad sincera requiere honestidad contigo mismo..."
        ),
        // 4. Amor
        DailyQuestion(
            text: "¿Qué miedo profundo se activa en ti cuando permites que alguien te conozca de verdad?",
            category: .amor,
            promptHint: "Observa tus defensas: el silencio, la huida o la complacencia..."
        ),
        // 5. Trabajo
        DailyQuestion(
            text: "¿Estás construyendo lo que realmente deseas, o estás cumpliendo la expectativa de alguien más?",
            category: .trabajo,
            promptHint: "Distingue entre la ambición que nace de tu alma y la que busca aprobación externa..."
        ),
        // 6. Autoconocimiento
        DailyQuestion(
            text: "¿Qué verdad sobre ti has estado postergando aceptar durante las últimas semanas?",
            category: .autoconocimiento,
            promptHint: "Respira profundo; este es un espacio seguro para ser completamente honesto..."
        ),
        // 7. Propósito
        DailyQuestion(
            text: "Si el dinero y la opinión ajena no importaran, ¿a qué dedicarías tu energía el día de hoy?",
            category: .proposito,
            promptHint: "Identifica qué actividades te hacen perder la noción del tiempo..."
        ),
        // 8. Amor
        DailyQuestion(
            text: "¿De qué manera te tratas a ti mismo cuando cometes un error?",
            category: .amor,
            promptHint: "¿Tu voz interna es de un crítico severo o de un mentor compasivo?"
        )
    ]
    
    public init() {}
    
    public func fetchDailyQuestions(for category: QuestionCategory) async throws -> [DailyQuestion] {
        // Simular latencia de red sutil (50ms) para garantizar comportamiento asíncrono real
        try await Task.sleep(nanoseconds: 50_000_000)
        
        let filtered = questionsCatalog.filter { $0.category == category }
        if filtered.count >= 2 {
            return Array(filtered.prefix(2))
        } else {
            // Si la categoría tiene menos de 2, complementamos con preguntas de autoconocimiento
            let fallbacks = questionsCatalog.filter { $0.category == .autoconocimiento }
            let combined = filtered + fallbacks
            return Array(combined.prefix(2))
        }
    }
    
    public func fetchCatalog() -> [DailyQuestion] {
        questionsCatalog
    }
}
