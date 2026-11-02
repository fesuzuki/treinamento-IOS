import SwiftUI


// view principal
struct ContentView: View {
    
    @State private var turma: Turma = Turma()
    @State private var showCadastroForm: Bool = false
    @State private var aluno: Aluno = Aluno()
    @State private var selectedTab = 0
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var alunoSelecionado: Aluno? = nil
    
    private var isNomeValido: Bool {
        !aluno.nome.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private var isNota1Valida: Bool {
        guard let nota1 = aluno.nota1 else { return false }
        return nota1 >= 0 && nota1 <= 10
    }
    
    private var isNota2Valida: Bool {
        guard let nota2 = aluno.nota2 else { return false }
        return nota2 >= 0 && nota2 <= 10
    }
    
    private var isFormValido: Bool {
        isNomeValido && isNota1Valida && isNota2Valida
    }
    
    private func isNotaMaiorMedia(nota:Float) -> Bool {
        return nota >= 7
    }
    
    
    private func adicionarAluno() {
        if !isNomeValido {
            alertMessage = "O campo de nome não pode ser vazio."
            showAlert = true
            return
        }
        
        guard let nota1 = aluno.nota1 else {
            alertMessage = "O campo da nota 1 não pode ser vazio."
            showAlert = true
            return
        }
        
        guard (0...10).contains(nota1) else {
            alertMessage = "O valor da nota 1 deve ser entre 0 e 10."
            showAlert = true
            return
        }
        
        guard let nota2 = aluno.nota2 else {
            alertMessage = "O campo da nota 2 não pode ser vazio."
            showAlert = true
            return
        }
        
        guard (0...10).contains(nota2) else {
            alertMessage = "O valor da nota 2 deve ser entre 0 e 10."
            showAlert = true
            return
        }
        
        turma.adicionar(aluno: aluno)
        aluno = Aluno()
        showCadastroForm = false
    }
    
    
    var body: some View {
        
        
        
        VStack{
            
            HStack{
                Image(systemName: "graduationcap.circle")
                    .font(.system(size: 40))
                    .foregroundStyle(.blue)
                
                Text("Minha Turma")
                    .font(.system(size: 30))
            }
        }
        
        
        TabView( selection: $selectedTab){
            
            viewTurma.tabItem(){
                Label("Turma", systemImage: "person.3.fill")
            }.tag(0)
            
            
            viewAluno.tabItem(){
                Label("Detalhe", systemImage: "person.crop.circle")
            }.tag(1)
            
            
        }
        .popover(isPresented: $showCadastroForm) {
            Form {
                Section {
                    TextField("Nome", text: $aluno.nome)
                        .textFieldStyle(.roundedBorder)
                } header: {
                    Text("Dados do Aluno")
                } footer: {
                    if !isNomeValido {
                        Text("O campo de nome não pode ser vazio.")
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                }
                
                Section {
                    TextField("Nota 1 (0 a 10)", value: $aluno.nota1, format: .number)
                        .keyboardType(.decimalPad)
                    if aluno.nota1 == nil {
                        Text("O campo da nota 1 não pode ser vazio.")
                            .font(.caption)
                            .foregroundStyle(.red)
                    } else if let nota1 = aluno.nota1, (nota1 < 0 || nota1 > 10) {
                        Text("A nota 1 deve ser entre 0 e 10.")
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                    
                    TextField("Nota 2 (0 a 10)", value: $aluno.nota2, format: .number)
                        .keyboardType(.decimalPad)
                    if aluno.nota2 == nil {
                        Text("O campo da nota 2 não pode ser vazio.")
                            .font(.caption)
                            .foregroundStyle(.red)
                    } else if let nota2 = aluno.nota2, (nota2 < 0 || nota2 > 10) {
                        Text("A nota 2 deve ser entre 0 e 10.")
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                } header: {
                    Text("Notas do aluno")
                } footer: {
                    Text("As notas são obrigatórias e devem estar entre 0 e 10.")
                        .font(.caption)
                }
                
                Button(action: {
                    adicionarAluno()
                }) {
                    Label(
                        "Adicionar Aluno",
                        systemImage: "person.crop.circle.badge.plus"
                    )
                }
            }
            .alert("Aviso", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
            .onSubmit {
                adicionarAluno()
            }
        }
        
        Button(action: {
            aluno = Aluno()
            showCadastroForm.toggle()
        }) {
            Label("Adicionar Aluno", systemImage: "person.badge.plus")
                .labelStyle(.automatic)
                .backgroundStyle(.blue)
                .foregroundStyle(.blue)
        }
        
    }
    
    
    
    var viewTurma: some View {
        VStack {
            Spacer()
            Grid(
                alignment: .leading,
                horizontalSpacing: 5,
                verticalSpacing: 5
            ){
                GridRow{
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.orange.opacity(0.5))
                        .frame(width: 150, height: 120)
                        .overlay (
                            VStack{
                                Text("\(turma.listaAlunos.count)")
                                    .fontWeight(.bold)
                                    .font(.system(size: 30))
                                Text("Total Alunos")
                            }
                        )
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.orange.opacity(0.5))
                        .frame(width: 150, height: 120)
                        .overlay (
                            VStack{
                                Text(String(format: "%.2f", turma.mediaClasse()))
                                    .foregroundStyle(isNotaMaiorMedia(nota: turma.mediaClasse()) ? .green : .red)
                                    .fontWeight(.bold)
                                    .font(.system(size: 30))
                                Text("Media da turma")
                            }
                        )
                    
                }
                GridRow{
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.orange.opacity(0.5))
                        .frame(width: 150, height: 120)
                        .overlay (
                            VStack{
                                Text("\(turma.aprovados())")
                                    .fontWeight(.bold)
                                    .font(.system(size: 30))
                                HStack {
                                    Text("Aprovados")
                                    Image(systemName: "checkmark.square.fill")
                                        .foregroundStyle(.green)
                                }
                            }
                        )
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.orange.opacity(0.5))
                        .frame(width: 150, height: 120)
                        .overlay (
                            VStack{
                                Text("\(turma.reprovados())")
                                    .fontWeight(.bold)
                                    .font(.system(size: 30))
                                HStack{
                                    Text("Reprovados")
                                    Image(systemName: "xmark.square")
                                        .foregroundStyle(.red)
                                } //
                            }
                        )
                    
                }
            }
            
            Spacer()
            
            List(turma.listaAlunos, id: \.self.id) { aluno in
                HStack {
                    Text(aluno.nome)
                    Spacer()
                    Button("", systemImage: "trash"){
                        turma.remover(aluno: aluno)
                    }.foregroundStyle(.red)
                    
                }
                
            }
            
        }
    }
    
    var viewAluno: some View {
        VStack {
            List(turma.listaAlunos, id: \.self.id) { aluno in
                HStack {
                    Text(aluno.nome)
                    Spacer()
                    Button("", systemImage: "magnifyingglass") {
                        alunoSelecionado = aluno
                    }
                    .foregroundStyle(.blue)
                }
            }
            .sheet(item: $alunoSelecionado) { aluno in
                detalheView(alunoSheet: aluno)
            }
        }
    }
    
    // SheetView
    
    struct detalheView: View {
        
        // Environment var that can dismiss the sheet
        @Environment(\.dismiss) var dismiss
        
        private func isNotaMaiorMedia(nota:Float) -> Bool {
            return nota >= 7
        }
        
        let alunoSheet: Aluno
        
        var body: some View {
            
            ScrollView{
                
                VStack (spacing: 20){
                    
                    VStack (spacing: 8){ // header
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 72, height: 72)
                            .foregroundStyle(.blue)
                        
                        Text(alunoSheet.nome)
                            .font(.title2).bold()
                    }
                    HStack(spacing: 12){
                        VStack(alignment: .leading){
                            Text("Média")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(String(format: "%.2f", alunoSheet.media()))
                                .font(.system(size: 32, weight: .bold, design: .rounded ))
                                .foregroundStyle(alunoSheet.passou() ? .green : .red)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding().background(Color(.white)).cornerRadius(16)
                        
                        VStack(alignment: .leading){
                            Text("Situação")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            HStack(spacing: 4){
                                Image(systemName: alunoSheet.passou() ? "checkmark.circle.fill" : "xmark.circle.fill")
                                Text(alunoSheet.passou() ? "Aprovado" : "Reprovado")
                            }.foregroundStyle(alunoSheet.passou() ? .green : .red).padding(3)
                            
                        }.frame(maxWidth: .infinity, alignment: .leading)
                            .padding().background(Color(.white)).cornerRadius(16)
                    }.padding(.horizontal, 2)
                    
                    
                    VStack(alignment: .leading, spacing: 12){
                        Text("Histórico de avaliações").font(.headline)
                        HStack{
                            Text ("Avaliação 01")
                            Spacer()
                            Text(String(format: "%.2f", alunoSheet.nota1 ?? 0))
                                .foregroundStyle(isNotaMaiorMedia(nota: alunoSheet.nota1!) ? .green : .red)
                        }
                        HStack{
                            Text ("Avaliação 01")
                            Spacer()
                            Text(String(format: "%.2f", alunoSheet.nota2 ?? 0))
                                .foregroundStyle(isNotaMaiorMedia(nota: alunoSheet.nota2!) ? .green : .red)
                        }
                    }
                    
                    
                    
                    
                    
                    // Button to dismiss the sheet
                    Button("fechar") {
                        // Triggers the environment var to dismiss the sheet
                        dismiss()
                    }.buttonStyle(.bordered)
                    
                }.padding()
            }.background(Color(.systemGroupedBackground))
        }
        
    }
}

#Preview {
    ContentView()
}
