import SwiftUI

struct ContentView: View {
    @State private var inputKey: String = ""
    @State private var searchResult: String = ""
    
    var managedConfig: [String: AnyObject] {
        fetchAppConfig()
    }
    
    var body: some View {
        mainContent
    }
    
    private var mainContent: some View {
        VStack(spacing: 20) {
            titleSection
            keyInputSection
            searchResultSection
            Divider()
            configDisplaySection
            Spacer()
        }
        .padding()
    }
    
    private var titleSection: some View {
        Text("MAC Check-chan😘")
            .font(.largeTitle)
            .padding()
    }
    
    private var keyInputSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Enter Key to Search:")
                .font(.headline)
            
            HStack {
                TextField("Enter key name", text: $inputKey)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Search") {
                    searchForKey()
                }
                .disabled(inputKey.isEmpty)
            }
        }
        .padding()
    }
    
    @ViewBuilder
    private var searchResultSection: some View {
        if !searchResult.isEmpty {
            VStack(alignment: .leading, spacing: 5) {
                Text("Result:")
                    .font(.headline)
                
                Text(searchResult)
                    .font(.system(size: 14))
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }
            .padding()
        }
    }
    
    private var configDisplaySection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("All Managed Configuration:")
                .font(.headline)
            
            configScrollView
        }
        .padding()
    }
    
    private var configScrollView: some View {
        ScrollView {
            configContent
        }
        .frame(maxHeight: 300)
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
    
    @ViewBuilder
    private var configContent: some View {
        if managedConfig.isEmpty {
            Text("No managed configuration found")
                .foregroundColor(.secondary)
                .italic()
        } else {
            VStack(alignment: .leading, spacing: 8) {
                ForEach(Array(managedConfig.keys.sorted()), id: \.self) { key in
                    configRow(key: key, value: managedConfig[key])
                }
            }
        }
    }
    
    private func configRow(key: String, value: AnyObject?) -> some View {
        HStack(alignment: .top) {
            Text("\(key):")
                .font(.system(size: 14, weight: .medium))
                .frame(minWidth: 100, alignment: .leading)
            
            Text(formatValue(value))
                .font(.system(size: 14))
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .padding(.vertical, 2)
    }
    
    private func fetchAppConfig() -> [String: AnyObject] {
        return UserDefaults.standard.dictionary(forKey: "com.apple.configuration.managed") as? [String: AnyObject] ?? [:]
    }
    
    private func searchForKey() {
        let config = fetchAppConfig()
        
        if let value = config[inputKey] {
            searchResult = "Key: \(inputKey)\nValue: \(formatValue(value))\nType: \(type(of: value))"
        } else {
            searchResult = "Key '\(inputKey)' not found in managed configuration"
        }
    }
    
    private func formatValue(_ value: AnyObject?) -> String {
        guard let value = value else {
            return "nil"
        }
        
        if let stringValue = value as? String {
            return "\"\(stringValue)\""
        } else if let numberValue = value as? NSNumber {
            return "\(numberValue)"
        } else if let boolValue = value as? Bool {
            return "\(boolValue)"
        } else if let arrayValue = value as? [Any] {
            return "[\(arrayValue.count) items]"
        } else if let dictValue = value as? [String: Any] {
            return "{\(dictValue.count) keys}"
        } else {
            return "\(value)"
        }
    }
}

#Preview {
    ContentView()
}
