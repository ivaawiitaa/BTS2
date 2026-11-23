//
//  ContentView.swift
//  BTS
//
//  Created by Guest User on 14/10/26.
//

import SwiftUI
import MapKit

//Funcion sencilla para saber hacia donde se deslizo el dedo
func direccionGesto(_ valor: DragGesture.Value) -> String {
    let x = valor.translation.width
    let y = valor.translation.height
    if abs(x) > abs(y) {
        if x < -50 { return "izquierda" }
        if x > 50 { return "derecha" }
    } else {
        if y < -50 { return "arriba" }
        if y > 50 { return "abajo" }
    }
    return ""
}

//Gesto de las secciones: derecha = regresar al inicio, izquierda = siguiente seccion
func gestoSeccion(_ valor: DragGesture.Value, ruta: Binding<[String]>, siguiente: String) {
    let direccion = direccionGesto(valor)
    if direccion == "derecha" {
        ruta.wrappedValue.removeAll()
    }
    if direccion == "izquierda" {
        ruta.wrappedValue = [siguiente]
    }
}

struct ContentView: View {
    @State private var ruta: [String] = []

    var body: some View {
        NavigationStack(path: $ruta){
            ScrollView{
                VStack (spacing: 20){
                    Text("BTS").font(.largeTitle).bold().multilineTextAlignment(.center)
                    Text("방탄소년단 - Bangtan Boys").foregroundStyle(.secondary)
                    Image("LogoBTS").resizable().scaledToFit().frame(maxHeight: 200).clipShape(RoundedRectangle(cornerRadius: 16))
                    Text("BTS es una boyband de Corea del Sur formada por Big Hit Entertainment. Debutaron en 2013 y son 7 integrantes: RM, Jin, Suga, J-Hope, Jimin, V y Jungkook. Son uno de los grupos más famosos del mundo y sus fans se llaman ARMY 💜")
                        .multilineTextAlignment(.center)
                    Text("Selecciona lo que deseas conocer").font(.headline)
                    Text("Tip: desliza ← para Historia o → para Integrantes").font(.caption).foregroundStyle(.secondary)

                    NavigationLink(value: "Historia"){
                        BotonMenu(
                            titulo: "Historia",
                            simbolo: "book.closed",
                            color: .blue
                        )
                    }

                    NavigationLink(value: "Integrantes"){
                        BotonMenu(
                            titulo: "Integrantes",
                            simbolo: "person.3.fill",
                            color: .purple
                        )
                    }

                    NavigationLink(value: "Logros"){
                        BotonMenu(
                            titulo: "Logros y premios",
                            simbolo: "trophy.fill",
                            color: .orange
                        )
                    }

                    NavigationLink(value: "Tour"){
                        BotonMenu(
                            titulo: "Tour Arirang",
                            simbolo: "music.mic",
                            color: .red
                        )
                    }

                    NavigationLink(value: "Mexico"){
                        BotonMenu(
                            titulo: "BTS en Mexico",
                            simbolo: "flag.fill",
                            color: .green
                        )
                    }

                    NavigationLink(value: "Army"){
                        BotonMenu(
                            titulo: "ARMY",
                            simbolo: "heart.fill",
                            color: .pink
                        )
                    }
                }
                .padding()
            }
            .background(Color.purple.opacity(0.05))
            .simultaneousGesture(
                DragGesture(minimumDistance: 30).onEnded { valor in
                    let direccion = direccionGesto(valor)
                    if direccion == "izquierda" { ruta.append("Historia") }
                    if direccion == "derecha" { ruta.append("Integrantes") }
                }
            )
            .navigationTitle("💜 Conoce a BTS")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: String.self) { seccion in
                switch seccion {
                case "Historia": HistoriaView(ruta: $ruta)
                case "Integrantes": IntegrantesView(ruta: $ruta)
                case "Logros": LogrosView(ruta: $ruta)
                case "Tour": TourView(ruta: $ruta)
                case "Mexico": MexicoView(ruta: $ruta)
                default: ArmyView(ruta: $ruta)
                }
            }
        }
    }
}

//Diseno reutilizable para los botones
struct BotonMenu: View {
    let titulo: String
    let simbolo: String
    let color: Color

