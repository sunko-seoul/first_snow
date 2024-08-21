import CoreBluetooth
import Flutter
import UIKit

class BLEManager: NSObject, ObservableObject {
    private var centralManager: CBCentralManager?
    private var peripheralManager: CBPeripheralManager?
    private var peripherals: [CBPeripheral] = []
    private var centrals: [CBCentral] = []
    @Published var peripheralName: [String] = []
    @Published var centralName: [String] = []
    private let serviceUUID = CBUUID(string: "485EB528-E4F0-4A02-B67D-24BDF8C8BBD3")
    private let characteristicUUID = CBUUID(string: "79998244-9654-4A10-8A29-3976A39FC51C")
    private var methodChannel: FlutterMethodChannel?
    
    override init() {
        super.init()
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: .main)
        self.centralManager = CBCentralManager(delegate: self, queue: .main)
    }
    
    func setMethodChannel(_ channel: FlutterMethodChannel) {
        self.methodChannel = channel
    }

    
    func startAdvertising() {
        guard let peripheralManager = peripheralManager, peripheralManager.state == .poweredOn else { return }
        
        let service = CBMutableService(type: serviceUUID, primary: true)
        let characteristic = CBMutableCharacteristic(
            type: characteristicUUID,
            properties: [.read, .notify],
            value: nil,
            permissions: [.readable]
        )
        service.characteristics = [characteristic]
        peripheralManager.add(service)
        
        let advertisementData = [CBAdvertisementDataServiceUUIDsKey: [serviceUUID]]
        peripheralManager.startAdvertising(advertisementData)
    }
    
    func startScan() {
        if let centralManager = centralManager, centralManager.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        }
    }
}

extension BLEManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            print("startScan!!")
            startScan()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any], rssi RSSI: NSNumber) {
        if !peripherals.contains(peripheral) {
            self.peripherals.append(peripheral)
            let name = peripheral.name ?? "Unknown"
            self.peripheralName.append(name)
            let uuid = peripheral.identifier.uuidString
            let localName = advertisementData[CBAdvertisementDataLocalNameKey] as? String ?? "Unknown"
            let isConnectable = advertisementData[CBAdvertisementDataIsConnectable] as? Bool ?? false
            let manufacturerData = advertisementData[CBAdvertisementDataManufacturerDataKey] as? Data
            let serviceUUIDs = advertisementData[CBAdvertisementDataServiceUUIDsKey] as? [CBUUID] ?? []
            let txPowerLevel = advertisementData[CBAdvertisementDataTxPowerLevelKey] as? Int ?? 0
            let advertisementInfo: [String: Any] = [
               "uuid": uuid,
               "localName": localName,
               "isConnectable": isConnectable,
               "manufacturerData": manufacturerData?.base64EncodedString() ?? "",
               "serviceUUIDs": serviceUUIDs.map { $0.uuidString },
               "txPowerLevel": txPowerLevel
           ]
            methodChannel?.invokeMethod("addPeripheral", arguments: advertisementInfo)
        }
    }
}

extension BLEManager: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            startAdvertising()
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
            if let error = error {
                print("Failed to add service: \(error.localizedDescription)")
            }
    }
}
