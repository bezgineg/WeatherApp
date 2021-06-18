
import Foundation

enum Direction: String, CaseIterable {
    case n = "с"
    case nne = "ссв"
    case ne = "св"
    case ene = "всв"
    case e = "в"
    case ese = "вюв"
    case se = "юв"
    case sse = "ююв"
    case s = "ю"
    case ssw = "ююз"
    case sw = "юз"
    case wsw = "зюз"
    case w = "з"
    case wnw = "зсз"
    case nw = "сз"
    case nnw = "ссз"
}

extension Direction: CustomStringConvertible  {
    init<D: BinaryFloatingPoint>(_ direction: D) {
        self =  Self.allCases[Int((direction.angle+11.25).truncatingRemainder(dividingBy: 360)/22.5)]
    }
    var description: String { rawValue.uppercased() }
}

extension BinaryFloatingPoint {
    var angle: Self {
        (truncatingRemainder(dividingBy: 360) + 360)
            .truncatingRemainder(dividingBy: 360)
    }
    var direction: Direction { .init(self) }
}
