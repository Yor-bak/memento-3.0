//
//  RootView.swift
//  Memento_App
//
//  Created by Senior iOS Engineer on 15/10/2026.
//

import SwiftUI
import SwiftData

/// Vista raíz orquestadora de la aplicación Memento.
/// Observa la máquina de estados de `AppCoordinator` y el perfil persistente en SwiftData,
/// presentando la pantalla adecuada con transiciones fluidas.
public struct RootView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var userProfiles: [UserProfile]
    
    @State private var coordinator = AppCoordinator()
    @State private var tempCheckInSubmission: DailyCheckInSubmission? = nil
    
    public init() {}
    
    private var activeProfile: UserProfile {
        if let existing = userProfiles.first {
            return existing
        } else {
            // Inicializar un perfil predeterminado si es la primera ejecución
            let newProfile = UserProfile()
            modelContext.insert(newProfile)
            return newProfile
        }
    }
    
    public var body: some View {
        ZStack {
            switch coordinator.currentState {
                
            // MARK: - Flujo de Primer Lanzamiento / Onboarding
            case .firstLaunch(let step):
                switch step {
                case .welcome:
                    WelcomeView {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            coordinator.advanceFromWelcome()
                        }
                    }
                    .transition(.opacity)
                    
                case .auth:
                    AuthView {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            coordinator.completeAuthentication()
                        }
                    }
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
                    
                case .securitySetup:
                    SetupSecurityView { pin, biometricsEnabled in
                        withAnimation(.easeInOut(duration: 0.5)) {
                            coordinator.completeSecuritySetup(
                                pin: pin,
                                biometricsEnabled: biometricsEnabled,
                                userProfile: activeProfile
                            )
                        }
                    }
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
                    
                case .categorySelection:
                    CategorySelectionView(initialCategory: activeProfile.currentCategory) { selected in
                        withAnimation(.easeInOut(duration: 0.5)) {
                            coordinator.selectCategoryAndProceed(category: selected, userProfile: activeProfile)
                        }
                    }
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
                    
                case .dailyCheckIn:
                    DailyCheckInView { submission in
                        tempCheckInSubmission = submission
                        withAnimation(.easeInOut(duration: 0.5)) {
                            coordinator.advanceFromCheckInToQuestions()
                        }
                    }
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
                    
                case .dailyQuestions:
                    DailyQuestionsView(
                        category: coordinator.selectedCategoryForSession,
                        checkInSubmission: tempCheckInSubmission,
                        userProfile: activeProfile
                    ) {
                        withAnimation(.easeInOut(duration: 0.6)) {
                            coordinator.completeDailyQuestions(userProfile: activeProfile)
                        }
                    }
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
                }
                
            // MARK: - Estado Bloqueado
            case .locked:
                CustomPinLockView(
                    storedPin: activeProfile.pinCode,
                    isBiometricsEnabled: activeProfile.isBiometricsEnabled
                ) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        coordinator.unlockWithSuccess(profile: activeProfile)
                    }
                }
                .transition(.opacity)
                
            // MARK: - Estado Autenticado
            case .authenticated(let destination):
                switch destination {
                case .dailyCheckIn:
                    DailyCheckInView { submission in
                        tempCheckInSubmission = submission
                        withAnimation(.easeInOut(duration: 0.5)) {
                            coordinator.advanceFromCheckInToQuestions()
                        }
                    }
                    .transition(.opacity)
                    
                case .dailyQuestions:
                    DailyQuestionsView(
                        category: coordinator.selectedCategoryForSession,
                        checkInSubmission: tempCheckInSubmission,
                        userProfile: activeProfile
                    ) {
                        withAnimation(.easeInOut(duration: 0.6)) {
                            coordinator.completeDailyQuestions(userProfile: activeProfile)
                        }
                    }
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
                    
                case .galaxy:
                    GalaxyHomeView(
                        userProfile: activeProfile,
                        onLockApp: {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                coordinator.lockApp()
                            }
                        },
                        onTriggerDailyCheckIn: {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                coordinator.currentState = .authenticated(.dailyCheckIn)
                            }
                        }
                    )
                    .transition(.opacity)
                }
            }
        }
        .onAppear {
            coordinator.evaluateInitialState(userProfile: userProfiles.first)
        }
    }
}
