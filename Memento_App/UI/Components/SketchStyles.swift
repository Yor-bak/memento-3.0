//
//  SketchStyles.swift
//  Memento_App
//
//  Created by Senior iOS UI/UX Engineer on 15/10/2026.
//

import SwiftUI

/// Estilo de botón interactivo con trazo de boceto artesanal (sketch / handmade) en SwiftUI.
/// Construido estrictamente con los tokens oficiales de Color de Memento.
public struct SketchButtonStyle: ButtonStyle {
    public var strokeColor: Color
    public var fillColor: Color
    public var cornerRadius: CGFloat
    
    public init(
        strokeColor: Color = Color.mementoSoftBlue,
        fillColor: Color = Color.mementoDeepViolet.opacity(0.35),
        cornerRadius: CGFloat = 16
    ) {
        self.strokeColor = strokeColor
        self.fillColor = fillColor
        self.cornerRadius = cornerRadius
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(.body, design: .rounded, weight: .semibold))
            .foregroundColor(Color.mementoWhite)
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(configuration.isPressed ? fillColor.opacity(1.8) : fillColor)
                    
                    // Trazo orgánico doble con ligero desfase para efecto de lápiz/boceto
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .strokeBorder(
                            strokeColor.opacity(configuration.isPressed ? 1.0 : 0.8),
                            lineWidth: 1.5
                        )
                    
                    RoundedRectangle(cornerRadius: cornerRadius - 1)
                        .strokeBorder(
                            strokeColor.opacity(configuration.isPressed ? 0.45 : 0.25),
                            style: StrokeStyle(lineWidth: 0.8, dash: [8, 4])
                        )
                }
            )
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.65), value: configuration.isPressed)
    }
}

/// Modificador para tarjetas estilo Sketch artesanal.
public struct SketchCardModifier: ViewModifier {
    public var accentColor: Color
    public var isSelected: Bool
    
    public func body(content: Content) -> some View {
        content
            .padding(18)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            isSelected
                            ? accentColor.opacity(0.18)
                            : Color.mementoDeepViolet.opacity(0.2)
                        )
                    
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(
                            isSelected ? accentColor : Color.mementoSoftBlue.opacity(0.3),
                            lineWidth: isSelected ? 2.0 : 1.2
                        )
                    
                    if isSelected {
                        RoundedRectangle(cornerRadius: 22)
                            .strokeBorder(
                                accentColor.opacity(0.35),
                                style: StrokeStyle(lineWidth: 1.0, dash: [6, 4])
                            )
                            .padding(-3)
                    }
                }
            )
            .shadow(
                color: isSelected ? accentColor.opacity(0.3) : Color.mementoBlack.opacity(0.35),
                radius: isSelected ? 12 : 6,
                x: 0,
                y: 4
            )
    }
}

public extension View {
    /// Aplica el estilo de tarjeta boceto artesanal.
    func sketchCard(accentColor: Color = Color.mementoSoftBlue, isSelected: Bool = false) -> some View {
        modifier(SketchCardModifier(accentColor: accentColor, isSelected: isSelected))
    }
    
    /// Aplica el estilo de botón con trazo sketch orgánico.
    func sketchButtonStyle(
        strokeColor: Color = Color.mementoSoftBlue,
        fillColor: Color = Color.mementoDeepViolet.opacity(0.35),
        cornerRadius: CGFloat = 16
    ) -> some View {
        buttonStyle(SketchButtonStyle(strokeColor: strokeColor, fillColor: fillColor, cornerRadius: cornerRadius))
    }
}