    var body: some View {
        HStack(spacing: 12){
            Image(systemName: simbolo).font(.title2).frame(width: 30)
            Text(titulo).font(.headline)
            Spacer()
            Image(systemName: "chevron.right")
        }
        .foregroundStyle(.white)
        .padding()
        .frame(maxWidth: .infinity)
        .background(color)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

//Boton regresar
struct BotonRegresar: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Button{
            dismiss()
        } label: {
            Label("Regresar al inicio", systemImage: "arrow.left")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
    }
}

//Imagen con titulo y texto (para premios y mexico)
struct Bloque: View {
    let imagen: String
    let titulo: String
    let texto: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8){
            Image(imagen).resizable().scaledToFit().clipShape(RoundedRectangle(cornerRadius: 12))
            Text(titulo).font(.headline)
            Text(texto).lineSpacing(5)
        }
    }
}

//Pantalla informativa reutilizable
struct PantallaInformativa: View {
    @Binding var ruta: [String]
    let titulo: String
    let simbolo: String
    let imagenes: [String]
    let contenido: String
    let siguiente: String

    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 24) {
                ForEach(imagenes, id: \.self) { imagen in
                    Image(imagen).resizable().scaledToFit().clipShape(RoundedRectangle(cornerRadius: 16))
                }
                Label(titulo, systemImage: simbolo)
                    .font(.title)
                    .bold()
                    .foregroundStyle(.purple)
                Text(contenido)
                    .font(.body)
                    .lineSpacing(6)

                Text("Desliza → para regresar o ← para ir a \(siguiente)").font(.caption).foregroundStyle(.secondary)
                BotonRegresar()
            }
            .padding()
            .navigationTitle(titulo)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 30).onEnded { valor in
                gestoSeccion(valor, ruta: $ruta, siguiente: siguiente)
            }
        )
    }
}

struct HistoriaView: View {
    @Binding var ruta: [String]
    var body: some View {
        PantallaInformativa(
            ruta: $ruta,
            titulo: "Historia",
            simbolo: "book.closed",
            imagenes: ["BTSorigen", "BTSHistoria", "FotoGrupal"],
            contenido:"BTS empezó en 2010 cuando Bang Si-hyuk, de Big Hit Entertainment, quería armar un grupo de hip hop. El primero en llegar fue RM y poco a poco se fueron uniendo los demás hasta quedar 7.\n\nDebutaron el 13 de junio de 2013 con la canción \"No More Dream\" del álbum 2 Cool 4 Skool. Su nombre viene de \"Bangtan Sonyeondan\" que significa algo como \"Boy Scouts a prueba de balas\", porque querían proteger a los jóvenes de los prejuicios. Después también dijeron que significa \"Beyond The Scene\".\n\nAl principio eran una empresa pequeña y no les iba tan bien, pero con eras como \"The Most Beautiful Moment in Life\", \"Wings\", \"Love Yourself\" y \"Map of the Soul\" se hicieron famosos en todo el mundo. En 2020 llegó \"Dynamite\", su primer #1 en Billboard.\n\nDe 2022 a 2025 hicieron su servicio militar y en 2026 regresaron los 7 juntos con el álbum ARIRANG.")
    }
}

//Datos de cada integrante
struct Integrante {
    let nombre: String
    let imagen: String
    let fecha: String
    let datos: String
}

