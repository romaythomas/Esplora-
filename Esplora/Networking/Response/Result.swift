
import Foundation

enum Result<T, U> where U: Error  {
    case success(T)
    case failure(U)
}

enum TupleResult<T, A , U> where U: Error  {
    case success(T, A)
    case failure(U)
}
