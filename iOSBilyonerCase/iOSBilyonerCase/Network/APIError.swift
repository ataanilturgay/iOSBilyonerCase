//
//  APIError.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 5.05.2025.
//

import Foundation

struct ApiError: Decodable, Error {
    
    let code: String
    let message: String

    static var unknown: ApiError {
        return ApiError(code: "unknown", message: "Bilinmeyen bir hata oluştu.")
    }

    static var network: ApiError {
        return ApiError(code: "network", message: "İnternet bağlantınızı kontrol edin.")
    }

    static var parse: ApiError {
        return ApiError(code: "parse", message: "Veri çözümlenemedi.")
    }
    
    static var typeMismatch: ApiError {
        return ApiError(code: "typeMismatch", message: "Yanlış modelleme durumu.")
    }
}