let integrantes = [
    Integrante(nombre: "Jungkook", imagen: "Jungkook", fecha: "2011",
               datos: "Jeon Jungkook nació el 1 de septiembre de 1997 en Busan. Es el menor (maknae) y le dicen \"Golden Maknae\" porque es bueno en todo. Entró a Big Hit después de audicionar en Superstar K. Su canción \"Seven\" fue #1 en Billboard."),
    Integrante(nombre: "Taehyung (V)", imagen: "Taehyung", fecha: "2011",
               datos: "Kim Taehyung nació el 30 de diciembre de 1995 en Daegu. Fue a una audición solo acompañando a un amigo y lo eligieron a él. Es vocalista y fue quien inventó la frase \"I purple you\" 💜. Su solo más conocido es \"Layover\"."),
    Integrante(nombre: "Yoongi (Suga)", imagen: "Yoongi", fecha: "2010",
               datos: "Min Yoongi nació el 9 de marzo de 1993 en Daegu. Es rapero y productor, hace muchas de las canciones del grupo. Como solista se llama Agust D y sacó el álbum \"D-Day\"."),
    Integrante(nombre: "J-Hope", imagen: "Jhope", fecha: "Diciembre 2010",
               datos: "Jung Hoseok nació el 18 de febrero de 1994 en Gwangju. Antes de BTS estaba en un grupo de baile y es el bailarín principal. Sacó el álbum \"Jack in the Box\" y fue headliner en Lollapalooza."),
    Integrante(nombre: "Jin", imagen: "Jin", fecha: "2011",
               datos: "Kim Seokjin nació el 4 de diciembre de 1992 en Gwacheon. Es el mayor del grupo y lo descubrieron en la calle. Es vocalista y le dicen \"Worldwide Handsome\". Fue el primero en ir al servicio militar."),
    Integrante(nombre: "Namjoon (RM)", imagen: "Namjoon", fecha: "2010",
               datos: "Kim Namjoon nació el 12 de septiembre de 1994 en Ilsan. Es el líder y fue el primer integrante en entrar. Aprendió inglés viendo la serie Friends y dio discursos en la ONU. Su álbum solista es \"Indigo\"."),
    Integrante(nombre: "Jimin", imagen: "Jimin", fecha: "2012",
               datos: "Park Jimin nació el 13 de octubre de 1995 en Busan. Fue el último en unirse al grupo. Estudió danza contemporánea y es vocalista y bailarín. Su canción \"Like Crazy\" fue #1 en Billboard.")
]

struct IntegrantesView: View {
    @Binding var ruta: [String]
    @State private var actual = 0

    var body: some View {
        let miembro = integrantes[actual]
        VStack(spacing: 14){
            Text("\(actual + 1) de \(integrantes.count)").foregroundStyle(.secondary)
            Image(miembro.imagen).resizable().scaledToFill().frame(width: 230, height: 260).clipShape(RoundedRectangle(cornerRadius: 16))
            Text(miembro.nombre).font(.title).bold()
            Text("Se unió a Big Hit: \(miembro.fecha)").foregroundStyle(.purple)
            Text(miembro.datos).lineSpacing(5)
            Text("↑ siguiente  ↓ anterior  → inicio  ← Logros").font(.caption).foregroundStyle(.secondary)
            BotonRegresar()
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
        .gesture(
            DragGesture(minimumDistance: 30).onEnded { valor in
                let direccion = direccionGesto(valor)
                withAnimation {
                    if direccion == "arriba" {
                        actual = (actual + 1) % integrantes.count
                    }
                    if direccion == "abajo" {
                        actual = (actual - 1 + integrantes.count) % integrantes.count
                    }
                }
                gestoSeccion(valor, ruta: $ruta, siguiente: "Logros")
            }
        )
        .navigationTitle("Integrantes")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }
}

struct LogrosView: View {
    @Binding var ruta: [String]
    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 24){
                Label("Logros y premios", systemImage: "trophy.fill").font(.title).bold().foregroundStyle(.orange)

                Bloque(imagen: "BTsPremios",
                       titulo: "Melon Music Awards 2026",
                       texto: "En los MMA 2026 ganaron Artista del Año, Álbum del Año con ARIRANG, Top 10, Mejor Grupo Masculino y Escenario del Año por el ARIRANG World Tour.")

                Bloque(imagen: "BtsPremios2",
                       titulo: "American Music Awards 2021",
                       texto: "Fueron el primer grupo asiático en ganar Artista del Año en los AMAs. También ganaron Mejor Dúo/Grupo Pop y Canción Pop Favorita con \"Butter\".")

                Text("Otros logros").font(.headline)
                Text("• \"Dynamite\" fue su primer #1 en el Billboard Hot 100 (2020)\n• Varias nominaciones al Grammy\n• Dieron discursos en la ONU\n• Muchos Daesang (los premios más grandes de Corea)\n• Récords Guinness por vistas en YouTube y seguidores")
                    .lineSpacing(5)

                Text("Desliza → para regresar o ← para ir a Tour").font(.caption).foregroundStyle(.secondary)
                BotonRegresar()
            }
            .padding()
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 30).onEnded { valor in
                gestoSeccion(valor, ruta: $ruta, siguiente: "Tour")
            }
        )
        .navigationTitle("Logros")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }
}

