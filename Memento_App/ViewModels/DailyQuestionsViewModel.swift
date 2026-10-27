//
//  DailyQuestionsViewModel.swift
//  Memento_App
//
//  Created by Senior iOS Engineer on 15/10/2026.
//

import SwiftUI
import SwiftData

/// ViewModel encargado de gobernar el flujo de las 2 preguntas diarias de introspección,
/// la interacción zen de foco, conteo de palabras en tiempo real y la creación de nodos en SwiftData.
@Observable
public final class DailyQuestionsViewModel {
    
    // Repositorio y servicios
    private let questionRepository: QuestionRepositoryProtocol
    private let galaxyService: GalaxyServiceProtocol
    
    // Estado de las preguntas y respuestas
    public var currentQuestions: [DailyQuestion] = []
    public var answerOne: String = ""
    public var answerTwo: String = ""
    public var isLoading: Bool = false
    public var isZenFocused: Bool = false
    public var activeQuestionIndex: Int = 0
    public var errorMessage: String? = nil
    
    public init(
        questionRepository: QuestionRepositoryProtocol = MockQuestionRepository(),
        galaxyService: GalaxyServiceProtocol = GalaxyService()
    ) {
        self.questionRepository = questionRepository
        self.galaxyService = galaxyService
    }
    
    // MARK: - Carga de Preguntas
    @MainActor
    public func loadQuestions(for category: QuestionCategory) async {
        isLoading = true
        errorMessage = nil
        do {
            currentQuestions = try await questionRepository.fetchDailyQuestions(for: category)
            isLoading = false
        } catch {
            errorMessage = "No se pudieron cargar las preguntas del día: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    // MARK: - Métricas de Texto
    public func wordCount(for text: String) -> Int {
        let components = text.split { $0.isWhitespace || $0.isNewline }
        return components.count
    }
    
    public var canSaveReflection: Bool {
        !answerOne.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !answerTwo.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    // MARK: - Guardado y Creación de Nodos en SwiftData
    @MainActor
    public func saveReflection(
        category: QuestionCategory,
        checkInSubmission: DailyCheckInSubmission?,
        modelContext: ModelContext,
        userProfile: UserProfile
    ) -> StarNode {
        // 1. Obtener la cantidad actual de nodos para calcular la posición orbital armónica
        let descriptor = FetchDescriptor<StarNode>()
        let existingNodes = (try? modelContext.fetch(descriptor)) ?? []
        
        let position = galaxyService.calculateNewMiniStarPosition(
            existingNodesCount: existingNodes.count,
            aroundParent: nil
        )
        
        // 2. Generar síntesis / resumen de la introspección (preparado para ser reemplazado por la respuesta del LLM)
        let summaryPrefix = answerOne.prefix(60).trimmingCharacters(in: .whitespacesAndNewlines)
        let summary = summaryPrefix.isEmpty ? "Introspección en \(category.rawValue)" : "\(summaryPrefix)..."
        
        // 3. Crear el nuevo MiniStarNode
        let newStar = StarNode(
            date: Date(),
            category: category.rawValue,
            typeRaw: StarNodeType.mini.rawValue,
            positionX: Double(position.x),
            positionY: Double(position.y),
            contentSummary: summary,
            parentNodeId: nil
        )
        modelContext.insert(newStar)
        
        // 4. Crear el registro persistente DailyEntry
        let sleep = checkInSubmission?.sleepQuality ?? 3
        let mood = checkInSubmission?.moodScore ?? 3
        let nutrition = checkInSubmission?.nutritionScore ?? 3
        
        let dailyEntry = DailyEntry(
            timestamp: Date(),
            sleepQuality: sleep,
            moodScore: mood,
            nutritionScore: nutrition,
            answers: [answerOne, answerTwo],
            category: category.rawValue,
            associatedStarNodeId: newStar.id
        )
        modelContext.insert(dailyEntry)
        
        // 5. Evaluar reglas de consolidación estelar (10 mini -> 1 mediana; 2 medianas -> 1 luna)
        let allNodesWithNew = existingNodes + [newStar]
        let consolidation = galaxyService.evaluateConsolidationRules(existingNodes: allNodesWithNew)
        
        // Insertar nuevas estrellas medianas
        for mediumStar in consolidation.newMediumStars {
            modelContext.insert(mediumStar)
        }
        
        // Insertar nuevas lunas
        for moon in consolidation.newMoons {
            modelContext.insert(moon)
        }
        
        // Actualizar parentNodeId en los nodos hijos correspondientes
        let dict = Dictionary(uniqueKeysWithValues: allNodesWithNew.map { ($0.id, $0) })
        for link in consolidation.updatedChildLinks {
            if let child = dict[link.childId] {
                child.parentNodeId = link.parentId
            }
        }
        
        // 6. Actualizar el perfil del usuario
        userProfile.totalQuestionsAnswered += 2
        userProfile.lastCheckInDate = Date()
        
        return newStar
    }
}
