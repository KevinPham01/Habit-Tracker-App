import SwiftUI
import ParseSwift

struct ContentView: View {
    @State private var isLoggedIn: Bool = UserDefaults.standard.bool(forKey: "isLoggedIn") // Load login state
    @State private var showingLogin: Bool = false
    @State private var showingSignUp: Bool = false
    @State private var habits: [Habit] = []
    @State private var completedHabits: [Bool] = []
    @State private var completionDate: Date?
    @State private var habitToDelete: IndexSet?
    @State private var showingAddHabit: Bool = false
    @State private var username: String = ""
    @State private var showWelcomeMessage: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                if isLoggedIn {
                    // Show welcome message if logged in
                    if showWelcomeMessage {
                        Text("Welcome, \(username)!")
                            .font(.headline)
                            .padding()
                            .onAppear {
                                // Automatically dismiss the message after a few seconds
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    showWelcomeMessage = false
                                }
                            }
                    }
                    // Main content for logged-in users
                    List {
                        ForEach(habits.indices, id: \.self) { index in
                            NavigationLink(destination: HabitDetailView(habits: $habits, completedHabits: $completedHabits, habit: habits[index])) {
                                HStack {
                                    Text("\(habits[index].name): \(habits[index].streak) \(getFrequencyUnit(habits[index].frequency))")
                                    Spacer()
                                    Image(systemName: completedHabits[index] ? "checkmark.square.fill" : "square")
                                        .foregroundColor(completedHabits[index] ? .green : .gray)
                                        .onTapGesture {
                                            if !isHabitLocked(at: index) {
                                                completeHabit(at: index)
                                            }
                                        }
                                }
                            }
                        }
                        .onDelete { indexSet in
                            habitToDelete = indexSet
                            deleteHabits(at: indexSet)
                        }
                    }
                    .navigationTitle("Habit Dashboard")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Logout") {
                                logout()
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            NavigationLink(destination: SettingsView()) {
                                Image(systemName: "gear")
                            }
                        }
                    }
                    .sheet(isPresented: $showingAddHabit) {
                        AddEditHabitView { newHabit in
                            habits.append(newHabit)
                            completedHabits.append(false)
                        }
                    }
                    
                    Button("Add Habit") {
                        showingAddHabit.toggle()
                    }
                    .padding()
                } else {
                    // Show login or sign-up options
                    VStack {
                        Text("Please log in or sign up")
                            .font(.headline)
                            .padding()

                        Button("Login") {
                            showingLogin.toggle()
                        }
                        .sheet(isPresented: $showingLogin) {
                            LoginView(showingLogin: $showingLogin, isLoggedIn: $isLoggedIn)
                        }

                        Button("Sign Up") {
                            showingSignUp.toggle()
                        }
                        .sheet(isPresented: $showingSignUp) {
                            SignUpView(showingSignUp: $showingSignUp, isLoggedIn: $isLoggedIn)
                        }
                    }
                }
            }
        }
        .onAppear(perform: loadData)
    }
    
    private func completeHabit(at index: Int) {
        completedHabits[index] = true
        habits[index].streak += 1
        completionDate = Date()
        saveData()
    }
    
    private func logout() {
        User.logout { result in
            switch result {
            case .success:
                print("✅ Successfully logged out")
                isLoggedIn = false
                habits.removeAll()
                completedHabits.removeAll()
            case .failure(let error):
                print("Error logging out: \(error.localizedDescription)")
            }
        }
    }
    
    private func isHabitLocked(at index: Int) -> Bool {
        if let completionDate = completionDate {
            return completedHabits[index] && Calendar.current.isDateInToday(completionDate)
        }
        return false
    }
    
    private func getFrequencyUnit(_ frequency: String) -> String {
        switch frequency {
            case "Daily": return "days"
            case "Weekly": return "weeks"
            case "Monthly": return "months"
            default: return "days"
        }
    }
    
    private func saveData() {
        if let encoded = try? JSONEncoder().encode(habits) {
            UserDefaults.standard.set(encoded, forKey: "SavedHabits")
        }
        UserDefaults.standard.set(completedHabits, forKey: "CompletedHabits")
        if let completionDate = completionDate {
            UserDefaults.standard.set(completionDate, forKey: "CompletionDate")
        }
    }
    
    private func loadData() {
        if let savedHabits = UserDefaults.standard.data(forKey: "SavedHabits"),
           let decodedHabits = try? JSONDecoder().decode([Habit].self, from: savedHabits) {
            habits = decodedHabits
        }
        
        completedHabits = UserDefaults.standard.array(forKey: "CompletedHabits") as? [Bool] ?? Array(repeating: false, count: habits.count)
        completionDate = UserDefaults.standard.object(forKey: "CompletionDate") as? Date
    }
    
    private func deleteHabits(at offsets: IndexSet) {
        habits.remove(atOffsets: offsets)
        completedHabits.remove(atOffsets: offsets)
        saveData()
    }
}

// Login View
struct LoginView: View {
    @Binding var showingLogin: Bool
    @Binding var isLoggedIn: Bool
    @State private var username: String = ""
    @State private var password: String = ""

    var body: some View {
        NavigationView {
            Form {
                TextField("Username", text: $username)
                SecureField("Password", text: $password)

                Button("Login") {
                    login()
                }
            }
            .navigationTitle("Login")
            .navigationBarItems(trailing: Button("Cancel") {
                showingLogin = false
            })
        }
    }

    private func login() {
        User.login(username: username, password: password) { result in
            switch result {
            case .success:
                print("✅ Successfully logged in")
                isLoggedIn = true
                UserDefaults.standard.set(true, forKey: "isLoggedIn") // Save login state
                showingLogin = false
            case .failure(let error):
                print("Error logging in: \(error.localizedDescription)")
            }
        }
    }
}


// Sign Up View
struct SignUpView: View {
    @Binding var showingSignUp: Bool
    @Binding var isLoggedIn: Bool
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        NavigationView {
            Form {
                TextField("Username", text: $username)
                TextField("Email", text: $email)
                SecureField("Password", text: $password)

                Button("Sign Up") {
                    signUp()
                }
            }
            .navigationTitle("Sign Up")
            .navigationBarItems(trailing: Button("Cancel") {
                showingSignUp = false
            })
        }
    }

    private func signUp() {
        var newUser = User()
        newUser.username = username
        newUser.email = email
        newUser.password = password

        newUser.signup { result in
            switch result {
            case .success:
                print("✅ Successfully signed up")
                isLoggedIn = true
                showingSignUp = false
            case .failure(let error):
                print("Error signing up: \(error.localizedDescription)")
            }
        }
    }
}

