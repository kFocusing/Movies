//
//  NetworkMonitor.swift
//  Movies
//
//  Created by Danylo Klymov on 09.05.2022.
//

import Network

final class NetworkMonitor {
    //MARK: - Static -
    static let shared = NetworkMonitor()
    
    //MARK: - Constants -
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    
    //MARK: - Variables -
    internal private(set) var isConnected: Bool = false
    
    internal private(set) var connectionType: ConnectionType = .unknown
    
    enum ConnectionType {
        case wifi
        case cellular
        case ethernet
        case unknown
    }
    
    //MARK: - Life Cycle -
    private init() {
        self.monitor = NWPathMonitor()
    }
    
    //MARK: - Internal -
    func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
            self?.getConnectionType(path)
        }
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
    
    private func getConnectionType(_ path: NWPath) {
        if path.usesInterfaceType(.wifi) {
            connectionType = .wifi
        } else if path.usesInterfaceType(.cellular) {
            connectionType = .cellular
        } else if path.usesInterfaceType(.wiredEthernet) {
            connectionType = .ethernet
        } else {
            connectionType = .unknown
        }
    }
}
