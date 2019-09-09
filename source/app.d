import tensor;

extern (C) void main() {
  foreach (u; __traits(getUnitTests, tensor))
    u();
}
