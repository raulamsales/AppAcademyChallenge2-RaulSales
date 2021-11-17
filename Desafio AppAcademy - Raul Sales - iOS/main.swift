//
//  main.swift
//  Desafio AppAcademy
//
//  Created by Raul Sales on 20/10/21.
//

import Foundation

// Importa lista com os dados para o projeto
extension String{
    func fileName() -> String {
        return URL(fileURLWithPath: self).deletingPathExtension().lastPathComponent
    }
    func fileExtension() -> String{
        return URL(fileURLWithPath: self).pathExtension
    }
}

    func readCSV(inputFile: String, separator: String) -> [String]{
        let urlFile: String = #filePath
        let urlCsv = urlFile.dropLast(10)
        let csvPath = "\(urlCsv)AppAcademy_Candidates.csv"
        let inputFile = URL(fileURLWithPath: csvPath )
        do {
            let savedData = try String(contentsOf: inputFile)
            return savedData.components(separatedBy: separator)
        }
        catch {
            return ["error"]
        }
    }

// Coloca a lista .csv dentro de um array
var myData = readCSV(inputFile: "AppAcademy_Candidates.csv", separator: ";")

struct Candidato {
    var nome: String
    var vaga: String
    var idade: Int
    var estado: String
}

// Remove "\r\n" e "anos"
var arrayList: [String] = myData
var ageList: [Int] = []
var counterA = 0
var counterB = arrayList.count

while (counterA < counterB) {
    if arrayList[counterA].contains("\r\n") {
        let b = arrayList[counterA].split { $0 == "\n" || $0 == "\r\n" }.map(String.init)
        arrayList.insert(b[0], at: counterA)
        arrayList.insert(b[1], at: counterA + 1)
        arrayList.remove(at: counterA + 2)
        counterB += 1
    }
    if arrayList[counterA].contains("anos") {
        let anos = arrayList[counterA].trimmingCharacters(in: CharacterSet(charactersIn: "0123456789.").inverted)
        ageList.append(Int(anos)!)
    }
    counterA += 1
}

// Remove os headers da lista (Nome;Vaga;Idade;Estado)
for _ in 0...3 {
    arrayList.remove(at: 0)
}
 
// Cria um array com structs que recebe a lista de candidatos
var listaCandidatos: [Candidato] = []
var nomeIndex = 0
var vagaIndex = 1
var idadeIndex = 0
var estadoIndex = 3

for _ in 0...arrayList.count-1 {
    if nomeIndex <= arrayList.count-1 {
        listaCandidatos.append(Candidato(nome: arrayList[nomeIndex], vaga: arrayList[vagaIndex], idade: (ageList[idadeIndex]), estado: arrayList[estadoIndex]))
        nomeIndex += 4
        vagaIndex += 4
        idadeIndex += 1
        estadoIndex += 4
    }
}

// Cria array com apenas os nomes da lista de candidatos
var nameList = [String]()
for candidato in 0...listaCandidatos.count-1 {
    nameList.append(listaCandidatos[candidato].nome)
}

// Organiza a lista de nomes alfabeticamente em pt-br
let ptBR = Locale(identifier: "pt-br")
let sortedNames = nameList.sorted {
    $0.compare($1, locale: ptBR) == .orderedAscending
}

// Cria um array de structs organizado alfabeticamente em pt-br
var candidatos: [Candidato] = []
counterA = 0
counterB = 0
var boolC = true

while counterB < 230 {
    while boolC {
        if sortedNames[counterB] == listaCandidatos[counterA].nome {
            candidatos.append(listaCandidatos[counterA])
            boolC = false
        }
        counterA += 1
    }
    counterB += 1
    if counterB < 230 {
        boolC = true
        counterA = 0
    }
}

// Exporta arquivo .csv em ordem alfabética
var csvFile = "Nome;Vaga;Idade;Estado\r\n"

for candidato in candidatos {
    csvFile += "\(candidato.nome);\(candidato.vaga);\(String(candidato.idade)) anos;\(candidato.estado)\r\n"
}

let urlFile: String = #file
let urlSortedCsv = urlFile.dropLast(48)
let fileName = "Sorted_AppAcademy_Candidates"
let fileURL = URL(fileURLWithPath: ("\(urlSortedCsv)\(fileName).csv") )
let writeString = csvFile

