//
//  DailyQuestionsView.swift
//  Memento_App
//
//  Created by Senior iOS Engineer on 15/10/2026.
//

import SwiftUI
import SwiftData

/// Pantalla de Preguntas Diarias de Introspección.
/// - Incorpora el componente superior `ZenListeningRingView` que reacciona con pulso cósmico al foco del texto.
/// - Presenta 2 preguntas reflexivas de la categoría activa.
/// - Provee contador de palabras en tiempo real y guarda la reflexión creando el nuevo `StarNode` en SwiftData.
public struct DailyQuestionsView: View {
    public let category: QuestionCategory
    public let checkInSubmission: DailyCheckInSubmission?
    public let userProfile: UserProfile
    public let onComplete: () -> Void
    
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = DailyQuestionsViewModel()
    @FocusState private var isFieldFocused: Bool
    
    public init(
        category: QuestionCategory,
        checkInSubmission: DailyCheckInSubmission?,
        userProfile: UserProfile,
        onComplete: @escaping () -> Void
    ) {
        self.category = category
        self.checkInSubmission = checkInSubmission
        self.userProfile = userProfile
        self.onComplete = onComplete
    }
    
    public var body: some View {
        ZStack {
            GalaxyWatercolorBackground()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Elemento Zen Superior: Anillos pulsantes reactivos al foco
                ZenListeningRingView(isFocused: isFieldFocused)
                    .padding(.top, 8)
                
                if viewModel.isLoading {
                    Spacer()
                    ProgressView()
                        .tint(Color(red: 0.85, green: 0.80, blue: 1.0))
                    Text("Invocando preguntas del cosmos...")
                        .font(.system(size: 14, design: .serif))
                        .foregroundColor(.white.opacity(0.6))
                        .padding(.top, 12)
                    Spacer()
                } else if viewModel.currentQuestions.count >= 2 {
                    ScrollView {
                        VStack(spacing: 24) {
                            // Pregunta 1
                            questionCard(
                                index: 1,
                                question: viewModel.currentQuestions[0],
                                text: $viewModel.answerOne
                            )
                            
                            // Pregunta 2
                            questionCard(
                                index: 2,
                                question: viewModel.currentQuestions[1],
                                text: $viewModel.answerTwo
                            )
                            
                            // Botón de Guardar e Iluminar la Galaxia
                            Button(action: {
                                isFieldFocused = false
                                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                                _ = viewModel.saveReflection(
                                    category: category,
                                    checkInSubmission: checkInSubmission,
                                    modelContext: modelContext,
                                    userProfile: userProfile
                                )
                                onComplete()
                            }) {
                                HStack(spacing: 12) {
                                    Text("Encender Nueva Estrella")
                                    Image(systemName: "sparkle")
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .sketchButtonStyle(
                                strokeColor: category.accentColor,
                                fillColor: category.accentColor.opacity(0.3),
                                cornerRadius: 18
                            )
                            .disabled(!viewModel.canSaveReflection)
                            .opacity(viewModel.canSaveReflection ? 1.0 : 0.45)
                            .padding(.top, 8)
                            .padding(.bottom, 36)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 12)
                    }
                }
            }
        }
        .task {
            await viewModel.loadQuestions(for: category)
        }
    }
    
    private func questionCard(index: Int, question: DailyQuestion, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // Número y Categoría
            HStack {
                Text("Pregunta \(index) de 2")
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundColor(category.accentColor)
                
                Spacer()
                
                // Contador de palabras
                let words = viewModel.wordCount(for: text.wrappedValue)
                Text("\(words) palabras")
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundColor(.white.opacity(0.5))
            }
            
            // Texto de la Pregunta
            Text(question.text)
                .font(.system(size: 17, weight: .semibold, design: .serif))
                .foregroundColor(.white)
                .lineSpacing(4)
            
            // Sugerencia psicológica reflexiva
            Text(question.promptHint)
                .font(.system(size: 13, design: .serif))
                .italic()
                .foregroundColor(.white.opacity(0.65))
            
            // Campo de Texto de Introspección
            TextEditor(text: text)
                .focused($isFieldFocused)
                .frame(minHeight: 110)
                .padding(10)
                .scrollContentBackground(.hidden)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.white.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .strokeBorder(
                                    isFieldFocused ? category.accentColor.opacity(0.6) : Color.white.opacity(0.15),
                                    lineWidth: 1.0
                                )
                        )
                )
                .foregroundColor(.white)
        }
        .sketchCard(accentColor: category.accentColor, isSelected: true)
    }
}
