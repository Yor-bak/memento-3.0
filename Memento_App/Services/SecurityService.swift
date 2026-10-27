//
//  SecurityService.swift
//  Memento_App
//
//  Created by Senior iOS Engineer on 15/10/2026.
//

import Foundation
import LocalAuthentication

/// Define los contratos para la autenticación biométrica y validación del PIN de seguridad en Memento.
public protocol SecurityServiceProtocol: Sendable {
    /// Evalúa si el dispositivo actual cuenta con biometría disponible y configurada (Face ID / Touch ID).
    func isBiometricsAvailable() -> Bool
    
    /// Devuelve el nombre del tipo biométrico disponible ("Face ID", "Touch ID" o "Biometría").
    func biometricTypeDescription() -> String
    
    /// Ejecuta la solicitud de autenticación biométrica mediante el framework LocalAuthentication.
    /// - Parameter reason: Motivo mostrado al usuario en el diálogo del sistema operativo.
    /// - Returns: Booleano indicando si la validación fue exitosa.
    func authenticateWithBiometrics(reason: String) async -> Result<Bool, SecurityError>
    
    /// Valida si el PIN ingresado coincide con el PIN configurado en el perfil de usuario.
    func validatePin(entered: String, against stored: String?) -> Bool
}

/// Errores tipados para el servicio de seguridad.
public enum SecurityError: Error, LocalizedError, Sendable {
    case biometricsNotAvailable
    case authenticationFailed
    case userCancelled
    case passcodeNotSet
    case unknown(String)
    
    public var errorDescription: String? {
        switch self {
        case .biometricsNotAvailable:
            return "La autenticación biométrica no está disponible o no está configurada en este dispositivo."
        case .authenticationFailed:
            return "No se pudo verificar tu identidad biométrica."
        case .userCancelled:
            return "La autenticación fue cancelada por el usuario."
        case .passcodeNotSet:
            return "El dispositivo no tiene un código de bloqueo configurado."
        case .unknown(let message):
            return "Error de seguridad: \(message)"
        }
    }
}

/// Implementación estándar de producción y prototipo para `SecurityServiceProtocol`.
public final class SecurityService: SecurityServiceProtocol {
    
    public init() {}
    
    public func isBiometricsAvailable() -> Bool {
        let context = LAContext()
        var error: NSError?
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }
    
    public func biometricTypeDescription() -> String {
        let context = LAContext()
        var error: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return "Biometría"
        }
        
        switch context.biometryType {
        case .faceID:
            return "Face ID"
        case .touchID:
            return "Touch ID"
        case .opticID:
            return "Optic ID"
        case .none:
            return "Código PIN"
        @unknown default:
            return "Biometría"
        }
    }
    
    public func authenticateWithBiometrics(reason: String) async -> Result<Bool, SecurityError> {
        let context = LAContext()
        context.localizedCancelTitle = "Usar PIN"
        
        var nsError: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &nsError) else {
            return .failure(.biometricsNotAvailable)
        }
        
        do {
            let success = try await context.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: reason
            )
            return .success(success)
        } catch let laError as LAError {
            switch laError.code {
            case .userCancel, .appCancel:
                return .failure(.userCancelled)
            case .passcodeNotSet:
                return .failure(.passcodeNotSet)
            case .biometryNotAvailable, .biometryNotEnrolled:
                return .failure(.biometricsNotAvailable)
            default:
                return .failure(.authenticationFailed)
            }
        } catch {
            return .failure(.unknown(error.localizedDescription))
        }
    }
    
    public func validatePin(entered: String, against stored: String?) -> Bool {
        guard let stored, !stored.isEmpty else {
            // Si no hay PIN configurado en el prototipo, se permite el acceso directo.
            return true
        }
        return entered == stored
    }
}
