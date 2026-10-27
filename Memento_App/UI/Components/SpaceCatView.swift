//
//  SpaceCatView.swift
//  Memento_App
//
//  Created by Senior iOS UI/UX Engineer on 15/10/2026.
//

import SwiftUI

/// Mascota animada de Memento: El "Gatito Espacial".
/// Proyecta una ilustración vectorial estilizada en SwiftUI basada estrictamente en la paleta oficial
/// de Memento con flotación continua suave y balanceo gravitacional dentro del cosmos.
public struct SpaceCatView: View {
    public var size: CGFloat
    public var isCompact: Bool
    
    @State private var hoverOffset: CGFloat = 0.0
    @State private var tiltAngle: Double = -3.0
    @State private var helmetGlow: CGFloat = 0.35
    
    public init(size: CGFloat = 80, isCompact: Bool = false) {
        self.size = size
        self.isCompact = isCompact
    }
    
    public var body: some View {
        ZStack {
            // Halo cósmico del casco en mementoSoftBlue
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.mementoSoftBlue.opacity(helmetGlow),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: size * 0.2,
                        endRadius: size * 0.65
                    )
                )
                .frame(width: size * 1.3, height: size * 1.3)
            
            // Traje / Casco de astronauta con gradiente mementoDeepViolet a mementoDarkPurple
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.mementoDeepViolet,
                            Color.mementoDarkPurple
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size, height: size)
                .overlay(
                    Circle()
                        .strokeBorder(
                            Color.mementoSoftBlue.opacity(0.4),
                            style: StrokeStyle(lineWidth: 1.5, dash: [6, 3])
                        )
                )
            
            // Orejitas del gatito saliendo del casco
            HStack(spacing: size * 0.32) {
                catEar(isLeft: true)
                catEar(isLeft: false)
            }
            .offset(y: -size * 0.38)
            
            // Rostro del gatito espacial
            VStack(spacing: size * 0.06) {
                // Ojos brillantes
                HStack(spacing: size * 0.22) {
                    catEye()
                    catEye()
                }
                
                // Nariz estelar en mementoGold
                PolygonStar(points: 4)
                    .fill(Color.mementoGold)
                    .frame(width: size * 0.09, height: size * 0.09)
                    .shadow(color: Color.mementoGold.opacity(0.6), radius: 3)
                
                // Bigotitos en mementoSoftBlue
                HStack(spacing: size * 0.28) {
                    catWhiskers(isLeft: true)
                    catWhiskers(isLeft: false)
                }
            }
            .offset(y: size * 0.02)
            
            // Reflejo del visor en mementoWhite tenue
            Capsule()
                .fill(Color.mementoWhite.opacity(0.2))
                .frame(width: size * 0.45, height: size * 0.08)
                .rotationEffect(.degrees(-35))
                .offset(x: -size * 0.18, y: -size * 0.20)
        }
        .offset(y: hoverOffset)
        .rotationEffect(.degrees(tiltAngle))
        .onAppear {
            withAnimation(.easeInOut(duration: 2.8).repeatForever(autoreverses: true)) {
                hoverOffset = -7.0
                tiltAngle = 4.0
                helmetGlow = 0.65
            }
        }
    }
    
    // MARK: - Subformas vectoriales
    private func catEar(isLeft: Bool) -> some View {
        Triangle()
            .fill(Color.mementoDeepViolet)
            .frame(width: size * 0.22, height: size * 0.26)
            .rotationEffect(.degrees(isLeft ? -18 : 18))
            .overlay(
                Triangle()
                    .stroke(Color.mementoSoftBlue.opacity(0.6), lineWidth: 1.0)
                    .rotationEffect(.degrees(isLeft ? -18 : 18))
            )
    }
    
    private func catEye() -> some View {
        Circle()
            .fill(Color.mementoWhite)
            .frame(width: size * 0.11, height: size * 0.11)
            .overlay(
                Circle()
                    .fill(Color.mementoBlack)
                    .frame(width: size * 0.07, height: size * 0.07)
                    .offset(x: size * 0.015, y: -size * 0.01)
            )
    }
    
    private func catWhiskers(isLeft: Bool) -> some View {
        VStack(spacing: 3) {
            Rectangle()
                .fill(Color.mementoSoftBlue.opacity(0.5))
                .frame(width: size * 0.14, height: 1)
                .rotationEffect(.degrees(isLeft ? -10 : 10))
            Rectangle()
                .fill(Color.mementoSoftBlue.opacity(0.5))
                .frame(width: size * 0.12, height: 1)
                .rotationEffect(.degrees(isLeft ? 8 : -8))
        }
    }
}

/// Forma de triángulo para las orejas del gato.
private struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

/// Forma de estrella geométrica de N puntas.
private struct PolygonStar: Shape {
    let points: Int
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let outerR = min(rect.width, rect.height) / 2.0
        let innerR = outerR * 0.4
        let step = .pi / CGFloat(points)
        
        for i in 0..<(points * 2) {
            let r = i.isMultiple(of: 2) ? outerR : innerR
            let angle = CGFloat(i) * step - (.pi / 2)
            let pt = CGPoint(x: center.x + cos(angle) * r, y: center.y + sin(angle) * r)
            if i == 0 { path.move(to: pt) } else { path.addLine(to: pt) }
        }
        path.closeSubpath()
        return path
    }
}
