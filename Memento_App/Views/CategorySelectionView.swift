//
//  CategorySelectionView.swift
//  Memento_App
//
//  Created by Senior iOS Engineer on 15/10/2026.
//

import SwiftUI

/// Pantalla de Selección de Categoría Temática.
/// Se invoca en el primer lanzamiento y cada vez que el contador de preguntas acumuladas alcanza múltiplos de 10.
/// Presenta tarjetas artesanales en estilo sketch con categorías extensibles (`QuestionCategory`).
public struct CategorySelectionView: View {
    public let initialCategory: QuestionCategory
    public let onCategorySelected: (QuestionCategory) -> Void
    
    @State private var selectedCategory: QuestionCategory
    
    public init(
        initialCategory: QuestionCategory = .autoconocimiento,
        onCategorySelected: @escaping (QuestionCategory) -> Void
    ) {
        self.initialCategory = initialCategory
        self._selectedCategory = State(initialValue: initialCategory)
        self.onCategorySelected = onCategorySelected
    }
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    public var body: some View {
        ZStack {
            GalaxyWatercolorBackground()
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Cabecera
                VStack(spacing: 10) {
                    Text("Elige tu Sendero")
                        .font(.system(size: 28, weight: .light, design: .serif))
                        .foregroundColor(.white)
                    
                    Text("Selecciona el área de tu vida donde deseas enfocar la luz de tu introspección hoy")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.75))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                .padding(.top, 24)
                
                // Rejilla de tarjetas estilo sketch
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(QuestionCategory.allCases) { category in
                            categoryCard(for: category)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                }
                
                // Botón de confirmación
                Button(action: {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    onCategorySelected(selectedCategory)
                }) {
                    HStack(spacing: 10) {
                        Text("Explorar \(selectedCategory.rawValue)")
                        Image(systemName: "arrow.right")
                    }
                    .frame(maxWidth: .infinity)
                }
                .sketchButtonStyle(
                    strokeColor: selectedCategory.accentColor,
                    fillColor: selectedCategory.accentColor.opacity(0.25),
                    cornerRadius: 18
                )
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
        }
    }
    
    private func categoryCard(for category: QuestionCategory) -> some View {
        let isSelected = selectedCategory == category
        
        return Button(action: {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                selectedCategory = category
            }
        }) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    ZStack {
                        Circle()
                            .fill(category.accentColor.opacity(0.2))
                            .frame(width: 44, height: 44)
                        
                        Image(systemName: category.iconName)
                            .font(.system(size: 20))
                            .foregroundColor(category.accentColor)
                    }
                    
                    Spacer()
                    
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 18))
                            .foregroundColor(category.accentColor)
                            .transition(.scale)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(category.rawValue)
                        .font(.system(size: 18, weight: .semibold, design: .serif))
                        .foregroundColor(.white)
                    
                    Text(category.subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.65))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
            }
            .sketchCard(accentColor: category.accentColor, isSelected: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
