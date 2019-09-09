@nogc @safe nothrow pure:

unittest {
  const t = tensor!(int, 3, 5, 7);
  alias T = typeof(t);
  static assert(isTensor!T);
  static assert(t.shape == [3, 5, 7]);
}

///
template tensor(T, Dims...) {
  struct Tensor {
    const size_t[Dims.length] shape = [Dims];
  }

  Tensor tensor() {
    return Tensor();
  }
}

/// Returns true if T is a tensor
template isTensor(T) {
  import std.traits : isStaticArray;
  import std.range : ElementType;

  const bool isTensor = is(typeof(T.init) == T) && isStaticArray!(typeof(T.init.shape));
}

unittest {
  enum t = tensor!(int, 3, 5, 7);
  static assert(t.rank == 3);
}

/// Return the rank of the tensor
size_t rank(T)(auto ref T t) if (isTensor!T) {
  return t.shape.length;
}

unittest {
  static assert([1, 2, 3].product == 6);
  static assert([1, 2, 3, 4].product == 24);
}

/// Fold using the multiplicative monoid
template product(F) {
  import std.algorithm : fold;
  import std.range : ElementType;

  ElementType!F product(auto ref F f) {
    return f.fold!"a * b"(cast(ElementType!F)(1));
  }
}

unittest {
  enum t = tensor!(int, 3, 5, 7);
  static assert(t.length == 3 * 5 * 7);
}

/// Return the total number of elements of the tensor
size_t length(T)(auto ref T t) if (isTensor!T) {
  return t.shape[].product;
}