struct TourView: View {
    @Binding var ruta: [String]
    var body: some View {
        PantallaInformativa(
            ruta: $ruta,
            titulo: "Tour Arirang",
            simbolo: "music.mic",
            imagenes: ["Arirang", "ArirangTour"],
            contenido:"Después de terminar su servicio militar, BTS regresó como grupo completo en 2026 con el álbum ARIRANG. El nombre viene de \"Arirang\", una canción tradicional muy importante de Corea.\n\nCon este álbum empezó el ARIRANG World Tour, su tour actual. Arrancó en abril de 2026 en Corea y está pasando por estadios de Asia, Norteamérica, Latinoamérica y Europa.\n\nEl tour hasta ganó \"Escenario del Año\" en los Melon Music Awards 2026.",
            siguiente: "Mexico")
    }
}

struct MexicoView: View {
    @Binding var ruta: [String]
    private let coordenada = CLLocationCoordinate2D(latitude: 19.4326, longitude: -99.1332)

    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 24){
                Label("BTS en Mexico", systemImage: "flag.fill").font(.title).bold().foregroundStyle(.green)

                Bloque(imagen: "BTSMexico2",
                       titulo: "Conciertos en CDMX",
                       texto: "Como parte del ARIRANG World Tour, BTS dio 3 conciertos en el Estadio GNP Seguros de la Ciudad de México los días 7, 9 y 10 de mayo de 2026.")

                Bloque(imagen: "BTSMexico3",
                       titulo: "Visita al Palacio Nacional",
                       texto: "Un día antes, el 6 de mayo de 2026, los 7 integrantes fueron recibidos por la presidenta Claudia Sheinbaum en Palacio Nacional.")

                Bloque(imagen: "BTSMexico4",
                       titulo: "Saludo desde el balcón",
                       texto: "Como a las 5 de la tarde salieron a uno de los balcones del Palacio para saludar a las ARMYs. Hacía como 30 grados y los bomberos tuvieron que echar agua a las fans que llevaban horas esperando.")

                Bloque(imagen: "BTSMexico",
                       titulo: "El Zócalo lleno",
                       texto: "Miles de fans (algunos medios dijeron que unas 50 mil) llenaron el Zócalo. La presidenta dijo que fue un acto de \"hermosa sencillez\", les pidió que regresen el próximo año y no descartó un concierto gratis en el Zócalo.")

                Text("¿Dónde fue?").font(.headline)
                Map(
                    initialPosition: .region(
                        MKCoordinateRegion(
                            center: coordenada,
                            span: MKCoordinateSpan(
                                latitudeDelta: 0.01,
                                longitudeDelta: 0.01
                            )
                        )
                    ),
                    interactionModes: []
                ){
                    Marker("Palacio Nacional",
                           coordinate: coordenada).tint(.purple)
                }
                .frame(height: 250)
                .clipShape(RoundedRectangle(cornerRadius: 16))

                Text("Desliza → para regresar o ← para ir a ARMY").font(.caption).foregroundStyle(.secondary)
                BotonRegresar()
            }
            .padding()
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 30).onEnded { valor in
                gestoSeccion(valor, ruta: $ruta, siguiente: "Army")
            }
        )
        .navigationTitle("Mexico")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }
}

struct ArmyView: View {
    @Binding var ruta: [String]
    var body: some View {
        PantallaInformativa(
            ruta: $ruta,
            titulo: "ARMY",
            simbolo: "heart.fill",
            imagenes: ["Army"],
            contenido:"ARMY es el nombre del fandom de BTS. Significa \"Adorable Representative M.C. for Youth\" y se anunció en julio de 2013.\n\nSu color es el morado 💜 por la frase \"I purple you\" que dijo V, que significa \"te voy a amar y confiar por mucho tiempo\".\n\nARMY es famoso por ser súper unido, por hacer donaciones y por llenar estadios en todo el mundo, como pasó en México.",
            siguiente: "Historia")
    }
}
//#Preview {
  //  ContentView()
//}