do {
    try writeString.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
} catch let error as NSError {
    print("Failed to write to URL")
    print(error)
}

do {
    var _ = try String(contentsOf: fileURL)
} catch let error as NSError {
    print("Failed to read file")
    print(error)
}


/* ==================== ATIVIDADES ==================== */

let totalCandidatos = candidatos.count
var candidatosAPI = 0.0
var candidatosQA = 0.0
var candidatosIOS = 0.0
var maisVelhoIOS = candidatos[0]
var somaIdadeQA = 0
var maisNovoAPI = candidatos[0]
var somaIdadeAPI = 0
var numEstados = [String]()
var instrutorIOS: [Candidato] = []

for candidato in candidatos {
    if candidato.vaga == "API .NET"{
        candidatosAPI += 1
        somaIdadeAPI += candidato.idade
        if candidato.idade < maisNovoAPI.idade {
            maisNovoAPI = candidato
        }
    }
    if candidato.vaga == "QA" {
        candidatosQA += 1
        somaIdadeQA += candidato.idade
    }
    if candidato.vaga == "iOS" {
        candidatosIOS += 1
        if candidato.idade > maisVelhoIOS.idade {
            maisVelhoIOS = candidato
        }
    }
    if !numEstados.contains(candidato.estado) {
        numEstados.append(candidato.estado)
    }
}

// Porcentagem de Vagas
let porcentAPI = (candidatosAPI/Double(totalCandidatos)) * 100
let porcentQA = (candidatosQA/Double(totalCandidatos)) * 100
let porcentIOS = (candidatosIOS/Double(totalCandidatos)) * 100

// Checagem número primo
func numPrimo(n: Int) -> Bool {
    return n > 1 && !(2..<n).contains { n % $0 == 0 }
}

// Encontrar instrutor iOS
let nameFormat = PersonNameComponentsFormatter()
for candidato in candidatos {
    if (candidato.idade > 20) &&
       (candidato.idade < 31) &&
       (candidato.vaga != "iOS") &&
       (candidato.idade % 2 == 1) &&
       (candidato.estado == "SC") &&
       (numPrimo(n: candidato.idade)) {
        if let splitName = nameFormat.personNameComponents(from: candidato.nome), let firstLetter = splitName.familyName?.first {
            if firstLetter == "V" {
                instrutorIOS.append(candidato)
            }
        }
    }
}

// RESPOSTAS

// 1) Mostrar a porcentagem de candidatos de API .NET, iOS e QA
print("1️⃣ A porcentagem de candidatos por vaga:")
print(" • API .NET  \(Int(porcentAPI))%")
print(" • QA        \(Int(porcentQA))%")
print(" • iOS       \(Int(porcentIOS))%")

// 2) Mostrar a idade média dos candidatos de QA
print("\n2️⃣ A idade média dos candidatos de QA é \(somaIdadeQA/Int(candidatosQA)) anos.")

// 3) Mostrar o candidato mais velho entre os candidatos de iOS
print("\n3️⃣ O candidato mais velho entre os candidatos de iOS é \(maisVelhoIOS.nome), de \(maisVelhoIOS.idade) anos de idade.")

// 4) Mostrar o candidato mais novo entre todos os candidatos API .NET
print("\n4️⃣ O candidato mais novo entre os candidatos de API .NET é \(maisNovoAPI.nome), de \(maisNovoAPI.idade) anos de idade.")

// 5) Mostrar a soma da idade de todos os candidatos do API .NET
print("\n5️⃣ A soma da idade de todos os candidatos de API .NET é \(somaIdadeAPI).")

// 6) Mostrar o número de estados distintos presentes na lista
print("\n6️⃣ Existem \(numEstados.count) estados distintos na lista.")

// 7) Mostrar o nome do instrutor da vaga para qual você se inscreveu
print("\n7️⃣ Encontrei o instrutor de iOS 🥸, com o nome \(instrutorIOS[0].nome) de \(instrutorIOS[0].idade) anos, na vaga de \(instrutorIOS[0].vaga), de \(instrutorIOS[0].estado).\n\n👏\n")

