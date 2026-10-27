//
//  ZenListeningRingView.swift
//  Memento_App
//
//  Created by Senior iOS UI/UX Engineer on 15/10/2026.
//

import SwiftUI

/// Componente Zen superior que proyecta anillos y partículas pulsantes.
/// Reacciona dinámicamente cuando el usuario interactúa o enfoca el campo de texto de introspección,
/// generando la sensación de presencia compasiva ("la app te está escuchando con calma").
/// Construido estrictamente con la paleta oficial (Color+Memento).
public struct ZenListeningRingView: View {
    public var isFocused: Bool
    
    @State private var breathePhase: CGFloat = 0.0
    @State private var rotationAngle: Double = 0.0
    
    public init(isFocused: Bool = false) {
        self.isFocused = isFocused
    }
    
    public var body: some View {
        ZStack {
            // Halo de luz difusa exterior en mementoSkyBlue / mementoDeepViolet
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            (isFocused ? Color.mementoSkyBlue : Color.mementoDeepViolet).opacity(isFocused ? 0.35 : 0.15),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 5,
                        endRadius: isFocused ? 75 : 50
                    )
                )
                .frame(width: 150, height: 150)
                .scaleEffect(1.0 + (breathePhase * (isFocused ? 0.25 : 0.12)))
            
            // Anillo exterior con trazo orgánico punteado en mementoSoftBlue
            Circle()
                .strokeBorder(
                    Color.mementoSoftBlue.opacity(isFocused ? 0.65 : 0.25),
                    style: StrokeStyle(lineWidth: 1.2, dash: isFocused ? [4, 4] : [8, 6])
                )
                .frame(width: isFocused ? 92 : 78, height: isFocused ? 92 : 78)
                .rotationEffect(.degrees(rotationAngle))
            
            // Anillo intermedio que pulsa en respiración
            Circle()
                .strokeBorder(
                    Color.mementoSoftBlue.opacity(isFocused ? 0.8 : 0.4),
                    lineWidth: isFocused ? 1.8 : 1.0
                )
                .frame(width: 62, height: 62)
                .scaleEffect(1.0 + (breathePhase * 0.15))
            
            // Núcleo brillante central (Punto de atención plena) en mementoWhite y mementoGold
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.mementoWhite,
                            isFocused ? Color.mementoGold : Color.mementoSoftBlue
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: isFocused ? 18 : 12, height: isFocused ? 18 : 12)
                .shadow(
                    color: (isFocused ? Color.mementoGold : Color.mementoWhite).opacity(isFocused ? 0.9 : 0.5),
                    radius: isFocused ? 12 : 6
                )
            
            // Partículas satelitales que orbitan suavemente en mementoWhite
            ForEach(0..<4) { index in
                Circle()
                    .fill(Color.mementoWhite.opacity(isFocused ? 0.75 : 0.35))
                    .frame(width: 3.5, height: 3.5)
                    .offset(x: particleRadius(for: index))
                    .rotationEffect(.degrees(rotationAngle + Double(index * 90)))
            }
        }
        .frame(height: 110)
        .onAppear {
            withAnimation(.easeInOut(duration: 3.2).repeatForever(autoreverses: true)) {
                breathePhase = 1.0
            }
            withAnimation(.linear(duration: 18.0).repeatForever(autoreverses: false)) {
                rotationAngle = 360.0
            }
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: isFocused)
    }
    
    private func particleRadius(for index: Int) -> CGFloat {
        let base: CGFloat = isFocused ? 44 : 36
        return base + CGFloat(index * 2)
    }
}
