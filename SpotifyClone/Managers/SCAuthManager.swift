//
//  SCAuthManager.swift
//  SpotifyClone
//
//  Created by Shagara F Nasution on 22/08/23.
//

import Foundation

final class SCAuthManager {
    public static let shared = SCAuthManager()
    
    struct Constants {
        static let clientId = "b942ce8e965c447fb120c26891b60144"
        static let clientSecret = "49b064b2f0e54c6e8dd14e171081cbf6"
        static let spotifyAccountBaseURLString = "https://accounts.spotify.com"
        static let tokenAPIURLString = "https://accounts.spotify.com/api/token"
        static let redirectURI = "https://github.com/shagaranasution"
        static let scope = "user-read-private%20playlist-modify-public%20playlist-modify-private%20playlist-read-private%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email"
    }
    
    private var isRefreshingToken = false
    private var onRefreshBlocks: [((String) -> Void)] = []
    
    // MARK: - Initialization
    
    private init() {}
    
    public var isSignedIn: Bool {
        return accessToken != nil
    }
    
    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: "accessToken")
    }
    
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "refreshToken")
    }
    
    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    
    private var shouldRefreshToken: Bool {
        guard let expirationDate = tokenExpirationDate else {
            return false
        }
        let currentDate = Date()
        let fineMinutes = 5 * 60
        
        return currentDate.addingTimeInterval(TimeInterval(fineMinutes)) >= expirationDate
    }
    
    public var signInURL: URL? {
        let scope = Constants.scope
        let baseUrlString = Constants.spotifyAccountBaseURLString
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "client_id", value: Constants.clientId),
            URLQueryItem(name: "scope", value: scope),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "show_dialog", value: "TRUE"),
        ]
        guard var url = URL(string: baseUrlString) else { return nil }
        
        if #available(iOS 16.0, *) {
            url.append(path: "authorize")
            url.append(queryItems: queryItems)
        } else {
            let queryString = queryItems.enumerated().reduce("?", { accumulate, current in
                let name = current.element.name
                let value = current.element.value ?? ""
                let queryItemString = accumulate + name + "=" + value
                if current.offset < queryItems.count - 1 {
                    return queryItemString + "&"
                }
                
                return queryItemString
            })
            let string = baseUrlString + "/authorize" + queryString
            return URL(string: string)
        }
        
        return url
    }
    
    private func cacheToken(fromData data: SCAuthResponse) {
        UserDefaults.standard.set(data.accessToken, forKey: "accessToken")
        UserDefaults.standard.set(Date().addingTimeInterval(TimeInterval(data.expiresIn)), forKey: "expirationDate")
        if let refreshToken = data.refreshToken {
            UserDefaults.standard.set(refreshToken, forKey: "refreshToken")
        }
    }
    
    public func requestExchangeToToken(
        forCode code: String,
        completion: @escaping ((_ success: Bool) -> Void)
    ) {
        guard let url = URL(string: Constants.tokenAPIURLString) else {
            return
        }
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "code",
                         value: code),
            URLQueryItem(name: "redirect_uri",
                         value: Constants.redirectURI),
            URLQueryItem(name: "grant_type",
                         value: "authorization_code"),
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = components.query?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let basicCredential = Constants.clientId+":"+Constants.clientSecret
        let data = basicCredential.data(using: .utf8)
        
        guard let base64String = data?.base64EncodedString() else {
            print("Failure to get base64 string")
            completion(false)
            return
        }
        
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data,
                  error == nil else {
                completion(false)
                return
            }
            
            do {
                let data = try JSONDecoder().decode(SCAuthResponse.self, from: data)
                self?.cacheToken(fromData: data)
                completion(true)
            } catch {
                print(error.localizedDescription)
                completion(false)
            }
        }
        task.resume()
    }
    
    public func withValidToken(
        completion: @escaping ((_ token: String) -> Void)
    ) {
        guard !isRefreshingToken else {
            onRefreshBlocks.append(completion)
            return
        }
        
        if shouldRefreshToken {
            refreshAccessTokenIfNeeded { [weak self] sucess in
                if let token = self?.accessToken, sucess {
                    completion(token)
                }
            }
        } else if let token = self.accessToken {
            completion(token)
        }
        
    }
    
    public func refreshAccessTokenIfNeeded(
        completion: ((_ sucess: Bool) -> Void)?
    ) {
        guard shouldRefreshToken else {
            completion?(true)
            return
        }
        
        guard let refreshToken = self.refreshToken else {
            return
        }
        
        guard let url = URL(string: Constants.tokenAPIURLString) else {
            return
        }
        
        isRefreshingToken = true
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type",
                         value: "refresh_token"),
            URLQueryItem(name: "refresh_token",
                         value: refreshToken),
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = components.query?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let basicCredential = Constants.clientId+":"+Constants.clientSecret
        let data = basicCredential.data(using: .utf8)
        
        guard let base64String = data?.base64EncodedString() else {
            print("Failure to get base64 string")
            completion?(false)
            return
        }
        
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            self?.isRefreshingToken = false
            
            guard let data = data,
                  error == nil else {
                completion?(false)
                return
            }
            
            do {
                let data = try JSONDecoder().decode(SCAuthResponse.self, from: data)
                self?.onRefreshBlocks.forEach { $0(data.accessToken) }
                self?.onRefreshBlocks.removeAll()
                self?.cacheToken(fromData: data)
                completion?(true)
            } catch {
                print(error.localizedDescription)
                completion?(false)
            }
        }
        task.resume()
    }
    
    public func singOut(completion: (Bool) -> Void) {
        UserDefaults.standard.set(nil, forKey: "accessToken")
        UserDefaults.standard.set(nil, forKey: "expirationDate")
        UserDefaults.standard.set(nil, forKey: "refreshToken")
        completion(true)
    }
}
