//
//  DailyCheckInView.swift
//  Memento_App
//
//  Created by Senior iOS Engineer on 15/10/2026.
//

import SwiftUI

/// Quizz interactivo de bienestar diario (Daily Check-In).
/// Captura de forma táctil y lúdica el estado holístico del usuario:
/// - Calidad de sueño con slider interactivo y texto orgánico animado ("zzZ").
/// - Selector horizontal de emociones con feedback háptico.
/// - Escala visual de nutrición y vitalidad física.
/// - Mascota "Gatito Espacial" flotando suavemente como acompañante.
public struct DailyCheckInView: View {
    public let onCompleteCheckIn: (DailyCheckInSubmission) -> Void
    
    @State private var viewModel = DailyCheckInViewModel()
    
    public init(onCompleteCheckIn: @escaping (DailyCheckInSubmission) -> Void) {
        self.onCompleteCheckIn = onCompleteCheckIn
    }
    
    public var body: some View {
        ZStack {
            GalaxyWatercolorBackground()
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 28) {
                    // Cabecera con el Gatito Espacial flotando
                    headerSection
                    
                    // 1. Módulo: Nivel de Sueño y Descanso
                    sleepSection
                    
                    // 2. Módulo: Estado de Ánimo (Mood)
                    moodSection
                    
                    // 3. Módulo: Alimentación y Vitalidad Física
                    nutritionSection
                    
                    // Botón de Continuar
                    Button(action: {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        let submission = viewModel.createSubmission()
                        onCompleteCheckIn(submission)
                    }) {
                        HStack(spacing: 12) {
                            Text("Continuar a Preguntas Diarias")
                            Image(systemName: "sparkles")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .sketchButtonStyle(
                        strokeColor: Color(red: 0.85, green: 0.80, blue: 1.0),
                        fillColor: Color(red: 0.45, green: 0.35, blue: 0.70).opacity(0.35),
                        cornerRadius: 18
                    )
                    .padding(.top, 12)
                    .padding(.bottom, 36)
                }
                .padding(.horizontal, 22)
            }
        }
    }
    
    // MARK: - Cabecera con Mascota
    private var headerSection: some View {
        VStack(spacing: 14) {
            SpaceCatView(size: 72)
                .padding(.top, 12)
            
            Text("Sintonía Diaria")
                .font(.system(size: 26, weight: .light, design: .serif))
                .foregroundColor(.white)
            
            Text("Antes de entrar a tus preguntas, calibra tu cuerpo y mente")
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
        }
    }
    
    // MARK: - Módulo 1: Sueño
    private var sleepSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Label("Descanso y Sueño", systemImage: "moon.zzz.fill")
                    .font(.system(size: 16, weight: .semibold, design: .serif))
                    .foregroundColor(Color(red: 0.85, green: 0.80, blue: 1.0))
                
                Spacer()
                
                // Texto animado orgánico con las "Z"
                Text(viewModel.sleepDescription.zCount)
                    .font(.system(size: 18, weight: .bold, design: .serif))
                    .italic()
                    .foregroundColor(Color(red: 0.95, green: 0.80, blue: 0.50))
                    .contentTransition(.numericText())
            }
            
            // Slider interactivo customizado
            Slider(value: $viewModel.sleepHoursQuality, in: 1...5, step: 1.0)
                .tint(Color(red: 0.65, green: 0.55, blue: 0.95))
            
            Text(viewModel.sleepDescription.label)
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(.white.opacity(0.65))
        }
        .sketchCard(accentColor: Color(red: 0.65, green: 0.55, blue: 0.95), isSelected: true)
    }
    
    // MARK: - Módulo 2: Estado de Ánimo
    private var moodSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Label("Estado de Ánimo", systemImage: "heart.text.square.fill")
                .font(.system(size: 16, weight: .semibold, design: .serif))
                .foregroundColor(Color(red: 0.85, green: 0.80, blue: 1.0))
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.moodOptions) { mood in
                        let isSelected = viewModel.selectedMoodIndex == mood.id
                        Button(action: {
                            viewModel.selectMood(id: mood.id)
                        }) {
                            VStack(spacing: 8) {
                                Text(mood.emoji)
                                    .font(.system(size: 28))
                                
                                Text(mood.label)
                                    .font(.system(size: 12, weight: isSelected ? .bold : .regular))
                                    .foregroundColor(isSelected ? .white : .white.opacity(0.6))
                            }
                            .frame(width: 80, height: 86)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(isSelected ? mood.color.opacity(0.3) : Color.white.opacity(0.05))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .strokeBorder(
                                                isSelected ? mood.color : Color.white.opacity(0.15),
                                                lineWidth: isSelected ? 2.0 : 1.0
                                            )
                                    )
                            )
                            .scaleEffect(isSelected ? 1.05 : 1.0)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .sketchCard(accentColor: Color(red: 0.60, green: 0.85, blue: 0.70), isSelected: true)
    }
    
    // MARK: - Módulo 3: Nutrición y Bienestar Físico
    private var nutritionSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Label("Alimentación y Vitalidad", systemImage: "fork.knife.circle.fill")
                .font(.system(size: 16, weight: .semibold, design: .serif))
                .foregroundColor(Color(red: 0.85, green: 0.80, blue: 1.0))
            
            HStack(spacing: 10) {
                ForEach(1...5, id: \.self) { score in
                    let isSelected = viewModel.nutritionScore >= score
                    Button(action: {
                        viewModel.setNutritionScore(score)
                    }) {
                        VStack(spacing: 4) {
                            Circle()
                                .fill(isSelected ? Color(red: 0.95, green: 0.70, blue: 0.50) : Color.white.opacity(0.1))
                                .frame(width: 32, height: 32)
                                .overlay(
                                    Image(systemName: "flame.fill")
                                        .font(.system(size: 14))
                                        .foregroundColor(isSelected ? .white : .white.opacity(0.3))
                                )
                            
                            Text("\(score)")
                                .font(.system(size: 11, design: .monospaced))
                                .foregroundColor(isSelected ? .white : .white.opacity(0.4))
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.vertical, 4)
        }
        .sketchCard(accentColor: Color(red: 0.95, green: 0.70, blue: 0.50), isSelected: true)
    }
}
