abstract class Record<T> {
  Future<T> read();

  Future<void> write(T data);

  Future<void> remove();
}
