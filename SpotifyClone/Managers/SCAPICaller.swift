//
//  SCAPICaller.swift
//  SpotifyClone
//
//  Created by Shagara F Nasution on 22/08/23.
//

import Foundation

final class SCAPICaller {
    static let shared = SCAPICaller()
    
    struct Constants {
        static let spotifyAPIBaseURLString = "https://api.spotify.com/v1"
        static let getNewReleasesPath = "/browse/new-releases"
        static let getUserSavedAlbums = "/me/albums"
        static let getFeaturedPlaylistsPath = "/browse/featured-playlists"
        static let getRecommendationGenres = "/recommendations/available-genre-seeds"
        static let getRecommendations = "/recommendations"
        static let getCategories = "/browse/categories"
        static let getSearchedItems = "/search"
    }
    
    enum HTTPMethods: String {
        case GET
        case POST
        case PUT
        case DELETE
    }
    
    enum APIErrors: Error {
        case failedToGetData
    }
    
    private init() {}
    
    //MARK: - Profile
    public func getCurrentUserProfile(
        completion: @escaping (Result<SCUserProfile, Error>) -> Void
    ) {
        createRequest(
            with: URL(string: Constants.spotifyAPIBaseURLString + "/me"),
            type: .GET
        ) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIErrors.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(SCUserProfile.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Browse
    public func getNewReleases(
        completion: @escaping ((Result<SCGetNewReleasesResponse, Error>) -> Void)
    ) {
        createRequest(
            with: URL(string: Constants.spotifyAPIBaseURLString + Constants.getNewReleasesPath + "?limit=50"),
            type: .GET
        ) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIErrors.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(SCGetNewReleasesResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getFeaturedPlaylists(
        completion: @escaping ((Result<SCGetFeaturedPlaylistsResponse, Error>) -> Void)
    ) {
        createRequest(
            with: URL(string: Constants.spotifyAPIBaseURLString + Constants.getFeaturedPlaylistsPath + "?limit=20"),
            type: .GET
        ) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIErrors.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(SCGetFeaturedPlaylistsResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getRecommendations(
        genres: Set<SCGenre>,
        completion: @escaping ((Result<SCGetRecommendationsResponse, Error>) -> Void)
    ) {
        let seeds = genres.joined(separator: ",")
        var urlString = Constants.spotifyAPIBaseURLString + Constants.getRecommendations
        urlString += "?seed_genres=\(seeds)"
        urlString += "&limit=20"
        
        createRequest(
            with: URL(string: urlString),
            type: .GET
        ) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIErrors.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(SCGetRecommendationsResponse.self, from: data)
                    
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getRecommendationGenres(
        completion: @escaping ((Result<SCGetRecommendationGenresResponse, Error>) -> Void)
    ) {
        createRequest(
            with: URL(string: Constants.spotifyAPIBaseURLString + Constants.getRecommendationGenres),
            type: .GET
        ) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIErrors.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(SCGetRecommendationGenresResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Albums
    
    public func getAlbum(
        album: SCAlbum,
        completion: @escaping ((Result<SCGetAlbumResponse, Error>) -> Void)
    ) {
        createRequest(
            with: URL(string: Constants.spotifyAPIBaseURLString + "/albums/" + album.id),
            type: .GET)
        { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIErrors.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(SCGetAlbumResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getUserSavedAlbums(
        comletion: @escaping ((Result<SCGetUserSavedAlbumsResponse, Error>) -> Void)
    ) {
        createRequest(
            with: URL(string: Constants.spotifyAPIBaseURLString + Constants.getUserSavedAlbums),
            type: .GET
        ) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data, error == nil else {
                    comletion(.failure(APIErrors.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(SCGetUserSavedAlbumsResponse.self, from: data)
                    comletion(.success(result))
                } catch {
                    comletion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func addAlbumToLibrary(
        album: SCAlbum,
        completion: @escaping ((Bool) -> Void)
    ) {
        var urlString = Constants.spotifyAPIBaseURLString
        urlString += "/me"
        urlString += "/albums"
        urlString += "?ids=\(album.id)"
        createRequest(
            with: URL(string: urlString),
            type: .PUT
        ) { baseRequest in
            var request = baseRequest
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = URLSession.shared.dataTask(with: request) { _, response, error in
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                      (200..<300) ~= statusCode,
                      error == nil else {
                    print("ERROR: \(error!.localizedDescription)")
                    completion(false)
                    return
                }
                completion(true)
            }
            task.resume()
        }
    }
    
    // MARK: - Playlists
    
    public func getPlaylist(
        playlist: SCSimplifiedPlaylist,
        completion: @escaping ((Result<SCGetPlaylistResponse, Error>) -> Void)
    ) {
        createRequest(
            with: URL(string: Constants.spotifyAPIBaseURLString + "/playlists/" + playlist.id),
            type: .GET
        ) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIErrors.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(SCGetPlaylistResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getCurrentUserPlaylists(
        completion: @escaping ((Result<[SCSimplifiedPlaylist], Error>) -> Void)
    ) {
        getCurrentUserProfile { [weak self] result in
            switch result {
            case .success(let profile):
                var urlString = Constants.spotifyAPIBaseURLString
                urlString += "/users"
                urlString += "/\(profile.id)"
                urlString += "/playlists"
                urlString += "?limit=50"
                
                self?.createRequest(
                    with: URL(string: urlString),
                    type: .GET
                ) { baseRequest in
                    let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                        guard let data = data, error == nil else {
                            completion(.failure(APIErrors.failedToGetData))
                            return
                        }
                        
                        do {
                            let result = try JSONDecoder().decode(SCGetUserPlaylistsResponse.self, from: data)
                            completion(.success(result.items))
                        } catch {
                            completion(.failure(error))
                        }
                    }
                    task.resume()
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func createPlaylist(
        with name: String,
        completion: @escaping ((Result<SCSimplifiedPlaylist, Error>) -> Void)
    ) {
        getCurrentUserProfile { [weak self] result in
            switch result {
            case .success(let profile):
                var urlString = Constants.spotifyAPIBaseURLString
                urlString += "/users"
                urlString += "/\(profile.id)"
                urlString += "/playlists"
                
                self?.createRequest(with: URL(string: urlString), type: .POST) { baseRequest in
                    let bodyJson = [
                        "name": name
                    ]
                    var request = baseRequest
                    request.httpBody = try? JSONSerialization.data(withJSONObject: bodyJson, options: .fragmentsAllowed)
                    let task = URLSession.shared.dataTask(with: request) { data, _, error in
                        guard let data = data, error == nil else {
                            completion(.failure(APIErrors.failedToGetData))
                            return
                        }
                        
                        do {
                            let result = try JSONDecoder().decode(SCSimplifiedPlaylist.self, from: data)
                            completion(.success(result))
                        } catch {
                            completion(.failure(error))
                        }
                    }
                    task.resume()
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func addTrackToPlaylist(
        track: SCTrack,
        playlist: SCSimplifiedPlaylist,
        completion: @escaping (Bool) -> Void
    ) {
        var urlString = Constants.spotifyAPIBaseURLString
        urlString += "/playlists"
        urlString += "/\(playlist.id)"
        urlString += "/tracks"
        
        createRequest(
            with: URL(string: urlString),
            type: .POST
        ) { baseRequest in
            var request = baseRequest
            let json: [String: Any] = [
                "uris": [
                    "spotify:track:\(track.id)"
                ],
                "position": 0
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(false)
                    return
                }
                
                do {
                    if let result = try JSONSerialization.jsonObject(
                        with: data,
                        options: .fragmentsAllowed
                    ) as? [String: Any],
                       result["snapshot_id"] as? String != nil {
                        completion(true)
                    } else {
                        completion(false)
                    }
                } catch {
                    print("ERROR: \(error)")
                    completion(false)
                }
            }
            task.resume()
        }
    }
    
    public func removeTrackFromPlaylist(
        track: SCTrack,
        playlist: SCSimplifiedPlaylist,
        completion: @escaping (Bool) -> Void
    ) {
        var urlString = Constants.spotifyAPIBaseURLString
        urlString += "/playlists"
        urlString += "/\(playlist.id)"
        urlString += "/tracks"
        
        createRequest(
            with: URL(string: urlString),
            type: .DELETE
        ) { baseRequest in
            var request = baseRequest
            let json: [String: Any] = [
                "tracks": [
                    [
                        "uri": "spotify:track:\(track.id)"
                    ],
                ],
                "snapshot_id": playlist.snapshotID
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
            
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(false)
                    return
                }
                
                do {
                    if let result = try JSONSerialization.jsonObject(
                        with: data,
                        options: .fragmentsAllowed
                    ) as? [String: Any],
                       result["snapshot_id"] as? String != nil{
                        completion(true)
                    } else {
                        completion(false)
                    }
                } catch {
                    print("ERROR: \(error.localizedDescription)")
                    completion(false)
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Categories
    
    public func getCategories(
        completion: @escaping ((Result<SCGetCategoriesResponse, Error>) -> Void)
    ) {
        var urlString = Constants.spotifyAPIBaseURLString
        urlString += Constants.getCategories
        urlString += "?limit=50"
        
        createRequest(
            with: URL(string: urlString),
            type: .GET
        ) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIErrors.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(SCGetCategoriesResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getCategoryPlaylists(
        category: SCCategory,
        completion: @escaping ((Result<SCGetFeaturedPlaylistsResponse, Error>) -> Void)
    ) {
        var urlString = Constants.spotifyAPIBaseURLString
        urlString +=  Constants.getCategories
        urlString += "/\(category.id)"
        urlString += "/playlists"
        urlString += "?limit=50"
        
        createRequest(
            with: URL(string: urlString),
            type: .GET
        ) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIErrors.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(SCGetFeaturedPlaylistsResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Searchs
    
    public func getSearchResults(
        q: String,
        completion: @escaping ((Result<SCGetSearchResultsResponse, Error>) -> Void)
    ) {
        guard let query = q.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        var urlString = Constants.spotifyAPIBaseURLString
        urlString += Constants.getSearchedItems
        urlString += "?limit=20"
        urlString += "&type=album,artist,playlist,track"
        urlString += "&q=\(query)"
        
        createRequest(
            with: URL(string: urlString),
            type: .GET
        ) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIErrors.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(SCGetSearchResultsResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    private func createRequest(
        with url: URL?,
        type: HTTPMethods,
        completion: @escaping ((URLRequest) -> Void)
    ) {
        SCAuthManager.shared.withValidToken { token in
            guard let apiUrl = url else {
                return
            }
            
            var request = URLRequest(url: apiUrl)
            request.httpMethod = type.rawValue
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.timeoutInterval = 30
            completion(request)
        }
    }
}


